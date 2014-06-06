require "../src/utils/sort"

local compare = function(v)
    return v
end

describe("merge sort", function()
    it("works for empty lists", function()
        local input = {}
        local output = mergeSort(input, compare)
        local target = {}
        assert.same(output, target)
    end)

    it("works for single element lists", function()
        local input = {0}
        local output = mergeSort(input, compare)
        local target = {0}
        assert.same(output, target)
    end)

    it("works for multiple element lists", function()
        local input = {1, 4, 0}
        local output = mergeSort(input, compare)
        local target = {0, 1, 4}
        assert.same(output, target)
    end)

    it("works for sorted lists", function()
        local input = {1, 2, 3}
        local output = mergeSort(input, compare)
        local target = {1, 2, 3}
        assert.same(output, target)
    end)
end)
