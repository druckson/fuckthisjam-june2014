local function checkSorted(list, valueFunction)
    local last = nil

    for _, item in pairs(list) do
        value = valueFunction(item)
        if last and last >= value then
            return false
        end
        last = value
    end
    
    return true
end

local function merge(l1, l2, valueFunction)
    local i1 = 1
    local i2 = 1
    local l3 = {}

    while true do
        local v1 = l1[i1]
        local v2 = l2[i2]

        if v1 and v2 then
            k1 = valueFunction(v1)
            k2 = valueFunction(v2)
            if k1 < k2 then
                table.insert(l3, v1)
                i1 = i1 + 1
            else
                table.insert(l3, v2)
                i2 = i2 + 1
            end
        else
            if v1 then
                table.insert(l3, v1)
                i1 = i1 + 1
            elseif v2 then
                table.insert(l3, v2)
                i2 = i2 + 1
            else
                break
            end
        end
    end

    return l3
end

local function mergeSortRecursive(list, first, last, valueFunction)
    if last < first then
        return {}
    elseif first == last then
        return {list[first]}
    end
    
    local middle = math.floor((first + last) / 2)
    local list1 = mergeSortRecursive(list, first, middle, valueFunction)
    local list2 = mergeSortRecursive(list, middle+1, last, valueFunction)

    return merge(list1, list2, valueFunction)
end

local function mergeSort(list, valueFunction)
    return mergeSortRecursive(list, 1, #list, valueFunction)
end

local function sort(list, valueFunction)
    if not checkSorted(list, valueFunction) then
        return mergeSort(list, valueFunction)
    end
    return list
end

return sort
