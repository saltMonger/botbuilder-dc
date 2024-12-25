-- local entity = {}
-- local realTime = 0

-- timer = require "lib.hump_timer"

-- local texture
-- local x, y = 320, 240
-- local currentDirection = nil
-- local isMoving = false
-- local skeleton

-- function entity.healthCheck()
--     return "we're alive!!!" 
-- end

-- function entity.init()
--     texture = graphics.loadTexture(findFile("assets/spritesheet.png"))
--     skeleton = sprite.new(nil, texture, 16, 4)
--     skeleton:play(0.1, 2 + 32, 9 + 32)
-- end

-- function entity.update(dt)
--     -- we need the timer to update the animation
--     timer.update(dt)
--     realTime = realTime + dt

--     isMoving = false
--     if input.getButtonDown("UP")    then move("UP") end
--     if input.getButtonDown("DOWN")  then move("DOWN") end
--     if input.getButtonDown("LEFT")  then move("LEFT") end
--     if input.getButtonDown("RIGHT") then move("RIGHT") end

--     if isMoving == false then
--         skeleton:stop()
--         currentDirection = nil
--     end

--     if input.getButton("START") then exit() end
-- end

-- function entity.render(dt)
--     skeleton:draw(x, y)
-- end

-- function entity.free()

-- end

-- function move(newDirection)
--     local speed = 2
--     if      newDirection == "UP" then
--         skelY = skelY - speed
--     elseif  newDirection == "DOWN" then
--         skelY = skelY + speed
--     elseif  newDirection == "LEFT" then
--         skelX = skelX - speed
--     elseif  newDirection == "RIGHT" then
--         skelX = skelX + speed
--     end

--     isMoving = true

--     if newDirection == currentDirection then return end
--     currentDirection = newDirection

--     if      currentDirection == "UP" then
--         skeleton:loop(0.1, 2, 9)
--     elseif  currentDirection == "LEFT" then
--         skeleton:loop(0.1, 2+16, 9+16)
--     elseif  currentDirection == "DOWN" then
--         skeleton:loop(0.1, 2+32, 9+32)
--     elseif  currentDirection == "RIGHT" then
--         skeleton:loop(0.1, 2+48, 9+48)
--     end
-- end

-- return entity
    