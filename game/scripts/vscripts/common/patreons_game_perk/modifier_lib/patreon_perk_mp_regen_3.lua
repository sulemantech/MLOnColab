patreon_perk_mp_regen_3 = class({})
--------------------------------------------------------------------------------

function patreon_perk_mp_regen_3:IsHidden()
	return true
end

--------------------------------------------------------------------------------

function patreon_perk_mp_regen_3:IsPurgable()
	return false
end
--------------------------------------------------------------------------------

function patreon_perk_mp_regen_3:DeclareFunctions()
	local funcs = {
        MODIFIER_PROPERTY_MANA_REGEN_CONSTANT,
	}
	return funcs
end
--------------------------------------------------------------------------------

function patreon_perk_mp_regen_3:GetModifierConstantManaRegen(params)
    return 3
end

--------------------------------------------------------------------------------