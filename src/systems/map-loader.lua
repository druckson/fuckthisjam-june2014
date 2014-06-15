local Class = require "lib/hump/class"
local merge = (require "utils/diff").merge
local prefab = require "utils/prefab"

local MapLoader = Class {
    init = function(self)
        self.prefabs = {}    
    end
}

function MapLoader:config(engine, data)
    self.engine = engine
end

function MapLoader:addPrefab(name, data)
    self.prefabs[name] = data
end

function MapLoader:clearPrefabs()
    self.prefabs = {}
end

function MapLoader:process_command(value)
    if value[1] == "unload" then
        if #value == 1 then
            self.engine:call("unload")
        end
    elseif value[1] == "load" then
        if #value == 2 then
            self.engine:call("load", value[2])
        end
    end
end

function MapLoader:unload()
    self.engine:clear()
    self.engine:call("clearPrefabs")
end

function MapLoader:load(file)
    self.engine:call("unload")

    local data = love.filesystem.read('maps/'..file..'.json')
    local map = json.decode(data)

    if map.prefabs then
        for name, prefab in pairs(map.prefabs) do
            self.engine:call("addPrefab", name, prefab)
        end
    end

    if map.entities then
        for name, entity in pairs(map.entities) do
            self.engine:createEntity(prefab(entity, self.prefabs))
        end
    end
end

return MapLoader
