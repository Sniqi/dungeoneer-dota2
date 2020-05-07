"use strict";

(function () {
  GameEvents.Subscribe( "show_boss_banner", ShowBossBanner );
})();

//ShowBossBanner( {bossName: "a_mighty_boar", bossNameReadable: "A Mighty Boar"} );
//ShowBossBanner( {bossName: "demonic_warrior", bossNameReadable: "Demonic Warrior"} );
//ShowBossBanner( {bossName: "scroll_collector", bossNameReadable: "Scroll Collector"} );
//ShowBossBanner( {bossName: "ancient_siege_engine", bossNameReadable: "Ancient Siege Engine"} );
//ShowBossBanner( {bossName: "wind_harpy", bossNameReadable: "Wind Harpy"} );
//ShowBossBanner( {bossName: "ferocious_lava_elemental", bossNameReadable: "Ferocious Lava Elemental"} );
//ShowBossBanner( {bossName: "iron_claw", bossNameReadable: "Iron Claw"} );
//ShowBossBanner( {bossName: "drono_red_dragonkin_commander", bossNameReadable: "Drono, Red Dragonkin Commander"} );
 
function ShowBossBanner(data) {

	var bossName = data.bossName;
	var bossNameReadable = data.bossNameReadable;

	var panel = $.CreatePanel('Panel', $('#Wrapper'), '');
	panel.BLoadLayoutSnippet("Banner");

	var pic = "file://{resources}/images/custom_game/boss_banner/banner1.png";
	panel.FindChildTraverse('BannerImage').SetImage(pic);

	panel.FindChildTraverse('BannerText').text = bossNameReadable;

	panel.BCreateChildren("<DOTAScenePanel id=\"BannerScene\" map=\"banner_background_" + bossName + "\" camera=\"camera1\" renderdeferred=\"false\" particleonly=\"false\" />");

	AnimatePanel($( "#BannerText" ), { "transform": "translateX(500px) translateY(0px) scaleX(2.0) scaleY(2.0) rotateZ( 0deg ) rotateX( 90deg );", "opacity": "0.0;" }, 0.0, "linear", 0.0);
	AnimatePanel($( "#BannerImage" ), { "transform": "translateX(0px) translateY(0px) scaleX(0.0) scaleY(0.0);", "opacity": "0.0;" }, 0.0, "linear", 0.0);
	AnimatePanel($( "#BannerScene" ), { "transform": "translateX(-500px) translateY(0px) scaleX(0.5) scaleY(0.5);", "opacity": "0.0;" }, 0.0, "linear", 0.0);

	var time1 = 2.0;
	AnimatePanel($( "#BannerText" ), { "transform": "translateX(0px) translateY(0px) scaleX(1.0) scaleY(1.0) rotateZ( 3deg ) rotateX( 5deg );", "opacity": "1.0;" }, time1, "ease-in", 0.01);
	AnimatePanel($( "#BannerImage" ), { "transform": "translateX(0px) translateY(0px) scaleX(1.0) scaleY(1.0);", "opacity": "1.0;" }, time1, "ease-in", 0.01);
	AnimatePanel($( "#BannerScene" ), { "transform": "translateX(0px) translateY(0px) scaleX(1.0) scaleY(1.0);", "opacity": "1.0;" }, time1, "ease-in", 0.01);

	var time2 = 6.0;
	$.Schedule(time1, function()
	{
		//$.DispatchEvent("DOTAGlobalSceneFireEntityInput", "BannerScene", "unit", "SetAnimation", "mighty_boar_idle_alt_b");
		AnimatePanel($( "#BannerText" ), { "transform": "translateX(3px) translateY(-3px) scaleX(1.03) scaleY(1.03) rotateZ( 3deg ) rotateX( 0deg );", "opacity": "1.0;" }, time2, "linear", 0.0);
		AnimatePanel($( "#BannerImage" ), { "transform": "translateX(-3px) translateY(3px) scaleX(1.0) scaleY(0.97);", "opacity": "1.0;" }, time2, "linear", 0.0);
		AnimatePanel($( "#BannerScene" ), { "transform": "translateX(3px) translateY(-3px) scaleX(1.0) scaleY(1.03);", "opacity": "1.0;" }, time2, "linear", 0.0);
	});

	$.Schedule(time2, function()
	{
		AnimatePanel($( "#BannerText" ), { "transform": "translateX(0px) translateY(0px) scaleX(0.0) scaleY(0.0) rotateZ( 3deg ) rotateX( 5deg );", "opacity": "0.0;" }, time1, "ease-in", 0.01);
		AnimatePanel($( "#BannerImage" ), { "transform": "translateX(0px) translateY(0px) scaleX(0.0) scaleY(0.0);", "opacity": "0.0;" }, time1, "ease-in", 0.01);
		AnimatePanel($( "#BannerScene" ), { "transform": "translateX(0px) translateY(0px) scaleX(0.0) scaleY(0.0);", "opacity": "0.0;" }, time1, "ease-in", 0.01);
	});

	$.Schedule(8.0, function()
	{
		panel.DeleteAsync(0);
	});
}


