sort = require "../src/utils/sort"

local compare = function(v)
    return v
end

describe("merge sort", function()
    it("works for empty lists", function()
        local input = {}
        local output = sort(input, compare)
        local target = {}
        assert.same(target, output)
    end)

    it("works for single element lists", function()
        local input = {0}
        local output = sort(input, compare)
        local target = {0}
        assert.same(target, output)
    end)

    it("works for multiple element lists", function()
        local input = {1, 4, 0}
        local output = sort(input, compare)
        local target = {0, 1, 4}
        assert.same(target, output)
    end)

    it("works for sorted lists", function()
        local input = {1, 2, 3}
        local output = sort(input, compare)
        local target = {1, 2, 3}
        assert.same(target, output)
    end)

    it("works for reverse sorted lists", function()
        local input = {3, 2, 1}
        local output = sort(input, compare)
        local target = {1, 2, 3}
        assert.same(target, output)
    end)

    it("works for lists with duplicate items", function()
        local input = {3, 2, 2}
        local output = sort(input, compare)
        local target = {2, 2, 3}
        assert.same(target, output)
    end)

    it("works for lists with complex items", function()
        local input = {
            {key=1, value="Hello1"},
            {key=3, value="Hello3"},
            {key=2, value="Hello2"}
        }
        local output = sort(input, function(i) return i.key end)
        local target = {
            {key=1, value="Hello1"},
            {key=2, value="Hello2"},
            {key=3, value="Hello3"}
        }
        assert.same(target, output)
    end)
end)
