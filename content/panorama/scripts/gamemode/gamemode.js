"use strict";

//$.Msg();   

OnChangeGamePhaseGameModePicker( {phase: "pick"} )

var GameModePickers = {};
var GameModePickersCount = 0;
var GameModePickersGameMode = {};
var GameModePickersGameModeCount = 0;

var MarginTop = 25;
var MarginLeft = 160;

var paneldebug1;
var paneldebug2;
var paneldebug3;
var paneldebug4;
var paneldebug5;

$("#ButtonLockText").style.color = "grey;";
$("#ButtonLock").enabled = false;
//$("#ButtonSkipText").style.color = "white;";
//$("#ButtonSkip").enabled = true;
$( "#ButtonSkip").visible = false;
$( "#ButtonSkip").enable = false;
$( "#ButtonSkip").hittest = false;
$( "#ButtonSkip").hittestchildren = false;

function ButtonLockActivate()
{
	var key;
	for (key in GameModePickersGameMode) {
		if (GameModePickersGameMode.hasOwnProperty(key)) {

			var panel = GameModePickersGameMode[key];
			
			$.GetContextPanel().enabled = false;
			panel.FindChildTraverse('GameModePicture').style.backgroundColor = "gradient( linear, 0% 100%, 0% 0%, from( #232323 ), to( #8c8c8c ) );";
		}
	}
	
	$("#ButtonLockText").style.color = "yellow;";
	$("#ButtonLock").enabled = false;
//	$("#ButtonSkipText").style.color = "grey;";
//	$("#ButtonSkip").enabled = false;

	GameEvents.SendCustomGameEventToServer( "gamemode_lock", { playerID: Players.GetLocalPlayer() } );
}

function ButtonSkipActivate()
{
	var key;
	for (key in GameModePickersGameMode) {
		if (GameModePickersGameMode.hasOwnProperty(key)) {

			var panel = GameModePickersGameMode[key];
			
			$.GetContextPanel().enabled = false;
			panel.FindChildTraverse('GameModePicture').style.backgroundColor = "gradient( linear, 0% 100%, 0% 0%, from( #232323 ), to( #8c8c8c ) );";
		}
	}

	$("#ButtonLockText").style.color = "grey;";
	$("#ButtonLock").enabled = false;
	//$("#ButtonSkipText").style.color = "yellow;";
	//$("#ButtonSkip").enabled = false;
	
	GameEvents.SendCustomGameEventToServer( "gamemode_skip", { playerID: Players.GetLocalPlayer() } );
}

function AddLine(name)
{
	var panel = $.CreatePanel('Panel', $('#GameModes'), '');
	panel.BLoadLayoutSnippet("GameModePicker");
	
	panel.FindChildTraverse('GameModeListCaption').text = name;

	panel.style.marginTop = (MarginTop) + "px;";
	
	return panel;
}

function AddGameMode(name, descr, pos, votes, color1, color2, gradient, enabled)
{
	var panel = $.CreatePanel('Panel', $('#GameModeButtons'), name);
	panel.BLoadLayoutSnippet("GameModeButton");

	panel.FindChildTraverse('GameModeLevelText').text = votes;
	if (votes == 0)
		panel.FindChildTraverse('GameModeLevelText').style.color = "#ff4444;";
	else
		panel.FindChildTraverse('GameModeLevelText').style.color = "#44ff44;";

	var pic = "file://{images}/custom_game/gamemode/" + name + ".png";
	panel.FindChildTraverse('GameModePicture').SetImage(pic);
	
	panel.FindChildTraverse('GameModePicture').style.backgroundColor = "gradient( linear, 0% " + gradient + "%, 0% 0%, from( " + color1 + " ), to( " + color2 + " ) );";

	// Left Click
	if (enabled) {
		panel.SetPanelEvent("onmouseactivate", function(){
			GameEvents.SendCustomGameEventToServer( "gamemode_upvote", { playerID: Players.GetLocalPlayer(), name: name } );
		})
	}
	
	// Tooltip Show
	panel.SetPanelEvent("onmouseover", function(){
		$.DispatchEvent( "DOTAShowTitleTextTooltip", panel, name, descr );
	})
	
	// Tooltip Hide
	panel.SetPanelEvent("onmouseout", function(){
		$.DispatchEvent( "DOTAHideTitleTextTooltip", panel );
	})
	
	panel.style.marginTop = (MarginTop) + "px;";
	panel.style.marginLeft = (MarginLeft*(pos-1)) + "px;";
	
	return panel;
}

function OnNewGameModePickerLine(data)
{
	var GameModePicker = AddLine(data.name);
	GameModePickers[GameModePickersCount] = GameModePicker;
	GameModePickersCount = GameModePickersCount + 1;
	
	return GameModePicker;
}

function OnNewGameModePickerLineGameMode(data)
{
	var GameModePickerGameMode = AddGameMode(data.name, data.descr, data.pos, data.votes, data.color1, data.color2, data.gradient, data.enabled);
	GameModePickersGameMode[data.name] = GameModePickerGameMode;
	
	return GameModePickerGameMode;
}

