local entity = {}

entity.__index = entity
setmetatable(entity, {__call = function(cls, ...) return cls.new(...) end,})

timer = require "lib.hump_timer"

local buildItems = {
    "ore", "metal", "badges", "power", "boons"
}

local gridSpacing = 32

function entity.new(nx, ny)
    local obj = {
        realTime = 0,
        x = nx,
        y = ny,
        texture = {},
        sprite = {},
        currentDirection = nil,
        isMoving = false,
        selectedBuildItem = 1,

        lastTickMoved = 0,
        targetTick = 0
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

-- todo: refactor this shit
-- function entity:latchInput(typ, val)
--     if typ == "left_trigger" then
--         if self.latch_leftTrigger == nil then 
--             self.latch_leftTrigger = val
--             return true
--         end
--         if (self.latch_leftTrigger > 0 and val == 0) then
--             self.latch_leftTrigger = 0
--             return false
--         end
--         if (self.latch_leftTrigger == 0 and val > 0) then
--             self.latch_leftTrigger = val
--             return true
--         end
--         return false
--     end
--     if self.latch_rightTrigger == nil then 
--         self.latch_rightTrigger = val
--         return true
--     end
--     if (self.latch_rightTrigger > 0 and val == 0) then
--         self.latch_rightTrigger = 0
--         return false
--     end
--     if (self.latch_rightTrigger == 0 and val > 0) then
--         self.latch_rightTrigger = val
--         return true
--     end
--     return false
-- end

function entity:latchInput(typ, val)
    if self["latch_"+typ] == nil then 
        self["latch_"+typ] = val
        return true
    end
    if (self["latch_"+typ] > 0 and val == 0) then
        self["latch_"+typ] = 0
        return false
    end
    if (self["latch_"+typ] == 0 and val > 0) then
        self["latch_"+typ] = val
        return true
    end
    return false
end

function entity:moveLatch()
    local dirX, dirY
    if input.getButtonDown("UP") then dirX = "UP"
    elseif input.getButtonDown("DOWN") then dirX = "DOWN" end
    
    if input.getButtonDown("LEFT") then dirY = "LEFT"
    elseif input.getButtonDown("RIGHT") then dirY = "RIGHT" end

    if dirX or dirY then
        -- early return here
        return {
            dirX = dirX,
            dirY = dirY,
            target = 10
        }
    end
    -- try to read joystick
    local joystick = input.getJoystick(1)
    local mag = 0
    if joystick.x ~= 0 then
        if joystick.x > 0 then 
            dirX = "RIGHT"
            mag = joystick.x
        else 
            dirX = "LEFT" 
            mag = -joystick.x 
        end 
        -- also need magnitude
    end

    if joystick.y ~= 0 then
        if joystick.y > 0 then
            dirY = "UP"
            mag = mag + joystick.y
        else 
            dirY = "DOWN"
            mag = mag + (-joystick.y)
        end
    end

    if dirX and dirY then
        mag = mag / 2
    end

    return {
        dirX = dirX,
        dirY = dirY, 
        target = mag
    }
end

function entity:update(dt, scene)
    -- we need the timer to update the animation
    timer.update(dt)
    self.realTime = self.realTime + dt

    local movement = self:moveLatch()
    self.targetTick = movement.target
    if self.lastTickMoved >= self.targetTick then
        self.lastTickMoved = 0
        self:move(movement)
    end

    -- todo, this needs changed...
    local currTick = math.floor(self.realTime / 2)
    if currTick > self.lastTickMoved then
        self.lastTickMoved = self.lastTickMoved + 1
    end

    if self.isMoving == false then
        self.sprite:stop()
        self.currentDirection = nil
    end

    if input.getButton("A") then
        self.debugButtonPressed = true
        local ret, resources = scene.buildingManager.devBuild(self.x, self.y, buildItems[self.selectedBuildItem], scene.resources)
        scene.resources = resources
        table.insert(scene.buildings.ore, ret)
    end 

    local trig = input.getTriggers(1) 
    if self:latchInput("left_trigger", trig.x) then
        self.selectedBuildItem = self.selectedBuildItem - 1
    end 
    if self:latchInput("right_trigger", trig.y) then
        self.selectedBuildItem = self.selectedBuildItem + 1
    end

    if self.selectedBuildItem < 1 then
        self.selectedBuildItem = 1
    elseif self.selectedBuildItem > #buildItems then
        self.selectedBuildItem = #buildItems
    end 

    if input.getButton("START") then exit() end

    return scene
end

function entity:render(dt)
    self.sprite:draw(self.x, self.y)
    if self.debugButtonPressed then
        graphics.print("CURSOR > Build button pressed", 20, 180)
    end
    if self.latch_rightTrigger then
        graphics.print("R_TRIGGER: " .. tostring(self.latch_rightTrigger), 160, 180)
    end

    graphics.print("BUILD ITEM: " .. tostring(buildItems[self.selectedBuildItem]), 20, 440)
    -- graphics.print("BUILD ITEM: " .. tostring(buildItems[self.selectedBuildItem]), 20, 440)
end

function entity:move(dir)
    local speed = 2
    if      dir.dirY == "UP" then
        self.y = self.y - speed
    elseif  dir.dirY == "DOWN" then
        self.y = self.y + speed
    end

    if  dir.dirX == "LEFT" then
        self.x = self.x - speed
    elseif  dir.dirX == "RIGHT" then
        self.x = self.x + speed
    end
end

return entity