"use strict";

['#ButtonLock'].forEach (HideElement);

var dynamicElements = ["#LootOverviews","#LootOverviewLines"]
dynamicElements.forEach (HideElement);

var ActiveLootLines = {};

function AddLootLine(name, descr, value, multiplier, empower, delay)
{
	var panel = $.CreatePanel('Panel', $('#LootOverviewLines'), name);
	panel.BLoadLayoutSnippet("LootOverviewLine");

	multiplier = Math.floor( multiplier * 100 );
	multiplier = multiplier / 100

	var empower_readable = Math.floor( empower * 100 );

	var LootOverviewBox_Currency_Descr = panel.FindChildTraverse('LootOverviewBox_Currency_Descr');
	var LootOverviewBox_Currency_Value = panel.FindChildTraverse('LootOverviewBox_Currency_Value');
	var LootOverviewBox_Currency_Pic = panel.FindChildTraverse('LootOverviewBox_Currency_Pic');
	var LootOverviewBox_Currency_Multiplier = panel.FindChildTraverse('LootOverviewBox_Currency_Multiplier');
	var LootOverviewBox_Currency_Value_Total = panel.FindChildTraverse('LootOverviewBox_Currency_Value_Total');
	var LootOverviewBox_Currency_Pic_Total = panel.FindChildTraverse('LootOverviewBox_Currency_Pic_Total');
	var LootOverviewBox_Currency_Empower_Button = panel.FindChildTraverse('LootOverviewBox_Currency_Empower_Button');
	var LootOverviewBox_Currency_Empower_Button_Txt = panel.FindChildTraverse('LootOverviewBox_Currency_Empower_Button_Txt');
	var LootOverviewBox_Currency_Empower_Button_Pic = panel.FindChildTraverse('LootOverviewBox_Currency_Empower_Button_Pic');
	var LootOverviewBox_Currency_Empower_Multiplier_Txt = panel.FindChildTraverse('LootOverviewBox_Currency_Empower_Multiplier_Txt');

	LootOverviewBox_Currency_Descr.text = descr+":";
	LootOverviewBox_Currency_Value.text = String(value);
	LootOverviewBox_Currency_Multiplier.text = "x"+String( multiplier );
	LootOverviewBox_Currency_Value_Total.text = String( Math.floor(value*multiplier) );
	LootOverviewBox_Currency_Empower_Button_Txt.text = "Empower by "+String( empower_readable )+"%";

	var pic = "file://{images}/custom_game/misc/" + name + ".png";
	LootOverviewBox_Currency_Pic.SetImage(pic);
	LootOverviewBox_Currency_Pic_Total.SetImage(pic);
	LootOverviewBox_Currency_Empower_Button_Pic.SetImage(pic);

	// Button Left Click
	LootOverviewBox_Currency_Empower_Button.SetPanelEvent("onmouseactivate", function(){
		GameEvents.SendCustomGameEventToServer( "loot_empower", { playerID: Players.GetLocalPlayer(), empower: name } );

		['#ButtonLock'].forEach (ShowElement);

		var key;
		for (key in ActiveLootLines) {		
			if (ActiveLootLines.hasOwnProperty(key)) {

				var panel = ActiveLootLines[key].FindChildTraverse('LootOverviewBox_Currency_Empower_Button');

				if (panel != undefined) {
					panel.DeleteAsync(0);
				}
			}
		}

		LootOverviewBox_Currency_Value_Total.text = String( Math.floor( (value*multiplier) * (1.0+empower) ) );
		LootOverviewBox_Currency_Empower_Multiplier_Txt.text = String( empower_readable )+"%";

		AnimatePanel(LootOverviewBox_Currency_Empower_Multiplier_Txt, { "opacity": "1.0;" }, 0.0, "ease-in", 0.0);
		AnimatePanel(LootOverviewBox_Currency_Empower_Multiplier_Txt, { "transform": "translateX(0px) translateY(-250px)", "opacity": "1.0;" }, 4.0, "ease-out", 0.0);

		AnimatePanel(LootOverviewBox_Currency_Value_Total, { "color": "green;" }, 0.2, "ease-in", 0.0);

		$.Schedule(1.0, function()
		{
			AnimatePanel(LootOverviewBox_Currency_Value_Total, { "color": "white;" }, 3.0, "ease-out", 0.0);
		});
	})

	Animation_HideElement(LootOverviewBox_Currency_Descr, 0.0, 0.0);
	Animation_HideElement(LootOverviewBox_Currency_Value, 0.0, 0.0);
	Animation_HideElement(LootOverviewBox_Currency_Pic, 0.0, 0.0);
	Animation_HideElement(LootOverviewBox_Currency_Multiplier, 0.0, 0.0);
	Animation_HideElement(LootOverviewBox_Currency_Value_Total, 0.0, 0.0);
	Animation_HideElement(LootOverviewBox_Currency_Pic_Total, 0.0, 0.0);
	Animation_HideElement(LootOverviewBox_Currency_Empower_Button, 0.0, 0.0);
	Animation_HideElement(LootOverviewBox_Currency_Empower_Button_Txt, 0.0, 0.0);
	Animation_HideElement(LootOverviewBox_Currency_Empower_Button_Pic, 0.0, 0.0);
	//Animation_HideElement(LootOverviewBox_Currency_Empower_Multiplier_Txt, 0.0, 0.0);
	AnimatePanel(LootOverviewBox_Currency_Empower_Multiplier_Txt, { "transform": "translateX(0px) translateY(0px) scaleX(1.0) scaleY(1.0);", "opacity": "0.0;" }, 0.0, "ease-in", 0.0);

	$.Schedule(parseFloat(delay), function()
	{

		var duration = 1.0;

		Animation_ShowElement(LootOverviewBox_Currency_Descr, 0.0, duration);
		Animation_ShowElement(LootOverviewBox_Currency_Value, 0.1, duration);
		Animation_ShowElement(LootOverviewBox_Currency_Pic, 0.2, duration);
		Animation_ShowElement(LootOverviewBox_Currency_Multiplier, 0.3, duration);
		Animation_ShowElement(LootOverviewBox_Currency_Value_Total, 0.4, duration);
		Animation_ShowElement(LootOverviewBox_Currency_Pic_Total, 0.5, duration);

		if (empower !== undefined) {
			Animation_ShowElement(LootOverviewBox_Currency_Empower_Button, 0.6, duration);
			Animation_ShowElement(LootOverviewBox_Currency_Empower_Button_Txt, 0.8, duration);
			Animation_ShowElement(LootOverviewBox_Currency_Empower_Button_Pic, 0.7, duration);
		}

	});

	ActiveLootLines[name] = panel;
	return panel;
}

