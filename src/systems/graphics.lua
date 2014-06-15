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
        self.entities_sorted = {}
    end
}

function Graphics:addEntity(entity, entityData, data)
    if data.graphics then
        System.addEntity(self, entity, entityData, data)
        table.insert(self.entities_sorted, entity)
        entityData.current.graphics = data.graphics
    end
end

function Graphics:removeEntity(entity)
    System.removeEntity(self, entity)
    for i, e in pairs(self.entities_sorted) do
        if e == entity then
            table.remove(self.entities_sorted, i)
        end
    end
end

function Graphics:marshallEntity(entity, data)
    if self.entities[entity] then
        local graphics = self.entities[entity].current.graphics
        data.graphics = graphics
    end
end

function Graphics:config(engine, data)
    self.engine = engine
    self.backgroundColor = data.backgroundColor
    self.foregroundColor = data.foregroundColor
end

function Graphics:resize(width, height)
    self.cameraSize = vector(width, height)
    love.window.setMode(width, height, {
        fullscreen = self.fullscreen,
        fsaa = 4
    })
end

function Graphics:mousepressed(x, y, key)
    local screenSpace = vector(x, y)
    local worldSpace = (screenSpace - self.cameraSize/2) / self.scale - self.cameraPosition
    local width = love.graphics.getWidth()
    local height = love.graphics.getHeight()
    local cx = (x - width/2) / self.scale - self.cameraPosition.x
    local cy = (y - height/2) / self.scale - self.cameraPosition.y
    self.engine:call("mousepressed_world", cx, cy, key)
end

function Graphics:key_command(key)
    if key == "f" then
        self.fullscreen = not self.fullscreen
        love.window.setMode(love.graphics.getWidth(), love.graphics.getHeight(), {
            fullscreen = self.fullscreen
        })
    end
end

function Graphics:key_held(dt, keys)
    speed = 10
    turnSpeed = 1
    zoomSpeed = 0.99

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

    self.engine:call("camera_changed", self.cameraPosition)

    if keys("q") then
        --self.cameraRotation = self.cameraRotation + dt*turnSpeed
        self.scale = self.scale * zoomSpeed
    end
    if keys("e") then
        --self.cameraRotation = self.cameraRotation - dt*turnSpeed
        self.scale = self.scale / zoomSpeed
    end
end

function Graphics:camera_changed(cameraPosition)
    
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

    local this = self
    self.entities_sorted = sort(self.entities_sorted, function(e)
        local layer = this.entities[e].current.graphics.layer
        if layer then
            return layer
        end
        return 0
    end)

    love.graphics.setColor(unpack(self.foregroundColor))
    for i, e in pairs(self.entities_sorted) do
        local entity = self.entities[e]
        love.graphics.push()

        if entity.current.transform then
            love.graphics.translate((entity.current.transform.position):unpack())
        end

        love.graphics.setColor(unpack(self.foregroundColor))

        if entity.current.graphics.color then
            love.graphics.setColor(unpack(entity.current.graphics.color))
        end

        if entity.current.graphics.type == "circle" then
            local r = entity.current.graphics.radius
            love.graphics.circle("fill", 0, 0, r, 20)
        elseif entity.current.graphics.type == "rect" then
            local w = entity.current.graphics.width
            local h = entity.current.graphics.height
            love.graphics.rectangle("fill", -w/2, -h/2, w, h)
        elseif entity.current.graphics.type == "line" then
            local lower_bound = -self.cameraPosition - (self.cameraSize/self.scale/2)
            local upper_bound = -self.cameraPosition + (self.cameraSize/self.scale/2)

            local repeatX = entity.current.graphics.repeatX
            local repeatY = entity.current.graphics.repeatY

            while repeatX < 10/self.scale do
                repeatX = repeatX * 2
            end

            while repeatX > 10/self.scale do
                repeatX = repeatX / 2 
            end

            while repeatY < 10/self.scale do
                repeatY = repeatY * 2
            end

            while repeatY > 10/self.scale do
                repeatY = repeatY / 2 
            end

            local function closest_lower(start, dist, target)
                while start <= target do
                    start = start + dist
                end

                while start > target do
                    start = start - dist
                end

                return start
            end

            if repeatX then
                local current = closest_lower(0, repeatX, lower_bound.x)
                while current < upper_bound.x do
                    love.graphics.setLineWidth(1/self.scale)
                    love.graphics.line(current, lower_bound.y, current, upper_bound.y)
                    current = current + repeatX
                end
            end

            if repeatY then
                local current = closest_lower(0, repeatY, lower_bound.y)
                while current < upper_bound.y do
                    love.graphics.setLineWidth(1/self.scale)
                    love.graphics.line(lower_bound.x, current, upper_bound.x, current)
                    current = current + repeatY
                end
            end
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
