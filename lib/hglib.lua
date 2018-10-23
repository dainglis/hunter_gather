-- hglib.lua
-- A library of functions used in the hunter_gather application

-- dist 
-- input: point (pos1 = {x, y}), point (pos2 = {x, y})
-- output: number
--   given two 2D points, returns the distance between these two points 
function dist(a, b)
    local distance = math.sqrt((a[1] - b[1]) ^ 2 + (a[2] - b[2]) ^ 2)
    return distance
end
