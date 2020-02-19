patreon_perk_bonus_int_10 = class({})
--------------------------------------------------------------------------------

function patreon_perk_bonus_int_10:IsHidden()
	return true
end

--------------------------------------------------------------------------------

function patreon_perk_bonus_int_10:IsPurgable()
	return false
end
--------------------------------------------------------------------------------

function patreon_perk_bonus_int_10:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
	}
	return funcs
end
--------------------------------------------------------------------------------

function patreon_perk_bonus_int_10:GetModifierBonusStats_Intellect(params)
    return 10
end

--------------------------------------------------------------------------------