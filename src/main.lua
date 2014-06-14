local Engine = require "engine"

local Graphics = require "systems/graphics"
local Physics = require "systems/physics"
local Transform = require "systems/transform"
local MapCreator = require "systems/map-creator"
local MapLoader = require "systems/map-loader"
local MapSaver = require "systems/map-saver"
local Input = require "systems/input"

local engine = Engine()

function love.load()
    -- Create systems
    engine:addSystem("transform", Transform())
    engine:addSystem("physics", Physics())
    engine:addSystem("graphics", Graphics())
    engine:addSystem("map-creator", MapCreator())
    engine:addSystem("map-loader", MapLoader())
    engine:addSystem("map-saver", MapSaver())
    engine:addSystem("input", Input())

    -- Configure systems
    engine:call("config", engine, {
        worldScale = 1,
        gravity = 20,
        backgroundColor = {0, 30, 60, 255},
        foregroundColor = {150, 150, 150, 255}
    })

    -- Wire up love calls
    local calls = {"update", "draw", "resize", "focus", "visible", "keypressed", "keyreleased", "joystickpressed", "joystickreleased", "joystickaxis", "joystickhat", "mousefocus", "mousepressed", "mousereleased", "quit"}
    
    for _, call in pairs(calls) do
        love[call] = function(...)
            engine:call(call, ...)
        end
    end

    engine:call("load", "board1")
end
