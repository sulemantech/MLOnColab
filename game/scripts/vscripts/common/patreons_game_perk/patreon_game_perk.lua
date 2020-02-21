LinkLuaModifier( "patreon_perk_mp_regen_1", "common/patreons_game_perk/modifier_lib/patreon_perk_mp_regen_1" ,LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "patreon_perk_mp_regen_3", "common/patreons_game_perk/modifier_lib/patreon_perk_mp_regen_3" ,LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "patreon_perk_hp_regen_1", "common/patreons_game_perk/modifier_lib/patreon_perk_hp_regen_1" ,LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "patreon_perk_hp_regen_3", "common/patreons_game_perk/modifier_lib/patreon_perk_hp_regen_3" ,LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "patreon_perk_bonus_movespeed_10", "common/patreons_game_perk/modifier_lib/patreon_perk_bonus_movespeed_10" ,LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "patreon_perk_bonus_movespeed_15", "common/patreons_game_perk/modifier_lib/patreon_perk_bonus_movespeed_15" ,LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "patreon_perk_bonus_agi_10", "common/patreons_game_perk/modifier_lib/patreon_perk_bonus_agi_10" ,LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "patreon_perk_bonus_str_10", "common/patreons_game_perk/modifier_lib/patreon_perk_bonus_str_10" ,LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "patreon_perk_bonus_int_10", "common/patreons_game_perk/modifier_lib/patreon_perk_bonus_int_10" ,LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "patreon_perk_bonus_all_stats_7", "common/patreons_game_perk/modifier_lib/patreon_perk_bonus_all_stats_7" ,LUA_MODIFIER_MOTION_NONE )


RegisterCustomEventListener("check_patreon_level", function(data)
	local patreon = Patreons:GetPlayerSettings(data.PlayerID)
	CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(data.PlayerID), "return_patreon_level", { patreonLevel = patreon.level})
end)

--RegisterCustomEventListener("replace_patreon_perk", function(data)
--	local playerID = data.PlayerID
--	if not playerID then return end
--	local player = PlayerResource:GetPlayer(playerID)
--	local newModifierName = data.newPerkName
--	local hero = player:GetAssignedHero()
--	local oldModifierName
--	if type(data.oldPerkName) == "string" then
--		oldModifierName = data.oldPerkName
--		hero:RemoveModifierByName(oldModifierName)
--	end
--
--	if hero then
--		hero:AddNewModifier(hero, nil, newModifierName, {duration = -1})
--	else
--		Timers:CreateTimer(3, function()
--			hero = player:GetAssignedHero()
--			hero:AddNewModifier(hero, nil, newModifierName, {duration = -1})
--		end)
--	end
--end)

RegisterCustomEventListener("set_patreon_game_perk", function(data)
	local playerID = data.PlayerID
	if not playerID then return end
	local player = PlayerResource:GetPlayer(playerID)
	local newModifierName = data.newPerkName
	local hero = player:GetAssignedHero()

	--print("start perk: ",newModifierName)
	if hero then
		--print("hero is been")
		if hero:IsAlive() then
			--print("hero is alive and got mod")
			hero:AddNewModifier(hero, nil, newModifierName, {duration = -1})
		else
			--print("hero is dead, we search him")
			Timers:CreateTimer(0.5, function()
				--print("try....")
				if hero:IsAlive() then
					--print("we search hero, add mod and stop timer")
					hero:AddNewModifier(hero, nil, newModifierName, {duration = -1})
					return nil
				end
				return 0.5
			end)
		end
	else
		--print("hero isn't been, we can wait 3 sec")
		Timers:CreateTimer(3, function()
			--print("we waited 3 sec and give you mod")
			hero = player:GetAssignedHero()
			hero:AddNewModifier(hero, nil, newModifierName, {duration = -1})
		end)
	end
end)