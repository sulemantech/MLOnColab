patreon_perk_bonus_all_stats_7 = class({})
--------------------------------------------------------------------------------

function patreon_perk_bonus_all_stats_7:IsHidden()
	return true
end

--------------------------------------------------------------------------------

function patreon_perk_bonus_all_stats_7:IsPurgable()
	return false
end
--------------------------------------------------------------------------------

function patreon_perk_bonus_all_stats_7:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
	}
	return funcs
end
--------------------------------------------------------------------------------

function patreon_perk_bonus_all_stats_7:GetModifierBonusStats_Agility(params)
    return 7
end

--------------------------------------------------------------------------------
function patreon_perk_bonus_all_stats_7:GetModifierBonusStats_Intellect(params)
	return 7
end

--------------------------------------------------------------------------------
function patreon_perk_bonus_all_stats_7:GetModifierBonusStats_Strength(params)
	return 7
end

--------------------------------------------------------------------------------