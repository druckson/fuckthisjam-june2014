local Class = require "lib/hump/class"
local toarray = require "utils/toarray"

local STATE_COMMAND = "command"
local STATE_NORMAL = "normal"

local Input = Class{
    init = function(self)
        self.state = STATE_NORMAL
        self.current_command = ""
    end
}

function Input:config(engine, data)
    self.engine = engine
end

function Input:debug_print(f)
    f("Command state: "..self.state)
    f("Current command: '"..self.current_command.."'")
end

function Input:set_state(state)
    self.state = state
    self.current_command = ""
end

function Input:update(dt)
    if self.state == STATE_NORMAL then
        self.engine:call("key_held", dt, love.keyboard.isDown)
    end
end

function Input:keypressed(key)
    if self.state == STATE_NORMAL then
        if key == ";" then
            self:set_state(STATE_COMMAND)
        else
            self.engine:call("key_command", key)
        end
    elseif self.state == STATE_COMMAND then
        if key == "escape" then
            self:set_state(STATE_NORMAL)
        elseif key == "backspace" then
            self.current_command = string.sub(self.current_command, 0, #self.current_command-1)
        elseif key == "return" then
            local command = toarray(string.gmatch(self.current_command, "%S+"))
            self.engine:call("process_command", command)
            self:set_state(STATE_NORMAL)
        elseif string.len(key) == 1 then
            self.current_command = self.current_command..key
        end
    end
end

return Input
