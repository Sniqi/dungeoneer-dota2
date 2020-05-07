"use strict";

var stat = {};
var showcase;

var boss_ability_panels = [];
var boss_item_panels = [];
var boss_challenge_panels = [];

var previous_boss = null;

BossInfoButtonActivate();
ToggleBossInfoVisibility(false)

function AddBossListEntry(data)
{
	var panel = $.CreatePanel('Panel', $('#BossInfoLists'), '');
	panel.BLoadLayoutSnippet("BossInfoList");
	
	var usableWidth = 450 - (data.bosscount*3)
	
		if (showcase != null)
		{
			showcase.DeleteAsync(0);
		}
		if (previous_boss != null)
		{
			for(var i=0; i < boss_ability_panels[previous_boss].length; i++) {
				boss_ability_panels[previous_boss][i].visible = false;
			}

		}

		showcase = $.CreatePanel('Panel', $('#BossInfoFrames'), '');
		showcase.BLoadLayoutSnippet("BossInfoFrame");

		showcase.FindChildTraverse('BossInfoFrameBossName').text = $.Localize("#npc_dota_hero_" + data.boss_unitname);
		
		showcase.BCreateChildren("<DOTAScenePanel id=\"BossInfoFrameBossScene\" map=\"banner_background_" + data.boss_unitname + "\" camera=\"camera1\" renderdeferred=\"false\" particleonly=\"false\" />");

		showcase.FindChildTraverse('BossInfoFrameBossDescription').text = $.Localize("#npc_dota_hero_" + data.boss_unitname + "_Description");

		for(var i=0; i < boss_ability_panels[data.boss_unitname].length; i++) {
			boss_ability_panels[data.boss_unitname][i].visible = true;
		}
		
		previous_boss = data.boss_unitname;

	return panel;
}

(function () {
  GameEvents.Subscribe( "add_boss_list_entry", AddBossListEntry );
})();

function AddBossAbilities(data)
{
		var panel = $.CreatePanel('Panel', $('#BossInfoAbilities'), data.ability_name);
		panel.BLoadLayoutSnippet("BossInfoAbility");
		
		panel.FindChildTraverse('BossInfoAbilityImage').abilityname = data.ability_name;
		panel.FindChildTraverse('BossInfoAbilityImage').style.marginLeft = (data.ability_pos*50) + "px;";
		
		// Tooltip Show
		panel.SetPanelEvent("onmouseover", function(){
			$.DispatchEvent( "DOTAShowAbilityTooltip", panel, data.ability_name );
		})
		
		// Tooltip Hide
		panel.SetPanelEvent("onmouseout", function(){
			$.DispatchEvent( "DOTAHideAbilityTooltip", panel );
		})
		
		panel.visible = false;
		
		if(boss_ability_panels[data.boss_unitname] == null) {
			boss_ability_panels[data.boss_unitname] = [];
		}
		
		boss_ability_panels[data.boss_unitname][boss_ability_panels[data.boss_unitname].length] = panel;
}

(function () {
  GameEvents.Subscribe( "add_boss_abilities", AddBossAbilities );
})();

function AddBossItems(data)
{
		var panel = $.CreatePanel('Panel', $('#BossInfoItemDrops'), data.item_name);
		panel.BLoadLayoutSnippet("BossInfoItemDrop");
		
		panel.FindChildTraverse('BossInfoItemDropImage').itemname = data.item_name;
		panel.FindChildTraverse('BossInfoItemDropTxt').text = data.item_chance + "%";
		
		var item_pos = data.item_pos;
		if(data.item_pos > 5) {
			panel.FindChildTraverse('BossInfoItemDropImage').style.marginTop = "38px;";
			panel.FindChildTraverse('BossInfoItemDropTxt').style.marginTop = "55px;";
			item_pos = data.item_pos-6;
		}
		panel.FindChildTraverse('BossInfoItemDropImage').style.marginLeft = (item_pos*50) + "px;";
		panel.FindChildTraverse('BossInfoItemDropTxt').style.marginLeft = 3 + (item_pos*50) + "px;";
		
		// Tooltip Show
		panel.SetPanelEvent("onmouseover", function(){
			$.DispatchEvent( "DOTAShowAbilityTooltip", panel, data.item_name );
		})
		
		// Tooltip Hide
		panel.SetPanelEvent("onmouseout", function(){
			$.DispatchEvent( "DOTAHideAbilityTooltip", panel );
		})
		
		panel.visible = false;
		
		if(boss_item_panels[data.boss_unitname] == null) {
			boss_item_panels[data.boss_unitname] = [];
		}

		boss_item_panels[data.boss_unitname][boss_item_panels[data.boss_unitname].length] = panel;
}

(function () {
  GameEvents.Subscribe( "add_boss_items", AddBossItems );
})();


