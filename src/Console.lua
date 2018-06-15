-- Console.lua
-- Contains definition and methods for the Console object and ConsoleWindow object



Console = {}
ConsoleWindow = {x, y, width, height, OFFSET_x = 10, OFFSET_y = 25}

function ConsoleWindow:new(x, y, width, height)
    local obj = {x=x, y=y, width=width, height=height}
    setmetatable(obj, self)
    self.__index = self
    return obj
end

function ConsoleWindow:test()
    return self.height
end
