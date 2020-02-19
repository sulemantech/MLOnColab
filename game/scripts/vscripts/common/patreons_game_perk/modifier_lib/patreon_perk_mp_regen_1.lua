patreon_perk_mp_regen_1 = class({})
--------------------------------------------------------------------------------

function patreon_perk_mp_regen_1:IsHidden()
	return true
end

--------------------------------------------------------------------------------

function patreon_perk_mp_regen_1:IsPurgable()
	return false
end
--------------------------------------------------------------------------------
function patreon_perk_mp_regen_1:RemoveOnDeath()
	return false
end
--------------------------------------------------------------------------------

function patreon_perk_mp_regen_1:DeclareFunctions()
	local funcs = {
        MODIFIER_PROPERTY_MANA_REGEN_CONSTANT,
	}
	return funcs
end
--------------------------------------------------------------------------------

function patreon_perk_mp_regen_1:GetModifierConstantManaRegen(params)
    return 1
end

--------------------------------------------------------------------------------