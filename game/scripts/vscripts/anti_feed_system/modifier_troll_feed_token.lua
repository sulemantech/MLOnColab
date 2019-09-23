modifier_troll_feed_token = class({})

--------------------------------------------------------------------------------
function modifier_troll_feed_token:IsHidden()
    return false
end

--------------------------------------------------------------------------------
function modifier_troll_feed_token:IsPurgable()
    return false
end

--------------------------------------------------------------------------------
function modifier_troll_feed_token:GetTexture()
    return "shadow_shaman_voodoo"
end

--------------------------------------------------------------------------------
function modifier_troll_feed_token:IsDebuff()
    return true
end

--------------------------------------------------------------------------------
function modifier_troll_feed_token:RemoveOnDeath()
    return false
end

--------------------------------------------------------------------------------
function modifier_troll_feed_token:OnCreated(kv)
    print("TOKEN CREATE")
end
--------------------------------------------------------------------------------