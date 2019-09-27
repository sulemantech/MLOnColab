function OnIntervalThink( event )
	local caster = event.caster
    local target = event.target
    
    target:ForceKill(false)
    -- Kill this unit immediately.
end