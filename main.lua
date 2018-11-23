-- HUNTER/GATHER 
-- Created by David Inglis
-- 2018

require"lib.hglib"
require"lib.hgconst"

require"src.Window"
require"src.Command"
require"src.Catalog"
require"src.Console"

require"src.Structure"
require"src.Human"
require"src.Forest"
require"src.Tree"
require"src.Rock"

debugTable = {}
debugFlagState = {}

nightFlag = false

lifeMatrix = {
    {spec="grass", pop=5000, new=150, growth=0.7},
    {spec="rabbit", pop=600, new=10, growth=0.6},
    {spec="wolf", pop=40, new=3, growth=0.15}
}

mouseX = 0; mouseY = 0; relativeX = 0; relativeY = 0

function init()
	--
	-- 	initialization convention
	-- 	static class 
	--		:init()
	--	
	--  object instance
	--  	object = Class:new()
	--		object:init()
	-- OR
	--		object = Class:generate() 
	--
    Window:init()
    Console:init()

    keymode = MOVEMENT

    longhouse = HouseStructure:new()
    longhouse:init(-26, -11, 52, 22, 2)

    tent = TentStructure:new()
    tent:init(77, 110, 12)

    fireX = 0
    fireY = 44
    fireRadius = 5

    -- TESTING ADDING ROCKS
    quarry = RockFormation:new()
    quarry:generate()

    debugFlagState["debug"] = true

	man = Human:generate()
    largeForest = Forest:new()
	largeForest:clear()
	largeForest:generate()

    local welcome = "welcome to hunter/gather"
    Console:push(welcome)
    print(welcome)
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
            if Console:length() == 0 then
                -- close console if enter key is hit and string is empty
                keymode = MOVEMENT
            else
                -- send input as command
                promptCommand(Console.text)
            end
            Console:clearText()
        elseif key == "backspace" then
            Console:backspace()
        end

    elseif keymode == MOVEMENT then
        if key == "escape" or key == "return" then
            keymode = CONSOLE
        elseif key == "backspace" then
            --init()
        end
        if key == "c" then
            --largeForest:cutRandomTree()
            largeForest:deleteRandomTree()
        end
    end
end

-- love.wheelmoved
-- input: number (x), number (y)
--  built-in love function, executed when mouse wheel is moved
function love.wheelmoved(x, y)
    if y > 0 then   
        Window:modifyScaleIn()
    elseif y < 0 then
        Window:modifyScaleOut()
    end
end

-- love.load
--  built-in love function, executes on program startup
function love.load()
    initDebugState()
    w.setMode(Window.width, Window.height)
    m.setVisible(false)
    k.setKeyRepeat(true)

    generateCatalog()

    init()
end

-- love.quit
--  built-in love function, executes when an attempt 
--		to close the love process is called. 
--  	return false will close the current process, 
--		returning true will continue running the process
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
    g.setFont(fontConsolas)
    -- mouse cursor square
    mouseX, mouseY = m.getPosition()
    relativeX, relativeY = Window:toAbsolutePosition(mouseX, mouseY)

    -- coordinates of relative center
    centerX, centerY = Window:toRelativePosition(0, 0)

    --sets building colours
    g.setColor(cWhite)

    -- draw Structures
    longhouse:draw()
    tent:draw()

    -- firepit
    fireModX, fireModY = Window:toRelativePosition(fireX, fireY)
    fireModRadius = fireRadius * Window.scale
    g.setColor(cFireRed)
    g.circle('line', fireModX, fireModY, fireModRadius)

    -- draws forest
    largeForest:draw()

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

    -- Draw all humans
    man:draw()

    --SCREEN OVERLAYS
    --draws nighttime overlay 
    --must be displayed as first overlay since it is diagetic
    if nightFlag then
        g.setColor(cNightOverlay)
        g.rectangle('fill', 0, 0, Window.width, Window.height)
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
        ConsoleWindow:draw()
    end
    --displays cursor
    g.rectangle('line', mouseX, mouseY, 2, 2, 0)
end
