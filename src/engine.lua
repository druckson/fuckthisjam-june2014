local Class = require "lib/hump/class"

local Engine = Class{
    init = function(self)
        self.systems = {}
        self.systemsByName = {}
    end
}

function Engine:createEntity(data)

end

function Engine:addSystem(name, system)
    table.insert(self.systems, system)
    self.systemsByName[name] = system
end

function Engine:eachSystem(f)
    for _, system in pairs(self.systems) do
        f(system)
    end
end

function Engine:update(dt)
    self:eachSystem(function(system)
        if system.update ~= nil then
            system:update(dt)
        end
    end)
end

function Engine:draw()
    self:eachSystem(function(system)
        if system.draw ~= nil then
            system:draw()
        end
    end)
end

return Engine
