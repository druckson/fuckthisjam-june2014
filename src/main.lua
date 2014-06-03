local Engine = require "engine"
--local Input = require "systems/input"
local Graphics = require "systems/graphics"

local engine = Engine()

function love.load()
    --engine:addSystem("input", Input())
    engine:addSystem("graphics", Graphics())
end

function love.update(dt)
    engine:update(dt)
end

function love.draw()
    engine:draw()
end
