local Class = require "lib/hump/class"
local toarray = require "utils/toarray"

local STATE_COMMAND = "command"
local STATE_NORMAL = "normal"

local Input = Class{
    init = function(self)
        self.state = STATE_NORMAL
        self.current_command = ""
        self.key_bindings = {}
    end
}

function Input:config(engine, data)
    self.engine = engine
    self.key_bindings = data.key_bindings
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
    local this = self
    if self.state == STATE_NORMAL then
        self.engine:call("input_held", dt, function(input)
            for k, v in pairs(this.key_bindings) do
                if v == input then
                    if love.keyboard.isDown(k) then
                        return true
                    end
                end
            end

            return false
        end)
    end
end

function Input:bindKey(key, input)
    self.key_bindings[key] = input
end

function Input:process_command(command)
    if command[1] == "bindKey" then
        if #command == 3 then
            print("Bound key "..command[2].." to "..command[3])
            self.engine:call("bindKey", command[2], command[3])
        end
    end
end

function Input:keypressed(key)
    if self.state == STATE_NORMAL then
        if key == ";" then
            self:set_state(STATE_COMMAND)
        else
            if self.key_bindings[key] then
                self.engine:call("input_start", self.key_bindings[key])
            end
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
            if love.keyboard.isDown("lshift") or
                love.keyboard.isDown("rshift") then
                key = string.upper(key)
            end
            self.current_command = self.current_command..key
        end
    end
end

function Input:keyreleased(key)
    if self.state == STATE_NORMAL then    
        if self.key_bindings[key] then
            self.engine:call("input_end", self.key_bindings[key])
        end
    end
end

return Input
