local entity

local game = {}
local realTime = 0

local song
local volume = 255
local loop = true

local player = {}
local file
local loadError
local test2
local rawTest

local lastTick = 0
local currTick = 0

local scene = {
    resources = {
        ore = 0,
        metal = 0,
        badges = 0,
        power = 0,
        boons = 0
    },
    buildings = {
        ore = {},
        metal = {},
        badges = {},
        power = {},
        boons = {},
    },
    buildingManager = {}
}

local function loadLib(file)
    local raw, fe = loadfile(findFile(file))
    if raw == nil then
        loadError = fe
        print(loadError)
        return nil
    end
    loadError = "found file: " .. file
    return raw()
end

function slowTick()
    for i=1,#scene.buildings do
        for j=1,#scene.buildings[i] do
            scene.resources = scene.buildings[i][j]:produce(0, scene.resources)
        end
    end 
end

function game.create()
    graphics.loadFont(findFile("assets/MonofontSmall.dtex"), 16, 8)
    song = audio.load(findFile("assets/adventures.wav"), audio.WAV)

    entity = loadLib("lib/entity.lua")
    if entity == nil then
        return
    end
    scene.buildingManager = loadLib("lib/building.lua")
    if scene.buildingManager == nil then
        loadError = "failed to load buildingManager"
        return
    end
    loadError = "libs loaded"
    player = entity.new(320, 240)
    player:init()
    audio.play(song, volume, loop)
end

function game.update(dt)
    scene = player:update(dt, scene)

    realTime = realTime + dt
    local currTick = math.floor(realTime / 2)
    if currTick > lastTick then
        lastTick = currTick
    end
    -- if lastTick != tick then
    --     slowTick()
    --     lastTick = tick
    -- end 
    -- if lastTick != tick then
    --     slowTick()
    -- end
end

function game.render(dt)
    graphics.setClearColor(0,0,0,1)
  
    graphics.setDrawColor(1,1,1,1)
    -- draws text at the given position, and centers it if you add the "center" flag
    graphics.print("Fuck off!!!!", 320, 240, "center")

    graphics.print("Time overall:" .. tostring(realTime), 20, 20)
    graphics.print("Tick:" .. tostring(lastTick), 200, 20)

    graphics.print("Ore:" .. tostring(scene.resources.ore), 20, 40)
    graphics.print("Power:" .. tostring(scene.resources.power), 100, 40)

    -- graphics.print("Loop:" .. tostring(loop), 20, 60)
    graphics.print("ERROR > " .. tostring(loadError), 20, 100)
    graphics.print("PLAYER > " .. tostring(entity), 20, 120)
    graphics.print("POS > " .. tostring(scene.buildingManager), 20, 140)
    graphics.print("BUILDINGS > " .. tostring(#scene.buildings.ore), 20, 160)

    player:render(dt)

    for i = 1,#scene.buildings.ore,1 do
        scene.buildings.ore[i]:render(dt)
    end
end

function game.free() 
    graphics.freeTexture(tex)
end

return game