local VOTES_NON_SUP = 6
local VOTES_SUP_LV_1 = 3
local VOTES_SUP_LV_2 = 6
local POSSIBLE_VOITES_PER_GAME = 1
local VOICES_FOR_PUNISHMENT = 6

LinkLuaModifier("troll_vote_debuff", 'items/voiting_troll/troll_vote_debuff', LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("troll_voiting", 'items/voiting_troll/troll_voiting', LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_troll_debuff_stop_feed", 'anti_feed_system/modifier_troll_debuff_stop_feed', LUA_MODIFIER_MOTION_NONE)


function OnSpellStartVoite(event)
	local target = event.target
	local caster = event.caster
	local playerID = caster:GetPlayerID()

	if _G.playersVoices[playerID] and _G.playersVoices[playerID] >= POSSIBLE_VOITES_PER_GAME then
		CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(playerID), "display_custom_error", { message = "#already_voiting_against_troll" })
		return
	end

	if target:HasModifier("troll_vote_debuff") then
		CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(playerID), "display_custom_error", { message = "#target_has_troll_debuff_with_voiting" })
		return
	end

	_G.playersVoices[playerID] = (_G.playersVoices[playerID] or 0) + 1

	local voiteBuffName = "troll_voiting"
	local votesAgainstPlayer = 0

	if target:HasModifier(voiteBuffName) then
		votesAgainstPlayer = target:GetModifierStackCount(voiteBuffName, caster)
	end

	local psets = Patreons:GetPlayerSettings(playerID)
	local currentPlayersVoice = VOTES_NON_SUP

	if psets.level == 1 then
		currentPlayersVoice = VOTES_SUP_LV_1
	elseif psets.level == 2 then
		currentPlayersVoice = VOTES_SUP_LV_2
	end

	local ability = event.ability

	if (votesAgainstPlayer + currentPlayersVoice) >= VOICES_FOR_PUNISHMENT then
		if votesAgainstPlayer > 0 then
			target:RemoveModifierByName(voiteBuffName)
		end
		target:AddNewModifier(caster, ability, "troll_vote_debuff", { duration = -1 })
	elseif votesAgainstPlayer > 0 then
		target:SetModifierStackCount(voiteBuffName, caster, votesAgainstPlayer + currentPlayersVoice)
	else
		target:AddNewModifier(caster, ability, voiteBuffName, { duration = -1 })
		target:SetModifierStackCount(voiteBuffName, caster, currentPlayersVoice)
	end

	ability:RemoveSelf()
end