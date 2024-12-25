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
        ore = 5,
        metal = 0,
        badges = 0,
        power = 0,
        boons = 0
    },
    buildings = {
        -- power needs to be evaluated first (jank)
        power = {},
        ore = {},
        metal = {},
        badges = {},
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

function slowTick(currTick)
    lastTick = currTick
    for name, set in pairs(scene.buildings) do
        for i=1,#set do
            if set[i] ~= nil then
                set[i]:produce(scene.resources)
            end 
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
        slowTick(currTick)
    end
end

function game.render(dt)
    graphics.setClearColor(0,0,0,1)
  
    graphics.setDrawColor(1,1,1,1)
    -- draws text at the given position, and centers it if you add the "center" flag
    graphics.print("Fuck off!!!!", 320, 240, "center")

    player:render(dt)

    graphics.print("Time overall:" .. tostring(realTime), 20, 20)
    graphics.print("Tick:" .. tostring(lastTick), 200, 20)
    graphics.print("SCENE: " .. tostring(scene), 20, 30)

    -- graphics.print("Loop:" .. tostring(loop), 20, 60)
    graphics.print("ERROR > " .. tostring(loadError), 20, 100)
    graphics.print("PLAYER > " .. tostring(entity), 20, 120)
    graphics.print("POS > " .. tostring(scene.buildingManager), 20, 140)
    graphics.print("BUILDINGS > " .. tostring(#scene.buildings.ore), 20, 160)

    for i = 1,#scene.buildings.ore,1 do
        scene.buildings.ore[i]:render(dt)
    end

    graphics.print("Ore:" .. tostring(scene.resources.ore), 20, 400)
    graphics.print("Metal:" .. tostring(scene.resources.metal), 100, 400)
    graphics.print("Badges:" .. tostring(scene.resources.badges), 180, 400)

    graphics.print("Power:" .. tostring(scene.resources.power), 20, 420)
    graphics.print("Boons:" .. tostring(scene.resources.boons), 100, 420)
end

function game.free() 
    graphics.freeTexture(tex)
end

return game