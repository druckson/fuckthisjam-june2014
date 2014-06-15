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
    __includes = System,
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
            mass = data.physics.mass,
            shape = data.physics.shape,
            body = body,
            fixture = fixture
        }
    end
end

function Physics:removeEntity(entity)
    if self.entities[entity] then
        self.entities[entity].current.physics.body:destroy()
        System.removeEntity(self, entity)
    end
end

function Physics:marshallEntity(entity, data)
    if self.entities[entity] then
        local physics = self.entities[entity].current.physics
        data.physics = {
            mass = physics.mass,
            type = physics.body:getType(),
            shape = physics.shape
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
