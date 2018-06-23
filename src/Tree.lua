Tree = {x = 0, y = 0, size = 1, cut = false}

-- Tree:new
--   Tree constructor
-- input: number (x), number (y), number (r), boolean (c)
-- output: Tree
--   creates a new Tree object with position (x, y), size r
function Tree:new(x, y, r, c)
    local obj = {x = x, y = y, size = r, cut = c}
    setmetatable(obj, self)
    self.__index = self
    return obj
end

function Tree:setPosition(x, y)
    self.x = x
    self.y = y
end

function Tree:setSize(r)
    self.size = r
end

function Tree:chop()
    self.cut = true
end