function OnNewLootLine(data)
{
	return AddLootLine(data.name, data.descr, data.value, data.multiplier, data.empower, data.delay);
}

(function () {
  GameEvents.Subscribe( "on_new_loot_line", OnNewLootLine );
})();

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

function LootShow(data) {
	dynamicElements.forEach (ShowElement);

	AnimatePanel($('#LootOverviews'), { "transform": "translateX(-400px) translateY(-400px) scaleX(0.0) scaleY(0.0);", "opacity": "0.0;" }, 0.0, "ease-in", 0.0);
	AnimatePanel($('#LootOverviews'), { "transform": "translateX(0px) translateY(0px) scaleX(1.0) scaleY(1.0);", "opacity": "1.0;" }, 1.0, "ease-in", 0.0);
}

function LootHide(data) {
	AnimatePanel($('#LootOverviews'), { "transform": "translateX(-400px) translateY(-400px) scaleX(0.0) scaleY(0.0);", "opacity": "0.0;" }, 1.0, "ease-out", 0.0);

	$.Schedule(2.0, function()
	{
		var key;
		for (key in ActiveLootLines) {
			if (ActiveLootLines.hasOwnProperty(key)) {

				var panel = ActiveLootLines[key];

				if (panel != undefined) {
					panel.DeleteAsync(0);
				}
			}
		}

		dynamicElements.forEach (HideElement);
	});
}

