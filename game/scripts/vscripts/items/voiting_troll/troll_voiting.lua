troll_voiting = class({})
--------------------------------------------------------------------------------
function troll_voiting:IsHidden()
    return false --TODO set to true after testing
end
--------------------------------------------------------------------------------
function troll_voiting:IsPurgable()
    return false
end

--------------------------------------------------------------------------------
function troll_voiting:GetTexture()
    return "shadow_shaman_voodoo"
end

--------------------------------------------------------------------------------
function troll_voiting:RemoveOnDeath()
    return false
end

--------------------------------------------------------------------------------
function troll_voiting:IsDebuff()
    return true
end

--------------------------------------------------------------------------------