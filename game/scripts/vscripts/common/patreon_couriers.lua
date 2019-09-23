PatreonCouriers = PatreonCouriers or {}

function PatreonCouriers.ExecuteOrderFilter(filterTable)
	local orderType = filterTable.order_type
	local playerId = filterTable.issuer_player_id_const
	local target = filterTable.entindex_target ~= 0 and EntIndexToHScript(filterTable.entindex_target) or nil
	local ability = filterTable.entindex_ability ~= 0 and EntIndexToHScript(filterTable.entindex_ability) or nil
	local abilityName = ability and ability:GetAbilityName() or nil
	local unit
	if filterTable.units and filterTable.units["0"] then
		unit = EntIndexToHScript(filterTable.units["0"])
	end

	local courier = PATREONCOURIERS[playerId]
	if not courier then 
		return true, filterTable 
	end

	if ability and (ability:GetAbilityName() == "courier_take_stash_and_transfer_items" or ability:GetAbilityName() == "courier_take_stash_items") then
		local ents = Entities:FindAllByClassname("ent_dota_fountain")
		
		local fountain
		for _,ent in pairs(ents) do
			if ent:GetTeamNumber() == courier:GetTeamNumber() then
				fountain = ent
			end
		end
		if fountain:GetRangeToUnit(courier) > 1000 then
			return false
		end
	end

	if unit:GetUnitName() == "npc_dota_courier" then
		-- Move all items to fake courier
		local ab = courier:FindAbilityByName(ability:GetAbilityName())
		courier:CastAbilityNoTarget(ab,playerId)
		return false
	end

	return true,filterTable
end

modifier_patreon_courier = {
	IsHidden = function() return not IsInToolsMode() end,
	IsPurgable = function() return false end,
	RemoveOnDeath = function() return false end,

	DeclareFunctions = function()
		return {
			MODIFIER_PROPERTY_MODEL_CHANGE ,

		}
	end,
}

function modifier_patreon_courier:OnCreated() 
	if IsServer() then
		self:StartIntervalThink(FrameTime())
		self.teamCourier = self:GetTeamCourier()
		
	end
end

function modifier_patreon_courier:OnIntervalThink() 
	if not self.teamCourier then
		self.teamCourier = self:GetTeamCourier()
	end

	local courier = self:GetParent()
	local playerId = self:GetCaster():GetPlayerOwnerID()

	if self.teamCourier then
		local hero = self:GetCaster()
		local hasItemInStash = false
		local dist = self.teamCourier:GetRangeToUnit(courier)
		-- Move items from team courier to own courier and in case of accidents the other way around
		for i =0 ,DOTA_STASH_SLOT_6  do
			local item = self.teamCourier:GetItemInSlot(i)
			if item then
				if item:GetAbilityName() == "item_stash_dummy" then
					item:Destroy()
				elseif item:GetPurchaser() == self:GetCaster() then
					item = self.teamCourier:TakeItem(item)
					courier:AddItem(item)
				end
			end

			item = courier:GetItemInSlot(i)
			if item then
				if item:GetAbilityName() == "item_stash_dummy" then
					item:Destroy()
				elseif item:GetPurchaser() ~= self:GetCaster() then
					item = courier:TakeItem(item)
					self.teamCourier:AddItem(item)
				end
			end

			if i >= DOTA_STASH_SLOT_1 then
				item = hero:GetItemInSlot(i)
				if item then
					hasItemInStash = true
				end
			else
				item = hero:GetItemInSlot(i)
				if item and item:GetAbilityName() == "item_stash_dummy" then
					item:Destroy()
				end
			end
		end

		if not hasItemInStash then
			local item = hero:AddItemByName("item_stash_dummy")
			item:SetSellable(false)
			item:SetDroppable(false)
			for i =0 ,DOTA_STASH_SLOT_5 do
				local it = hero:GetItemInSlot(i)
				if it and it:GetAbilityName() == "item_stash_dummy" then
					hero:SwapItems(i,DOTA_STASH_SLOT_6)
					break
				end
			end
		end


		
		--Fix selection issues
		for i =0,23 do
			local hasPatreonCourier =  false
			if PATREONCOURIERS[playerId] then
				--courier = PATREONCOURIERS[playerId]
				hasPatreonCourier = true
			end
			if hasPatreonCourier and PlayerResource:IsUnitSelected(i,self.teamCourier) then
				PlayerResource:NewSelection(playerId, courier)
			end

			if not hasPatreonCourier and PlayerResource:IsUnitSelected(i,courier) then
				PlayerResource:NewSelection(playerId, self.teamCourier)
			end
		end
	end

end

function modifier_patreon_courier:GetTeamCourier()
	local ents = Entities:FindAllByName("npc_dota_courier")
	for _,ent in pairs(ents) do
		if ent:GetUnitName() == "npc_dota_courier" and ent:GetTeamNumber() == self:GetParent():GetTeamNumber() then
			return ent
		end
	end
end

function modifier_patreon_courier:GetModifierModelChange()
	return "models/courier/baby_rosh/babyroshan.vmdl"
end


