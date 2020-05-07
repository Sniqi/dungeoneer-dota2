"use strict";

//$.Msg();

OnChangeGamePhaseSubMode_ClassicPicker( {phase: "no-pick"} )

var paneldebug1;
var paneldebug2;
var paneldebug3;
var paneldebug4;
var paneldebug5;

var Difficulty = 10;
var Difficulty_Minimum = 5;
var Casual = false;
var Endless = false;

$("#OtherPlayersText").visible = false;
$("#OtherPlayersText").enable = false;
$("#OtherPlayersText").hittest = false;
$("#OtherPlayersText").hittestchildren = false;


function ButtonLockActivate()
{
	GameEvents.SendCustomGameEventToServer( "gamemode_classicsubmode_lock", { playerID: Players.GetLocalPlayer() } );
}

function DifficultyColor(Difficulty)
{
	var color = "";

	if (Difficulty >= 5 && Difficulty < 8)
	{
		color = "#00fbff;";
	}
	if (Difficulty >= 8 && Difficulty < 10)
	{
		color = "#00ff00;";
	}
	if (Difficulty >= 10 && Difficulty < 11)
	{
		color = "#ffffff;";
	}
	if (Difficulty >= 11 && Difficulty < 12)
	{
		color = "#fffb00;";
	}
	if (Difficulty >= 12 && Difficulty < 14)
	{
		color = "#ff9500;";
	}
	if (Difficulty >= 14)
	{
		color = "#ff0000;";
	}

	return color;
}

function ButtonIncreaseDifficulty()
{
	Difficulty += 1;
	$("#DifficultyText").text = String(Difficulty / 10);

	if (Difficulty == Difficulty_Minimum + 1)
	{
		$("#ButtonDecreaseDifficultyText").style.color = "white;";
		$("#ButtonDecreaseDifficulty").enabled = true;
	}

	$("#DifficultyText").style.color = DifficultyColor(Difficulty);

	GameEvents.SendCustomGameEventToServer( "gamemode_classicsubmode_difficulty", { playerID: Players.GetLocalPlayer(), difficulty: Difficulty } );
}

function ButtonDecreaseDifficulty()
{
	Difficulty -= 1;
	$("#DifficultyText").text = String(Difficulty / 10);

	if (Difficulty == Difficulty_Minimum)
	{
		$("#ButtonDecreaseDifficultyText").style.color = "grey;";
		$("#ButtonDecreaseDifficulty").enabled = false;
	}

	$("#DifficultyText").style.color = DifficultyColor(Difficulty);

	GameEvents.SendCustomGameEventToServer( "gamemode_classicsubmode_difficulty", { playerID: Players.GetLocalPlayer(), difficulty: Difficulty } );
}

function ToggleCasualShowTooltip()
{
	$.DispatchEvent( "DOTAShowTitleTextTooltip", $('#ToggleCasual'), "Casual Mode", "Recommended for <font color='#16ff77'><b>Rookie</b></font> Players!<br><br>Grants infinite amount of retries for Bosses, but also lowers the Score you can reach drastically" );
}

function ToggleEndlessShowTooltip()
{
	$.DispatchEvent( "DOTAShowTitleTextTooltip", $('#ToggleEndless'), "Endless Mode", "Defeat as many encounters as you can.<br><br>Note: This mode uses a separate leaderboard." );
}

function ToggleCasualHideTooltip()
{
	$.DispatchEvent( "DOTAHideTitleTextTooltip", $('#ToggleCasual') );
}

function ToggleEndlessHideTooltip()
{
	$.DispatchEvent( "DOTAHideTitleTextTooltip", $('#ToggleEndless') );
}

function ToggleCasual()
{
	Casual = !Casual;
	GameEvents.SendCustomGameEventToServer( "gamemode_classicsubmode_casualmode", { playerID: Players.GetLocalPlayer(), active: Casual } );
}

