local Engine = require "engine"

local Graphics = require "systems/graphics"
local Physics = require "systems/physics"
local Transform = require "systems/transform"
local MapLoader = require "maploader"
local _ = require "lib/underscore/lib/underscore"

local engine = Engine()
local loader = MapLoader(engine)

function love.load()
    -- Create systems
    engine:addSystem("transform", Transform())
    engine:addSystem("physics", Physics())
    engine:addSystem("graphics", Graphics())

    -- Configure systems
    engine:call("config", engine, {
        worldScale = 1,
        gravity = 20,
        backgroundColor = {0, 30, 60, 255},
        foregroundColor = {150, 150, 150, 255}
    })

    -- Wire up love calls
    _.each({"update", "draw", "resize", "keypressed", "keyreleased"}, function(func)
        love[func] = function(...)
            engine:call(func, ...)
        end
    end)

    loader:loadMap("board1")
end
