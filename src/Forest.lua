-- Forest.lua
-- Contains Forest object definition and related methods
Forest = {trees = {}, marker = 0}

-- Forest:new
--   Forest constructor
-- input: nil
-- output: Forest
--   creates a new Forest object
function Forest:new()
    local obj = {trees = {}, marker = 0}
    setmetatable(obj, self)
    self.__index = self
    
    return obj
end

-- Forest:addTree
-- input: Tree (t)
-- output: nil
--   adds a new Tree object to the referenced Forest's 'trees' table
function Forest:addTree(t)
    table.insert(self.trees, t)
end

-- Forest:size
-- input: nil
-- output: number
--   returns the number of Tree elements in the Forest objects 'trees' table
function Forest:size()
    return table.getn(self.trees)
end

-- Forest:cutRandomTree
-- input: nil
-- output: nil
--   debugging function for 'cutting' a random tree
function Forest:cutRandomTree()
--    print("Cutting random tree...")
    if self:size() > 0 then
        local toCut = math.random(1, self:size())
        self.trees[toCut].cut = true
    end
end

-- Forest:deleteRandomTree
-- input: nil
-- output: nil
--   a random tree from the forest is removed completely
function Forest:deleteRandomTree()
    if self:size() > 0 then
        local toDelete = math.random(1, self:size())
        table.remove(self.trees, toDelete)
    end
end

-- Forest:checkClosestTree
-- input: number (x), number (y)
-- output: nil
--   looks for the closest tree to the given position (x, y)
function Forest:checkClosestTree(x, y)
    self.marker = 0
    local distance = -1

    for i = 1, self:size() do
        local curTree = self.trees[i]
        local curDist = dist({curTree.x, curTree.y}, {x, y})
    --    local curDist = math.sqrt((curTree.x - x) ^ 2 + (curTree.y - y) ^ 2)

        if ((curDist < distance) or (distance == -1) and curDist <= curTree.size) then
            self.marker = i
        end
    end
end

-- generateForest()
-- input: nil
-- output: Forest
--   randomly generates and draws a forest northwest of the origin
function generateForest()
    local f = Forest:new()
    forestGenerated = true
    print("Generating forest...")
    math.randomseed(os.time())

    -- generate thick patch in y = a/(x-p) + q pattern
    local manyTrees = math.random(155, 189)
    for t = 1, manyTrees do
        local r = math.random(5, 18)
        local x = math.random(-500, 670)
        local y = math.floor(29000/(x + 505) - 350)
        local modX = math.random(-190, 100)
        local modY = math.random(-100, 200)

        if (math.random() > 0.71) then
            modY = modY + math.random(10,155)
        end

        f:addTree(Tree:new(x + modX, y + modY, r, false))
    end

    -- generate sporadic trees in a linear (square) pattern
    local manyMoreTrees = math.random(65, 90)
    for t = 1, manyMoreTrees do
        local r = math.random(5, 18)
        local x = math.random(-1700, 1500)
        local y = math.random(-1300, 740)

        f:addTree(Tree:new(x, y, r, false))
    end

    print("Generated a forest with " .. f:size() .. " trees")
    return f
end
