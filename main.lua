-- HUNTER/GATHER 
-- Created by David Inglis
-- 2018

require"src.Window"
require"src.Command"
require"src.Catalog"
require"src.Console"
require"src.Forest"
require"src.Human"
require"src.Tree"
require"src.Table"
require"src.Position"
require"src.Rock"

g = love.graphics
k = love.keyboard
m = love.mouse
w = love.window

--fontMono = g.newFont("/res/font/source-code-pro.regular.ttf")
--fontCourier = g.newFont("res/font/courier-prime-code.regular.ttf", 12)
--fontCourierItalics = g.newFont("res/font/courier-prime-code.italic.ttf", 14)

debugTable = {}
debugFlagState = {}

nightFlag = false

lifeMatrix = {
    {spec="grass", pop=5000, new=150, growth=0.7},
    {spec="rabbit", pop=600, new=10, growth=0.6},
    {spec="wolf", pop=40, new=3, growth=0.15}
}

--Colours for drawing
cWhite = {1, 1, 1}
cWhiteFade = {1, 1, 1, 0.12}
cNightOverlay = {0, 0, 0, 0.7}
cConsoleBackground = {0, 0, 0, 0.7}

cHuman = {244/255, 214/255, 66/255}
cHumanFade = {244/255, 214/255, 66/255, 0.5}
cTree = {13/255, 170/255, 42/255}
cTreeFade = {13/255, 170/255, 42/255, 0.12}
cTreeTrunk = {0.45, 0.2, 0.05}
cTreeTrunkFade = {0.45, 0.2, 0.05, 0.6}
cTreeSelected = {0.8, 0.8, 0.8}
cFireRed = {1, 0.4, 0.4}
cRock = {0.57, 0.57, 0.57}
cRockFade = {0.57,0.57,0.57, 0.3}

-- scale = 1
--scaleModifier = 0.05
mouseX = 0; mouseY = 0; relativeX = 0; relativeY = 0
--movement = {speed = 0, speedBase = 3, speedMod = 3}

function init()
    Window:init()
    Console:init()

    keymode = MOVEMENT

    baseX = 0
    baseY = 0
    baseWidth = 55
    baseHeight = 25
    baseTrim = 2

    tentX = 77
    tentY = 110
    tentRadius = 12

    fireX = 0
    fireY = 44
    fireRadius = 5

    -- TESTING ADDING ROCKS
    quarry = RockFormation:new()
    quarry:generate()

    debugFlagState["debug"] = true

    generateHuman()
    largeForest = generateForest()

    local welcome = "welcome to hunter/gather"
    Console:push(welcome)
    print(welcome)
end

function resizeConsole() 
    -- TODO: change to relative positioning, no magic numbers
    -- uses absolute positions, not a good idea for window scaling
    ConsoleWindow:setPosition(20, 716) -- x, y
    ConsoleWindow:setSize(480, ConsoleWindow.OFFSET.Y + ConsoleWindow.OFFSET.X) -- width, height
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
    local modX, modY = Window:toAbsolutePosition(x, y)
    largeForest:checkClosestTree(modX, modY)
    man:startMovement(relativeX, relativeY)

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
            --largeForest:cutRandomTree()
            largeForest:deleteRandomTree()
        end
    end
end

function love.wheelmoved(x, y)
    if y > 0 then   
        Window:modifyScaleIn()
    elseif y < 0 then
        Window:modifyScaleOut()
    end
end

function love.load()
    initDebugState()
    w.setMode(Window.width, Window.height)
    m.setVisible(false)
    k.setKeyRepeat(true)

    generateCatalog()

    init()
end

function love.quit()
    return false
end

