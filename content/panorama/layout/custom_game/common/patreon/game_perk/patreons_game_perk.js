var patreons_game_perks = {
"patreon_perk_mp_regen_1": 1,
"patreon_perk_mp_regen_3": 2,
"patreon_perk_hp_regen_1": 1,
"patreon_perk_hp_regen_3": 2,
"patreon_perk_bonus_movespeed_10": 1,
"patreon_perk_bonus_movespeed_15": 2,
"patreon_perk_bonus_agi_10": 1,
"patreon_perk_bonus_str_10": 1,
"patreon_perk_bonus_int_10": 1,
"patreon_perk_bonus_all_stats_7": 2,
};

var patreonLevel = 0;

function print(val){
	$.Msg(val);
}

function SetPlayerPatreonLevel(data){
	patreonLevel = data.patreonLevel;
}

function HidePatreonsGamePerksHint(){
	var settingsButton = $("#SetPatreonGamePerkButton")
	$.DispatchEvent( 'DOTAHideTextTooltip', settingsButton);
	settingsButton.SetImage("file://{resources}/layout/custom_game/common/patreon/game_perk/patreon_button_setting_no_glow.png")
}

function ShowPatreonsGamePerksHint(){
	var settingsButton = $("#SetPatreonGamePerkButton")
	$.DispatchEvent( 'DOTAShowTextTooltip', settingsButton, $.Localize("#patreonperktooltip_hint"));
	settingsButton.SetImage("file://{resources}/layout/custom_game/common/patreon/game_perk/patreon_button_setting_glow.png")
}

function ShowPatreonsGamePerks(){
	var perksPanel = $("#PatreonsGamePerkMenu");
	var perksPanelClose = $("#ClosePatreonsPerks");
	perksPanel.visible = true;
	perksPanelClose.visible = true;
}

function HidePatreonsGamePerks(){
	var perksPanel = $("#PatreonsGamePerkMenu");
	var perksPanelClose = $("#ClosePatreonsPerks");
	perksPanel.visible = false;
	perksPanelClose.visible = false;
}

function SetPatreonsPerkButtonAction(panel, perkName){
	panel.SetPanelEvent( "onactivate", function() {
		var settingPerksButton = $("#SetPatreonGamePerkButton")

		settingPerksButton.SetImage("file://{resources}/layout/custom_game/common/patreon/game_perk/icons/"+perkName+".png")
		GameEvents.SendCustomGameEventToServer( "set_patreon_game_perk", {
			newPerkName: perkName
		} )
		settingPerksButton.SetPanelEvent( "onmouseover", function() {
			$.DispatchEvent( 'DOTAShowTextTooltip', settingPerksButton, $.Localize("#patreonperktooltip_"+perkName));
		} )
		settingPerksButton.SetPanelEvent( "onmouseout", function() {
			$.DispatchEvent( 'DOTAHideTextTooltip', settingPerksButton);
		} )
		settingPerksButton.SetPanelEvent( "onactivate", function() {} )
		HidePatreonsGamePerks()
	} )
}

function UpdateBlockPatreonsPerk(panel){
	panel.SetPanelEvent( "onmouseover", function() {
		$.DispatchEvent( 'DOTAShowTextTooltip', panel, $.Localize("#high_tier_supporter_perk"));
	} )
	panel.SetPanelEvent( "onmouseout", function() {
		$.DispatchEvent( 'DOTAHideTextTooltip', panel);
	} )
}

function CreatePatreonsGamePerks(){
	if (patreonLevel > 0){
		$("#PatreonGamePerkButtonOption").visible = true;
		$("#PatreonGamePerkButtonPanel").visible = true;

		for (var key in patreons_game_perks) {
			var perkPanel = $.CreatePanel("Panel", $("#PatreonsGamePerksList"), "");
			perkPanel.AddClass("GamePerkForPatreon");

			var perkIconImage = $.CreatePanel("Image", perkPanel, "qwe");
			perkIconImage.AddClass("GamePerkImage");
			perkIconImage.SetImage("file://{resources}/layout/custom_game/common/patreon/game_perk/icons/"+key+".png")
			perkIconImage.icon = key

			var perkLabelText = $.CreatePanel("Label", perkPanel, "");
			perkLabelText.AddClass("GamePerkText");
			perkLabelText.text = $.Localize("#patreonperktooltip_"+key);

			if (patreons_game_perks[key] > patreonLevel){
				perkIconImage.AddClass("GamePerkImageNotAvailable");
				perkLabelText.AddClass("GamePerkTextNotAvailable");
				UpdateBlockPatreonsPerk(perkIconImage);
			}else{
				perkIconImage.AddClass("GamePerkImageHover");
				SetPatreonsPerkButtonAction(perkIconImage, key);
			}
		};
	}
}

(function () {
	GameEvents.Subscribe('return_patreon_level', SetPlayerPatreonLevel);
	GameEvents.SendCustomGameEventToServer("check_patreon_level", {});
	$.Schedule(1, function() {
		CreatePatreonsGamePerks();
	});
})();