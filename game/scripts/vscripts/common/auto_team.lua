AutoTeam = class({})

function AutoTeam:IsPatreon(pID)
	return AutoTeam:GetPatreonLevel(pID) >= 1;
end

function AutoTeam:GetPatreonLevel(pID)
	return Patreons:GetPlayerSettings(pID).level
end

function AutoTeam:GetAllPlayers()
	local data  = {}
	for i=0,DOTA_MAX_PLAYERS do
		if PlayerResource:IsValidPlayer(i) then 
			table.insert(data,i)
		end
	end
	return data
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

function AutoTeam:Index()
	local playersNoPatreons = AutoTeam:GetNotPatreonPlayers(AutoTeam:GetPatreonPlayers())
	local validTeams = AutoTeam:GetValidTeam()
	local highPatreons = AutoTeam:GetHighPatreon() -- patreons level 2
	local lowPatreons = AutoTeam:GetLowPatreon() -- patreons level 1
	local sumHighPatreons = #highPatreons * 2 -- count * level patreon
	local sumLowPatreons = #lowPatreons -- count * level patreon
	local teams = {}
	for __,v in ipairs(validTeams) do teams[v] = {} end
	for __,pID in pairs(AutoTeam:GetAllPlayers()) do
		print(PlayerResource:GetPlayer(pID):GetTeam()..' Team number')
	end
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
		local team = getMinLevelAllTeam() 
		table.insert(teams[team],pID)
	end

	for __,pID in pairs(lowPatreons) do
		local team = getMinLevelAllTeam()
		table.insert(teams[team],pID)
	end

	for __,pID in ipairs(playersNoPatreons) do
		local team = AutoTeam:PickRandomShuffle( validTeams )
		local maxPlayers = GameRules:GetCustomGameTeamMaxPlayers(team)
		while (#teams[team] >= maxPlayers) do
			team = AutoTeam:PickRandomShuffle( validTeams )
		end
		table.insert(teams[team],pID)
	end
	for teamID,players in pairs(teams) do
		for __,pID in pairs(players) do
			local player = PlayerResource:GetPlayer(pID)
			if player then 
				player:SetTeam(teamID)
				PlayerResource:SetCustomTeamAssignment(pID,teamID)
			end
		end
	end
end