-- love.update
-- input: number (dt)
--
--   built-in love function, executes each frame. parameter dt records the time between
--     the current and previous frame. 
function love.update(dt)
    debugTable["fps"] = love.timer.getFPS()
    debugTable["xmouse"] = "(" .. mouseX .. ", " .. mouseY .. ")"
    debugTable["rmouse"] = "(" .. relativeX .. ", " .. relativeY .. ")"
    debugTable["scale"] = Window.scale

    if forestGenerated then
        debugTable["forest"] = largeForest:size()
    end

    debugTable["movespeed"] = Window.move
    debugTable["keymode"] = keymode

    man:updateMovement()

    -- lifeMatrix
    if debugFlagState["life"] then
        Console:clear()
        for p in pairs(lifeMatrix) do
            if math.random() > lifeMatrix[p].growth then
                lifeMatrix[p].pop = lifeMatrix[p].pop + lifeMatrix[p].new
            end
            Console:push(p .. " " .. lifeMatrix[p].pop)
        end
    end

    if keymode == MOVEMENT then
        -- MOVEMENT KEYS
        if k.isDown('z') then
            Window:modifyScaleIn()
        elseif k.isDown('x') then
            Window:modifyScaleOut()
        end

        if k.isDown("lshift") then
            Window:movementSpeedMod(true)
        else
            Window:movementSpeedMod(false)
        end

        if k.isDown("left") then
            Window:moveLeft()
        elseif k.isDown("right") then
            Window:moveRight()
        end

        if k.isDown("up") then
            Window:moveUp()
        elseif k.isDown("down") then
            Window:moveDown()
        end
    end
    
end

-- love.draw
--
--   built-in love function for drawing a frame
function love.draw()
    -- mouse cursor square
    mouseX, mouseY = m.getPosition()
    relativeX, relativeY = Window:toAbsolutePosition(mouseX, mouseY)

    -- coordinates of relative center
    centerX, centerY = Window:toRelativePosition(0, 0)

    --sets building colours
    g.setColor(cWhite)

    -- longhouse
    baseX, baseY = Window:toRelativePosition(-baseWidth/2, -baseHeight/2)
    baseModWidth = baseWidth * Window.scale
    baseModHeight = baseHeight * Window.scale
    g.setColor(cWhiteFade)
    g.rectangle('fill', baseX, baseY, baseModWidth, baseModHeight, baseTrim)
    g.setColor(cWhite)
    g.rectangle('line', baseX, baseY, baseModWidth, baseModHeight, baseTrim)
    
    -- tent
    tentModX, tentModY = Window:toRelativePosition(tentX, tentY)
    tentModRadius = tentRadius * Window.scale
    g.circle('line', tentModX, tentModY, tentModRadius)

    -- firepit
    fireModX, fireModY = Window:toRelativePosition(fireX, fireY)
    fireModRadius = fireRadius * Window.scale
    g.setColor(cFireRed)
    g.circle('line', fireModX, fireModY, fireModRadius)

    -- draws forest
    for f = 1, largeForest:size() do
        local curTree = largeForest.trees[f]
        local treeX, treeY = Window:toRelativePosition(curTree.x, curTree.y)

        local treeColor = cTree
        local treeColorFade = cTreeFade

        if curTree.cut == false then
            treeR = curTree.size * Window.scale
            treeColor = cTree
            treeColorFade = cTreeFade
        else 
            treeR = math.floor(curTree.size/3) * Window.scale
            treeColor = cTreeTrunk
            treeColorFade = cTreeTrunkFade
        end

        if f == largeForest.marker then
            treeColor = cTreeSelected
        end

        g.setColor(treeColorFade)
        g.circle('fill', treeX, treeY, treeR)
        g.setColor(treeColor)
        g.circle('line', treeX, treeY, treeR)
    end

    -- draws rock formations
    for r = 1, table.getn(quarry.rocks) do
        local curRock = quarry.rocks[r]
        local rockX, rockY = Window:toRelativePosition(curRock.x, curRock.y)
        local rockR = curRock.size * Window.scale
        g.setColor(0.4,0.4,0.43, 0.3)
        g.circle('fill', rockX, rockY, rockR)
        g.setColor(cRock)
        g.circle('line', rockX, rockY, rockR)
    end

    cManX, cManY = Window:toRelativePosition(man:getPosition())
    g.setColor(cHumanFade)
    g.circle('fill', cManX, cManY, 4 * Window.scale)
    g.setColor(cHuman)
    g.circle('line', cManX, cManY, 4 * Window.scale)

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
            x, y = Window:toRelativePosition(i, (math.floor(27000/(i + 505)) - 350))
            g.points(x, y)
        end
    end

    if debugFlagState["waterbug"] then
        for i = -1000, 1000, 6 do
            x, y = Window:toRelativePosition(i, 30 * math.sin(0.0272 * i) * math.cos(0.01 * i + math.random(0,1)) + (0.18 * i))
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
        resizeConsole()

        g.setColor(cConsoleBackground)
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
    end
    --displays cursor
    g.rectangle('line', mouseX, mouseY, 2, 2, 0)
end
