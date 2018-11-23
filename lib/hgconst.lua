-- hgconst.lua
-- contains constants used in hunter_gather application

-- love library shorthands
g = love.graphics
k = love.keyboard
m = love.mouse
w = love.window

-- fonts
fontConsolas = g.newFont("/res/font/consolas-reg.ttf", 12)
--fontMono = g.newFont("/res/font/source-code-pro.regular.ttf")
--fontCourier = g.newFont("res/font/courier-prime-code.regular.ttf", 12)
--fontCourierItalics = g.newFont("res/font/courier-prime-code.italic.ttf", 14)

--Colours for drawing
cWhite = {1, 1, 1}
cWhiteFade = {1, 1, 1, 0.18}
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
cRockFadeALT = {0.4, 0.4, 0.43, 0.3}

print("DEBUG: HGconst successfully loaded.")
