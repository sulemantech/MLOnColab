patreon_perk_bonus_agi_10 = class({})
--------------------------------------------------------------------------------

function patreon_perk_bonus_agi_10:IsHidden()
	return true
end

--------------------------------------------------------------------------------

function patreon_perk_bonus_agi_10:IsPurgable()
	return false
end
--------------------------------------------------------------------------------
---
function patreon_perk_bonus_agi_10:RemoveOnDeath()
	return false
end
--------------------------------------------------------------------------------

function patreon_perk_bonus_agi_10:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
	}
	return funcs
end
--------------------------------------------------------------------------------

function patreon_perk_bonus_agi_10:GetModifierBonusStats_Agility(params)
    return 10
end

--------------------------------------------------------------------------------