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

function MapLoader:load(file)
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
