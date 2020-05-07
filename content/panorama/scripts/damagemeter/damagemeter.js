"use strict"

var dmgmtr = {};

function OnNewDamagemeterLine(data)
{
	var panel = $.CreatePanel('Panel', $('#Damagemeters'), '');
	panel.BLoadLayoutSnippet('Damagemeter');
	
	dmgmtr[data.name] = panel
	
	if (data.dps == null)
		data.dps = 0
	
	panel.FindChildTraverse('DamagemeterIcon').heroname = data.name;
	panel.FindChildTraverse('DamagemeterLabel').text = data.label;
	panel.FindChildTraverse('DamagemeterValue').text = data.value + " (" + data.percentage + "%) [" + data.dps + " DPS]";
	panel.FindChildTraverse('BackgroundBar').style.width = data.percentage + "%";
}

function OnUpdateDamagemeterLine(data)
{
	var panel = dmgmtr[data.name];
	
	panel.FindChildTraverse('DamagemeterValue').text = data.value;
	panel.FindChildTraverse('BackgroundBar').style.width = data.percentage + "%";
}

function OnRemoveDamagemeterLine(data)
{
	var panel = dmgmtr[data.name];
	if (panel != null) {
		
		panel.DeleteAsync(0);
		dmgmtr[data.name] = null;
		
	}
}

(function () {
  GameEvents.Subscribe( "on_new_damagemeter_line", OnNewDamagemeterLine );
})();

(function () {
  GameEvents.Subscribe( "on_update_damagemeter_line", OnUpdateDamagemeterLine );
})();

(function () {
  GameEvents.Subscribe( "on_remove_damagemeter_line", OnRemoveDamagemeterLine );
})();



function ButtonDamagemeters(){
	var Panel = $( "#DamagemetersFrame");
	
	if (Panel.visible) {
		Panel.visible = false;
		Panel.enable = false;
		Panel.hittest = false;
		Panel.hittestchildren = false;
	} else { 
		Panel.visible = true;
		Panel.enable = true;
		Panel.hittest = true;
		Panel.hittestchildren = true;
	}
}

var DamagemetersFrame = $( "#DamagemetersFrame");
DamagemetersFrame.visible = false;
DamagemetersFrame.enable = false;
DamagemetersFrame.hittest = false;
DamagemetersFrame.hittestchildren = false;


function DamagemeterVisible() {
	var Panel = [ $("#DamagemetersFrame"), $("#Damagemeters"), $("#ButtonDamagemeters"), $("#ButtonDamagemetersText") ];

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

// Debug

function debug()
{
	OnNewDamagemeterLine({name: "npc_dota_hero_necrolyte", label: "Gravekeeper", value: "151.765", percentage: "40"});
	OnNewDamagemeterLine({name: "npc_dota_hero_dragon_knight", label: "Dragon Warrior", value: "122.765", percentage: "30"});
	OnNewDamagemeterLine({name: "npc_dota_hero_arc_warden", label: "Dominator of Time", value: "83.765", percentage: "15"});
	OnNewDamagemeterLine({name: "npc_dota_hero_rattletrap", label: "Steam Mech", value: "78.547", percentage: "10"});
	OnNewDamagemeterLine({name: "npc_dota_hero_omniknight", label: "Paladin", value: "52.124", percentage: "5"});
	$.Schedule(10, function()
	{
		//OnStatUpdate({name: "crit_chance", value: "55%"});
		OnRemoveDamagemeterLine("npc_dota_hero_necrolyte");
		OnRemoveDamagemeterLine("npc_dota_hero_dragon_knight");
		OnRemoveDamagemeterLine("npc_dota_hero_arc_warden");
		OnRemoveDamagemeterLine("npc_dota_hero_rattletrap");
		OnRemoveDamagemeterLine("npc_dota_hero_omniknight");
		//OnStatRemove(stattest1);
		//OnStatRemove(stattest2);
	});
	
	//
}
