local _ = require "lib/underscore/lib/underscore"
local Class = require "lib/hump/class"
local System = require "systems/system"

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
    self.world:setGravity(unpack(data.gravity))
end

function Physics:update(dt)
    self.world:update(dt)
    _.each(self.entities, function(entity)
        entity.transform.position = vector.new(entity.physics.body:getPosition())
        entity.transform.rotation = vector.new(entity.physics.body:getAngle())
    end)
end

return Physics
