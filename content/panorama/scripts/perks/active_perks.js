"use strict";

//$.Msg();   

var ActivePerksPickers = {};
var ActivePerksPickersCount = 0;
var ActivePerksPickersActivePerks = {};

var MarginTop = 0;
var MarginLeft = 68;

var paneldebug1;

function AddLine(name)
{
	var panel = $.CreatePanel('Panel', $('#ActivePerkss'), '');
	panel.BLoadLayoutSnippet("ActivePerksPicker");
	
	panel.FindChildTraverse('ActivePerksListCaption').text = name;

	panel.style.marginTop = (MarginTop) + "px;";
	
	return panel;
}

function AddActivePerks(name, title, descr, type1, type2, level, pos, votes, color1, color2, gradient, bordercolor, enabled)
{
	var panel;
	var picturePanel;

	if (name.match("^artifact"))
	{
		panel = $.CreatePanel('Panel', $('#ActivePerksAbilityButtons'), name);
		panel.BLoadLayoutSnippet("ActivePerksAbilityButton");
		picturePanel = 'ActivePerksAbilityPicture';

		/*
		panel.SetPanelEvent("onmouseactivate", function(){
			GameEvents.SendCustomGameEventToServer( "activeperks_use_ability", { name: name, pos: pos } );
		})
		*/
	}
	else if (name.match("^glyph"))
	{
		panel = $.CreatePanel('Panel', $('#ActivePerksButtons'), name);
		panel.BLoadLayoutSnippet("ActivePerksButton");
		picturePanel = 'ActivePerksPicture';
	}

	var pic = "file://{images}/custom_game/perks/" + name + ".png";
	panel.FindChildTraverse(picturePanel).SetImage(pic);
	
	panel.FindChildTraverse(picturePanel).style.backgroundColor = "gradient( linear, 0% " + gradient + "%, 0% 0%, from( " + color1 + " ), to( " + color2 + " ) );";
	
	// Left Click
	/*
	if (enabled) {
		panel.SetPanelEvent("onmouseactivate", function(){
			GameEvents.SendCustomGameEventToServer( "activeperks_replace", { name: name, pos: pos } );
		})
	}
	*/

	// Tooltip Show
	
	var descr_chunks = descr.match(/.{1,254}/g);
	var formatted_descr = "";
	var i = 1;
	for (var chunk in descr_chunks) {
		formatted_descr = formatted_descr + "&description" + i + "=" + descr_chunks[chunk];
		i = i + 1;
	}
	
	panel.SetPanelEvent("onmouseover", function(){
		//$.DispatchEvent( "DOTAShowTitleTextTooltip", panel, title, descr );
		$.DispatchEvent( "UIShowCustomLayoutParametersTooltip", panel, "PerkTooltip", "file://{resources}/layout/custom_game/perks/perks_tooltip.xml", "title="+title+"&type1="+type1+"&type2="+type2+"&level="+level+formatted_descr );
	})
	
	// Tooltip Hide
	panel.SetPanelEvent("onmouseout", function(){
		//$.DispatchEvent( "DOTAHideTitleTextTooltip", panel );
		$.DispatchEvent( "UIHideCustomLayoutTooltip", "PerkTooltip" );
	})
	
	panel.style.marginTop = (MarginTop) + "px;";
	panel.style.marginLeft = (MarginLeft*(pos)) + "px;";
	
	return panel;
}

function OnNewActivePerksPickerLineActivePerks(data)
{
	var ActivePerksPickerActivePerks = AddActivePerks(data.name, data.title, data.descr, data.type1, data.type2, data.level, data.pos, data.votes, data.color1, data.color2, data.gradient, data.bordercolor, data.enabled);
	ActivePerksPickersActivePerks[data.name+data.pos] = ActivePerksPickerActivePerks;
	
	return ActivePerksPickerActivePerks;
}

(function () {
  GameEvents.Subscribe( "on_new_activeperkspicker_line_activeperks", OnNewActivePerksPickerLineActivePerks );
})();

function RemoveAll()
{
	var key;
	for (key in ActivePerksPickersActivePerks) {
		if (ActivePerksPickersActivePerks.hasOwnProperty(key)) {

			if (ActivePerksPickersActivePerks[key] != undefined) {
				ActivePerksPickersActivePerks[key].DeleteAsync(0);
				ActivePerksPickersActivePerks[key] = null;
			}
		}
	}
}

(function () {
  GameEvents.Subscribe( "activeperks_removeall", RemoveAll );
})();

