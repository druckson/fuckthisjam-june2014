local _ = require "lib/underscore/lib/underscore"
local Class = require "lib/hump/class"
local System = require "systems/system"

local Graphics = Class{
    __includes = System,
    init = function(self)
        System.init(self)
    end
}

function Graphics:config(engine, data)
    self.backgroundColor = data.backgroundColor
    self.foregroundColor = data.foregroundColor
end

function Graphics:draw()
    love.graphics.reset()
    love.graphics.setBackgroundColor(unpack(self.backgroundColor))

    _.each(self.entities, function(entity)
        love.graphics.
    end)

    love.graphics.setColor(unpack(self.foregroundColor))
    love.graphics.print("FPS: "..love.timer.getFPS(), 10, 10)
end

return Graphics
