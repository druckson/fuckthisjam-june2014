local _ = require "lib/underscore/lib/underscore"
local Class = require "lib/hump/class"
local System = require "systems/system"
local vector = require "lib/hump/vector"

function newShape(data)
    if data.type == "circle" then
        return love.physics.newCircleShape(data.radius)
    elseif data.type == "rect" then
        return love.physics.newRectangleShape(data.width, data.height)
    end

    return nil
end

local Physics = Class{
    _includes = System,
    init = function(self)
        System.init(self)
        self.world = love.physics.newWorld(0, 0, true)
    end
}

function Physics:config(engine, data)
    self.engine = engine
    love.physics.setMeter(data.worldScale)
    self.gravity = data.gravity
end

function Physics:addEntity(entity, entityData, data)
    if data.physics and data.transform then
        System.addEntity(self, entity, entityData, data)

        local body = love.physics.newBody(self.world,
            data.transform.position.x,
            data.transform.position.y, data.physics.type)

        local fixture = love.physics.newFixture(body,
            newShape(data.physics.shape), 1)

        entityData.current.physics = {
            body = body,
            fixture = fixture
        }
    end
end

function Physics:update(dt)
    self.world:update(dt)
    for i, entity in pairs(self.entities) do
        body = entity.current.physics.body
        if entity.current.transform.position.y > 0 then
            body:applyForce(0,  self.gravity)
        else
            body:applyForce(0, -self.gravity)
        end
        entity.current.transform.position = vector(body:getPosition())
        entity.current.transform.rotation = body:getAngle()
    end
end

return Physics
