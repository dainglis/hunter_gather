-- Position.lua
-- Contains functions for converting absolute coordinates to relative coordinates for display

function convertPositionMouse()
    local relX = math.floor((mouseX - originX)/scale - offsetX)
    local relY = math.floor((mouseY - originY)/scale - offsetY)
    return relX, relY
end

function convertPositionRectangle(absX, absY)
    local relX = originX - (absX/2 - offsetX) * scale
    local relY = originY - (absY/2 - offsetY) * scale
    return relX, relY
end

--DEPRECATED, not currently used
function convertPositionPoint(absX, absY)
    local relX = originX - (absX - offsetX) * scale
    local relY = originY - (absY - offsetY) * scale
    return relX, relY
end

function convertPosition(absX, absY)
    local relX = originX + (absX + offsetX) * scale
    local relY = originY + (absY + offsetY) * scale
    return relX, relY
end
