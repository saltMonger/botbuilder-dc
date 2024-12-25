local game = {}
local graphics = require "graphics"


function game.create()
end

function game.update(dt)
    if input.getButton("START") then exit() end
end

function game.render(dt)
    graphics.setClearColor(0,0,0,1)
    
    graphics.setDrawColor(1,0,0,1)
    graphics.drawLine(100, 240, 640-100, 240, 3)

    local t = getMS() * 0.001
    local s, c = math.sin(t), math.cos(t)
    local x1, y1 = 320 - 100 * c, 240 + 100 * s
    local x2, y2 = 320 + 100 * c, 240 - 100 * s
    graphics.setDrawColor(0,0,1,1)
    graphics.drawLine(x1, y1, x2, y2, 3)

end

function game.free()
end

return game