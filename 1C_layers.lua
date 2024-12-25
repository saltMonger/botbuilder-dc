local game = {}

local logo 

function game.create()
  logo = graphics.loadTexture(findFile("assets/logo.dtex"))
  font = graphics.loadFont(findFile("assets/MonofontSmall.dtex"), 16, 8)
end

function game.update(dt)
  if input.getButton("START") then
    exit()
  end
end

function game.render(dt) 
  graphics.setClearColor(0,0,0,1)
  graphics.setDrawColor(1,1,1,1)

  -- Order should be WHITE, GREEN, RED

  graphics.setLayer(3)
  graphics.drawTexture(logo, 320, 240)

  
  graphics.setLayer(2)
  graphics.setDrawColor(1,0,0,1)
  graphics.drawTexture(logo, 320 + 20, 240 + 20)

  
  graphics.setLayer(1)
  graphics.setDrawColor(0,1,0,1)
  graphics.drawTexture(logo, 320 + 10, 240 + 10)
  
end

function game.free()
  -- free the texture from memory
  graphics.freeTexture(logo)
end

return game