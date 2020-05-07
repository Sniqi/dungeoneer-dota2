"use strict";

//$.Msg();

OnChangeGamePhasePerksPicker( {phase: "no-pick"} )

var PerksPickersCount = 0;
var PerksPickersPerks = {};
var PerksPickersPerksCount = 0;

var LastPickedPerk = "";

var PerkType = "";

var MarginTop = 25;
var MarginLeft = 115;

var DebugState = false;

var paneldebug1;
var paneldebug2;
var paneldebug3;
var paneldebug4;
var paneldebug5;

//$("#ButtonContinueText").style.color = "grey;";
//$("#ButtonContinue").enabled = false;

$("#ButtonRerollText").style.color = "white;";
$("#ButtonReroll").enabled = true;

function PerksInit(data)
{
	PerksPickersCount = 0;
	PerksPickersPerks = {};
	PerksPickersPerksCount = 0;

	LastPickedPerk = "";

	$("#Headline").text = data.headline;

	MarginTop = 25;
	MarginLeft = 115;

	if (data.reroll < 1 || data.perkType == "artifact") {
		$("#ButtonReroll").visible = false;
		$("#ButtonReroll").enable = false;
		$("#ButtonReroll").hittest = false;
		$("#ButtonReroll").hittestchildren = false;
	}
	else {
		//$("#ButtonContinueText").style.color = "grey;";
		//$("#ButtonContinue").enabled = false;
		$("#ButtonRerollText").style.color = "white;";
		$("#ButtonReroll").enabled = true;
	}
}

(function () {
  GameEvents.Subscribe( "on_perks_init", PerksInit );
})();

function ButtonContinueActivate()
{
	/*
	var key;
	for (key in PerksPickersPerks) {
		if (PerksPickersPerks.hasOwnProperty(key)) {

			var panel = PerksPickersPerks[key];
			
			$.GetContextPanel().enabled = false;
			panel.FindChildTraverse('PerksPicture').style.backgroundColor = "gradient( linear, 0% 100%, 0% 0%, from( #232323 ), to( #8c8c8c ) );";
		}
	}
	
//	$("#ButtonContinueText").style.color = "yellow;";
//	$("#ButtonContinue").enabled = false;
//	$("#ButtonRerollText").style.color = "grey;";
//	$("#ButtonReroll").enabled = false;

	RemoveAll()
	*/

	GameEvents.SendCustomGameEventToServer( "perks_lock", { perkType: PerkType } );
}

function ButtonRerollActivate()
{
	GameEvents.SendCustomGameEventToServer( "perks_reroll", { perkType: PerkType } );

	$( "#ButtonReroll").visible = false;
	$( "#ButtonReroll").enable = false;
	$( "#ButtonReroll").hittest = false;
	$( "#ButtonReroll").hittestchildren = false;
}

function RemoveAll_Upgrade()
{
	var key;
	for (key in PerksPickersPerks) {
		if (PerksPickersPerks.hasOwnProperty(key)) {
			if (key.match("^upgrade")) {

				$.Msg("RemoveAll_Upgrade() "+key);
				if (PerksPickersPerks[key] != undefined) {
					PerksPickersPerks[key].DeleteAsync(0);
					PerksPickersPerks[key] = null;
				}
			}
		}
	}
}

(function () {
  GameEvents.Subscribe( "perks_removeall_upgrade", RemoveAll_Upgrade );
})();

function RemoveAll()
{
	var key;
	for (key in PerksPickersPerks) {
		if (PerksPickersPerks.hasOwnProperty(key)) {

			if (PerksPickersPerks[key] != undefined) {
				PerksPickersPerks[key].DeleteAsync(0);
				PerksPickersPerks[key] = null;
			}
		}
	}
}

(function () {
  GameEvents.Subscribe( "perks_removeall", RemoveAll );
})();


function RemovePerk(data)
{
	$.Msg("RemovePerk(data) "+data.type+data.name+data.pos);
	PerksPickersPerks[data.type+data.name+data.pos].DeleteAsync(0);
	PerksPickersPerks[data.type+data.name+data.pos] = null;
}

(function () {
  GameEvents.Subscribe( "on_remove_perk", RemovePerk );
})();


