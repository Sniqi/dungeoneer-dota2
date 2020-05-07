"use strict";

AnimatePanel($( "#ScoreValueAdjustment" ), { "transform": "translateX(0px) translateY(0px) scaleX(0.0) scaleY(0.0);", "opacity": "0.0;" }, 0.0, "ease-in", 0.0);

function Score( table ) {
	var ScoreValue = $( "#ScoreValue" );
	ScoreValue.text = $.Localize(  Math.floor( table.score ) );
	
	var ScoreValueAdjustment = $( "#ScoreValueAdjustment" );
	
	ScoreValueAdjustment.text = $.Localize(  Math.floor( table.diff ) );
	ScoreValueAdjustment.style.color = "#ff6751";
	
	if (Math.floor( table.diff ) > 0) {
		ScoreValueAdjustment.text = $.Localize(  "+" + Math.floor( table.diff ) );
		ScoreValueAdjustment.style.color = "#31e200";
	}
	
	
	
	var color = "red";
	if (Math.floor( table.diff ) > 0) {
		color = "green";
	}
	
	var ScoreBox = $( "#ScoreBox" );
	
	AnimatePanel(ScoreBox, { "background-color": color+";" }, 0.30, "ease-in", 0.0);
	
	$.Schedule(0.40, function()
	{
		AnimatePanel(ScoreBox, { "background-color": "black;" }, 0.30, "ease-out", 0.0);
	});
	
	

	AnimatePanel(ScoreValueAdjustment, { "transform": "translateX(0px) translateY(0px) scaleX(0.0) scaleY(0.0);", "opacity": "0.0;" }, 0.0, "ease-in", 0.0);

	AnimatePanel(ScoreValueAdjustment, { "transform": "scaleX(1.0) scaleY(1.0);", "opacity": "1.0;" }, 0.75, "ease-in", 0.0);
	$.Schedule(2, function()
	{
		AnimatePanel(ScoreValueAdjustment, { "transform": "translateX(0px) translateY(30px) scaleX(0.5) scaleY(0.5);", "opacity": "0.0;" }, 1.0, "ease-in", 0.0);
	});

}

(function () {
  GameEvents.Subscribe( "score", Score );
})();




function InfoDifficulty( table ) {
	var DifficultyValue = $( "#DifficultyValue" );
	DifficultyValue.text = table.gamemode;//$.Localize(  table.difficulty );
	
	if (table.casual) {
		DifficultyValue.text += " [C]";
		DifficultyValue.style.color = "#b6ff82;";
	}

	if (table.endless) {
		DifficultyValue.text += " [E]";
		DifficultyValue.style.color = "#d5baff;";
	}

	if (table.difficulty == "Free") {
		DifficultyValue.style.color = "#b88aff;";
	}
}

(function () {
  GameEvents.Subscribe( "info_difficulty", InfoDifficulty );
})();




function InfoRound( table ) {
	var RoundTxt = $( "#RoundTxt" );
	var RoundValue = $( "#RoundValue" );
	
	RoundValue.text = table.round;
	
	if ( Number(table.round) > 2 && Number(table.round) < 6 ) {
		RoundTxt.style.color = "#ffe3c6;";
		RoundValue.style.color = "#ffe3c6;";
	}
	if ( Number(table.round) == 6 ) {
		RoundTxt.style.color = "#ffd1c6;";
		RoundValue.style.color = "#ffd1c6;";
	}
}

(function () {
  GameEvents.Subscribe( "info_round", InfoRound );
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
