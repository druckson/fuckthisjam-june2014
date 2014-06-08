local _ = require "lib/underscore/lib/underscore"
local Class = require "lib/hump/class"
local System = require "systems/system"
local vector = require "lib/hump/vector"
local sort = require "utils/sort"

local Graphics = Class{
    __includes = System,
    init = function(self)
        System.init(self)
        self.cameraPosition = vector(0, 0)
        self.cameraRotation = 0
        self.scale = 10
        self.fullscreen = false
    end
}

function Graphics:addEntity(entity, entityData, data)
    if data.graphics and data.transform then
        System.addEntity(self, entity, entityData, data)
        entityData.current.graphics = data.graphics
    end
end

function Graphics:config(engine, data)
    self.engine = engine
    self.backgroundColor = data.backgroundColor
    self.foregroundColor = data.foregroundColor
end

function Graphics:resize(width, height)
    self.width = width
    self.height = height
    love.window.setMode(width, height, {
        fullscreen = self.fullscreen
    })
end

function Graphics:mousepressed(x, y, key)
    local width = love.graphics.getWidth()
    local height = love.graphics.getHeight()
    local cx = (x - width/2) / self.scale - self.cameraPosition.x
    local cy = (y - height/2) / self.scale - self.cameraPosition.y
    self.engine:call("mousepressed_world", cx, cy, key)
end

function Graphics:keycommand(key)
    if key == "f" then
        self.fullscreen = not self.fullscreen
        love.window.setMode(love.graphics.getWidth(), love.graphics.getHeight(), {
            fullscreen = self.fullscreen
        })
    end
end

function Graphics:keyheld(dt, keys)
    speed = 1
    turnSpeed = 1

    if keys("w") then
        self.cameraPosition.y = self.cameraPosition.y + dt*speed
    end
    if keys("s") then
        self.cameraPosition.y = self.cameraPosition.y - dt*speed
    end
    if keys("a") then
        self.cameraPosition.x = self.cameraPosition.x + dt*speed
    end
    if keys("d") then
        self.cameraPosition.x = self.cameraPosition.x - dt*speed
    end
    if keys("q") then
        self.cameraRotation = self.cameraRotation + dt*turnSpeed
    end
    if keys("e") then
        self.cameraRotation = self.cameraRotation - dt*turnSpeed
    end
end

function Graphics:debug_print(f)
    f("FPS: "..love.timer.getFPS())
end

function Graphics:draw()
    love.graphics.reset()
    love.graphics.setBackgroundColor(unpack(self.backgroundColor))

    love.graphics.push()
    love.graphics.translate(love.graphics.getWidth()/2, love.graphics.getHeight()/2)
    love.graphics.scale(self.scale, self.scale)
    love.graphics.translate(self.cameraPosition:unpack())
    love.graphics.rotate(self.cameraRotation)

    self.entities = sort(self.entities, function(e)
        local layer = e.current.graphics.layer
        if layer then
            return layer
        end
        return 0
    end)

    love.graphics.setColor(unpack(self.foregroundColor))
    for i, entity in pairs(self.entities) do
        love.graphics.push()
        love.graphics.translate((entity.current.transform.position):unpack())
        love.graphics.setColor(unpack(self.foregroundColor))

        if entity.current.graphics.color then
            love.graphics.setColor(unpack(entity.current.graphics.color))
        end

        if entity.current.graphics.type == "circle" then
            r = entity.current.graphics.radius
            love.graphics.circle("fill", 0, 0, r, 20)
        elseif entity.current.graphics.type == "rect" then
            w = entity.current.graphics.width
            h = entity.current.graphics.height
            love.graphics.rectangle("fill", -w/2, -h/2, w, h)
        end
        love.graphics.pop()
    end
    love.graphics.pop()

    love.graphics.setColor(unpack(self.foregroundColor))

    local offset = 10
    self.engine:call("debug_print", function(message)
        love.graphics.print(message, 10, offset)
        offset = offset + 10
    end)
end

return Graphics
