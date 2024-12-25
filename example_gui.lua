local game = {}
local graphics = require "graphics"
local gui = require "gui"

local gui_fps, gui_stats
local stats = {}

function game.create()
    --graphics.setTextureFilter(graphics.filter.bilinear)
    --graphics.loadFont(findFile("assets/font_space.png"), 16, 8, 0)
    graphics.loadFont(findFile("assets/MonofontSmall.dtex"), 16, 8, 0)
    graphics.setFontSize(16)

    gui.init()

    -- gui element can be simple string, with or without newlines
    -- first argument is the type of gui element
    -- second argument is the value of the element
    -- third and fourth arguments are the x and y position of the element
    -- fifth and sixth arguments are the width and height of the elements, if left to zero, the will be automatically calculated.
    gui.add("text", "Centered Box", 320, 240, 0, 0)
    gui.add("text", "Dialog Box. Align to the left.\nSecond line.", 20, 420, 0, 0, false)



    -- gui element can be a table of strings
    gui_stats = gui.add("text", graphics.perfInfo(), 20, 20, 0, 0, false)

end

function game.update(dt)
    if input.getButton("START") then exit() end

    -- refreshing the table each frame.
    gui_stats.values = graphics.perfInfo()


    gui.update(dt)
end

function game.render(dt)
    graphics.setClearColor(0.1,0.1,0.5,1)
    gui.render()

end

function game.free()
end

return game