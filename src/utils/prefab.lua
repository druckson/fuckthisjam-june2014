local merge = (require "utils/diff").merge

local function prefab(data, prefabs)
    local out = {}
    
    if data.prefab then
        if prefabs[data.prefab] then
            out = prefab(prefabs[data.prefab], prefabs)
        end
    end

    return merge(out, data)
end

return prefab
