-- Forest.lua
-- Contains Forest object definition and related methods
Forest = {trees = {}, marker}

function Forest:new()
    local obj = {trees = {}, marker}
    setmetatable(obj, self)
    self.__index = self
    
    return obj
end

function Forest:addTree(t)
    table.insert(self.trees, t)
end

function Forest:newTree(t_x, t_y, t_r)
    tree = {x = t_x, y = t_y, r = t_r, cut = false}
    table.insert(self.trees, tree)
end

function Forest:size()
    return table.getn(self.trees)
end

function Forest:cutRandomTree()
    print("cutting random tree...")
    toCut = math.random(1, self:size())
    self.trees[toCut].cut = true
end

function Forest:checkClosestTree(x, y)
    self.marker = 0
    dist = 50 -- MAGIC, also very bad practice

    for i = 1, self:size() do
        curTree = self.trees[i]
        curDist = math.floor(math.sqrt((curTree.x - x) ^ 2 + (curTree.y - y) ^ 2))

        if curDist < dist and curDist <= curTree.r then
            self.marker = i
        end
    end
end
