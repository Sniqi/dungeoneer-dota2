"use strict"

var Retry = false;
var OrigText;

DisableButtonRetryFight()

// Tooltip Show
function ButtonRetryFightMouseover(){
	var ButtonRetryFight = $( "#ButtonRetryFight");
	$.DispatchEvent( "DOTAShowTextTooltip", ButtonRetryFight, "Caution! After confirming and passing the vote ends the fight immediately." );
}

// Tooltip Hide
function ButtonRetryFightMouseout(){
	var ButtonRetryFight = $( "#ButtonRetryFight");
	$.DispatchEvent( "DOTAHideTextTooltip", ButtonRetryFight );
}

function ButtonRetryFight(){
	var ButtonRetryFightText = $( "#ButtonRetryFightText");
	var ButtonRetryFight = $( "#ButtonRetryFight");

	if (Retry) {
		Retry = false;
		
		GameEvents.SendCustomGameEventToServer( "retryfight", {} );

		ButtonRetryFightText.text=OrigText;
		DisableButtonRetryFight()
	} else {
		Retry = true;
		OrigText = ButtonRetryFightText.text;
		ButtonRetryFightText.text="Confirm 3";
		ButtonRetryFightText.style.color = "yellow;";
		
		$.Schedule(1, function()
		{
			if (Retry) {
				ButtonRetryFightText.text="Confirm 2";
			}
			else
			{
				return;
			}
		});
		
		$.Schedule(2, function()
		{
			if (Retry) {
				ButtonRetryFightText.text="Confirm 1";
			}
			else
			{
				return;
			}
		});
		
		$.Schedule(3, function()
		{
			if (Retry) {
				var ButtonRetryFight = $( "#ButtonRetryFight");
				ButtonRetryFight.onactivate="ButtonRetryFight()";
				ButtonRetryFightText.style.color = "white;";
				ButtonRetryFightText.text=OrigText;
				Retry = false;
			}
			else
			{
				return;
			}
		});
	}

}

function EnableButtonRetryFight(){
	var ButtonRetryFightText = $( "#ButtonRetryFightText");
	var ButtonRetryFight = $( "#ButtonRetryFight");
	
	ButtonRetryFightText.style.color = "white;";
	ButtonRetryFight.enabled = true;
}

function DisableButtonRetryFight(){
	var ButtonRetryFightText = $( "#ButtonRetryFightText");
	var ButtonRetryFight = $( "#ButtonRetryFight");
	
	ButtonRetryFightText.style.color = "grey;";
	ButtonRetryFight.enabled = false;
}

(function () {
  GameEvents.Subscribe( "enable_retryfight", EnableButtonRetryFight );
})();

(function () {
  GameEvents.Subscribe( "disable_retryfight", DisableButtonRetryFight );
})();
