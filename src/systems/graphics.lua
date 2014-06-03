local _ = require "lib/underscore/lib/underscore"
local Class = require "lib/hump/class"
local System = require "systems/system"
local vector = require "lib/hump/vector"

local Graphics = Class{
    __includes = System,
    init = function(self)
        System.init(self)
        self.cameraPosition = vector(0, 100)
        self.scale = 30
    end
}

function Graphics:config(engine, data)
    self.backgroundColor = data.backgroundColor
    self.foregroundColor = data.foregroundColor
end

function Graphics:draw()
    love.graphics.reset()
    love.graphics.setBackgroundColor(unpack(self.backgroundColor))

    love.graphics.push()
    love.graphics.translate(love.graphics.getWidth()/2, love.graphics.getHeight()/2)
    love.graphics.scale(self.scale, self.scale)
    love.graphics.translate(self.cameraPosition:unpack())

    _.each(self.entities, function(entity)
        love.graphics.translate((-entity.transform.position):unpack())
        if entity.graphics.type == "circle" then
            r = entity.graphics.radius
            love.graphics.circle("fill", -r/2, -r/2, r, 20)
        end
    end)
    love.graphics.pop()

    love.graphics.setColor(unpack(self.foregroundColor))
    love.graphics.print("FPS: "..love.timer.getFPS(), 10, 10)
end

return Graphics
