local game = {}

-- BASIC TOPICS
TEXTURE     = findFile("1A_texture.lua")
FONT        = findFile("1B_font.lua")
LAYERS      = findFile("1C_layers.lua")
INPUT       = findFile("2_input.lua")
AUDIO       = findFile("3_audio.lua")

-- ADVANCED TOPICS
SCENE     = findFile("example_scene.lua")
TILED     = findFile("example_tiled.lua")
GUI       = findFile("example_gui.lua")
TEXT      = findFile("example_text.lua")
ROMDISK   = findFile("example_romdisk.lua")
VIDEO     = findFile("example_video.lua")
LINE      = findFile("example_line.lua")
SAVEFILE  = findFile("example_savefile.lua")
ANIMATION = findFile("example_animation.lua")
COLLISION = findFile("example_collision.lua")
MATH      = findFile("example_math.lua")
BUMP      = findFile("example_bump.lua")


TEST      = findFile("test.lua")

-- Change the argument to the example you want to run
game = gameworld.loadfile(TEST)

return game