function RemoveActivePerks(data)
{
	$.Msg("RemoveActivePerks(data) "+data.name+data.pos);
	ActivePerksPickersActivePerks[data.name+data.pos].DeleteAsync(0);
	ActivePerksPickersActivePerks[data.name+data.pos] = null;
}

(function () {
  GameEvents.Subscribe( "on_remove_activeperk", RemoveActivePerks );
})();

//OnActivePerkChangeAppearance( {name: "greater_interval_health_regen_mana_regen", bordercolor: "#ff3333"} )

function OnActivePerkChangeAppearance(data)
{
	var perkName = data.name;
	var perkID = data.id;
	var panel = ActivePerksPickersActivePerks[perkName+perkID].FindChildTraverse('ActivePerksPicture');
	var panelTxt = ActivePerksPickersActivePerks[perkName+perkID].FindChildTraverse('ActivePerksLabel');

	var bordercolor = data.bordercolor;

	panelTxt.text = $.Localize(data.time);

	AnimatePanel(panel, { "border": "4px solid "+bordercolor+";" }, 0.45, "ease-in", 0.0);
	AnimatePanel(panelTxt, { "color": bordercolor+";" }, 0.45, "ease-in", 0.0);
	
	$.Schedule(0.50, function()
	{
		AnimatePanel(panel, { "border": "2px solid black;" }, 0.45, "ease-out", 0.0);
		AnimatePanel(panelTxt, { "color": "white;" }, 0.45, "ease-out", 0.0);
	});
}

(function () {
  GameEvents.Subscribe( "on_active_perk_change_appearance", OnActivePerkChangeAppearance );
})();


function OnInactivePerkChangeAppearance(data)
{
	var perkName = data.name;
	var perkID = data.id;
	var panelTxt = ActivePerksPickersActivePerks[perkName+perkID].FindChildTraverse('ActivePerksLabel');

	panelTxt.text = $.Localize(data.time);
	panelTxt.style.color = "red;";
}

(function () {
  GameEvents.Subscribe( "on_inactive_perk_change_appearance", OnInactivePerkChangeAppearance );
})();

function OnUpdateActivePerksAbilityCooldown(data)
{
	var panelBtn = ActivePerksPickersActivePerks[data.name+data.id].FindChildTraverse('ActivePerksAbilityPicture');
	var panelTxt = ActivePerksPickersActivePerks[data.name+data.id].FindChildTraverse('ActivePerksAbilityLabel');

	if (data.time == 0) {

		panelBtn.style.opacity = "1.0;";
		panelTxt.text = "";

	} else {

		panelBtn.style.opacity = "0.2;";
		panelTxt.text = String(data.time);
	}
}

(function () {
  GameEvents.Subscribe( "on_update_activeperks_ability_cooldown", OnUpdateActivePerksAbilityCooldown );
})();

function AbilityUsable(data)
{
	var panel = ActivePerksPickersActivePerks[data.name+data.id];

	if (data.usable) {
		//panel.style.opacity = "1.0;";
	}
	else {
		//panel.style.opacity = "0.4;";
	}

	panel.FindChildTraverse('ActivePerksAbilityPicture').style.backgroundColor = "gradient( linear, 0% " + data.gradient + "%, 0% 0%, from( " + data.color1 + " ), to( " + data.color2 + " ) );";
}

(function () {
  GameEvents.Subscribe( "ability_usable", AbilityUsable );
})();


var DEFAULT_DURATION = "300.0ms";
var DEFAULT_EASE = "linear";

function AnimatePanel(panel, values, duration, ease, delay)
{
	// generate transition string
	var durationString = (duration != null ? parseInt(duration * 1000) + ".0ms" : DEFAULT_DURATION);
	var easeString = (ease != null ? ease : DEFAULT_EASE);
	var delayString = (delay != null ? parseInt(delay * 1000) + ".0ms" : "0.0ms"); 
	var transitionString = durationString + " " + easeString + " " + delayString;

	var i = 0;
	var finalTransition = ""
	for (var property in values)
	{
		// add property to transition
		finalTransition = finalTransition + (i > 0 ? ", " : "") + property + " " + transitionString;
		i++;
	}

	// apply transition
	panel.style.transition = finalTransition + ";";

	// apply values
	for (var property in values)
		panel.style[property] = values[property];
}


// Debug 

//debug()

function debug()
{
	paneldebug1 = OnNewActivePerksPickerLineActivePerks({ name: "greater_interval_health_regen_mana_regen", pos: "2", descr: "missing!", votes: "0", color1: "black", color2: "black", gradient: "black", bordercolor: "black", enabled: true });
	
	$.Schedule(6, function()
	{
		paneldebug1.DeleteAsync(0);
		paneldebug1 = null;
	});

}
