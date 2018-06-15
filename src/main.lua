-- HUNTER/GATHER 
-- Created by David Inglis
-- 2018

require"Command"
require"Console"
require"Forest"
require"Human"
require"Tree"
require"Table"
require"Position"

g = love.graphics
k = love.keyboard
m = love.mouse
w = love.window

--Colours for drawing
cWhite = {1, 1, 1}
cHumanYellow = {244/255, 214/255, 66/255}
cTreeGreen = {0, 0.9, 0}
cTreeTrunk = {0.45, 0.2, 0.05}
cTreeSelected = {0.8, 0.8, 0.8}
cFireRed = {1, 0.4, 0.4}

cNightOverlay = {0, 0, 0, 0.7}

DEBUG = true
TREEBUG = false

WINDOW_WIDTH= 1366
WINDOW_HEIGHT= 768

SCALE_MIN = 0.7
SCALE_MAX = 4.5 

originX = WINDOW_WIDTH/2
originY = WINDOW_HEIGHT/2
scale = 1
scaleModifier = 0.05
mouseX = 0; mouseY = 0; relativeX = 0; relativeY = 0

nightActive = false
nightDarkness = 0

CONSOLE = "console"
MOVEMENT = "movement"
keymode = MOVEMENT

debugTable = {}
consoleTable = {memory = 5}
prompt = "$ "
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

function toggleNight()
    if nightActive then
        nightActive = false
    else
        nightActive = true
    end
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

function generateConsole()
    -- change magic numbers
    cWindow = ConsoleWindow:new(20, 508, 620, 240)
    print("Console generated, (" .. cWindow.x .. ", " .. cWindow.y .. ")")
end

function generateHuman()
    local manStartX = 15
    local manStartY = 22

    man = Human:new(5, manStartX, manStartY, "Tim")
    local x, y = man:getPosition()
    print("Man generated, " .. man.name .. " (" .. x .. ", " .. y .. ")")
end

-- Randomly generates and draws a forest southwest of the origin
function generateForest()
    largeForest = Forest:new()
    forestGenerated = true

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
     -- print("new tree: (" .. treeX + treeOffsetX .. " " .. treeY + treeOffsetY .. " " .. treeRadius .. ")")
    end

    -- generate sporadic trees in a linear (square) pattern
    manyMoreTrees = math.random(65, 90)
    for t = 1, manyMoreTrees do
        treeX = math.random(-1700, 1500)
        treeY = math.random(-1300, 740)
        treeRadius = math.random(5, 18)

        largeForest:newTree(treeX, treeY, treeRadius)
      --print("new tree: (" .. treeX .. " " .. treeY .. " " .. treeRadius .. ")")
    end
    print("... generated a forest with " .. largeForest:size() .. " trees")
end

function clearText()
    textstring = ""
end

function love.mousereleased(x, y, button, istouch)
    man:startMovement(relativeX, relativeY)
    modX, modY = convertPositionMouse(x, y)
    largeForest:checkClosestTree(modX, modY)
end

function love.textinput(text)
    if keymode == CONSOLE then  
        textstring = textstring .. text
    end
end

function love.keypressed(key, scancode, isrepeat)
    if keymode == CONSOLE then
        if key == "escape" then
            keymode = MOVEMENT
            clearText()
        elseif key == "return" then
            pushConsole(consoleTable, textstring)
            promptCommand(textstring)
            clearText()
        elseif key == "backspace" then
            textstring = string.sub(textstring, 1, -2)
        end
    elseif keymode == MOVEMENT then
        if key == "escape" or key == "return" then
            keymode = CONSOLE
        elseif key == "backspace" then
            init()
        end
        if key == "c" then
            largeForest:cutRandomTree()
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
    generateConsole()
    generateForest()
    generateHuman()
end

function love.update(dt)
    debugTable["fps"] = love.timer.getFPS()
    debugTable["xmouse"] = "(" .. mouseX - originX .. ", " .. mouseY - originY .. ")"
    debugTable["rmouse"] = "(" .. relativeX .. ", " .. relativeY .. ")"
    debugTable["scale"] = scale

    if forestGenerated then
        debugTable["forest"] = largeForest:size()
    end

    debugTable["movespeed"] = moveSpeed
    debugTable["keymode"] = keymode

    man:updateMovement()
end

function love.draw()
    -- mouse cursor square
    mouseX, mouseY = m.getPosition()
    relativeX, relativeY = convertPositionMouse()


    -- coordinates of relative center
    centerX, centerY = convertPosition(0, 0)

    --sets building colours
    g.setColor(cWhite)

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
    g.setColor(cFireRed)
    g.circle('line', fireModX, fireModY, fireModRadius)

    -- draws forest
    for f = 1, largeForest:size() do
        g.setColor(cTreeGreen)
        curTree = largeForest.trees[f]

        treeX, treeY = convertPosition(curTree.x, curTree.y)

        if curTree.cut == false then
            treeR = curTree.r * scale
        else 
            g.setColor(cTreeTrunk)
            treeR = math.floor(curTree.r/3) * scale
        end

        if f == largeForest.marker then
            g.setColor(cTreeSelected)
        end

        g.circle('line', treeX, treeY, treeR)
    end

    g.setColor(cHumanYellow)
    cManX, cManY = convertPosition(man:getPosition())
    g.circle('fill', cManX, cManY, 4 * scale)

    --SCREEN OVERLAYS
    --draws nighttime overlay 
    if nightActive then
        g.setColor(cNightOverlay)
        g.rectangle('fill', 0, 0, WINDOW_WIDTH, WINDOW_HEIGHT)
    end

    --sets text color
    g.setColor(cWhite)
    if TREEBUG then
        for i = -2000, 2000, 6 do
            x, y = convertPosition(i, (math.floor(27000/(i + 505)) - 350))
            g.points(x, y)
        end
    end

    --draws topleft debug menu
    if DEBUG then
        spacing = 1 
        for key, val in pairs(debugTable) do
            if val ~= nil then
                g.print(key .. ": " .. val, 10, 15 * spacing - 5)
                spacing = spacing + 1
            end
        end

        --center dot
        g.rectangle('line', centerX, centerY, 2, 2)
    end

    if keymode == CONSOLE then
        --key input display
        --g.print(prompt .. textstring, 10, WINDOW_HEIGHT - 25) 

        for i=1, table.getn(consoleTable) do
--            g.print("   " .. consoleTable[i], 10, WINDOW_HEIGHT - 25 - 15*i)
        end
        g.setColor(cNightOverlay)
        g.rectangle('fill', cWindow.x, cWindow.y, cWindow.width, cWindow.height)
        g.setColor(cWhite)
        g.rectangle('line', cWindow.x, cWindow.y, cWindow.width, cWindow.height)

        g.print(prompt .. textstring, 
                cWindow.x + ConsoleWindow.OFFSET_x, cWindow.y + cWindow.height - ConsoleWindow.OFFSET_y)

    elseif keymode == MOVEMENT then
        -- MOVEMENT KEYS
        if k.isDown('c') then
            largeForest:cutRandomTree()
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
    
    --displays cursor
    g.rectangle('line', mouseX, mouseY, 2, 2, 0)
end
