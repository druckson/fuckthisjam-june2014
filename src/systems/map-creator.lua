local _ = require "lib/underscore/lib/underscore"
local Class = require "lib/hump/class"
local System = require "systems/system"

local MapCreator = Class{
    __includes = System,
    init = function(self)
        self.current_prefab = ""
    end
}

function MapCreator:config(engine, data)
    self.engine = engine

    self.prefabs = data.prefabs

    -- create vertical grid lines
    engine:createEntity({
        graphics = {
            type = "line",
            repeatX = 1,
            repeatY = 1,
            width = 1
        }
    })
end

function MapCreator:addEntity(entity, entityData, data)
    
end

function MapCreator:mousepressed_world(x, y, button)
    self.engine:createEntity({
        transform = {
            position = {
                x = x,
                y = y
            },
            rotation = 0
        },
        graphics = {
            type = "rect",
            width = 1,
            height = 1
        }
    })
end

function MapCreator:keypressed(k)
end

return MapCreator
