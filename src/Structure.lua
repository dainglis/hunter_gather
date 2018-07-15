-- Structure.lua
-- Contains definition and methods for the Structure object (used for any building or object)
--   HouseStructure
--   TentStructure
-- TODO: Modify class definition to use abstractness with standard Structure object
-- Structures contain a "draw" method which will allow them to be drawn in the plane. This requires the shorthands
--   for default love libraries, specified in main.lua

HouseStructure = {x, y, width, height, trim}
TentStructure = {x, y, rad}

Structure = {}

function Structure:new()
    local obj = {}
    setmetatable(obj, self)
    self.__index = self

    return obj
end

-- HouseStructure

function HouseStructure:new()
    local obj = {}
    setmetatable(obj, self)
    self.__index = self

    return obj
end

function HouseStructure:init(x, y, w, h, t)
    t = t or 0
    self.x = x
    self.y = y
    self.width = w
    self.height = h
    self.trim = t
end

function HouseStructure:draw()
    local relX, relY = Window:toRelativePosition(self.x, self.y)
    local relWidth = self.width * Window.scale
    local relHeight = self.height * Window.scale
    g.setColor(cWhiteFade)
    g.rectangle('fill', relX, relY, relWidth, relHeight, self.trim)
    g.setColor(cWhite)
    g.rectangle('line', relX, relY, relWidth, relHeight, self.trim)
end

-- TentStructure

function TentStructure:new()
    local obj = {}
    setmetatable(obj, self)
    self.__index = self

    return obj
end

function TentStructure:init(x, y, r)
    self.x = x
    self.y = y
    self.rad = r
end

function TentStructure:draw()
    local relX, relY = Window:toRelativePosition(self.x, self.y)
    local relRad = self.rad * Window.scale
    g.setColor(cWhiteFade)
    g.circle('fill', relX, relY, relRad)
    g.setColor(cWhite)
    g.circle('line', relX, relY, relRad)
end
