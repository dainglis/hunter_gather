-- HUNTER/GATHER 
-- Created by David Inglis
-- 2018

g = love.graphics
k = love.keyboard
m = love.mouse
w = love.window

DEBUG = true

WINDOW_WIDTH= 1366
WINDOW_HEIGHT= 768

SCALE_MIN = 0.7
SCALE_MAX = 5

originX = WINDOW_WIDTH/2
originY = WINDOW_HEIGHT/2
scale = 1
scaleModifier = 0.05

trees = {}

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

function modifyScaleIn()
    if scale < SCALE_MAX then
        scale = scale + scaleModifier
    end
end

function modifyScaleOut()
    if scale >= SCALE_MIN then
        scale = scale - scaleModifier
    end
end

function love.wheelmoved(x, y)
    if y > 0 then   
        modifyScaleIn()
    elseif y < 0 then
        modifyScaleOut()
    end
end

-- Randomly generates and draws a forest southwest of the origin
function generateForest()
    g.print("generating forest", 10, 200)
    treeOffX = -300
    treeOffY = -330

    forestSize = math.random(5, 9)
    for i=0,forestSize do
        plusX = math.random(-20, 20)
        plusY = math.random(-20, 20)
        rad = math.random(8, 22)
        newTree = {treeOffX + plusX, treeOffY + plusY, rad}
        table.insert(trees, newTree)
    end
    g.print("trees made: " .. table.getn(trees), 10, 80)
    g.print(trees[2][1], 10, 99)
end

function drawForest()
    for i=0,table.getn(trees) do
        --g.circle('line', trees[i][0], trees[i][1], trees[i][2])
    end
end

function love.load()
    w.setMode(WINDOW_WIDTH, WINDOW_HEIGHT)
    m.setVisible(false)
    generateForest()
    init()
end

function love.draw()
    -- mouse cursor square
    mouseX, mouseY = m.getPosition()
    relativeX = math.floor((mouseX - originX - offsetX * scale) / scale)
    relativeY = math.floor((mouseY - originY - offsetY * scale) / scale)
    g.rectangle('line', mouseX, mouseY, 2, 2, 0)

    -- coordinates of relative center
    centerX = convert_position(originX, 0, offsetX)
    centerY = convert_position(originY, 0, offsetY)


    if DEBUG == true then
        g.print("fps: " .. love.timer.getFPS( ), 10, 10)
        g.print("xmouse: (" .. mouseX - originX .. ", " .. mouseY - originY .. ")", 10, 25) 
        g.print("rmouse: (" .. relativeX .. ", " .. relativeY .. ")", 10, 40)
        g.print("scale: " .. scale, 10, 55)

        --center dot
        g.rectangle('line', centerX, centerY, 2, 2)
    end



    baseX = convert_position(originX, baseWidth, offsetX)
    baseY = convert_position(originY, baseHeight, offsetY) 

    baseModWidth = baseWidth * scale
    baseModHeight = baseHeight * scale
    
    tentModX = originX + (tentX + offsetX) * scale
    tentModY = originY + (tentY + offsetY) * scale
    tentModRadius = tentRadius * scale

    fireModX = originX + (fireX + offsetX) * scale
    fireModY = originY + (fireY + offsetY) * scale
    fireModRadius = fireRadius * scale

    -- longhouse
    g.rectangle('line', baseX, baseY, baseModWidth, baseModHeight, baseTrim)
    -- tent
    g.circle('line', tentModX, tentModY, tentModRadius)

    g.setColor(1, 0.4, 0.4)
    g.circle('line', fireModX, fireModY, fireModRadius)
    g.setColor(1, 1, 1)

    -- Randomly generates and draws forest
    drawForest()

    if love.keyboard.isDown('z') then
        modifyScaleIn()
    elseif love.keyboard.isDown('x') then
        modifyScaleOut()
    end

    if love.keyboard.isDown("left") then
        offsetX = offsetX + moveSpeed
    elseif love.keyboard.isDown("right") then
        offsetX = offsetX - moveSpeed
    end

    if love.keyboard.isDown("up") then
        offsetY = offsetY + moveSpeed
    elseif love.keyboard.isDown("down") then
        offsetY = offsetY - moveSpeed
    end

    if k.isDown("backspace") then
        scale = 1
        offsetX = 0
        offsetY = 0
    end

end
