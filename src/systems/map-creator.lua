local Class = require "lib/hump/class"
local System = require "systems/system"
local prefab = require "utils/prefab"

local MapCreator = Class{
    __includes = System,
    init = function(self)
        System.init(self)
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
            color = {255, 255, 255, 50},
            repeatX = 1,
            repeatY = 1,
            width = 1
        }
    })
end

function MapCreator:addPrefab(name, data)
    self.prefabs[name] = data
end

function MapCreator:marshallEntity(entity, data)
    if self.entities[entity] then
        data.meta = self.entities[entity].current.meta
    end
end

function MapCreator:mousepressed_world(x, y, button)
    self.engine:createEntity(prefab({
        prefab = "ball",
        transform = {
            position = {
                x = x,
                y = y
            },
            rotation = 0
        }
    }, self.prefabs))
end

function MapCreator:process_command(value)
    if value[0] == "setprefab" then
        if #value > 1 then
            self.current_prefab = value[1]
        end
    end
end

return MapCreator
