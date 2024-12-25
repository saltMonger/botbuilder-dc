local maf = require "lib.maf"

local game = {}

function game.create()
  local loopLimit = 100
  local t1, t2
  -- test regular vector distance
  local v1 = maf.vector(1, 1)
  local v2 = maf.vector(4, 5)
  local dist = 0
  

  -- SIN/COS ----------------------------------
  print("-- SIN/COS --")
  t1 = os.clock()
  local r = 0
  for i=1, loopLimit do
    r = math.sin(0.5)
  end
  t2 = os.clock()
  print("Regular math.sin time: " ..  t2-t1) -- 0.01

  t1 = os.clock()
  local r = 0
  local sin = math.sin
  for i=1, loopLimit do
    r = sin(0.5)
  end
  t2 = os.clock()
  print("Local math.sin time: " ..  t2-t1) -- 0.01

  t1 = os.clock()
  local r = 0
  for i=1, loopLimit do
    r = sh4_sin(0.5)
  end
  t2 = os.clock()
  print("sh4_sin time: " ..  t2-t1) -- 0.01

  t1 = os.clock()
  local r = 0
  sin = sh4_sin
  for i=1, loopLimit do
    r = sin(0.5)
  end
  t2 = os.clock()
  print("Local sh4_sin time: " ..  t2-t1) -- 0.01


  -- DISTANCE ----------------------------------
  print("-- DISTANCE --")
  t1 = os.clock()
  for i=1, loopLimit do
    dist = v1:distance(v2)
  end
  t2 = os.clock()
  print("Regular maf.distance time: " ..  t2-t1) -- 0.39

  t1 = os.clock()
  for i=1, loopLimit do
    dist = sh4_distance(v1.x,v1.y,v2.x,v2.y)  
  end
  t2 = os.clock()
  print("sh4_distance time: " ..  t2-t1) -- 0.06 



  -- LERP -----------------------------------
  print("-- LERP --")
  --do a test that does lerp opration ina  for loop
  local out = maf.vector()
  t1 = os.clock()
  for i=1, loopLimit do
    out = v1:lerp(v2, 0.5)
  end
  t2 = os.clock()
  print("Regular maf.lerp time: " ..  t2-t1)

  t1 = os.clock()
  for i=1, loopLimit do
    out.x = sh4_lerp(v1.x, v2.x, 0.5)
    out.y = sh4_lerp(v1.y, v2.y, 0.5)
  end
  t2 = os.clock()
  print("sh4_lerp time: " ..  t2-t1)

  maf.vector.lerp = vec_lerp
  t1 = os.clock()
  for i=1, loopLimit do
    out = v1:lerp(v2, 0.5)
  end
  t2 = os.clock()
  print("Replaced lerp time: " ..  t2-t1)

  maf.vector.lerp = vec_lerp
  local lerp = maf.vector.lerp
  t1 = os.clock()
  for i=1, loopLimit do
    out = lerp(v1, v2, 0.5)
  end
  t2 = os.clock()
  print("Local lerp time: " ..  t2-t1)

  t1 = os.clock()
  lerp = sh4_lerp
  for i=1, loopLimit do
    out.x = lerp(v1.x, v2.x, 0.5)
    out.y = lerp(v1.y, v2.y, 0.5)
  end
  t2 = os.clock()
  print("Local sh4_lerp time: " ..  t2-t1)

end

function game.update(dt)
  if input.getButton("START") then
    exit()
  end
end

function game.render(dt)
end

function game.free()
end

function vec_lerp(v, u, t, out)
  out = out or v
  out.x = sh4_lerp(v.x, u.x, t)
  out.y = sh4_lerp(v.y, u.y, t)
  out.z = sh4_lerp(v.z, u.z, t)
  return out
end

return game