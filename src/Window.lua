-- Window.lua

SCALE_MIN = 0.7
SCALE_MAX = 2.0

MOVEMENT = "movement"

Window = {offset = {x = 0, y = 0},
        origin = {x = 0, y = 0},
        width = 1366,
        height = 768,

        scale = 1,
        scaleMod = 0.05,

        move = 0,
        moveBase = 3,
        moveMod = 3}

-- Window:init
-- input: nil
-- output: nil
--   initializes the origin (center point) of the window based on the dimensions
function Window:init()
    self.offset = {x = 0, y = 0}
    self.origin = {x = self.width/2, y = self.height/2}
    print(self.origin.x .. "   " .. self.origin.y)
end

function Window:modifyScaleIn()
    if self.scale <= SCALE_MAX then
        self.scale = self.scale + self.scaleMod
    end
end

function Window:modifyScaleOut()
    if self.scale >= SCALE_MIN then
        self.scale = self.scale - self.scaleMod
    end
end
 
-- Window:movementSpeedMod
-- input: bool (state)
-- output: nil
--   if the boolean "state" is true, then the window movement speed is increased by the modifier.
--     if false, movement speed is set back to the base speed.
function Window:movementSpeedMod(state)
    if state then
        self.move = self.moveBase + self.moveMod
    else
        self.move = self.moveBase
    end
end

function Window:moveLeft()
    self.offset.x = self.offset.x + self.move
end

function Window:moveRight()
    self.offset.x = self.offset.x - self.move
end

function Window:moveUp()
    self.offset.y = self.offset.y + self.move
end

function Window:moveDown()
    self.offset.y = self.offset.y - self.move
end

-- Window:toRelativePosition
-- input: number (absX), number (absY)
-- output: number, number
--   used when converting the absolute position of an object to the relative position (to the origin) 
--     for display in the window
function Window:toRelativePosition(absX, absY)
    local relX = self.origin.x + (absX + self.offset.x) * self.scale
    local relY = self.origin.y + (absY + self.offset.y) * self.scale
    return relX, relY
end

-- Window:toAbsolutePosition
-- input: number (relX), number (relY)
-- output: number, number
--   used when converting the relative position of an object in the window back to absolute position, OR
--     for projecting the mouse cursor's position on the screen into the window
function Window:toAbsolutePosition(relX, relY)
    -- TODO: adjust use of the mouseX, mouseY variables
    local absX = math.floor((mouseX - self.origin.x) / self.scale - self.offset.x)
    local absY = math.floor((mouseY - self.origin.y) / self.scale - self.offset.y)
    return absX, absY
end
