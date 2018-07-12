-- Structure.lua
-- Contains definition and methods for the Structure object (used for any building or object)

Structure = {style, x, y, width, height, rad}
TENT = "tent"
HOUSE = "house"

function Structure:new(s)
    local obj = {}
    setmetatable(obj, self)
    self.__index = self

    return obj
end

function Structure:generate(s, x, y, w, h)

end

function Structure:generate(s, x, y, r)
