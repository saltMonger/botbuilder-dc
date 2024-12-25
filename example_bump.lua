local game = {}

local bump  = require "lib.bump_box"
local world = bump.newWorld(32)

local box     = {name = "box",    x=320, y=240, w=100, h=100}
local bullet  = {name = "bullet", x=320, y=240, w=5, h=5}
local bullets = {}

local boxCollide = false

function game.create()
  local font = graphics.loadFont(findFile("assets/MonofontSmall.dtex"), 16, 8, 0)

  --world:add(box, box.x-box.w/2, box.y-box.h/2, box.w, box.h)

  for i=1, 100 do
    local b = {name = "bullet", x=math.random(0,640), y=math.random(0,480), w=10, h=10}
    world:add(b, b.x-b.w/2, b.y-b.h/2, b.w, b.h)
    b.dX = math.random(-2,2) + 0.2
    b.dY = math.random(-2,2) + 0.2
    table.insert(bullets, b)
  end

end


function game.update(dt)
  if input.getButton("START") then
    exit()
  end

  local v = nil
  for i=1, 10 do v = bullets[i]
    v.x = v.x + v.dX
    v.y = v.y + v.dY
    
    if v.x < 0 or v.x > 640 then
      v.dX = -v.dX
    end
    if v.y < 0 or v.y > 480 then
      v.dY = -v.dY
    end
    local coll, obj = false, nil
    v.x, v.y, coll, obj = world:move(v, v.x, v.y)
    if coll then
    
    end
  end

end

function game.render(dt)
  graphics.setClearColor(1,0,0,1)
  graphics.setDrawColor(0,0,0,1)
  graphics.print("Render Time:" .. getUS(), 20, 412)
  graphics.print("DT:" .. dt, 20, 426)
  graphics.print("FPS:" .. getFPS(), 20, 440)

  if boxCollide then
    graphics.setDrawColor(0,1,0,1)
  else
    graphics.setDrawColor(1,1,1,1)
  end

  --graphics.drawRect(box.x, box.y, box.w, box.h)

  graphics.setColor(1,1,1,1)
  for i, v in ipairs(bullets) do  
    --graphics.drawRect(world:getPosition(v))
    graphics.drawRect(v.x, v.y, v.w, v.h)
    --graphics.drawSpriteFast(-1, v.x, v.y, v.w, v.h, 0, nil)
  end

  
end

function game.free()
  graphics.freeTexture(tex)
end

function collisionRoutine()
  local collision = 0
  for i, v in ipairs(bullets) do
    collision = C_box2box(v.x, v.y, v.w, v.h, box.x, box.y, box.w, box.h)
    if collision == 1 then
      return true, 1
    end
  end
  return false, 0
end

return game