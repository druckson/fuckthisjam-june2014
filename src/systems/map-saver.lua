local Class = require "lib/hump/class"
local merge = (require "utils/diff").merge
local diff = (require "utils/diff").diff
local prefab = require "utils/prefab"

local MapSaver = Class {
    init = function(self)
        self.prefabs = {}    
    end
}

function MapSaver:config(engine, data)
    self.engine = engine
end

function MapSaver:addPrefab(name, data)
    self.prefabs[name] = data
end

function MapSaver:clearPrefabs()
    self.prefabs = {}
end

function MapSaver:process_command(value)
    if value[0] == "save" then
        self.engine:call("save")
    end
end

function MapSaver:save(file, entities)
    local out_entities = {}

    for entity, v in pairs(entities) do
        if not v.meta then
            out_entities[k] = {}
            self.engine:call("marshallEntity", entity, out_entities[k])
        end
    end

    local data = json.encode({
        prefabs = self.prefabs,
        entities = out_entities
    })

    love.filesystem.write('maps/'..file..'.json', data)
end

return MapSaver