function AddPerks(type, name, title, descr, type1, type2, level, costs, pos, votes, color1, color2, gradient, enabled)
{
	var panel;

	if (name.match("^artifact"))
	{
		PerkType = "artifact";
	}
	else if (name.match("^glyph"))
	{
		PerkType = "glyph";
	}

	if (type == "buy")
	{
		panel = $.CreatePanel('Panel', $('#PerksButtons'), name);
	}
	else if (type == "upgrade")
	{
		panel = $.CreatePanel('Panel', $('#PerksButtonsUpgrade'), name);
	}

	panel.BLoadLayoutSnippet("PerksButton");

	if (enabled) {
		panel.perkenabled = true;
	} else {
		panel.perkenabled = false;
	}

	var pic = "file://{images}/custom_game/perks/" + name + ".png";
	panel.FindChildTraverse('PerksPicture').SetImage(pic);
	
	panel.FindChildTraverse('PerksPicture').style.backgroundColor = "gradient( linear, 0% " + gradient + "%, 0% 0%, from( " + color1 + " ), to( " + color2 + " ) );";

	if (costs == -1) {
		panel.FindChildTraverse('PerksLevelText').text = String("max");
	}
	else {
		panel.FindChildTraverse('PerksLevelText').text = String(costs*-1);
	}

	// Sell
	if (type == "upgrade") {
		// Right Click
		panel.SetPanelEvent("oncontextmenu", function(){
			GameEvents.SendCustomGameEventToServer( "perks_sell", { playerID: Players.GetLocalPlayer(), name: name, pos: pos, level: level } );
		})
	}

	// Buy / Upgrade
	// Left Click
	panel.SetPanelEvent("onmouseactivate", function(){
		GameEvents.SendCustomGameEventToServer( "perks_upvote", { playerID: Players.GetLocalPlayer(), name: name, pos: pos, level: level, enabled: panel.perkenabled } );
		LastPickedPerk = name;
	})

	if (enabled) {
		panel.FindChildTraverse('PerksLevelText').style.color = "#00FF00;";

	} else {
		panel.style.opacity = "0.3;";
		panel.FindChildTraverse('PerksLevelText').style.color = "#FF0000;";
	}
	
	// Tooltip Show
	var descr_chunks = descr.match(/.{1,254}/g);
	var formatted_descr = "";
	var i = 1;
	for (var chunk in descr_chunks) {
		formatted_descr = formatted_descr + "&description" + i + "=" + descr_chunks[chunk];
		i = i + 1;
	}
	
	panel.SetPanelEvent("onmouseover", function(){
		//$.DispatchEvent( "DOTAShowTitleTextTooltip", panel, "#" + name + "_Title", "#" + name + "_Description" );
		$.DispatchEvent( "UIShowCustomLayoutParametersTooltip", panel, "PerkTooltip", "file://{resources}/layout/custom_game/perks/perks_tooltip.xml", "title="+title+"&type1="+type1+"&type2="+type2+"&level="+level+formatted_descr );
	})
	
	// Tooltip Hide
	panel.SetPanelEvent("onmouseout", function(){
		//$.DispatchEvent( "DOTAHideTitleTextTooltip", panel );
		$.DispatchEvent( "UIHideCustomLayoutTooltip", "PerkTooltip" );
	})
	
	if (pos <= 3) {
		panel.style.marginTop = (MarginTop) + "px;";
		panel.style.marginLeft = (MarginLeft*(pos)) + "px;";
	} else {
		panel.style.marginTop = (MarginTop+125) + "px;";
		panel.style.marginLeft = (MarginLeft*(pos-4)) + "px;";
	}

	if (DebugState === true) {
		var size = 84;
		var perksPerRow = 10;
		var row = 1;
		panel.style.width = size+"px;";
		panel.style.height = size+"px;";

		if (pos <= perksPerRow) {
			panel.style.marginTop = (MarginTop) + "px;";
			panel.style.marginLeft = ( (5+size)*(pos)) + "px;";
		} else if (pos <= 20) {
			row = 1;
			panel.style.marginTop = (MarginTop+5+(size*row)) + "px;";
			panel.style.marginLeft = ( (5+size)*(pos-(perksPerRow*row))) + "px;";
		} else {
			row = 2;
			panel.style.marginTop = (MarginTop+5+(size*row)) + "px;";
			panel.style.marginLeft = ( (5+size)*(pos-(perksPerRow*row))) + "px;";
		}
	}

	return panel;
}

function OnNewPerksPickerLinePerks(data)
{
	var PerksPickerPerks = AddPerks(data.type, data.name, data.title, data.descr, data.type1, data.type2, data.level, data.costs, data.pos, data.votes, data.color1, data.color2, data.gradient, data.enabled);
	PerksPickersPerks[data.type+data.name+data.pos] = PerksPickerPerks;
	
	return PerksPickerPerks;
}

