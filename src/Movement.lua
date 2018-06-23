-- Movement.lua

MOVEMENT = "movement"

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
        moveSpeed = 3
    end
end

