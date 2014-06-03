local Class = require "lib/hump/class"

local Graphics = Class{
    init = function(self)
        self.entities = {}
    end
}

function Graphics:config(data)
    
end

function Graphics:draw()
    love.graphics.reset()
    love.graphics.setBackgroundColor(1, 16, 19)

    love.graphics.setColor(150, 150, 150)
    love.graphics.print("FPS: "..love.timer.getFPS(), 10, 10)

    --love.graphics.print("> "..self.message, 10, 30)
    --loveframes.draw()
end

return Graphics
