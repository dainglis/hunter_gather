-- Movement.lua

MOVEMENT = "movement"



function modifyScaleIn()
    if scale <= SCALE_MAX then
        scale = scale + scaleModifier
    end
end

function modifyScaleOut()
    if scale >= SCALE_MIN then
        scale = scale - scaleModifier
    end
end

-- movementSpeedMod
-- input: bool (state)
-- output: nil
--   if the boolean "state" is true, then the window movement speed is increased by the modifier.
--     if false, movement speed is set back to the base speed.
function movementSpeedMod(state)
    if state then
        movement.speed = movement.speedBase + movement.speedMod
    else
        movement.speed = movement.speedBase
    end
end

