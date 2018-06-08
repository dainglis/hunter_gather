-- HUNTER/GATHER 
-- Created by David Inglis
-- 2018

require"Forest"
require"Tree"
require"Table"

g = love.graphics
k = love.keyboard
m = love.mouse
w = love.window

DEBUG = true
TREEBUG = true

WINDOW_WIDTH= 1366
WINDOW_HEIGHT= 768

SCALE_MIN = 0.7
SCALE_MAX = 4.5 

originX = WINDOW_WIDTH/2
originY = WINDOW_HEIGHT/2
scale = 1
scaleModifier = 0.05

nightActive = false
nightDarkness = 0

prompt = "$ "
CONSOLE = "console"
MOVEMENT = "movement"
keymode = CONSOLE

close = {"close", "quit", "exit"}
reset = {"reset", "clear"}
cut = {"cut"}

textstring = ""

function init()
    baseWidth = 55
    baseHeight = 25
    baseTrim = 2

    tentX = 77
    tentY = 110
    tentRadius = 12

    fireX = 0
    fireY = 44
    fireRadius = 5

    scale = 1
    offsetX = 0
    offsetY = 0
    moveSpeed =2 

end

function convert_position(origin, value, offset)
    return origin - (value/2 - offset) * scale
end

function convertPositionMouse()
    relX = math.floor((mouseX - originX)/scale - offsetX)
    relY = math.floor((mouseY - originY)/scale - offsetY)
    return relX, relY
end

function convertPositionRectangle(absX, absY)
    relX = originX - (absX/2 - offsetX) * scale
    relY = originY - (absY/2 - offsetY) * scale
    return relX, relY
end

function convertPositionPoint(absX, absY)
    relX = originX - (absX - offsetX) * scale
    relY = originY - (absY - offsetY) * scale
    return relX, relY
end

function convertPosition(absX, absY)
    relX = originX + (absX + offsetX) * scale
    relY = originY + (absY + offsetY) * scale
    return relX, relY
end

function modifyScaleIn()
    if scale <= SCALE_MAX then
        scale = scale + scaleModifier
    end
    checkSpeed()
end

function modifyScaleOut()
    if scale >= SCALE_MIN then
        scale = scale - scaleModifier
    end
    checkSpeed()
end

function checkSpeed()
    if tostring(scale) == tostring(SCALE_MIN) then
        moveSpeed = 6
    else
        moveSpeed = 2
    end
end

-- Randomly generates and draws a forest southwest of the origin
function generateForest()
    largeForest = Forest
    forestgen = true

    print("Generating forest...")

    math.randomseed(os.time())

    -- generate thick patch in y = a/(x-p) + q pattern
    manyTrees = math.random(155, 189)
    for t = 1, manyTrees do
        treeOffsetX = math.random(-190, 100)
        treeOffsetY = math.random(-100, 200)

        if (math.random() > 0.71) then
            treeOffsetY = treeOffsetY + math.random(10,155)
        end

        treeRadius = math.random(5, 18)

        treeX = math.random(-500, 670)
        treeY = math.floor(29000/(treeX + 505) - 350)
        largeForest:newTree(treeX + treeOffsetX, treeY + treeOffsetY, treeRadius)

        if DEBUG then
           -- print("new tree: (" .. treeX + treeOffsetX .. " " .. treeY + treeOffsetY .. " " .. treeRadius .. ")")
        end
    end

    -- generate sporadic trees in a linear (square) pattern
    manyMoreTrees = math.random(65, 90)
    for t = 1, manyMoreTrees do
        treeX = math.random(-1700, 1500)
        treeY = math.random(-1300, 740)
        treeRadius = math.random(5, 18)

        largeForest:newTree(treeX, treeY, treeRadius)
        if DEBUG then
            --print("new tree: (" .. treeX .. " " .. treeY .. " " .. treeRadius .. ")")
        end
    end
end

function cutRandomTree()
    print("cutting random tree...")
    toCut = math.random(1, largeForest:size())
    largeForest.trees[toCut].cut = true
end

function checkClosestTree(x, y)
    marker = 0
    dist = 50 -- MAGIC

    for i = 1, largeForest:size() do
        curTree = largeForest.trees[i]
        curDist = math.floor(math.sqrt((curTree.x - x) ^ 2 + (curTree.y - y) ^ 2))

        if curDist < dist and curDist <= curTree.r then
            marker = i
        end
    end
end

function clearText()
    textstring = ""
end

function promptCommand(cmd)
    if tableContains(reset, cmd) then
        init()
    elseif tableContains(close, cmd) then
        w.close()
    end
end

