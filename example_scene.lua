local game = {}
local bump  = require "lib.bump_box"
local world 

local vector = require "vector"

timer = require "lib.hump_timer"

local logo, font, sfx, bgm
local logoX, logoY  = 320, 240
local spinSpd       = 10.0
local realTime      = 0
local cursor

local states        = {"bounce", "drawManySprite", "zOrder", "bumpy", "skeleton", "shapes"}
local cState        = 1

local spritesheet, skeleton, skelCollider
local skelX, skelY      = 320, 240
local dir, lDir         = maf.vector(0, 0), maf.vector(5, 1)
local currentDirection  = nil
local isMoving          = false
local solidBox          = {}

local maxSprite     = 500
local pos           = {}
local batch         = nil

function game.create()
    font    = graphics.loadFont(findFile("assets/MonofontSmall.dtex"), 16, 8, 0)
    logo    = graphics.loadTexture(findFile("assets/logo.png"))
    cursor  = graphics.loadTexture(findFile("assets/cursor.png"))

    world       = bump.newWorld(32)
    spritesheet = graphics.loadTexture(findFile("assets/spritesheet.png"))
    skeleton    = sprite.new(nil, spritesheet, 16, 4)
    skeleton:play(0.1, 2 + 32, 9 + 32)

    skelCollider = {name="skelly", solid = true}
    world:add(skelCollider, skelX, skelY, 32, 45)

    solidBox = {name="box", x=120, y=240, w=32, h=100, solid = true}
    world:add(solidBox, solidBox.x, solidBox.y, solidBox.w, solidBox.h)

    sfx = audio.load(findFile("assets/login.wav"), audio.SFX)
    bgm = audio.load(0, audio.CDDA)
    audio.play(bgm, 250, 1)
end

function game.update(dt)
    timer.update(dt)
    realTime = realTime + dt

    if input.getButton("START") then
        exit()
    end

    if input.getButton("A") then
        audio.play(sfx, 210)
    end

    if input.getButton("LEFT") then
        cState = cState - 1
        if cState < 1 then
            cState = #states
        end
    end

    if input.getButton("RIGHT") then
        cState = cState + 1
        if cState > #states then
            cState = 1
        end
    end

    local joy = input.getJoystick(1)
    logoX = logoX + joy.x / 30.0
    logoY = logoY + joy.y / 30.0

    local trig = input.getTriggers(1)
    if trig.x > 0 then
        spinSpd = spinSpd + (trig.x * 0.01);
    end

    if trig.y > 0 then
        spinSpd = spinSpd - (trig.y * 0.01);
    end

    --C_vmuProfiler()
end

function game.render(dt)
    graphics.setClearColor(0.1,0.1,0.1,1)

    graphics.setLayer(1)
    local mode = states[cState]
    if      mode == "bounce" then
        bounceLogo()
    elseif  mode == "drawManySprite" then
        drawManySprite()
    elseif  mode == "zOrder" then
        zOrder()
    elseif  mode == "bumpy" then
        bumpy()
    elseif  mode == "skeleton" then
        skeletonAnimation()
    elseif  mode == "shapes" then
        drawShapes()
    end

    graphics.setLayer(5)
    graphics.setDrawColor(1,1,1,1)
    graphics.print("Press LEFT or RIGHT to change demo", 20, 424)
    graphics.print("DT:" .. dt, 20, 440)
end

function game.free()
    graphics.freeTexture(logo)
    graphics.freeFont(font)
    audio.free(sfx)
end

function bounceLogo()
    graphics.setDrawColor(1,0,0,1)
    local logoWidth     = math.sin(realTime)
    local logoHeight    = math.sin(realTime)
    logoWidth = 1
    logoHeight = 1
    
    graphics.drawTexture(logo, logoX, logoY, logoWidth, logoHeight, realTime * spinSpd)
end

