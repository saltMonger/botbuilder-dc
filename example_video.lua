local game = {}


function game.create()
  -- plays a video file, coordinate are based on the center of the video
  -- arguments are: file, x, y, width, height
  graphics.playVideo(findFile("assets/test.roq"), 320, 240, 640, 480)
end

function game.update(dt)
  if input.getButton("START") then
    exit()
  end

end

function game.render(dt)

end

return game