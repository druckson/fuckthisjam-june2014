local _ = require "lib/underscore/lib/underscore"
local Class = require "lib/hump/class"
local System = require "systems/system"

local MapCreator = Class{
    __includes = System,
    init = function(self)
        self.prefabs = {}
        self.entityData = {}
        self.current_prefab = ""
    end
}

function MapCreator:config(engine, data)
    self.engine = engine

    -- create grid lines
    engine:createEntity({
        meta = true,
        graphics = {
            type = "line",
            repeatX = 1,
            repeatY = 1,
            width = 1
        }
    })
end

function MapCreator:addPrefab(name, data)
    self.prefabs[name] = data
end

function MapCreator:addEntity(entity, entityData, data)
    self.entityData[entity] = data
end

function MapCreator:removeEntity(entity)
    self.entityData[entity] = nil
end

function MapCreator:save(filename)
    love.filesystem.write(filename, {
        prefabs =  self.prefabs,
        entities = self.entityData
    })
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

function MapCreator:process_command(value)
    print(value)
    if value[0] == "setprefab" then
        if #value > 1 then
            self.current_prefab = value[1]
        end
    end
end

return MapCreator
