local Class = require "lib/hump/class"
local System = require "systems/system"
local merge = (require "utils/diff").merge
local diff = (require "utils/diff").diff
local prefab = require "utils/prefab"

local MapSaver = Class {
    __includes = System,
    init = function(self)
        System.init(self)
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
    if #value == 2 then
        if value[1] == "save" then
            self.engine:call("save", value[2])
        end
    end
end

function MapSaver:save(file)
    if file then
        print("Saving: "..file)
        local out_entities = {}

        for k, v in pairs(self.entities) do
            if not v.meta then
                out_entities[k] = {}
                self.engine:call("marshallEntity", k, out_entities[k])
            end
        end

        local data = json.encode({
            prefabs = self.prefabs,
            entities = out_entities
        })

        local path = 'maps/'..file..'.json'
        love.filesystem.createDirectory("maps")
        if not love.filesystem.write(path, data) then
            print("Failed to write.")
        end
    end
end

return MapSaver