(function () {
  GameEvents.Subscribe( "loot_show", LootShow );
})();

(function () {
  GameEvents.Subscribe( "loot_hide", LootHide );
})();

function Animation_ShowElement(elem, delay, duration) {
	$.Schedule(delay, function()
	{
		AnimatePanel(elem, { "transform": "translateX(0px) translateY(0px) scaleX(1.0) scaleY(1.0);", "opacity": "1.0;" }, duration, "ease-in", 0.0);
	});
}

function Animation_HideElement(elem, delay, duration) {
	$.Schedule(delay, function()
	{
		AnimatePanel(elem, { "transform": "translateX(-50px) translateY(0px) scaleX(0.0) scaleY(0.0);", "opacity": "0.0;" }, duration, "ease-out", 0.0);
	});
}

function ButtonLockActivate()
{
	['#ButtonLock'].forEach (HideElement);

	GameEvents.SendCustomGameEventToServer( "loot_overview_lock", { playerID: Players.GetLocalPlayer() } );
}

function OnUpdateLootOverviewTimer(data)
{
	$("#Timer").text = String(data.time) + "s";
}

(function () {
  GameEvents.Subscribe( "on_update_loot_overview_timer", OnUpdateLootOverviewTimer );
})();

/*

AnimatePanel($( "#LootGold_Round_Txt" ), { "transform": "translateX(0px) translateY(0px) scaleX(0.0) scaleY(0.0);", "opacity": "0.0;" }, 0.0, "ease-in", 0.0);
AnimatePanel($( "#LootGold_Round_Value" ), { "transform": "translateX(0px) translateY(0px) scaleX(0.0) scaleY(0.0);", "opacity": "0.0;" }, 0.0, "ease-in", 0.0);
AnimatePanel($( "#LootGold_Round_Pic" ), { "transform": "translateX(0px) translateY(0px) scaleX(0.0) scaleY(0.0);", "opacity": "0.0;" }, 0.0, "ease-in", 0.0);
AnimatePanel($( "#LootGold_TimeBonus_Txt" ), { "transform": "translateX(0px) translateY(0px) scaleX(0.0) scaleY(0.0);", "opacity": "0.0;" }, 0.0, "ease-in", 0.0);
AnimatePanel($( "#LootGold_TimeBonus_Value" ), { "transform": "translateX(0px) translateY(0px) scaleX(0.0) scaleY(0.0);", "opacity": "0.0;" }, 0.0, "ease-in", 0.0);
AnimatePanel($( "#LootGold_TimeBonus_Pic" ), { "transform": "translateX(0px) translateY(0px) scaleX(0.0) scaleY(0.0);", "opacity": "0.0;" }, 0.0, "ease-in", 0.0);
AnimatePanel($( "#LootGold_Sum_Separator" ), { "transform": "translateX(0px) translateY(0px) scaleX(0.0) scaleY(0.0);", "opacity": "0.0;" }, 0.0, "ease-in", 0.0);
AnimatePanel($( "#LootGold_Sum_Value" ), { "transform": "translateX(0px) translateY(0px) scaleX(0.0) scaleY(0.0);", "opacity": "0.0;" }, 0.0, "ease-in", 0.0);
AnimatePanel($( "#LootGold_Sum_Pic" ), { "transform": "translateX(0px) translateY(0px) scaleX(0.0) scaleY(0.0);", "opacity": "0.0;" }, 0.0, "ease-in", 0.0);

//Loot_Gold( { round_gold: 2200, timebonus_gold: 562, sum_gold: 2762, duration: 10 } )

function Loot_Gold( table ) {

	var LootGold_Round_Value = $( "#LootGold_Round_Value" );
	LootGold_Round_Value.text = $.Localize( "+" + Math.floor( table.round_gold ) );

	var LootGold_TimeBonus_Value = $( "#LootGold_TimeBonus_Value" );
	LootGold_TimeBonus_Value.text = $.Localize(  "+" + Math.floor( table.timebonus_gold ) );

	var LootGold_Sum_Value = $( "#LootGold_Sum_Value" );
	LootGold_Sum_Value.text = $.Localize(  "+" + Math.floor( table.sum_gold ) );
	
	$.Schedule(0.2, function() {
		AnimatePanel($( "#LootGold_Round_Txt" ), { "transform": "translateX(0px) translateY(0px) scaleX(1.0) scaleY(1.0);", "opacity": "1.0;" }, 0.3, "ease-in", 0.0);
	});

	$.Schedule(0.4, function() {
		AnimatePanel($( "#LootGold_Round_Pic" ), { "transform": "translateX(0px) translateY(0px) scaleX(1.0) scaleY(1.0);", "opacity": "1.0;" }, 0.3, "ease-in", 0.0);
	});

	$.Schedule(0.6, function() {
		AnimatePanel($( "#LootGold_Round_Value" ), { "transform": "translateX(0px) translateY(0px) scaleX(1.0) scaleY(1.0);", "opacity": "1.0;" }, 0.3, "ease-in", 0.0);
	});


	$.Schedule(0.8, function() {
		AnimatePanel($( "#LootGold_TimeBonus_Txt" ), { "transform": "translateX(0px) translateY(0px) scaleX(1.0) scaleY(1.0);", "opacity": "1.0;" }, 0.3, "ease-in", 0.0);
	});

	$.Schedule(1.0, function() {
		AnimatePanel($( "#LootGold_TimeBonus_Pic" ), { "transform": "translateX(0px) translateY(0px) scaleX(1.0) scaleY(1.0);", "opacity": "1.0;" }, 0.3, "ease-in", 0.0);
	});

	$.Schedule(1.2, function() {
		AnimatePanel($( "#LootGold_TimeBonus_Value" ), { "transform": "translateX(0px) translateY(0px) scaleX(1.0) scaleY(1.0);", "opacity": "1.0;" }, 0.3, "ease-in", 0.0);
	});


	$.Schedule(2.2, function() {
		AnimatePanel($( "#LootGold_Sum_Separator" ), { "transform": "translateX(0px) translateY(0px) scaleX(1.0) scaleY(1.0);", "opacity": "1.0;" }, 0.3, "ease-in", 0.0);
	});

	$.Schedule(3.2, function() {
		AnimatePanel($( "#LootGold_Sum_Pic" ), { "transform": "translateX(0px) translateY(0px) scaleX(1.0) scaleY(1.0);", "opacity": "1.0;" }, 0.3, "ease-in", 0.0);
	});

	$.Schedule(3.4, function() {
		AnimatePanel($( "#LootGold_Sum_Value" ), { "transform": "translateX(0px) translateY(0px) scaleX(1.0) scaleY(1.0);", "opacity": "1.0;" }, 0.3, "ease-in", 0.0);
	});


	$.Schedule(table.duration, function() {
		AnimatePanel($( "#LootGold_Round_Txt" ), { "transform": "translateX(0px) translateY(0px) scaleX(0.0) scaleY(0.0);", "opacity": "0.0;" }, 1.0, "ease-in", 0.0);
		AnimatePanel($( "#LootGold_Round_Value" ), { "transform": "translateX(0px) translateY(0px) scaleX(0.0) scaleY(0.0);", "opacity": "0.0;" }, 1.0, "ease-in", 0.0);
		AnimatePanel($( "#LootGold_Round_Pic" ), { "transform": "translateX(0px) translateY(0px) scaleX(0.0) scaleY(0.0);", "opacity": "0.0;" }, 1.0, "ease-in", 0.0);
		AnimatePanel($( "#LootGold_TimeBonus_Txt" ), { "transform": "translateX(0px) translateY(0px) scaleX(0.0) scaleY(0.0);", "opacity": "0.0;" }, 1.0, "ease-in", 0.0);
		AnimatePanel($( "#LootGold_TimeBonus_Value" ), { "transform": "translateX(0px) translateY(0px) scaleX(0.0) scaleY(0.0);", "opacity": "0.0;" }, 1.0, "ease-in", 0.0);
		AnimatePanel($( "#LootGold_TimeBonus_Pic" ), { "transform": "translateX(0px) translateY(0px) scaleX(0.0) scaleY(0.0);", "opacity": "0.0;" }, 1.0, "ease-in", 0.0);
		AnimatePanel($( "#LootGold_Sum_Separator" ), { "transform": "translateX(0px) translateY(0px) scaleX(0.0) scaleY(0.0);", "opacity": "0.0;" }, 1.0, "ease-in", 0.0);
		AnimatePanel($( "#LootGold_Sum_Value" ), { "transform": "translateX(0px) translateY(0px) scaleX(0.0) scaleY(0.0);", "opacity": "0.0;" }, 1.0, "ease-in", 0.0);
		AnimatePanel($( "#LootGold_Sum_Pic" ), { "transform": "translateX(0px) translateY(0px) scaleX(0.0) scaleY(0.0);", "opacity": "0.0;" }, 1.0, "ease-in", 0.0);
	});

}

(function () {
  GameEvents.Subscribe( "loot_gold", Loot_Gold );
})();



AnimatePanel($( "#LootLevel_Round_Txt" ), { "transform": "translateX(0px) translateY(0px) scaleX(0.0) scaleY(0.0);", "opacity": "0.0;" }, 0.0, "ease-in", 0.0);
AnimatePanel($( "#LootLevel_Round_Value" ), { "transform": "translateX(0px) translateY(0px) scaleX(0.0) scaleY(0.0);", "opacity": "0.0;" }, 0.0, "ease-in", 0.0);
AnimatePanel($( "#LootLevel_Round_Pic" ), { "transform": "translateX(0px) translateY(0px) scaleX(0.0) scaleY(0.0);", "opacity": "0.0;" }, 0.0, "ease-in", 0.0);

//Loot_Level( { round_level: 4, duration: 10 } )

function Loot_Level( table ) {

	var LootLevel_Round_Value = $( "#LootLevel_Round_Value" );
	LootLevel_Round_Value.text = $.Localize( "+" + Math.floor( table.round_level ) );

	$.Schedule(0.2, function() {
		AnimatePanel($( "#LootLevel_Round_Txt" ), { "transform": "translateX(0px) translateY(0px) scaleX(1.0) scaleY(1.0);", "opacity": "1.0;" }, 0.3, "ease-in", 0.0);
	});

	$.Schedule(0.4, function() {
		AnimatePanel($( "#LootLevel_Round_Pic" ), { "transform": "translateX(0px) translateY(0px) scaleX(1.0) scaleY(1.0);", "opacity": "1.0;" }, 0.3, "ease-in", 0.0);
	});

	$.Schedule(0.6, function() {
		AnimatePanel($( "#LootLevel_Round_Value" ), { "transform": "translateX(0px) translateY(0px) scaleX(1.0) scaleY(1.0);", "opacity": "1.0;" }, 0.3, "ease-in", 0.0);
	});

	$.Schedule(table.duration, function() {
		AnimatePanel($( "#LootLevel_Round_Txt" ), { "transform": "translateX(0px) translateY(0px) scaleX(0.0) scaleY(0.0);", "opacity": "0.0;" }, 1.0, "ease-in", 0.0);
		AnimatePanel($( "#LootLevel_Round_Value" ), { "transform": "translateX(0px) translateY(0px) scaleX(0.0) scaleY(0.0);", "opacity": "0.0;" }, 1.0, "ease-in", 0.0);
		AnimatePanel($( "#LootLevel_Round_Pic" ), { "transform": "translateX(0px) translateY(0px) scaleX(0.0) scaleY(0.0);", "opacity": "0.0;" }, 1.0, "ease-in", 0.0);
	});

}

(function () {
  GameEvents.Subscribe( "loot_level", Loot_Level );
})();

*/

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
