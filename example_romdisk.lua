local game = {}

-- a romdisk is a small compressed package that you can load direcently into memory.
-- this can be useful if you want to load a small bundle of assets for a level or a menu.
-- the files can be of any types.

-- to create romdisks, add a folder to your game project and prefix it with "rd_" and run 'make romdisk'

local texture

function game.create()
    -- load a romdisk file at a specific mount point.
    mountRomdisk(findFile("rd_example.img"), "/rd")

    -- load a texture from the romdisk
    texture = graphics.loadTexture("/rd/golem.dtex")

    -- now that we have loaded the texture, we can unmount the romdisk to free up memory.
    -- you can unmount the romdisk with the following command:
    unmountRomdisk("/rd")
end

function game.update(dt)
    if input.getButton("START") then
        exit()
    end
end

function game.render()
    graphics.drawTexture(texture, 320, 240, 0.5, 0.5)
end

return game