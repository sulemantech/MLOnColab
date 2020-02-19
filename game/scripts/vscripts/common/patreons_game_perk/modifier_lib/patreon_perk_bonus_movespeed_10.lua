patreon_perk_bonus_movespeed_10 = class({})
--------------------------------------------------------------------------------

function patreon_perk_bonus_movespeed_10:IsHidden()
	return true
end

--------------------------------------------------------------------------------

function patreon_perk_bonus_movespeed_10:IsPurgable()
	return false
end
--------------------------------------------------------------------------------
function patreon_perk_bonus_movespeed_10:RemoveOnDeath()
	return false
end
--------------------------------------------------------------------------------

function patreon_perk_bonus_movespeed_10:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
	}
	return funcs
end
--------------------------------------------------------------------------------

function patreon_perk_bonus_movespeed_10:GetModifierMoveSpeedBonus_Constant(params)
    return 10
end

--------------------------------------------------------------------------------