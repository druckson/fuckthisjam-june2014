local _ = require "lib/underscore/lib/underscore"
local Class = require "lib/hump/class"
require "lib/json"

local Engine = Class{
    init = function(self)
        self.systems = {}
        self.systemsByName = {}
    end
}

function Engine:createEntity(data)
    
end

function Engine:removeEntity(entity)
    self:call("removeEntity", entity)
end

function Engine:addSystem(name, system)
    table.insert(self.systems, system)
    self.systemsByName[name] = system
end

function Engine:call(name, ...)
    local args = {...}
    _.each(self.systems, function(system)
        if system[name] ~= nil then
            system[name](system, unpack(args))
        end
    end)
end

return Engine
