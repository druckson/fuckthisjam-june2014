local Class = require "lib/hump/class"

local System = Class {
    init = function(self)
        self.entities = {}
    end
}

function System:addEntity(entity, entityData, data)
    self.entities[entity] = entityData
end

function System:removeEntity(entity)
    self.entites[entity] = nil
end

return System
