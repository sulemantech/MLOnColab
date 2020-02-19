patreon_perk_bonus_movespeed_15 = class({})
--------------------------------------------------------------------------------

function patreon_perk_bonus_movespeed_15:IsHidden()
	return true
end

--------------------------------------------------------------------------------

function patreon_perk_bonus_movespeed_15:IsPurgable()
	return false
end
--------------------------------------------------------------------------------

function patreon_perk_bonus_movespeed_15:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
	}
	return funcs
end
--------------------------------------------------------------------------------

function patreon_perk_bonus_movespeed_15:GetModifierMoveSpeedBonus_Constant(params)
    return 15
end

--------------------------------------------------------------------------------