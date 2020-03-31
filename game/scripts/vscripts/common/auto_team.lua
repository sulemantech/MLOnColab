if not _G.AutoTeam then 
	_G.AutoTeam = class({})
	_G.AutoTeam.cache = {}
	_G.AutoTeam.testing = false
end

function AutoTeam:IsPatreon(pID)
	return AutoTeam:GetPatreonLevel(pID) >= 1;
end

function AutoTeam:GetPatreonLevel(pID)
	return Patreons:GetPlayerSettings(pID).level
end

function AutoTeam:GetAllPlayers()
	if _G.AutoTeam.cache.allPlayers then 
		return _G.AutoTeam.cache.allPlayers
	end
	local data  = {}
	for i=0,DOTA_MAX_PLAYERS do
		if PlayerResource:IsValidPlayer(i) then 
			table.insert(data,i)
		end
	end
	_G.AutoTeam.cache.allPlayers = data
	return _G.AutoTeam.cache.allPlayers
end

function AutoTeam:filter(callback,iterateTable)
	local iterateTable = iterateTable or AutoTeam:GetAllPlayers()
	local data = {}
	for __,value in pairs(iterateTable) do

		if callback and callback(value) then 
			table.insert(data,value)
		end
	end
	return data
end

function AutoTeam:GetHighPatreon()
	return AutoTeam:filter(function(pID)  return AutoTeam:GetPatreonLevel(pID) == 2 end)
end

function AutoTeam:GetLowPatreon()
	return AutoTeam:filter(function(pID)  return AutoTeam:GetPatreonLevel(pID) == 1 end)
end

function AutoTeam:GetPatreonPlayers()
	return AutoTeam:filter(function(pID) return AutoTeam:IsPatreon(pID) end)
end

function AutoTeam:GetNotPatreonPlayers(patreonPlayers)
	return AutoTeam:filter(function(pID)  return not table.find(patreonPlayers, pID) end)
end

function AutoTeam:GetValidTeam()
	local allTeams = {}
	for i=DOTA_TEAM_FIRST,DOTA_TEAM_CUSTOM_MAX do
		table.insert(allTeams,i)
	end
	return AutoTeam:filter(function(teamID) return GameRules:GetCustomGameTeamMaxPlayers(teamID) > 0 end,allTeams)
end

function AutoTeam:PickRandomShuffle( reference_list )
    if ( #reference_list == 0 ) then
        return nil
    end
    return reference_list[ RandomInt( 1, #reference_list ) ]
end

function AutoTeam:getTeamMinPlayers(teams)
	local _teamID = -1
	local min = 150
	for teamID,players in pairs(teams) do
		if min > #players then 
			min = #players
			_teamID = teamID
		end
	end
	return _teamID
end

function AutoTeam:Index()
	local allPlayers = AutoTeam:GetAllPlayers()
	local playersNoPatreons = AutoTeam:GetNotPatreonPlayers(AutoTeam:GetPatreonPlayers())
	local validTeams = AutoTeam:GetValidTeam()
	local highPatreons = AutoTeam:GetHighPatreon() -- patreons level 2
	local lowPatreons = AutoTeam:GetLowPatreon() -- patreons level 1
	local sumHighPatreons = #highPatreons * 2 -- count * level patreon
	local sumLowPatreons = #lowPatreons -- count * level patreon
	local partyPlayers = {}
	for _,pID in pairs(allPlayers) do
		local partyID = tostring(PlayerResource:GetPartyID(pID))
		partyPlayers[partyID] = partyPlayers[partyID] or {}
		table.insert(partyPlayers[partyID],pID)
	end
	local teams = {}
	local playersIsParty = {}
	for __,v in ipairs(validTeams) do teams[v] = {} end

	for partyID,players in pairs(partyPlayers) do
		if #players > 1 then 
			local team = AutoTeam:getTeamMinPlayers(teams)
			local maxPlayers = GameRules:GetCustomGameTeamMaxPlayers(team)
			for _,pID in pairs(players) do
				if #teams[team] >= maxPlayers then break end -- max count player in team
				table.insert(teams[team],pID)
				playersIsParty[pID] = true
			end
		end
	end
	local playersIsParty_length = table.length(playersIsParty)
	local getLevelByTeam = function(teamID)
		local amount = 0;
		for __,pID in pairs(teams[teamID]) do
			amount = amount + AutoTeam:GetPatreonLevel(pID)
		end
		return amount
	end

	local getMinLevelAllTeam = function()
		local min = (sumHighPatreons + sumLowPatreons)
		local _teamID = -1
		for teamID,__ in pairs(teams) do
			local lvl = getLevelByTeam(teamID)
			if lvl < min then 
				min = lvl
				_teamID = teamID
			end
		end
		return _teamID
	end

	for __,pID in pairs(highPatreons) do
		if not playersIsParty[pID] then 
			local team = getMinLevelAllTeam() 
			table.insert(teams[team],pID)
		end
	end

	for __,pID in pairs(lowPatreons) do
		if not playersIsParty[pID] then
			local team = getMinLevelAllTeam()
			table.insert(teams[team],pID)
		end
	end

	for __,pID in ipairs(playersNoPatreons) do
		if not playersIsParty[pID] then
			if playersIsParty_length > 3 then 
				local team = AutoTeam:getTeamMinPlayers(teams)
				table.insert(teams[team],pID)
			else
				local team = AutoTeam:PickRandomShuffle( validTeams )
				local maxPlayers = GameRules:GetCustomGameTeamMaxPlayers(team)
				while (#teams[team] >= maxPlayers) do
					team = AutoTeam:PickRandomShuffle( validTeams )
					maxPlayers = GameRules:GetCustomGameTeamMaxPlayers(team)
				end
				table.insert(teams[team],pID)
			end
		end
	end

	if _G.AutoTeam.testing then 
		print('TEAMS')
		DeepPrintTable(teams)
		print('Party Teams')
		DeepPrintTable(partyPlayers)
	end

	for teamID,players in pairs(teams) do
		for __,pID in pairs(players) do
			local player = PlayerResource:GetPlayer(pID)
			GameRules:SetCustomGameTeamMaxPlayers(teamID, GameRules:GetCustomGameTeamMaxPlayers(teamID) + 1)
			if player then 
				player:SetTeam(teamID)
			end
			PlayerResource:SetCustomTeamAssignment(pID,teamID)
			GameRules:SetCustomGameTeamMaxPlayers(teamID, GameRules:GetCustomGameTeamMaxPlayers(teamID) - 1)
		end
	end
end