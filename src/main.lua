local Engine = require "engine"

local Graphics = require "systems/graphics"
local Physics = require "systems/physics"
local Transform = require "systems/transform"
local MapCreator = require "systems/map-creator"
local MapLoader = require "maploader"
local _ = require "lib/underscore/lib/underscore"

local engine = Engine()
local loader = MapLoader(engine)

function love.load()
    -- Create systems
    engine:addSystem("transform", Transform())
    engine:addSystem("physics", Physics())
    engine:addSystem("graphics", Graphics())
    engine:addSystem("map-creator", MapCreator())

    -- Configure systems
    engine:call("config", engine, {
        worldScale = 1,
        gravity = 20,
        backgroundColor = {0, 30, 60, 255},
        foregroundColor = {150, 150, 150, 255}
    })

    -- Wire up love calls
    _.each({"update", "draw", "resize", "focus", "visible", "keypressed", "keyreleased", "joystickpressed", "joystickreleased", "joystickaxis", "joystickhat", "mousefocus", "mousepressed", "mousereleased", "quit"}, function(func)
        love[func] = function(...)
            engine:call(func, ...)
        end
    end)

    --loader:loadMap("board1")
end
