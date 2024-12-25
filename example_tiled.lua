local game = {}
local tiled     = require "tiled2"
local graphics  = require "graphics"
local bump      = require "lib.bump_box"

local map       = nil
local player    = nil
local world     = nil

--[[
    This is a very minimal example for loading tiled maps exported as .lua file.
    Right now, the tiled2.lua module only supports 1 tileset per map.

    Make sure you do the following :
    1. Embed the spritesheet in the map file. (Edit > Preferences > Export option > Embed tileset)
    2. Export the map as .lua file.
    3. Save the spritesheet as a .png file (make sure it is pow2).
]]--

function game.create()
    -- this takes a tiled map export with the lua extension
    -- and a image file with the sprite data.
    map = tiled.load("assets/map.lua", "assets/minimal8.png")
    map.scale = 2
    map.batch = map:createBatch()

    world = bump.newWorld(64)
    for _, coll in ipairs(map.colliders) do
        coll.solid = true
        world:add(coll, coll.x, coll.y, coll.width, coll.height)
    end

    --player = map:getObject("player")
    --player.y = player.y - 1
    --world:add(player, player.x, player.y, player.w, player.h)
end

function game.update(dt)
    if input.getButton("START") then exit() end

    --[[
    local nX, nY = player.x, player.y
    if input.getButtonDown("LEFT")  then nX = nX - 1 end
    if input.getButtonDown("RIGHT") then nX = nX + 1 end

    local coll, collObject
    coll, player.x, player.y, collObject = world:move(player, nX, nY)

    if coll then
        --print("Colliding with something")
    end
    --]]
end

function game.render()
    local camX, camY = -320+(map.width * map.scale)/2, -240+(map.height * map.scale)/2
    graphics.camera.pos:set(camX, camY)

    local scale = map.scale
    graphics.setDrawColor(1,1,1,1)
    for k, v in pairs(world.world) do
        --graphics.drawRect(v[1]*scale, v[2]*scale, v[3]*scale, v[4]*scale)
    end

    graphics.setDrawColor(1,1,1,1)
    map:render()
    map:renderBatch(-camX, -camY)
    --map:renderObjects()

end

return game