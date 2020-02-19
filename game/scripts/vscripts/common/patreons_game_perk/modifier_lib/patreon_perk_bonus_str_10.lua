patreon_perk_bonus_str_10 = class({})
--------------------------------------------------------------------------------

function patreon_perk_bonus_str_10:IsHidden()
	return true
end

--------------------------------------------------------------------------------

function patreon_perk_bonus_str_10:IsPurgable()
	return false
end
--------------------------------------------------------------------------------
function patreon_perk_bonus_str_10:RemoveOnDeath()
	return false
end
--------------------------------------------------------------------------------

function patreon_perk_bonus_str_10:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
	}
	return funcs
end
--------------------------------------------------------------------------------

function patreon_perk_bonus_str_10:GetModifierBonusStats_Strength(params)
    return 10
end

--------------------------------------------------------------------------------