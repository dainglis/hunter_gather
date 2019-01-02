-- Catalog.lua
-- Contains definitions and member functions for the Catalog object

-- A Catalog is a formal table that contains the following entries:
--  string (key)
--  table<string> (title, description, value_3, ...)

Catalog = {}
Catalog.__index = Catalog


-- Catalog:new
-- input: nil
-- output: Catalog
--   constructor for the Catalog object
--   returns a new Catalog which inherits all items from the static
--   Catalog object
function Catalog:new()
    local obj = {}
    setmetatable(obj, self)
    return obj
end


-- Catalog:init
-- input: nil
-- output: nil
--   initializes the static Catalog, clearing it if it is non-empty
function Catalog:init()
    -- clear Catalog if non-empty
end


-- Catalog:add
-- input: string (key), table<string> (values)
-- output: nil
function Catalog:add(key, values)
    self[key] = values
end


-- Catalog:print
-- input: nil
-- output: nil
--   pushes each item of the Catalog to the game Console and the system
--   console
function Catalog:print()
    for key in pairs(Catalog) do
        local output = ""
        if (type(Catalog[key]) == "table" and key ~= "__index") then
            output = key .. ": " .. table.concat(self[key], " - ")
            Console:push(output)
            print(output)
        end
    end
end


