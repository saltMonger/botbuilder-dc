local building = {}

building.__index = building
setmetatable(building, {__call = function(cls, ...) return cls.new(...) end,})

-- resources
-- 
local buildingData = {
    ore0 = {
        production = 5,
        powerDrain = 5,
        cost = 100,
        tex = "assets/ore.png",
    },
    ore1 = {
        production = 10,
        powerDrain = 7,
        cost = 200,
        tex = "assets/ore.png",
    },
    ore2 = {
        production = 15,
        powerDrain = 10,
        cost = 300,
        tex = "assets/ore.png",
    },
    metal0 = {
        production = 5,
        powerDrain = 5,
        cost = 100,
        tex = "assets/ore.png",
    },
    metal1 = {
        production = 10,
        powerDrain = 7,
        cost = 200,
        tex = "assets/ore.png",
    },
    metal2 = {
        production = 15,
        powerDrain = 10,
        cost = 300,
        tex = "assets/ore.png",
    },
    badge0 = {
        production = 5,
        powerDrain = 5,
        cost = 100,
        tex = "assets/ore.png",
    },
    badge1 = {
        production = 10,
        powerDrain = 7,
        cost = 200,
        tex = "assets/ore.png",
    },
    badge2 = {
        production = 15,
        powerDrain = 10,
        cost = 300,
        tex = "assets/ore.png",
    },
    badge0 = {
        production = 5,
        powerDrain = 5,
        cost = 100,
        tex = "assets/ore.png",
    },
    badge1 = {
        production = 10,
        powerDrain = 0,
        cost = 200,
        tex = "assets/ore.png",
    },
    badge2 = {
        production = 15,
        powerDrain = 0,
        cost = 300,
        tex = "assets/ore.png",
    },
}

local function newBuilding(nx, ny, tex, resource, buildingInfo)
    local obj = {
        x = nx,
        y = ny,
        sprite = tex,
        resource = resource,
        buildingInfo = buildingInfo,
        level = 0,
    }

    local self = setmetatable(obj, building)
    return self
end

function building.build(nx, ny, building, resources)
    local found = buildingData[building + "0"]
    if found == nil then
        return "not found", resources
    end

    -- need a way to present error if not enough money...
    if found.cost > resources.boons then
        return nil, resources
    end
    resources.boons = resources.boons - found.cost
    local texture = graphics.loadTexture(findFile(found.tex)) 

    return building.new(nx, ny, texture, building, found), resources
end

function building.devBuild(nx, ny, building, resources)
    local found = buildingData[building .. "0"]
    if found == nil then
        return "Broke", resources
    end

    return newBuilding(nx, ny, graphics.loadTexture(findFile(found.tex)), building, found), resources
end



function building:report()
    return string(x) + " " + string(y) + " is producing" + resource
end

function building:upgrade(resources)

end

function building:produce(resources)
    return self:devProduce(resources)
    -- if self.resource == "power" then 
    --     resources["power"] = resources["power"] + self.buildingInfo.productionAmount
    --     return resources 
    -- end

    -- if resources["power"] > powerDrain then
    --     resources["power"] = resources["power"] - self.buildingInfo.powerDrain
    --     resources[resource] = resources[resource] + self.buildingInfo.productionAmount
    -- end
    -- return resources
end

function building:devProduce(resources)
    resources[self.resource] = resources[self.resource] + self.buildingInfo.productionAmount
    return resources
end 

function building:render(dt)
    graphics.drawTexture(self.sprite, self.x, self.y, 2, 2)
end

return building