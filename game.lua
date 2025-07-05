local game = {}

TEST      = findFile("test.lua")

-- Change the argument to the example you want to run
game = gameworld.loadfile(TEST)

return game