(function () {
  GameEvents.Subscribe( "on_new_perkspicker_line_perks", OnNewPerksPickerLinePerks );
})();

function OnBuyPerk(data)
{
	/*
	// Adjust old vote
	if (data.oldname != undefined)
	{
		var panel = PerksPickersPerks[data.oldname];
		
		//panel.FindChildTraverse('PerksLevelText').text = data.oldvotes;
		if (data.oldvotes == 0) {
			panel.FindChildTraverse('PerksLevelText').style.color = "#ff4444;";
			panel.FindChildTraverse('PerksLevelText').text = "X";
		}
		else {
			panel.FindChildTraverse('PerksLevelText').style.color = "#44ff44;";
			panel.FindChildTraverse('PerksLevelText').text = "&#x2665;";
		}
	}
	else
	{
		if ( $("#ButtonContinueText").text == "Replace" ) {
			$("#ButtonContinueText").style.color = "#ff2100;";
		} else {
			$("#ButtonContinueText").style.color = "white;";
		}
		$("#ButtonContinue").enabled = true;
	}
	
	
	for (key in PerksPickersPerks) {
		if (PerksPickersPerks.hasOwnProperty(key)) {
			$.Msg(key);
		}
	}
$.Msg(data.type+data.name+data.pos);
	var panel = PerksPickersPerks[data.type+data.name+data.pos];
	panel.style.opacity = "0.3;";
	panel.FindChildTraverse('PerksLevelText').style.color = "#FF0000;";
	panel.perkenabled = false;
	*/
}

(function () {
  GameEvents.Subscribe( "on_buy_perk", OnBuyPerk );
})();

function EnableAllPerks(data)
{
	var key;
	for (key in PerksPickersPerks) {
		if (PerksPickersPerks.hasOwnProperty(key)) {

			var panel = PerksPickersPerks[key];

			if (panel != undefined && key.match("^buy") ) {
				panel.style.opacity = "1.0;";
				panel.FindChildTraverse('PerksLevelText').style.color = "#00FF00;";
				panel.perkenabled = true;
			}
		}
	}
}

(function () {
  GameEvents.Subscribe( "enable_all_perks", EnableAllPerks );
})();


function DisableAllPerks(data)
{
	var key;
	for (key in PerksPickersPerks) {
		if (PerksPickersPerks.hasOwnProperty(key)) {

			var panel = PerksPickersPerks[key];

			if (panel != undefined && key.match("^buy") ) {
				panel.style.opacity = "0.3;";
				panel.FindChildTraverse('PerksLevelText').style.color = "#FF0000;";
				panel.perkenabled = false;
			}
		}
	}
}

(function () {
  GameEvents.Subscribe( "disable_all_perks", DisableAllPerks );
})();

function DisableBoughtPerks(data)
{
	var array = data.array.split(";");

	var key, value;
	for (key in array) {
		if (PerksPickersPerks.hasOwnProperty(array[key])) {

			var panel = PerksPickersPerks[array[key]];

			if (panel != undefined && array[key].match("^buy") ) {
				panel.style.opacity = "0.3;";
				panel.FindChildTraverse('PerksLevelText').style.color = "#FF0000;";
				panel.perkenabled = false;
			}
		}
	}
}

(function () {
  GameEvents.Subscribe( "disable_bought_perks", DisableBoughtPerks );
})();


function DisablePerksTooExpensive(data)
{
	var key;
	for (key in PerksPickersPerks) {
		if (PerksPickersPerks.hasOwnProperty(key)) {

			var panel = PerksPickersPerks[key];

			if (panel != undefined ) {
				var costs = parseInt(panel.FindChildTraverse('PerksLevelText').text);
				
				if (costs > data.currency) {
					panel.style.opacity = "0.3;";
					panel.FindChildTraverse('PerksLevelText').style.color = "#FF0000;";
					panel.perkenabled = false;
				} else {
					panel.style.opacity = "1.0;";
					panel.FindChildTraverse('PerksLevelText').style.color = "#00FF00;";
					panel.perkenabled = true;	
				}

			}
		}
	}
}

(function () {
  GameEvents.Subscribe( "disable_perks_too_expensive", DisablePerksTooExpensive );
})();

function OnUpdatePerksTimer(data)
{
	$("#Timer").text = String(data.time) + "s";
}

