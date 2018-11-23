-- Forest.lua
-- Contains Forest object definition and related methods
Forest = {trees = {}, marker = 0}

DEBUG_HEADER = "DEBUG (Forest): "

-- Forest:new
--   Forest constructor
-- input: nil
-- output: Forest
--   creates a new Forest object
function Forest:new()
    local obj = {}
    setmetatable(obj, self)
    self.__index = self
    
    return obj
end

-- Forest:generate()
-- input: nil
-- output: Forest
--   randomly generates and draws a forest northwest of the origin
-- TODO: Currently this method only generates a small forest near the origin. 
--   The plan is to generate forests in chunks across a large map. This method
--   will need to either become the Forest object constructor, or a Forest method 
--   which does not create a new Forest instance. 
function Forest:generate()
    --local f = Forest:new()
    print(DEBUG_HEADER .. "Clearing forest...")
	self:clear()
    forestGenerated = true
    print(DEBUG_HEADER .. "Generating forest...")
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

       	self:addTree(Tree:new(x + modX, y + modY, r, false))
    end

    -- generate sporadic trees in a linear (square) pattern
    local manyMoreTrees = math.random(65, 90)
    for t = 1, manyMoreTrees do
        local r = math.random(5, 18)
        local x = math.random(-1700, 1500)
        local y = math.random(-1300, 740)

        self:addTree(Tree:new(x, y, r, false))
    end

    print(DEBUG_HEADER .. "Generated a forest with " .. self:size() .. " trees")
    --return f
end
function Forest:clear()
	for i = 1, self:size() do
		table.remove(self.trees)
	end
end

-- Forest:addTree
-- input: Tree (t)
-- output: nil
--  adds a new Tree object to the referenced Forest's 'trees' table
function Forest:addTree(t)
    table.insert(self.trees, t)
end

-- Forest:size
-- input: nil
-- output: number
--  returns the number of Tree elements in the Forest objects 'trees' table
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

        if ((curDist < distance) or (distance == -1) and curDist <= curTree.size) then
            self.marker = i
        end
    end
end

-- Forest:draw
-- input: nil
-- output: nil
--   this method outlines the drawing of an entire forest object in the plane. the draw method 
--     each tree is called. must be executed within the scope of love.draw
function Forest:draw()
    for f = 1, self:size() do
        local curTree = self.trees[f]
        if f == self.marker then
            curTree:draw(true)
        else
            curTree:draw(false)
        end
    end
end
    

