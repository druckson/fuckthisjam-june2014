local Class = require "lib/hump/class"
require "lib/json"

local Engine = Class{
    init = function(self)
        self.entities = {}
        self.systems = {self}
        self.systemsByName = {}
        self.nextEntity = 1
    end
}

function Engine:createEntity(data)
    local entity = self.nextEntity
    self.nextEntity = self.nextEntity+1

    self.entities[entity] = {
        current = {},
        old = {}
    }
    self:call("addEntity", entity, self.entities[entity], data)

    return entity
end

function Engine:removeEntity(entity)
    self:call("removeEntity", entity)
    self.entities[entity] = nil
end

function Engine:clear()
    for _, entity in pairs(self.entities) do
        self:removeEntity(entity)
    end
    self.entities = {}
end

function Engine:addSystem(name, system)
    table.insert(self.systems, system)
    self.systemsByName[name] = system
end

function Engine:update(dt)
end

function Engine:call(name, ...)
    local args = {...}

    for _, system in pairs(self.systems) do
        if system[name] ~= nil then
            system[name](system, unpack(args))
        end
    end
end

return Engine