function love.mousereleased(x, y, button, istouch)
    modX, modY = convertPositionMouse(x, y)
    checkClosestTree(modX, modY)
end

function love.textinput(text)
    if keymode == CONSOLE then  
        textstring = textstring .. text

        --DEBUG
        print(textstring)
    end
end

function love.keypressed(key, scancode, isrepeat)
    if keymode == CONSOLE then
        if key == "escape" then
            keymode = MOVEMENT
            clearText()
        elseif key == "return" then
            promptCommand(textstring)
            clearText()
        elseif key == "backspace" then
            textstring = string.sub(textstring, 1, -2)
        end
    elseif keymode == MOVEMENT then
        if key == "escape" then
            keymode = CONSOLE
        elseif key == "backspace" then
            init()
        end
        if key == "c" then
            cutRandomTree()
        end
    end
end

function love.wheelmoved(x, y)
    if y > 0 then   
        modifyScaleIn()
    elseif y < 0 then
        modifyScaleOut()
    end
end

function love.load()
    w.setMode(WINDOW_WIDTH, WINDOW_HEIGHT)
    m.setVisible(false)
    k.setKeyRepeat(true)

    print("\nWelcome to Hunter/Gather")

    init()
    generateForest()
end

function love.draw()
    -- mouse cursor square
    mouseX, mouseY = m.getPosition()
    relativeX, relativeY = convertPositionMouse()

    g.rectangle('line', mouseX, mouseY, 2, 2, 0)

    -- coordinates of relative center
    centerX, centerY = convertPosition(0, 0)

    if DEBUG == true then
        debugTable = table

        debugTable:insert("fps: " .. love.timer.getFPS())
        debugTable:insert("xmouse: (" .. mouseX - originX .. ", " .. mouseY - originY .. ")")
        debugTable:insert("rmouse: (" .. relativeX .. ", " .. relativeY .. ")")
        debugTable:insert("scale: " .. scale)

        if forestgen == true then
            debugTable:insert("forest size: " .. largeForest:size())
        end

        debugTable:insert("movespeed: " .. moveSpeed)
        debugTable:insert("keymode: " .. keymode)

        for i = 1, debugTable:getn() do
            g.print(debugTable[1], 10, -5 + 15*i)
            debugTable:remove(1)
        end

        --center dot
        g.rectangle('line', centerX, centerY, 2, 2)
    end

    -- longhouse
    baseX, baseY = convertPositionRectangle(baseWidth, baseHeight)
    baseModWidth = baseWidth * scale
    baseModHeight = baseHeight * scale
    g.rectangle('line', baseX, baseY, baseModWidth, baseModHeight, baseTrim)
    
    -- tent
    tentModX, tentModY = convertPosition(tentX, tentY)
    tentModRadius = tentRadius * scale
    g.circle('line', tentModX, tentModY, tentModRadius)

    -- firepit
    fireModX, fireModY = convertPosition(fireX, fireY)
    fireModRadius = fireRadius * scale
    g.setColor(1, 0.4, 0.4)
    g.circle('line', fireModX, fireModY, fireModRadius)

    -- draws forest
    for f = 1, largeForest:size() do
        g.setColor(0, 0.9, 0)
        curTree = largeForest.trees[f]

        treeX, treeY = convertPosition(curTree.x, curTree.y)

        if curTree.cut == false then
            treeR = curTree.r * scale
        else 
            g.setColor(0.45, 0.2, .05)
            treeR = math.floor(curTree.r/3) * scale
        end

        if f == marker then
            g.setColor(0,0,1)
        end

        g.circle('line', treeX, treeY, treeR)

    end

    g.setColor(1, 1, 1)

    if TREEBUG == true then
        for i = -2000, 2000, 6 do
            x, y = convertPosition(i, (math.floor(27000/(i + 505)) - 350))
            g.points(x, y)
        end
    end

    if keymode == CONSOLE then
        --key input display
        g.print(prompt .. textstring, 10, WINDOW_HEIGHT - 25) 
    elseif keymode == MOVEMENT then
        -- MOVEMENT KEYS
        if k.isDown('c') then
            cutRandomTree()
        end

        if k.isDown('z') then
            modifyScaleIn()
        elseif k.isDown('x') then
            modifyScaleOut()
        end

        if k.isDown("left") then
            offsetX = offsetX + moveSpeed
        elseif k.isDown("right") then
            offsetX = offsetX - moveSpeed
        end

        if k.isDown("up") then
            offsetY = offsetY + moveSpeed
        elseif k.isDown("down") then
            offsetY = offsetY - moveSpeed
        end
    end
end
