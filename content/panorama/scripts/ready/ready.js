"use strict"

var Retry = false;
var OrigText;

DisableButtonReady()

// Tooltip Show
function ButtonReadyMouseover(){
	var ButtonReady = $( "#ButtonReady");
	$.DispatchEvent( "DOTAShowTextTooltip", ButtonReady, "Ready up to begin the fight immediately." );
}

// Tooltip Hide
function ButtonReadyMouseout(){
	var ButtonReady = $( "#ButtonReady");
	$.DispatchEvent( "DOTAHideTextTooltip", ButtonReady );
}

function ButtonReady(){
	GameEvents.SendCustomGameEventToServer( "ready", {} );

	DisableButtonReady()
	
	/*
	var ButtonReadyText = $( "#ButtonReadyText");
	var ButtonReady = $( "#ButtonReady");

	if (Ready) {
		Ready = false;
		
		GameEvents.SendCustomGameEventToServer( "ready", {} );

		ButtonReadyText.text=OrigText;
		DisableButtonReady()
	} else {
		Ready = true;
		OrigText = ButtonReadyText.text;
		ButtonReadyText.text="Confirm 3";
		ButtonReadyText.style.color = "yellow;";
		
		$.Schedule(1, function()
		{
			if (Ready) {
				ButtonReadyText.text="Confirm 2";
			}
			else
			{
				return;
			}
		});
		
		$.Schedule(2, function()
		{
			if (Ready) {
				ButtonReadyText.text="Confirm 1";
			}
			else
			{
				return;
			}
		});
		
		$.Schedule(3, function()
		{
			if (Ready) {
				var ButtonReady = $( "#ButtonReady");
				ButtonReady.onactivate="ButtonReady()";
				ButtonReadyText.style.color = "white;";
				ButtonReadyText.text=OrigText;
				Ready = false;
			}
			else
			{
				return;
			}
		});
	}
*/
}

function EnableButtonReady(){
	var ButtonReadyText = $( "#ButtonReadyText");
	var ButtonReady = $( "#ButtonReady");
	
	ButtonReadyText.style.color = "white;";
	ButtonReadyText.enabled = true;
	ButtonReady.enabled = true;
}

(function () {
  GameEvents.Subscribe( "enable_ready", EnableButtonReady );
})();

function DisableButtonReady(){
	var ButtonReadyText = $( "#ButtonReadyText");
	var ButtonReady = $( "#ButtonReady");
	
	ButtonReadyText.style.color = "grey;";
	ButtonReadyText.enabled = false;
	ButtonReady.enabled = false;
}

(function () {
  GameEvents.Subscribe( "disable_ready", DisableButtonReady );
})();
