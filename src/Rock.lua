-- Rock.lua
-- Contains Rock and RockFormation object definitions

Rock = {x, y, size}
RockFormation = {rocks}

function Rock:new(x, y, size)
    local obj = {x=x, y=y, size=size}
    setmetatable(obj, self)
    self.__index = self

    return obj
end

function RockFormation:new()
    local obj = {rocks = {}}
    setmetatable(obj, self)
    self.__index = self

    return obj
end

function RockFormation:generate()
    local rock_origin = {x = 890, y = 990}
    for i=1,70 do
        local x = math.random(0, 440 + 12 * i)
        local y = math.random(0, 400 - 8 * i)
        local s = math.random(5, 18)
        local r = Rock:new(rock_origin.x + x, rock_origin.y + y, s)
        table.insert(self.rocks, r)
    end
    print("A new rock formation arose")
end

