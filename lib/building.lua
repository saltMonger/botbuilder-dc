local building = {}

building.__index = building
setmetatable(building, {__call = function(cls, ...) return cls.new(...) end,})

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
        tex = "assets/refinery.png",
    },
    metal1 = {
        production = 10,
        powerDrain = 7,
        cost = 200,
        tex = "assets/refinery.png",
    },
    metal2 = {
        production = 15,
        powerDrain = 10,
        cost = 300,
        tex = "assets/refinery.png",
    },
    badges0 = {
        production = 5,
        powerDrain = 5,
        cost = 100,
        tex = "assets/factory.png",
    },
    badges1 = {
        production = 10,
        powerDrain = 7,
        cost = 200,
        tex = "assets/factory.png",
    },
    badges2 = {
        production = 15,
        powerDrain = 10,
        cost = 300,
        tex = "assets/factory.png",
    },
    power0 = {
        production = 5,
        powerDrain = 5,
        cost = 100,
        tex = "assets/power.png",
    },
    power1 = {
        production = 10,
        powerDrain = 0,
        cost = 200,
        tex = "assets/power.png",
    },
    power2 = {
        production = 15,
        powerDrain = 0,
        cost = 300,
        tex = "assets/power.png",
    },
    boons0 = {
        production = 5,
        powerDrain = 5,
        cost = 100,
        tex = "assets/market.png",
    },
    boons1 = {
        production = 10,
        powerDrain = 0,
        cost = 200,
        tex = "assets/market.png",
    },
    boons2 = {
        production = 15,
        powerDrain = 0,
        cost = 300,
        tex = "assets/market.png",
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
    return newBuilding(nx, ny, graphics.loadTexture(findFile(found.tex)), building, found), resources
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
    if self.resource == "power" then 
        resources["power"] = resources["power"] + self.buildingInfo.productionAmount
        return resources 
    end

    if resources["power"] > powerDrain then
        resources["power"] = resources["power"] - self.buildingInfo.powerDrain
        resources[resource] = resources[resource] + self.buildingInfo.productionAmount
    end

    -- todo: set palette grayscale if it doesn't have power?

    return resources
end

function building:devProduce(resources)
    resources[self.resource] = resources[self.resource] + self.buildingInfo.production
    return resources
end 

function building:render(dt)
    if self.productionRun then 
        graphics.print(self.resource .. " " .. self.buildingInfo.production, 20, 300)
    end
    graphics.drawTexture(self.sprite, self.x, self.y, 1, 1)
end

return building