function ToggleEndless()
{
	Endless = !Endless;
	GameEvents.SendCustomGameEventToServer( "gamemode_classicsubmode_endlessmode", { playerID: Players.GetLocalPlayer(), active: Endless } );
}

function OnUpdateSubMode_ClassicPickerLineSubMode_Classic(data)
{
	// Adjust old vote
	if (data.oldname != null)
	{
		var panel = SubMode_ClassicPickersSubMode_Classic[data.oldname];
		
		panel.FindChildTraverse('SubMode_ClassicLevelText').text = data.oldvotes;
		if (data.oldvotes == 0)
			panel.FindChildTraverse('SubMode_ClassicLevelText').style.color = "#ff4444;";
		else
			panel.FindChildTraverse('SubMode_ClassicLevelText').style.color = "#44ff44;";
	}
	else
	{
		$("#ButtonLockText").style.color = "white;";
		$("#ButtonLock").enabled = true;
	}
	
	// Adjust new vote
	var panel = SubMode_ClassicPickersSubMode_Classic[data.name];
	
	panel.FindChildTraverse('SubMode_ClassicLevelText').text = data.votes;
	if (data.votes == 0)
		panel.FindChildTraverse('SubMode_ClassicLevelText').style.color = "#ff4444;";
	else
		panel.FindChildTraverse('SubMode_ClassicLevelText').style.color = "#44ff44;";
	
}

function OnUpdateSubMode_ClassicTimer(data)
{
	$("#Timer").text = String(data.time) + "s";
}

