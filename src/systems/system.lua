local Class = require "lib/hump/class"

local System = Class {
    init = function(self)
        self.entities = {}
        self.entityIDs = {}
    end
}

function System:addEntity(entity, entityData, data)
    local entityID = #self.entities
    self.entityIDs[entity] = entityID
    table.insert(self.entities, entityData)
end

function System:removeEntity(entity)
    table.remove(self.entities, self.entityIDs[entity])
    self.entityIDs[entity] = nil
end

return System
