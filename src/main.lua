local Engine = require "engine"
local Graphics = require "systems/graphics"
local Physics = require "systems/physics"
local _ = require "lib/underscore/lib/underscore"

local engine = Engine()

function love.load()
    -- Create systems
    engine:addSystem("physics", Physics())
    engine:addSystem("graphics", Graphics())

    -- Configure systems
    engine:call("config", engine, {
        worldScale = 1,
        gravity = {0, -10},
        backgroundColor = {0, 30, 60},
        foregroundColor = {150, 150, 150}
    })

    -- Wire up love calls
    _.each({"update", "draw"}, function(func)
        love[func] = function(...)
            engine:call(func, ...)
        end
    end)
end
