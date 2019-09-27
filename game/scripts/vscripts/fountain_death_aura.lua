function OnIntervalThink( event )
    local target = event.target
    local pos = target:GetAbsOrigin()
    local sum = pos.x + pos.y

    if sum > 14200 or sum < -14400 then
        target:ForceKill(false)
        -- Kill this unit immediately.
    end
end