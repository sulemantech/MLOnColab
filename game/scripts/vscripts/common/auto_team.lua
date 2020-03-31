AutoTeam = class({})

function AutoTeam:IsPatreon(pID)
	return Patreons:GetPlayerSettings(pID).level >= 1;
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
	local iterateTable = iterateTable or  AutoTeam:GetAllPlayers()
	local data = {}
	for __,value in pairs(iterateTable) do

		if callback and callback(value) then 
			table.insert(data,value)
		end
	end
	return data
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
	local patreonPlayers = AutoTeam:GetPatreonPlayers()
	local playersNoPatreons = AutoTeam:GetNotPatreonPlayers(patreonPlayers)
	local amountPatreons = #patreonPlayers
	local validTeams = AutoTeam:GetValidTeam()
	local PatreonPerTeam = amountPatreons > 0 and amountPatreons/#validTeams or 0
	local playersPerTeam = (amountPatreons + #playersNoPatreons)/#validTeams
	local teams = {}
	for __,v in ipairs(validTeams) do teams[v] = {} end
	for __,pID in ipairs(patreonPlayers) do
		local team = AutoTeam:PickRandomShuffle( validTeams)
		while (#teams[team] > PatreonPerTeam) do
			team = AutoTeam:PickRandomShuffle( validTeams)
		end
		table.insert(teams[team],pID)
	end
	for __,pID in ipairs(playersNoPatreons) do
		local team = AutoTeam:PickRandomShuffle( validTeams )
		local maxPlayers = GameRules:GetCustomGameTeamMaxPlayers(team)
		while (#teams[team] > maxPlayers or playersPerTeam <= #teams[team]) do
			team = AutoTeam:PickRandomShuffle( validTeams )
		end
		table.insert(teams[team],pID)
	end
	for teamID,players in pairs(teams) do
		for __,pID in pairs(players) do
			local player = PlayerResource:GetPlayer(pID)
			if player then 
				player:SetTeam(teamID)
			end
			PlayerResource:SetCustomTeamAssignment(pID,teamID)
		end
	end
end
