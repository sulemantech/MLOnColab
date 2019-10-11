function OnSpellStart( event )
    local caster = event.caster
    local abilityname = event.Ability
    --local psets = Patreons:GetPlayerSettings(caster:GetPlayerID())
    --if psets.level > 0 then
        local pa1 = caster:AddAbility(abilityname)
        pa1:SetLevel(1)
        pa1:CastAbility()
        Timers:CreateTimer(1, function()
            caster:RemoveAbility(abilityname)
        end)
    --else
    --    CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(caster:GetPlayerID()), "display_custom_error", { message = "#nopatreonerror" })
    --end
end

function OnSpellStartBundle( event )
    local caster = event.caster
    local ability = event.ability
    local item1 = event.Item1
    local item2 = event.Item2
    local item3 = event.Item3
    local item4 = event.Item4
    if caster:IsRealHero() then
        local psets = Patreons:GetPlayerSettings(caster:GetPlayerID())
        if psets.level > 0 then
            ability:RemoveSelf()
            caster:AddItemByName(item1)
            caster:AddItemByName(item2)
            caster:AddItemByName(item3)
            caster:AddItemByName(item4)
        else
            CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(caster:GetPlayerID()), "display_custom_error", { message = "#nopatreonerror" })
        end
    end
end

function OnSpellStartBanHammer( event )
    local target = event.target
    local caster = event.caster
    local ability = event.ability
    if caster:IsRealHero() then
        local psets = Patreons:GetPlayerSettings(caster:GetPlayerID())
        if psets.level > 1 then
            if target:IsRealHero() then
                local ptsets = Patreons:GetPlayerSettings(target:GetPlayerID())
                if ptsets.level == 0 then
                    if ability:GetCurrentCharges() > 1 then
                        ability:SetCurrentCharges(ability:GetCurrentCharges()-1)
                    else
                        ability:RemoveSelf()
                    end
                    _G.kicks[target:GetPlayerID()+1] = true
                    CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(target:GetPlayerID()), "setkicks", {kicks = _G.kicks})
                end
            end
        else
            CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(caster:GetPlayerID()), "display_custom_error", { message = "#nopatreonerror2" })
        end
    end
end

function OnSpellStartSummonCourier( event )
    local hero = event.caster

    if not hero:IsRealHero() then return end

    local player = event.caster
    local pID = player:GetPlayerID()
    local psets = Patreons:GetPlayerSettings(pID)
    if psets.level > 1 then
        if _G.personalCouriers[pID] == nil then
            local cr = CreateUnitByName("npc_dota_courier", hero:GetAbsOrigin() + RandomVector(RandomFloat(100, 100)), true, nil, nil, 2)

            Timers:CreateTimer(.1, function()
                cr:SetControllableByPlayer(hero:GetPlayerID(), true)
                _G.personalCouriers[pID] = cr;
            end)
            UTIL_Remove(event.ability);
        else
            CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(pID), "display_custom_error", { message = "#privatecourieralready" })
            return
        end
    else
        CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(pID), "display_custom_error", { message = "#nopatreonerror2" })
        return
    end
end
