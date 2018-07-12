-- Position.lua
-- Contains functions for converting absolute coordinates to relative coordinates for display
--[[
function convertPositionMouse()
    local relX = (mouseX - originX)/scale - offsetX
    local relY = (mouseY - originY)/scale - offsetY
    return relX, relY
end

function convertPositionRectangle(absX, absY)
    local relX = originX - (absX/2 - offsetX) * scale
    local relY = originY - (absY/2 - offsetY) * scale
    return relX, relY
end

function convertPosition(absX, absY)
    local relX = originX + (absX + offsetX) * scale
    local relY = originY + (absY + offsetY) * scale
    return relX, relY
end
]]--
-- dist 
-- input: point (pos1 = {x, y}), point (pos2 = {x, y})
-- output: number
--   given two 2D points, returns the distance between these two points 
function dist(a, b)
    local distance = math.sqrt((a[1] - b[1]) ^ 2 + (a[2] - b[2]) ^ 2)
    return distance
end
    
