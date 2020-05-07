"use strict";

var ActiveChecklist = {};

var paneldebug1;
var paneldebug2;

function AddChecklistItem(name, descr)
{
	var panel = $.CreatePanel('Panel', $('#ChecklistBoxs'), name);
	panel.BLoadLayoutSnippet("ChecklistBox");

	var pic = "file://{images}/custom_game/misc/" + name + ".png";
	panel.FindChildTraverse('ChecklistPicture').SetImage(pic);

	panel.FindChildTraverse('ChecklistTxt').text = descr;

	AnimatePanel(panel.FindChildTraverse('ChecklistValueAdjustment'), { "transform": "translateX(0px) translateY(0px) scaleX(0.0) scaleY(0.0);", "opacity": "0.0;" }, 0.0, "ease-in", 0.0);

	AnimatePanel(panel, { "transform": "translateX(-500px) translateY(0px);", "opacity": "0.5;" }, 0.0, "ease-in", 0.0);

	AnimatePanel(panel, { "transform": "translateX(0px) translateY(0px);", "opacity": "1.0;" }, 1.25, "ease-in", 1.0);

	ActiveChecklist[name] = panel;
	return panel;
}

function OnNewChecklistItem(data)
{
	return AddChecklistItem(data.name, data.descr);
}

(function () {
  GameEvents.Subscribe( "on_new_checklist_item", OnNewChecklistItem );
})();

function ChecklistItemUpdate(data) {
	var ChecklistValue = ActiveChecklist[data.name];
	ChecklistValue.FindChildTraverse('ChecklistTxt').text = data.descr;

	var updatetext;
	var txt_color_highlight;
	var txt_color_end;
	var color_highlight;
	var color_end;
	var opacity_highlight;
	var opacity_end;
	var pic;
	var show_pic;

	if (data.updatetype == "in_progress")
	{
		updatetext 			= "";
		txt_color_highlight = "#ffffff";
		txt_color_end 		= "#ffdb26";
		color_highlight 	= "#ffec70";
		color_end 			= "#000000";
		opacity_highlight	= "1.0";
		opacity_end			= "0.8";
		pic 				= "";
		show_pic			= false;
	}

	if (data.updatetype == "done")
	{
		updatetext 			= "done!";
		txt_color_highlight = "#ffffff";
		txt_color_end 		= "#ffffff";
		color_highlight 	= "#31e200";
		color_end 			= "#1e6e09";
		opacity_highlight	= "1.0";
		opacity_end			= "0.5";
		pic 				= "file://{images}/custom_game/misc/checkmark.png";
		show_pic			= true;
	}

	var ChecklistValueAdjustment = ChecklistValue.FindChildTraverse('ChecklistValueAdjustment');

	ChecklistValueAdjustment.text = updatetext;
	ChecklistValueAdjustment.style.color = color_highlight;

	var ChecklistTxt = ChecklistValue.FindChildTraverse('ChecklistTxt');
	var ChecklistBoxBackground = ChecklistValue.FindChildTraverse('ChecklistBoxBackground');
	
	AnimatePanel(ChecklistTxt, { "color": txt_color_highlight+";" }, 0.0, "ease-in", 0.0);
	AnimatePanel(ChecklistBoxBackground, { "background-color": color_highlight+";", "opacity": opacity_highlight+";" }, 0.0, "ease-in", 0.0);
	
	$.Schedule(0.40, function()
	{
		AnimatePanel(ChecklistTxt, { "color": txt_color_end+";" }, 0.75, "ease-in", 0.0);
		AnimatePanel(ChecklistBoxBackground, { "background-color": color_end+";", "opacity": opacity_end+";" }, 0.75, "ease-out", 0.0);
	});

	if (show_pic)
	{
		var ChecklistCheckmarkPicture = ChecklistValue.FindChildTraverse('ChecklistCheckmarkPicture');

		ChecklistValue.FindChildTraverse('ChecklistCheckmarkPicture').SetImage(pic);

		AnimatePanel(ChecklistCheckmarkPicture, { "transform": "scaleX(0.0) scaleY(0.0);", "opacity": "0.0;" }, 0.0, "ease-in", 0.0);

		AnimatePanel(ChecklistCheckmarkPicture, { "transform": "scaleX(1.0) scaleY(1.0);", "opacity": "2.0;" }, 0.75, "ease-in", 0.0);
	}
}

(function () {
  GameEvents.Subscribe( "checklist_item_update", ChecklistItemUpdate );
})();

function ChecklistItemRemove(data) {
	var panel = ActiveChecklist[data.name];

	AnimatePanel(panel, { "transform": "translateX(-500px) translateY(0px);", "opacity": "0.5;" }, 1.25, "ease-in", 1.0);
	
	$.Schedule(2.25, function()
	{
		ActiveChecklist[data.name].DeleteAsync(0);
	});
}

(function () {
  GameEvents.Subscribe( "checklist_item_remove", ChecklistItemRemove );
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
	paneldebug1 = OnNewChecklistItem({ name: "artifact", name_readable: "Artifact Fragments", value: "100"});
	paneldebug2 = OnNewChecklistItem({ name: "glyph", name_readable: "Glyph Particles", value: "500"});
	
	$.Schedule(60, function()
	{
		paneldebug1.DeleteAsync(0);
		paneldebug2.DeleteAsync(0);
	});

}
