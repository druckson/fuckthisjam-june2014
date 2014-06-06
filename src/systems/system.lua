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
    for i, e in pairs(self.entities) do
        if e == entity then
            table.remove(self.entities, i)
        end
    end
    self.entityIDs[entity] = nil
end

return System