function drawManySprite()

    if batch == nil then
        batch = {}
        local color = {0,0,1,1}
        for i=1, maxSprite do
            -- texture.texture, x, y, angle, scaleX, scaleY, uvs, z (layer), color
            batch[i] = {logo.texture, 320 + math.random(-320, 320), 240 + math.random(-240, 240), 0, 0.1, 0.1, nil, 0, color}
        end
    end
    -- this is a test to get the optimal drawing time to draw on the DC
    local t1    = getUS()
    C_renderBatch(0, 0, batch)
    local t2 = getUS()
    print("Time to draw " .. maxSprite .. " sprites:(us)" .. t2 - t1)
    print("Timer per call :(us)" .. (t2 - t1) / maxSprite)
end

function zOrder()
    local x, y = 320, 240

    graphics.setLayer(3)
    graphics.setColor(1,0,0,1)
    graphics.drawTexture(logo, x, y, 1, 1, 0)

    graphics.setLayer(2)
    graphics.setColor(0,1,0,1)
    graphics.drawTexture(logo, x+10, y+10, 1, 1, 0)

    graphics.setLayer(1)
    graphics.setColor(0,0,1,1)
    graphics.drawTexture(logo, x+20, y+20, 1, 1, 0)
end

function bumpy()
    local centerBox = {x = 320, y = 240, w = 100, h = 100}

    local collision = C_box2box(centerBox.x, centerBox.y, centerBox.w, centerBox.h, logoX, logoY, 32, 64)
    if collision == 1 then
        graphics.setDrawColor(1,0,0,1)
    else
        graphics.setDrawColor(0,1,0,1)
    end
    graphics.drawRect(centerBox.x, centerBox.y, centerBox.w, centerBox.h)
    graphics.setDrawColor(0.5, 0.5, 1, 1)
    graphics.drawTexture(cursor, logoX, logoY, 1, 1, 0)
end

function skeletonAnimation()
    graphics.setDrawColor(0.5, 0.5, 1, 1)
    graphics.drawRect(solidBox.x, solidBox.y, solidBox.w, solidBox.h)


    isMoving = checkMovement()
    lDir     = maf.vector(dir.x, dir.y)

    if isMoving == false then
       skeleton:stop()
       currentDirection = nil
    end

    local colls = world:getAllColliders()
    local c = {}
    graphics.setDrawColor(1,0,0,0.5)
    for k, v in pairs(colls) do
        graphics.drawRect(v[1], v[2], v[3], v[4])
    end

    graphics.setDrawColor(1,1,1,1)
    skeleton:draw(skelX, skelY-10)
end
-- required for the skeleton animation
function checkMovement()
    dir = input.getJoystick(1)
    dir = dir:scale(0.01)

    local coll, obj, newX, newY
    newX, newY, coll, obj = world:move(skelCollider, skelX + dir.x, skelY + dir.y)

    if #dir == 0 or coll then
        return false 
    else
        skelX = newX
        skelY = newY
    end

    

    local mainDir   = math.abs(dir.x)   > math.abs(dir.y)   and "X" or "Y"
    local lMainDir  = math.abs(lDir.x)  > math.abs(lDir.y)  and "X" or "Y"
    if lMainDir == mainDir then return true end

    if      mainDir == "Y" and dir.y < 0 then
        skeleton:loop(0.1, 2, 9)
        return true
    elseif  mainDir == "Y" and dir.y > 0 then
        skeleton:loop(0.1, 2+32, 9+32)
        return true
    end

    if      mainDir == "X" and dir.x < 0 then
        skeleton:loop(0.1, 2+16, 9+16)
        return true
    elseif  mainDir == "X" and dir.x > 0 then
        skeleton:loop(0.1, 2+48, 9+48)
        return true
    end
    
end

function drawShapes()
    local x, y = 320, 240
    graphics.setDrawColor(0,0,1,1)
    graphics.drawRect(x, y, 200, 200)
    graphics.setDrawColor(0,1,0,1)
    graphics.drawCircle(x, y, 50, 32)

    local x2, y2 = math.sin(realTime) * 300 + 320, math.cos(realTime) * 300 + 240

    graphics.setDrawColor(0,1,1,1)
    graphics.drawLine(x, y, x2, y2, 3)
end



return game


