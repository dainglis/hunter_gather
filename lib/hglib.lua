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


-- tokenizeString
-- input: string (str)
-- output: table (tokens)
--   all tokens of string delimited by the space character, %s
function tokenizeString(str)
    local tokens = {} 
    if (str) then
        for word in string.gmatch(str, "([^%s]+)") do
            table.insert(tokens, word)
        end
    end
    return tokens
end


-- tableContains
-- input: table<string> (tb), string (word)
-- output: boolean
--   iterates through the given table "tb" of strings, returning true if 
--     "word" is an indexed element of the table (ie could be accessed 
--     with tb[i], where i is an integer), and false otherwise
function tableContains(tb, word)
    for i = 1, table.getn(tb) do
        if tb[i] == word then
            return true
        end
    end
    return false
end

