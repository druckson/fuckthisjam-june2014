local _ = require "lib/underscore/lib/underscore"
local Class = require "lib/hump/class"
local System = require "systems/system"

local MapCreator = Class{
    __includes = System,
    init = function(self)
        
    end
}

function MapCreator:config(engine, data)
    self.engine = engine

    -- create vertical grid lines
    engine:createEntity({
        transform = {
            position = {
                x = 0,
                y = 0
            },
            rotation = 0
        },
        graphics = {
            type = "line",
            repeatX = 5,
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
