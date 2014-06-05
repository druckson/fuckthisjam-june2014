local _ = require "lib/underscore/lib/underscore"
local Class = require "lib/hump/class"
local System = require "systems/system"
local vector = require "lib/hump/vector"

local Physics = Class{
    _includes = System,
    init = function(self)
        System.init(self)
        self.world = love.physics.newWorld(0, 0, true)
    end
}

function Physics:addEntity(entity, entityData, data)
    if data.physics and data.transform then
        System.addEntity(self, entity, entityData, data)
        entityData.current.physics = {
            body = love.physics.newBody(self.world,
                data.transform.position.x,
                data.transform.position.y, data.physics.type)
        }
    end
end

function Physics:config(engine, data)
    self.engine = engine
    love.physics.setMeter(data.worldScale)
    self.world:setGravity(unpack(data.gravity))
end

function Physics:update(dt)
    self.world:update(dt)
    _.each(self.entities, function(entity)
        entity.current.transform.position = vector(entity.current.physics.body:getPosition())
        entity.current.transform.rotation = entity.current.physics.body:getAngle()
    end)
end

return Physics
