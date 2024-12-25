local entity = {}

entity.__index = entity
setmetatable(entity, {__call = function(cls, ...) return cls.new(...) end,})

timer = require "lib.hump_timer"

function entity.new(nx, ny)
    local obj = {
        realTime = 0,
        x = nx,
        y = ny,
        texture = {},
        sprite = {},
        currentDirection = nil,
        isMoving = false,
    }

    local self = setmetatable(obj, entity)
    return self
end

function entity:healthCheck()
    return "we're alive!!!"
end

function entity:init()
    self.texture = graphics.loadTexture(findFile("assets/spritesheet.png"))
    self.sprite = sprite.new(nil, self.texture, 16, 4)
    self.sprite:play(0.1, 2 + 32, 9 + 32)
end

function entity:update(dt, scene)
    -- we need the timer to update the animation
    timer.update(dt)
    self.realTime = self.realTime + dt

    self.isMoving = false
    if input.getButtonDown("UP")    then self:move("UP") end
    if input.getButtonDown("DOWN")  then self:move("DOWN") end
    if input.getButtonDown("LEFT")  then self:move("LEFT") end
    if input.getButtonDown("RIGHT") then self:move("RIGHT") end

    if self.isMoving == false then
        self.sprite:stop()
        self.currentDirection = nil
    end

    if input.getButton("A") then
        self.debugButtonPressed = true
        local ret, resources = scene.buildingManager.devBuild(self.x, self.y, "ore", scene.resources)
        self.returnSent = ret
        scene.resources = ret.resources
        table.insert(scene.buildings.ore, ret)
    end 

    if input.getButton("START") then exit() end

    return scene
end

function entity:render(dt)
    self.sprite:draw(self.x, self.y)
    if self.debugButtonPressed then
        graphics.print("CURSOR > Build button pressed", 20, 180)
    end

    graphics.print("RETURN > " .. tostring(self.returnSent), 20, 200)
end

function entity:move(dir)
    local speed = 2
    if      dir == "UP" then
        self.y = self.y - speed
    elseif  dir == "DOWN" then
        self.y = self.y + speed
    elseif  dir == "LEFT" then
        self.x = self.x - speed
    elseif  dir == "RIGHT" then
        self.x = self.x + speed
    end

    self.isMoving = true

    if dir == self.currentDirection then return end
    self.currentDirection = dir

    if      dir == "UP" then
        self.sprite:loop(0.1, 2, 9)
    elseif  dir == "LEFT" then
        self.sprite:loop(0.1, 2+16, 9+16)
    elseif  dir == "DOWN" then
        self.sprite:loop(0.1, 2+32, 9+32)
    elseif  dir == "RIGHT" then
        self.sprite:loop(0.1, 2+48, 9+48)
    end
end

return entity