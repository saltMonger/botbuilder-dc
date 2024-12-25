local game  = {}
local audio = require "audio"

local song, click
local volume  = 255
local loop    = true

function game.create()
  graphics.loadFont(findFile("assets/MonofontSmall.dtex"), 16, 8, 0)

  -- There are 3 types of audio that you can load.
  -- audio.CDDA : this streams tracks from a CD. very useful for music but you canot use the CD drive for other things. 
  -- audio.SFX : this loads a sound effect in memory. useful for short sounds effect.
  -- audio.WAV : this streams a file from the CD that isn't registered has a CDDA track.

  song  = audio.load(findFile("assets/song.wav"), audio.WAV)
  click = audio.load(findFile("assets/login.wav"), audio.SFX)

  -- Plays the source, other arguments ares volume (0,255) and loop (true, false).
  audio.play(song, volume, loop)

end

function game.update(dt)
  if input.getButton("START") then
    exit()
  end


  if input.getButton("A") then
    if audio.isPlaying(song) then
      audio.pause(song)
    else
      audio.resume(song)
    end

  end

  if input.getButton("X") then
    audio.play(click, 240)
  end

  if input.getButton("B") then
    audio.free(click)
  end

  if input.getButton("DOWN")  then audio.setVolume(song, song.volume - 35) end
  if input.getButton("UP")    then audio.setVolume(song, song.volume + 35) end
  
end

function game.render()
  graphics.setClearColor(0.1,0.1,0.1,1.0)

  if audio.isPlaying(song) then
    graphics.print("Streaming audio track.", 20, 20)
    graphics.print("Volume:" .. tostring(song.volume), 20, 40)
    graphics.print("Loop:" .. tostring(loop), 20, 60)
  else
    graphics.print("CDDA paused.", 20, 20)
  end

  graphics.print("Press A to pause/resume.", 20, 100)
  graphics.print("Press UP/DOWN to change volume.", 20, 120)
  graphics.print("Press X to play a SFX sound.", 20, 140)
  graphics.print("Press B to free a SFX sound.", 20, 160)
end

return game