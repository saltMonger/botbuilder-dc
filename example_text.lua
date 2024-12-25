local game = {}
local graphics = require "graphics"

function game.create()
    -- image (.detx or .png), col, row
    graphics.loadFont(findFile("assets/font_space.png"), 16, 8)
end

function game.update(dt)
    if input.getButton("START") then exit() end

end

function game.render(dt)
    graphics.setClearColor(0.1, 0.1, 0.1, 1)
    graphics.setFontSize(16)
    graphics.setTextureFilter(graphics.filter.none)
    graphics.print("Space Mono\nRendered at 16 pixel.", 20, 20)

    graphics.setFontSize(24)
    graphics.setTextureFilter(graphics.filter.bilinear)
    graphics.print("Space Mono\nRendered at 24 pixel.", 20, 100)

    graphics.setFontSize(32)
    graphics.print("Space Mono\nOriginal resolution (32px).", 20, 200)

    graphics.setTextureFilter(graphics.filter.none)
    graphics.setFontSize(50)
    graphics.print("Space Mono\nRendered at 50 pixel.", 20, 350)
end

function game.free()
end

return game