local game = {}

--[[
Notes on using vector math.

-- +, -, X, /
The fastest way to the simple add, sub, mul, div math is to decompose the vector and to regular operation on each component
result.x, result.y, result.z = v1.x + v2.x, v1.y + v2.y, v1.z + v2.z

The second best is to make a local function that calls the vector lib.
result.x, result.y, result.z = vectorAdd(v1.x, v1.y, v1.z, v2.x, v2.y, v2.z)

For lenth and distance, use vectorLength(v1) and vectorDistance(v1, v2) 




]]--

function game.create()
    print("testing new vector lib")
    local test = vector(2, 5)
    local test2 = vector(3, 4)
    print(test, test2)
    local result = vector(0,0,0)
    local va = function(x1, y1, z1, x2, y2, z2)
        return x1 / x2, y1 / y2, z1 / z2
    end

    for i = 1, 5 do
        print("----------------")
        t1 = getMS()
        for i = 1, 10000 do
            result.x, result.y, result.z = va(test.x, test.y, test.z, test2.x, test2.y, test2.z)
        end
        print(result)
        print("Time for vector div (10k): ", getMS() - t1)
    end
end

function game.update(dt)

end

function game.render(dt)

end

return game