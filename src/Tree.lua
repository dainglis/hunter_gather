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

-- Tree:draw
-- input: boolean (marked)
-- output: nil
--   this method outlines the drawing of a tree object on the plane. must be 
--     executed within the scope of love.draw
function Tree:draw(marked)
    local relX, relY = Window:toRelativePosition(self.x, self.y)
    local relRad = 1
    local treeColor = cTree
    local treeColorFade = cTreeFade

    if self.cut then
       relRad = math.floor(self.size/3) * Window.scale
       treeColor = cTreeTrunk
       treeColor = cTreeTrunkFade
   else
       relRad = self.size * Window.scale
   end
   
   if marked then
       treeColor = cTreeSelected
   end

   g.setColor(treeColorFade)
   g.circle('fill', relX, relY, relRad)
   g.setColor(treeColor)
   g.circle('line', relX, relY, relRad)
end

