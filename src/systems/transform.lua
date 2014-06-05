local System = require "systems/system"
local Class = require "lib/hump/class"
local vector = require "lib/hump/vector"

local Transform = Class{
    __includes = System,
    init = function(self)
        System.init(self)
    end
}

function Transform:addEntity(entity, entityData, data)
    if data.transform then
        System.addEntity(self, entity, entityData, data)
        entityData.current.transform = {
            position = vector(data.transform.position.x, data.transform.position.y),
            rotation = data.transform.rotation
        }
    end
end

return Transform
