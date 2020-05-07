"use strict"

ButtonTutorials();
Hint();

function Hint()
{
	var delay = 3.00;
	
	var Panel = $( "#ButtonTutorials");
	$.Schedule(delay+0.50, function()
	{
		Panel.style.border = "2px solid red;";
	});
	$.Schedule(delay+1.00, function()
	{
		Panel.style.border = "2px solid black;";
	});
	$.Schedule(delay+1.50, function()
	{
		Panel.style.border = "2px solid red;";
	});
	$.Schedule(delay+2.00, function()
	{
		Panel.style.border = "2px solid black;";
	});
	$.Schedule(delay+2.50, function()
	{
		Panel.style.border = "2px solid red;";
	});
	$.Schedule(delay+3.00, function()
	{
		Panel.style.border = "2px solid black;";
	});
	$.Schedule(delay+3.50, function()
	{
		Panel.style.border = "2px solid red;";
	});
	$.Schedule(delay+4.00, function()
	{
		Panel.style.border = "2px solid black;";
	});
}

function AddTutorialTooltip(data)
{
	var panelName = data.panelName
	var title = data.title
	var tooltip = data.tooltip
	
	var Panel = $( "#TutorialDescription_" + panelName);

	// Tooltip Show
	Panel.SetPanelEvent("onmouseover", function(){
		$.DispatchEvent( "DOTAShowTitleTextTooltip", Panel, title, tooltip );
	})
	
	// Tooltip Hide
	Panel.SetPanelEvent("onmouseout", function(){
		$.DispatchEvent( "DOTAHideTitleTextTooltip", Panel );
	})
}

function ButtonTutorials(){
	var Panel = $( "#TutorialsPanel");
	var Button = $( "#ButtonTutorials");
	
	if (Panel.visible) {
		Panel.visible = false;
		Panel.enable = false;
		Panel.hittest = false;
		Panel.hittestchildren = false;
		
		Button.style.border = null;
	} else { 
		Panel.visible = true;
		Panel.enable = true;
		Panel.hittest = true;
		Panel.hittestchildren = true;
		
		Button.style.border = "3px solid #fff;";
	}
}

(function () {
  GameEvents.Subscribe( "on_new_tutorial_tooltip", AddTutorialTooltip );
})();

(function () {
  GameEvents.Subscribe( "toogle_tutorial", ButtonTutorials );
})();

