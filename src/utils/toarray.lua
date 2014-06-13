local function toarray(iter)
    local arr = {}
    for i in iter do
        table.insert(arr, i)
    end

    return arr
end

return toarray
