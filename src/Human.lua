-- Human.lua
-- Contains Human object definition and related methods
Human = {id, name, size, curX, curY, newX, newY, changeX, changeY, dist, movement, speed}

function Human:new(id, curX, curY, name)
    --obj = obj or Human 
    local obj = {id=id, size = 4, curX=curX, curY=curY, name=name, 
            newX=0, newY=0, changeX=0, changeY=0, dist=0, movement=false, speed=3}
    setmetatable(obj, self)
    self.__index = self

    return obj
end

-- getPosition
-- input: nil (self)
-- output: number, number
--   x, y coordinates of the specified human
function Human:getPosition()
    return self.curX, self.curY
end

function Human:getName()
    if self.name ~= nil then
        return name
    else
        return "Nobody"
    end
end

function Human:setID(newid)
    self.id = newid
end

function Human:getID()
    return self.id
end

-- startMovement
-- input: number (x)
--        number (y)
-- output: nil
--   records the new position for the specified human to move to, calculates movement speeds in x and
--     y directions and allows the updateMovement method to be run from love.update
function Human:startMovement(x, y)
    self.movement = true
    self.newX = x
    self.newY = y

    self.dist = math.sqrt((self.newX - self.curX)^2 + (self.newY - self.curY)^2)
    self.changeX = self.speed * (self.newX - self.curX) / self.dist
    self.changeY = self.speed * (self.newY - self.curY) / self.dist
end

-- updateMovement
-- input: nil
-- output: nil
--   runs on each frame of love.update, changing the specified human's position by the respective move
--     distances. When the human comes within a small distance of the end position (specified by that 
--     human's speed), movement is complete and the method does not run until a new position is provided
function Human:updateMovement()
    if (self.movement == false) or (self.curX == self.newX and self.curY == self.newY) then
        --floor coordinates for safer calculations

        --self.curX = math.floor(self.curX)
        --self.curY = math.floor(self.curY)

        self.movement = false
        return nil
    else
        -- uses largeForest, not abstract Forest obj
        local i = largeForest.marker
        if i ~= 0 then
            if dist({self.curX, self.curY}, {largeForest.trees[i].x, largeForest.trees[i].y}) 
                    <= largeForest.trees[i].size + 5 then
                print("inside tree")
                self.newX = self.curX
                self.newY = self.curY
            end
        end
        self.curX = self.curX + self.changeX
        self.curY = self.curY + self.changeY
        if (math.abs(self.curX - self.newX) < self.speed) then
            self.newX = self.curX
        end
        if (math.abs(self.curY - self.newY) < self.speed) then
            self.newY = self.curY
        end
    end
end

function Human:draw()
    local relX, relY = Window:toRelativePosition(self:getPosition())
    local relRad = self.size * Window.scale

    g.setColor(cHumanFade)
    g.circle('fill', relX, relY, relRad)
    g.setColor(cHuman)
    g.circle('line', relX, relY, relRad)
end