function OnChangeGamePhaseSubMode_ClassicPicker(data)
{
	if (data.phase == "pick")
	{
		$.GetContextPanel().visible = true;
		$.GetContextPanel().enabled = true;
		$.GetContextPanel().hittest = true;

		["#Background","#SubMode_ClassicCaption","#SubMode_Classics","#SubMode_ClassicButtons","#ToggleCasual",
			"#ToggleCasualText","#ToggleEndless","#ToggleEndlessText","#DifficultyDescriptionText","#DifficultyText",
			"#ButtonIncreaseDifficulty","#ButtonIncreaseDifficultyText","#ButtonDecreaseDifficulty",
			"#ButtonDecreaseDifficultyText","#Timer","#ButtonLockText","#Help"].forEach (ShowElement);

			["#ButtonLock"].forEach (ShowElement);
			/*
		$.Schedule(3.0, function()
		{
			["#ButtonLock"].forEach (ShowElement);
		});
		*/
	}
	else
	{
		$.GetContextPanel().visible = false;
		$.GetContextPanel().enabled = false;
		$.GetContextPanel().hittest = false;

		["#Background","#SubMode_ClassicCaption","#SubMode_Classics","#SubMode_ClassicButtons","#ToggleCasual",
			"#ToggleCasualText","#ToggleEndless","#ToggleEndlessText","#DifficultyDescriptionText","#DifficultyText",
			"#ButtonIncreaseDifficulty","#ButtonIncreaseDifficultyText","#ButtonDecreaseDifficulty",
			"#ButtonDecreaseDifficultyText","#Timer","#ButtonLock","#ButtonLockText","#Help"].forEach (HideElement);
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

function SubModeClassicNonHost() {
	["#ToggleCasual","#ToggleEndless","#ButtonIncreaseDifficulty","#ButtonDecreaseDifficulty","#ButtonLock"].forEach (DisableElement);
	
	$("#ToggleCasualText").style.color = "grey;";
	$("#ToggleEndlessText").style.color = "grey;";
	$("#ButtonIncreaseDifficultyText").style.color = "grey;";
	$("#ButtonDecreaseDifficultyText").style.color = "grey;";
	$("#ButtonLockText").style.color = "grey;";

	$("#OtherPlayersText").visible = true;
	$("#OtherPlayersText").enable = true;
	$("#OtherPlayersText").hittest = true;
	$("#OtherPlayersText").hittestchildren = true;
}

function DisableElement(elem) {
	$(elem).enable = false;
	$(elem).hittest = false;
	$(elem).hittestchildren = false;
}


function OnUpdateSubMode_Classic_Difficulty(data) {
	$("#DifficultyText").text = parseInt(data.difficulty)/10;
	$("#DifficultyText").style.color = DifficultyColor(data.difficulty);
}

function OnUpdateSubMode_Classic_CasualMode(data) {
	$("#ToggleCasual").checked = parseInt(data.active);
}

function OnUpdateSubMode_Classic_EndlessMode(data) {
	$("#ToggleEndless").checked = parseInt(data.active);
}



(function () {
  GameEvents.Subscribe( "on_update_submode_classic_timer", OnUpdateSubMode_ClassicTimer );
})();

(function () {
  GameEvents.Subscribe( "on_change_game_phase_submode_classicpicker", OnChangeGamePhaseSubMode_ClassicPicker );
})();

(function () {
  GameEvents.Subscribe( "submode_classic_nonhost", SubModeClassicNonHost );
})();

(function () {
  GameEvents.Subscribe( "on_update_submode_classic_difficulty", OnUpdateSubMode_Classic_Difficulty );
})();

(function () {
  GameEvents.Subscribe( "on_update_submode_classic_casualmode", OnUpdateSubMode_Classic_CasualMode );
})();

(function () {
  GameEvents.Subscribe( "on_update_submode_classic_endlessmode", OnUpdateSubMode_Classic_EndlessMode );
})();


function HelpTooltipShow()
{
	var panel = $("#Help");
	var title = "Difficulty Multiplier";
	var descr = "This multiplier can be used to make the game easier or harder. The multiplier may not affect the values 1:1.<br><br>The following are affected by the multiplier:<br>- All <b>score changes</b> (positive and negative)<br>- <b>Health</b> of enemies<br>- <b>Outgoing damage</b> of enemies";
	$.DispatchEvent( "DOTAShowTitleTextTooltip", panel, title, descr );
	//$.DispatchEvent( "UIShowCustomLayoutParametersTooltip", panel, "PerkTooltip", "file://{resources}/layout/custom_game/perks/perks_tooltip.xml", "title="+title+"&type1="+type1+"&type2="+type2+"&level="+level+formatted_descr );

}

function HelpTooltipHide()
{
	var panel = $("#Help");
	$.DispatchEvent( "DOTAHideTitleTextTooltip", panel );
	//$.DispatchEvent( "UIHideCustomLayoutTooltip", "PerkTooltip" );
}


// Debug
//debug();

function debug() {

	paneldebug1 = OnNewSubMode_ClassicPickerLine( { name: "Optional: Choose a Special Mode" } );
	paneldebug2 = OnNewSubMode_ClassicPickerLineSubMode_Classic( { name: "Classic", descr: "Abyssal Portals", pos: "1", votes: "0", color1: "#fbfbfbff", color2: "#c0c0c0c0", gradient: "100" } );
	paneldebug3 = OnNewSubMode_ClassicPickerLineSubMode_Classic( { name: "Casual", descr: "Environmental Impact", pos: "2", votes: "0", color1: "#fbfbfbff", color2: "#c0c0c0c0", gradient: "100" } );
	paneldebug4 = OnNewSubMode_ClassicPickerLineSubMode_Classic( { name: "Endless", descr: "Important Delivery", pos: "3", votes: "0", color1: "#fbfbfbff", color2: "#c0c0c0c0", gradient: "100" } );
	paneldebug5 = OnNewSubMode_ClassicPickerLineSubMode_Classic( { name: "Free", descr: "Ludicrous Auras", pos: "4", votes: "0", color1: "#fbfbfbff", color2: "#c0c0c0c0", gradient: "100" } );
		
	$.Schedule(5, function()
	{
		paneldebug1.DeleteAsync(0);
		paneldebug2.DeleteAsync(0);
		paneldebug3.DeleteAsync(0);
		paneldebug4.DeleteAsync(0);
		paneldebug5.DeleteAsync(0);
	});
}
