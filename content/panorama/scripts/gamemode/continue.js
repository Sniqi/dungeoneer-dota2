"use strict";

//$.Msg();   

OnShowContinue( {phase: "no-pick"} )

function ButtonContinueActivate()
{
	GameEvents.SendCustomGameEventToServer( "continue_vote", { vote: "continue", playerID: Players.GetLocalPlayer() } );
	OnShowContinue( {phase: "no-pick"} )
}

function ButtonEndActivate()
{
	GameEvents.SendCustomGameEventToServer( "continue_vote", { vote: "surrender", playerID: Players.GetLocalPlayer() } );
	OnShowContinue( {phase: "no-pick"} )
}

function OnUpdateContinueTimer(data)
{
	$("#Timer").text = String(data.time) + "s";
}

function OnShowContinue(data)
{
	var phase = data.phase
	var costs = data.costs

	if (phase == "pick")
	{
		$.GetContextPanel().visible = true;
		$.GetContextPanel().enabledd = true;
		$.GetContextPanel().hittest = true;
		
		$("#ContinuePicker").visible = true;
		$("#ContinuePicker").enabled = true;
		$("#ContinuePicker").hittest = true;
		$("#ContinuePicker").hittestchildren = true;

		$("#ContinueText").visible = true;
		$("#ContinueText").enabled = true;
		$("#ContinueText").hittest = true;
		$("#ContinueText").hittestchildren = true;

		$("#Timer").visible = true;
		$("#Timer").enabled = true;
		$("#Timer").hittest = true;
		$("#Timer").hittestchildren = true;

		$("#ButtonContinue").visible = true;
		$("#ButtonContinue").enabled = true;
		$("#ButtonContinue").hittest = true;
		$("#ButtonContinue").hittestchildren = true;

		$("#ButtonEnd").visible = true;
		$("#ButtonEnd").enabled = true;
		$("#ButtonEnd").hittest = true;
		$("#ButtonEnd").hittestchildren = true;

		if (costs == 0) {
			$("#ContinueText").text = "Continue..?";
			$("#ButtonContinueCostText").text = "(use extra life)";
			$("#ButtonContinueCostText").style.color = "#a4f442;";
		} else if (costs == -1) {
			$("#ContinueText").text = "Game Over";
			$("#ButtonContinueCostText").text = "(not enough points)";
			$("#ButtonContinueCostText").style.color = "#cecece;";
			$("#ButtonContinue").enabled = false;
			$("#ButtonContinue").style.boxShadow = "fill #000000c0 2px 2px 8px 0px;";
		} else {
			$("#ContinueText").text = "Continue..?";
			$("#ButtonContinueCostText").text = "(use " + costs.toString() + " points)";
			$("#ButtonContinueCostText").style.color = "#ff7147;";
		}
	}
	else
	{
		$.GetContextPanel().visible = false;
		$.GetContextPanel().enabledd = false;
		$.GetContextPanel().hittest = false;

		$("#ContinuePicker").visible = false;
		$("#ContinuePicker").enabled = false;
		$("#ContinuePicker").hittest = false;
		$("#ContinuePicker").hittestchildren = false;

		$("#ContinueText").visible = false;
		$("#ContinueText").enabled = false;
		$("#ContinueText").hittest = false;
		$("#ContinueText").hittestchildren = false;

		$("#Timer").visible = false;
		$("#Timer").enabled = false;
		$("#Timer").hittest = false;
		$("#Timer").hittestchildren = false;

		$("#ButtonContinue").visible = false;
		$("#ButtonContinue").enabled = false;
		$("#ButtonContinue").hittest = false;
		$("#ButtonContinue").hittestchildren = false;

		$("#ButtonEnd").visible = false;
		$("#ButtonEnd").enabled = false;
		$("#ButtonEnd").hittest = false;
		$("#ButtonEnd").hittestchildren = false;
	}
}

(function () {
  GameEvents.Subscribe( "on_show_continue", OnShowContinue );
})();

(function () {
  GameEvents.Subscribe( "on_update_continue_timer", OnUpdateContinueTimer );
})();
