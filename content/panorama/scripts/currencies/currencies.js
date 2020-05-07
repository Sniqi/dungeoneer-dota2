"use strict";

var ActiveCurrencies = {};

var paneldebug1;
var paneldebug2;

function AddCurrency(name, name_readable, value)
{
	var panel = $.CreatePanel('Panel', $('#CurrenciesBoxs'), name);
	panel.BLoadLayoutSnippet("CurrenciesBox");

	var pic = "file://{images}/custom_game/misc/" + name + ".png";
	panel.FindChildTraverse('CurrenciesPicture').SetImage(pic);

	panel.FindChildTraverse('CurrenciesTxt').text = name_readable+": "+$.Localize(  Math.floor( value ) );

	AnimatePanel(panel.FindChildTraverse('CurrenciesValueAdjustment'), { "transform": "translateX(0px) translateY(0px) scaleX(0.0) scaleY(0.0);", "opacity": "0.0;" }, 0.0, "ease-in", 0.0);

	ActiveCurrencies[name] = panel;
	return panel;
}

function OnNewCurrency(data)
{
	return AddCurrency(data.name, data.name_readable, data.value);
}

(function () {
  GameEvents.Subscribe( "on_new_currency", OnNewCurrency );
})();

function CurrencyUpdate(data) {
	var CurrenciesValue = ActiveCurrencies[data.name];
	CurrenciesValue.FindChildTraverse('CurrenciesTxt').text = data.name_readable+": "+$.Localize(  Math.floor( data.value ) );

	var CurrenciesValueAdjustment = CurrenciesValue.FindChildTraverse('CurrenciesValueAdjustment');
	
	CurrenciesValueAdjustment.text = $.Localize(  Math.floor( data.diff ) );
	CurrenciesValueAdjustment.style.color = "#ff6751";
	
	if (Math.floor( data.diff ) > 0) {
		CurrenciesValueAdjustment.text = $.Localize(  "+" + Math.floor( data.diff ) );
		CurrenciesValueAdjustment.style.color = "#31e200";
	}
	
	var color = "red";
	if (Math.floor( data.diff ) > 0) {
		color = "green";
	}
	
	var CurrenciesBoxBackground = CurrenciesValue.FindChildTraverse('CurrenciesBoxBackground');
	
	AnimatePanel(CurrenciesBoxBackground, { "background-color": color+";" }, 0.30, "ease-in", 0.0);
	
	$.Schedule(0.40, function()
	{
		AnimatePanel(CurrenciesBoxBackground, { "background-color": "black;" }, 0.30, "ease-out", 0.0);
	});
	
	

	AnimatePanel(CurrenciesValueAdjustment, { "transform": "translateX(0px) translateY(0px) scaleX(0.0) scaleY(0.0);", "opacity": "0.0;" }, 0.0, "ease-in", 0.0);

	AnimatePanel(CurrenciesValueAdjustment, { "transform": "scaleX(1.0) scaleY(1.0);", "opacity": "1.0;" }, 0.75, "ease-in", 0.0);
	$.Schedule(2, function()
	{
		AnimatePanel(CurrenciesValueAdjustment, { "transform": "translateX(0px) translateY(30px) scaleX(0.5) scaleY(0.5);", "opacity": "0.0;" }, 1.0, "ease-in", 0.0);
	});

}

(function () {
  GameEvents.Subscribe( "currency_update", CurrencyUpdate );
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
	paneldebug1 = OnNewCurrency({ name: "artifact", name_readable: "Artifact Fragments", value: "100"});
	paneldebug2 = OnNewCurrency({ name: "glyph", name_readable: "Glyph Particles", value: "500"});
	
	$.Schedule(60, function()
	{
		paneldebug1.DeleteAsync(0);
		paneldebug2.DeleteAsync(0);
	});

}