function OnUpdateGameModePickerLineGameMode(data)
{
	// Adjust old vote
	if (data.oldname != null)
	{
		var panel = GameModePickersGameMode[data.oldname];
		
		panel.FindChildTraverse('GameModeLevelText').text = data.oldvotes;
		if (data.oldvotes == 0)
			panel.FindChildTraverse('GameModeLevelText').style.color = "#ff4444;";
		else
			panel.FindChildTraverse('GameModeLevelText').style.color = "#44ff44;";
	}
	else
	{
		$("#ButtonLockText").style.color = "white;";
		$("#ButtonLock").enabled = true;
	}
	
	// Adjust new vote
	var panel = GameModePickersGameMode[data.name];
	
	panel.FindChildTraverse('GameModeLevelText').text = data.votes;
	if (data.votes == 0)
		panel.FindChildTraverse('GameModeLevelText').style.color = "#ff4444;";
	else
		panel.FindChildTraverse('GameModeLevelText').style.color = "#44ff44;";
	
}

function OnUpdateGameModeTimer(data)
{
	$("#Timer").text = String(data.time) + "s";
}

function OnUpdateGameModeSkip(data)
{
	//$("#ButtonSkip").text = "Skip(" + String(data.skipcount) + ")";
}

function OnChangeGamePhaseGameModePicker(data)
{
	if (data.phase == "pick")
	{
		$.GetContextPanel().visible = true;
		$.GetContextPanel().enabled = true;
		$.GetContextPanel().hittest = true;
		
		$( "#Background").visible = true;
		$( "#Background").enable = true;
		$( "#Background").hittest = true;
		$( "#Background").hittestchildren = true;
		
		$( "#GameModes").visible = true;
		$( "#GameModes").enable = true;
		$( "#GameModes").hittest = true;
		$( "#GameModes").hittestchildren = true;
		
		$( "#Timer").visible = true;
		$( "#Timer").enable = true;
		$( "#Timer").hittest = true;
		$( "#Timer").hittestchildren = true;
		
		$( "#ButtonLock").visible = true;
		$( "#ButtonLock").enable = true;
		$( "#ButtonLock").hittest = true;
		$( "#ButtonLock").hittestchildren = true;
		
		//$( "#ButtonSkip").visible = true;
		//$( "#ButtonSkip").enable = true;
		//$( "#ButtonSkip").hittest = true;
		//$( "#ButtonSkip").hittestchildren = true;
		
		GameEvents.SendCustomGameEventToServer( "help_add", { playerID: Players.GetLocalPlayer(), name: "Special Modes"} );
	}
	else
	{
		$.GetContextPanel().visible = false;
		$.GetContextPanel().enabled = false;
		$.GetContextPanel().hittest = false;
		
		$( "#Background").visible = false;
		$( "#Background").enable = false;
		$( "#Background").hittest = false;
		$( "#Background").hittestchildren = false;
		
		$( "#GameModes").visible = false;
		$( "#GameModes").enable = false;
		$( "#GameModes").hittest = false;
		$( "#GameModes").hittestchildren = false;
		
		$( "#Timer").visible = false;
		$( "#Timer").enable = false;
		$( "#Timer").hittest = false;
		$( "#Timer").hittestchildren = false;
		
		$( "#ButtonLock").visible = false;
		$( "#ButtonLock").enable = false;
		$( "#ButtonLock").hittest = false;
		$( "#ButtonLock").hittestchildren = false;
		
		//$( "#ButtonSkip").visible = false;
		//$( "#ButtonSkip").enable = false;
		//$( "#ButtonSkip").hittest = false;
		//$( "#ButtonSkip").hittestchildren = false;
		
		GameEvents.SendCustomGameEventToServer( "help_remove", { playerID: Players.GetLocalPlayer(), name: "Special Modes"} );
	}
}

(function () {
  GameEvents.Subscribe( "on_new_gamemodepicker_line", OnNewGameModePickerLine );
})();

(function () {
  GameEvents.Subscribe( "on_new_gamemodepicker_line_gamemode", OnNewGameModePickerLineGameMode );
})();

(function () {
  GameEvents.Subscribe( "on_update_gamemodepicker_line_gamemode", OnUpdateGameModePickerLineGameMode );
})();

(function () {
  GameEvents.Subscribe( "on_update_gamemode_timer", OnUpdateGameModeTimer );
})();

(function () {
  GameEvents.Subscribe( "on_update_gamemode_skip", OnUpdateGameModeSkip );
})();

(function () {
  GameEvents.Subscribe( "on_change_game_phase_gamemodepicker", OnChangeGamePhaseGameModePicker );
})();

// Debug
//debug();

function debug() {

	paneldebug1 = OnNewGameModePickerLine( { name: "Optional: Choose a Special Mode" } );
	paneldebug2 = OnNewGameModePickerLineGameMode( { name: "Classic", descr: "Abyssal Portals", pos: "1", votes: "0", color1: "#fbfbfbff", color2: "#c0c0c0c0", gradient: "100" } );
	paneldebug3 = OnNewGameModePickerLineGameMode( { name: "Casual", descr: "Environmental Impact", pos: "2", votes: "0", color1: "#fbfbfbff", color2: "#c0c0c0c0", gradient: "100" } );
	paneldebug4 = OnNewGameModePickerLineGameMode( { name: "Endless", descr: "Important Delivery", pos: "3", votes: "0", color1: "#fbfbfbff", color2: "#c0c0c0c0", gradient: "100" } );
	paneldebug5 = OnNewGameModePickerLineGameMode( { name: "Free", descr: "Ludicrous Auras", pos: "4", votes: "0", color1: "#fbfbfbff", color2: "#c0c0c0c0", gradient: "100" } );
		
	$.Schedule(5, function()
	{
		paneldebug1.DeleteAsync(0);
		paneldebug2.DeleteAsync(0);
		paneldebug3.DeleteAsync(0);
		paneldebug4.DeleteAsync(0);
		paneldebug5.DeleteAsync(0);
	});
}
