-- HUNTER/GATHER 
-- Created by David Inglis
-- 2018

require"src.Command"
require"src.Catalog"
require"src.Console"
require"src.Movement"
require"src.Forest"
require"src.Human"
require"src.Tree"
require"src.Table"
require"src.Position"

g = love.graphics
k = love.keyboard
m = love.mouse
w = love.window

print(love.filesystem.getIdentity())
print(love.filesystem.getSaveDirectory())
fontVeraSans = g.newFont(22)
fontMono = g.newFont("/res/font/source-code-pro.regular.ttf")
fontCourier = g.newFont("res/font/courier-prime-code.regular.ttf", 12)
fontCourierItalics = g.newFont("res/font/courier-prime-code.italic.ttf", 14)

--Colours for drawing
cWhite = {1, 1, 1}
cHumanYellow = {244/255, 214/255, 66/255}
cTreeGreen = {0, 0.9, 0}
cTreeTrunk = {0.45, 0.2, 0.05}
cTreeSelected = {0.8, 0.8, 0.8}
cFireRed = {1, 0.4, 0.4}

cNightOverlay = {0, 0, 0, 0.7}

--DEBUG = true
--TREEBUG = false
--WATERBUG = false

WINDOW_WIDTH= 1366
WINDOW_HEIGHT= 768

SCALE_MIN = 0.7
SCALE_MAX = 2.0 

originX = WINDOW_WIDTH/2
originY = WINDOW_HEIGHT/2
scale = 1
scaleModifier = 0.05
mouseX = 0; mouseY = 0; relativeX = 0; relativeY = 0

debugTable = {}
debugFlagState = {}

nightFlag = false

function init()
    keymode = MOVEMENT

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
    moveSpeed = 3

    debugFlagState["debug"] = true

    generateHuman()
    largeForest = generateForest()
end

function resizeConsole() 
    ConsoleWindow:setPosition(20, 708) -- x, y
    ConsoleWindow:setSize(620, ConsoleWindow.OFFSET.Y + ConsoleWindow.OFFSET.X) -- width, height
    for i=1, table.getn(Console.memory) do
        ConsoleWindow:setPosition(ConsoleWindow.x, ConsoleWindow.y - 15)
        ConsoleWindow:setSize(ConsoleWindow.width, ConsoleWindow.height + 15)
    end
end

function initConsole()
    Console.text = ""
    if Console.memory == nil then
        Console.memory = {}
    end

    for i=1, table.getn(Console.memory) do
        print(table.getn(Console.memory))
    end
    resizeConsole()
end

function generateHuman()
    local manStartX = 15
    local manStartY = 22

    man = Human:new(5, manStartX, manStartY, "Tim")
    local x, y = man:getPosition()
    print("man generated, " .. man.name .. " (" .. x .. ", " .. y .. ")")
end


function generateCatalog()
    cat = Catalog:new()
    cat:add("human", "Homo sapiens", "Human")
end

function love.mousereleased(x, y, button, istouch)
    man:startMovement(relativeX, relativeY)

    local modX, modY = convertPositionMouse(x, y)
    largeForest:checkClosestTree(modX, modY)
end

function love.textinput(text)
    if keymode == CONSOLE then  
        Console:append(text)
    end
end

function love.keypressed(key, scancode, isrepeat)
    if keymode == CONSOLE then
        if key == "escape" then
            keymode = MOVEMENT
            Console:clearText()
        elseif key == "return" then
            promptCommand(Console.text)
            Console:clearText()
        elseif key == "backspace" then
            Console:backspace()
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
    initConsole()
    initDebugState()
    w.setMode(WINDOW_WIDTH, WINDOW_HEIGHT)
    m.setVisible(false)
    k.setKeyRepeat(true)

    local welcome = "welcome to hunter/gather"
    Console:push(welcome)
    print(welcome)

    generateCatalog()

    init()
end

function love.quit()
    return false
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
   -- g.setFont(fontMono)

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
            treeR = curTree.size * scale
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
    --must be displayed as first overlay since it is diagetic
    if nightFlag then
        g.setColor(cNightOverlay)
        g.rectangle('fill', 0, 0, WINDOW_WIDTH, WINDOW_HEIGHT)
    end

    --sets text color
    g.setColor(cWhite)

    if debugFlagState["treebug"] then
        for i = -2000, 2000, 6 do
            x, y = convertPosition(i, (math.floor(27000/(i + 505)) - 350))
            g.points(x, y)
        end
    end

    if debugFlagState["waterbug"] then
        for i = -1000, 1000, 6 do
            x, y = convertPosition(i, 30 * math.sin(0.0272 * i) * math.cos(0.01 * i + math.random(0,1)) + (0.18 * i))
            g.points(x, y)
        end
    end

    --draws topleft debug menu
    if debugFlagState["debug"] then
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

        resizeConsole()

        g.setColor(cNightOverlay)
        g.rectangle('fill', ConsoleWindow.x, ConsoleWindow.y, ConsoleWindow.width, ConsoleWindow.height)
        g.setColor(cWhite)
        g.rectangle('line', ConsoleWindow.x, ConsoleWindow.y, ConsoleWindow.width, ConsoleWindow.height)

        g.print(Console.PROMPT .. Console.text,
                ConsoleWindow.x + ConsoleWindow.OFFSET.X, 
                ConsoleWindow.y + ConsoleWindow.height - ConsoleWindow.OFFSET.Y)
        for i = 1, Console:memSize() do
            g.print(Console.memory[i], 
                    ConsoleWindow.x + ConsoleWindow.OFFSET.X,
                    ConsoleWindow.y + ConsoleWindow.height - ConsoleWindow.OFFSET.Y - (15 * i))
        end


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