function OnUpdatePerksReroll(data)
{
	$("#ButtonReroll").text = "Reroll(" + String(data.rerollcount) + ")";
}

function DefaultTxt()
{
	$("#ButtonContinueText").text = "Choose";
	$("#ButtonContinueText").style.color = "#ffffff;";
	$("#ReplaceTxt").text ="";
}

(function () {
  GameEvents.Subscribe( "perks_defaulttxt", DefaultTxt );
})();

function ReplaceTxt(data)
{
	$("#ButtonContinueText").text = "Replace";
	$("#ButtonContinueText").style.color = "#ff2100;";
	$("#ReplaceTxt").text ="<font color='#ff2100'>Warning!</font> This action replaces <font color='#f4e842'>" +  $.Localize("#" + String(data.name) + "_Title" ) + "</font>";
}

ReplaceMessageShow( { show: false } )

function ReplaceMessageShow(data)
{
	if ( data.show ) {
		["#ReplaceMessage","#ReplaceMessageTxt","#ReplaceMessageButton","#ReplaceMessageButtonTxt","#ReplaceTxt"].forEach (ShowElement);
	} else {
		["#ReplaceMessage","#ReplaceMessageTxt","#ReplaceMessageButton","#ReplaceMessageButtonTxt","#ReplaceTxt"].forEach (HideElement);
		if ( !data.hidemessageonly ) {
			["#ReplaceTxt"].forEach (HideElement);
		}
	}
}

(function () {
  GameEvents.Subscribe( "perks_replacemessage_show", ReplaceMessageShow );
})();

function ReplaceMessageButtonActivate()
{
	ReplaceMessageShow( { show: false, hidemessageonly: true } )
}

function OnChangeGamePhasePerksPicker(data)
{
	if (data.phase == "pick")
	{
		$.GetContextPanel().visible = true;
		$.GetContextPanel().enable = true;
		
		["#Perkss","#Timer","#ButtonContinue","#ButtonReroll"].forEach (ShowElement);
		
		//GameEvents.SendCustomGameEventToServer( "help_add", { playerID: Players.GetLocalPlayer(), name: "Special Modes"} );
	}
	else
	{
		$.GetContextPanel().visible = false;
		$.GetContextPanel().enable = false;

		["#Perkss","#Timer","#ButtonContinue","#ButtonReroll"].forEach (HideElement);
		
		//GameEvents.SendCustomGameEventToServer( "help_remove", { playerID: Players.GetLocalPlayer(), name: "Special Modes"} );
	}
}

function ShowElement(elem) {
	$(elem).visible = true;
	$(elem).enable = true;
	$(elem).hittest = true;
	$(elem).hittestchildren = true;
}

function HideElement(elem) {
	$(elem).visible = false;
	$(elem).enable = false;
	$(elem).hittest = false;
	$(elem).hittestchildren = false;
}

(function () {
  GameEvents.Subscribe( "on_update_perks_timer", OnUpdatePerksTimer );
})();

(function () {
  GameEvents.Subscribe( "on_update_perks_reroll", OnUpdatePerksReroll );
})();

(function () {
  GameEvents.Subscribe( "on_change_game_phase_perkspicker", OnChangeGamePhasePerksPicker );
})();


(function () {
  GameEvents.Subscribe( "perks_replacetxt", ReplaceTxt );
})();


function HelpTooltipShow()
{
	var panel = $("#Help");
	var title = "Manage Perks";
	var descr = "<b>Left click</b> a Perk to buy or upgrade<br><br>";
	descr += "<b>Right click</b> an owned Perk to <b>sell</b> it. Only the costs of the <b>current level</b> is refunded, not the upgrade costs from before.";
	$.DispatchEvent( "DOTAShowTitleTextTooltip", panel, title, descr );
	//$.DispatchEvent( "UIShowCustomLayoutParametersTooltip", panel, "PerkTooltip", "file://{resources}/layout/custom_game/perks/perks_tooltip.xml", "title="+title+"&type1="+type1+"&type2="+type2+"&level="+level+formatted_descr );

}

function HelpTooltipHide()
{
	var panel = $("#Help");
	$.DispatchEvent( "DOTAHideTitleTextTooltip", panel );
	//$.DispatchEvent( "UIHideCustomLayoutTooltip", "PerkTooltip" );
}

function DEBUG(data)
{
	DebugState = true;

	$("#Perkss").style.width = "100%;";
	$("#Perkss").style.height = "100%;";
}

(function () {
  GameEvents.Subscribe( "perkspicker_debug", DEBUG );
})();