function BossInfoButtonActivate(){
	var Panel = [ $("#BossInfoListsWrap"), $("#BossInfoFrames") ];

	if (Panel[0].visible) {
		for(var i=0; i<Panel.length; i++) {
			Panel[i].visible = false;
			//Panel[i].enable = false;
			//Panel[i].hittest = false;
			//Panel[i].hittestchildren = false;
		}
	} else { 
		for(var i=0; i<Panel.length; i++) {
			Panel[i].visible = true;
			//Panel[i].enable = true;
			//Panel[i].hittest = true;
			//Panel[i].hittestchildren = true;
		}
	}
}

function BossInfoRerollButtonActivate(){
	GameEvents.SendCustomGameEventToServer( "boss_info_reroll_boss", { playerID: Players.GetLocalPlayer() } );
}

function BossInfoRerollButtonShow(){
	var Panel = [ $("#BossInfoRerollButton"), $("#BossInfoRerollButtonText") ];

		for(var i=0; i<Panel.length; i++) {
			if(Panel[i] != null) {
				Panel[i].visible = true;
				Panel[i].enable = true;
				Panel[i].hittest = true;
				Panel[i].hittestchildren = true;
			}
		}
}

(function () {
  GameEvents.Subscribe( "boss_info_reroll_boss_show", BossInfoRerollButtonShow );
})();

function BossInfoRerollButtonHide(){
	var Panel = [ $("#BossInfoRerollButton"), $("#BossInfoRerollButtonText") ];

		for(var i=0; i<Panel.length; i++) {
			if(Panel[i] != null) {
				Panel[i].visible = false;
				Panel[i].enable = false;
				Panel[i].hittest = false;
				Panel[i].hittestchildren = false;
			}
		}
}

(function () {
  GameEvents.Subscribe( "boss_info_reroll_boss_hide", BossInfoRerollButtonHide );
})();


function ToggleBossInfoVisibility(data){
	var Panel = [ $("#BossInfoListsWrap"), $("#BossInfoFrames"), $("#BossInfoButton"), $("#BossChallengeButton"), $("#BossInfoChallenges") ];

	if (data.visible) {
		for(var i=0; i<Panel.length; i++) {
			if(Panel[i] != null) {
				Panel[i].visible = true;
				Panel[i].enable = true;
				Panel[i].hittest = true;
				Panel[i].hittestchildren = true;
			}
		}
	} else { 
		for(var i=0; i<Panel.length; i++) {
			if(Panel[i] != null) {
				Panel[i].visible = false;
				Panel[i].enable = false;
				Panel[i].hittest = false;
				Panel[i].hittestchildren = false;
			}
		}
	}
}

(function () {
  GameEvents.Subscribe( "toggle_boss_info_visibility", ToggleBossInfoVisibility );
})();

// Debug

//debug();

function debug()
{
	AddBossListEntry({ boss_unitname: "npc_dota_hero_broodmother", bossname: "A Mighty Boar", boss_descr: "Missing!", pos: 0, bosscount: 7 });
	AddBossAbilities({ bossname: "A Mighty Boar", ability_pos: 0, ability_name: "a_mighty_boar_tremble" });
	AddBossAbilities({ bossname: "A Mighty Boar", ability_pos: 1, ability_name: "a_mighty_boar_charge" });
	AddBossAbilities({ bossname: "A Mighty Boar", ability_pos: 2, ability_name: "a_mighty_boar_trample" });
	//AddBossItems({ bossname: "Earth Brutes", item_pos: 0, item_name: "item_mythical_1", item_chance: "75%" });
	//AddBossItems({ bossname: "Earth Brutes", item_pos: 1, item_name: "item_mythical_3", item_chance: "60%" });
	//AddBossItems({ bossname: "Earth Brutes", item_pos: 2, item_name: "item_mythical_5", item_chance: "60%" });
	//AddBossItems({ bossname: "Earth Brutes", item_pos: 3, item_name: "item_legendary_2", item_chance: "20%" });
	//AddBossItems({ bossname: "Earth Brutes", item_pos: 6, item_name: "item_rare_random", item_chance: "10%" });
	//AddBossItems({ bossname: "Earth Brutes", item_pos: 7, item_name: "item_mythical_random", item_chance: "10%" });
	//AddBossListEntry({ boss_unitname: "npc_dota_hero_tiny", bossname: "Stony", boss_descr: "Stony", pos: 1, bosscount: 7 });
	//AddBossListEntry({ boss_unitname: "npc_dota_hero_treant", bossname: "Graft", boss_descr: "Graft", pos: 2, bosscount: 7 });
	//AddBossListEntry({ boss_unitname: "EF_subboss2_wolf_pack", bossname: "Wolves", boss_descr: "Wolves", pos: 3, bosscount: 7 });
	//AddBossListEntry({ boss_unitname: "npc_dota_hero_lycan", bossname: "Fenrir", boss_descr: "Fenrir", pos: 4, bosscount: 7 });
	//AddBossListEntry({ boss_unitname: "EF_subboss3_fairy_lion", bossname: "Fairy Lions", boss_descr: "Fairy Lions", pos: 5, bosscount: 7 });
	//AddBossListEntry({ boss_unitname: "npc_dota_hero_enchantress", bossname: "Freya", boss_descr: "Freya", pos: 6, bosscount: 7 });
	
	$.Schedule(6, function()
	{

	});
	
	//
}
