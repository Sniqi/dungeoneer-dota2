"use strict";

function Timer( table ) {

	var Timer_Txt = $( "#Timer_Txt" );
	Timer_Txt.text = $.Localize( table.txt );

	var Timer_Value = $( "#Timer_Value" );
	Timer_Value.text = $.Localize( table.time );

	if ( table.txt == "Fight Countdown:" && table.time == "00:25" ) {
		Timer_Value.style.color = "#ffbe00;";
	}
	else if ( table.txt == "Fight Countdown:" && table.time == "00:10" ) {
		Timer_Value.style.color = "#ff2222;";
	}
}

(function () {
  GameEvents.Subscribe( "timer", Timer );
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
