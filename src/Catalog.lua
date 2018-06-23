-- Catalog.lua

Catalog = {}

function Catalog:new()
    local obj = {}
    setmetatable(obj, self)
    self.__index = self

    return obj
end

function Catalog:add(key, val1, val2)
    self[key] = {title=val1, desc=val2}
    print("Catalog entry: " .. self[key].title .. " - " .. self[key].desc)
end