(function () {
  GameEvents.Subscribe( "show_arena_banner", ShowArenaBanner );
})();


function ShowArenaBanner(data) {

	var arenaName = data.arenaName;
	var arenaNameReadable = data.arenaNameReadable;

	var panel = $.CreatePanel('Panel', $('#Wrapper'), '');
	panel.BLoadLayoutSnippet("BannerArena");

	var pic = "file://{resources}/images/custom_game/boss_banner/banner2.png";
	panel.FindChildTraverse('BannerArenaImage').SetImage(pic);

	panel.FindChildTraverse('BannerArenaText').text = arenaNameReadable;

	AnimatePanel($( "#BannerArenaText" ), { "transform": "translateX(250px) translateY(500px) scaleX(2.0) scaleY(2.0) rotateZ( 90deg ) rotateX( 0deg );", "opacity": "0.0;" }, 0.0, "linear", 0.0);
	AnimatePanel($( "#BannerArenaImage" ), { "transform": "translateX(0px) translateY(0px) scaleX(0.0) scaleY(0.0);", "opacity": "0.0;" }, 0.0, "linear", 0.0);

	var time1 = 2.0;
	AnimatePanel($( "#BannerArenaText" ), { "transform": "translateX(0px) translateY(0px) scaleX(1.0) scaleY(1.0) rotateZ( 3deg ) rotateX( 5deg );", "opacity": "1.0;" }, time1, "ease-in", 0.01);
	AnimatePanel($( "#BannerArenaImage" ), { "transform": "translateX(0px) translateY(0px) scaleX(1.0) scaleY(1.0);", "opacity": "1.0;" }, time1, "ease-in", 0.01);

	var time2 = 6.0;
	$.Schedule(time1, function()
	{
		//$.DispatchEvent("DOTAGlobalSceneFireEntityInput", "BannerScene", "unit", "SetAnimation", "mighty_boar_idle_alt_b");
		AnimatePanel($( "#BannerArenaText" ), { "transform": "translateX(-3px) translateY(3px) scaleX(1.03) scaleY(1.03) rotateZ( 1deg ) rotateX( 3deg );", "opacity": "1.0;" }, time2, "linear", 0.0);
		AnimatePanel($( "#BannerArenaImage" ), { "transform": "translateX(3px) translateY(-3px) scaleX(1.0) scaleY(0.97);", "opacity": "1.0;" }, time2, "linear", 0.0);
	});

	$.Schedule(time2, function()
	{
		AnimatePanel($( "#BannerArenaText" ), { "transform": "translateX(0px) translateY(0px) scaleX(0.0) scaleY(0.0) rotateZ( 4deg ) rotateX( 3deg );", "opacity": "0.0;" }, time1, "ease-in", 0.01);
		AnimatePanel($( "#BannerArenaImage" ), { "transform": "translateX(0px) translateY(0px) scaleX(0.0) scaleY(0.0);", "opacity": "0.0;" }, time1, "ease-in", 0.01);
	});

	$.Schedule(8.0, function()
	{
		panel.DeleteAsync(0);
	});
}


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
