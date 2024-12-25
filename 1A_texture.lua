local game = {}

local logo 
local logoColor = {1,1,1,1}

function game.create()
  -- load a texture (.png or .dtex) from a path
  -- the texture must be pow2 in side, doesn't have to be square (16,32,64,128,256,512,1024)
  -- notice the use of findFile. findFile will look for the file in many location: /pc /cd /sd /rd

  logo = graphics.loadTexture(findFile("assets/logo.dtex"))
  --logo = graphics.loadTexture(findFile("assets/logo.png"))

  logoColor = {math.random(), math.random(), math.random(),1}
end

function game.update(dt)
  if input.getButton("START") then
    exit()
  end

  if input.getButton("A") then
    logoColor = {math.random(),math.random(),math.random(),1}
  end


end

function game.render(dt)
  -- sets the background color
  -- the colors are floating point between 1.0 and 0.0
  graphics.setClearColor(0,0,0,1)

  -- sets the color of subsequent texture, quads, text, etc.
  -- these color can aso be passed as a table {r,g,b,a}
  graphics.setDrawColor(logoColor)

  -- draws a texture at the center of the screen
  -- notice the x-y coordinate are referencing the center of the image.
  -- draw texture takes the following arguments: texture, x, y, scale x (optional), scale y(optional), rotation(optional)
  --graphics.print("DT: " .. dt, 20, 440)
  graphics.drawTexture(logo, 320, 240, 0.5, 0.5, 180)
end

function game.free()
  -- free the texture from memory
  graphics.freeTexture(logo)
end

return game