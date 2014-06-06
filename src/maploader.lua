local _ = require "lib/underscore/lib/underscore"
local Class = require "lib/hump/class"
local merge = (require "utils/diff").merge
require "lib/json"

local MapLoader = Class{
    init = function(self, engine)
        self.engine = engine
    end
}

function MapLoader:prefab(data, prefabs)
    local out = {}
    if data.prefab then
        if prefabs[data.prefab] then
            out = self:prefab(prefabs[data.prefab], prefabs)
        end
    end

    return merge(out, data)
end

function MapLoader:loadMap(file)
    local data = love.filesystem.read('maps/'..file..'.json')
    local map = json.decode(data)

    if map.entities then
        
        for name, entityData in pairs(map.entities) do
            self.engine:createEntity(self:prefab(entityData, map.prefabs))
        end
        --_.each(map.entities, function(entityData)
        --    self.engine:createEntity(self:prefab(entityData, map.prefabs))
        --end)
    end

    --if map.audio then
    --    for _, song in pairs(map.audio.songs) do
    --        self.engine:createEntity({
    --            sound = {
    --                file = song
    --            },
    --            networking = {
    --                type = "static"
    --            }
    --        })
    --    end
    --    --self.engine.systemsByName.sound:addSong
    --end
end

return MapLoader
