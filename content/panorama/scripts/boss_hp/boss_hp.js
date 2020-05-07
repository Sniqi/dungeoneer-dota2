"use strict"

var boss_hps = {};
//var selectedBoss = null;

function SetBoss_HpProgress(panel, current)
{
	panel.FindChildTraverse('Boss_HpProgress').text = current + "%";
	
	var background = panel.FindChildTraverse("Background");
	background.style.width = current + "%";
	
	if (current < 50) {
		background.style.backgroundColor = "rgb(255,215,0)";
	}
	
	if (current < 25) {
		background.style.backgroundColor = "rgb(255,140,0)";
	}
	
	if (current < 10) {
		background.style.backgroundColor = "rgb(255,0,0)";
	}
}

function OnNewBoss_Hp(data)
{
	var panel = $.CreatePanel('Panel', $('#Boss_Hps'), '');
	panel.BLoadLayoutSnippet("Boss_Hp");

	panel.FindChildTraverse('Boss_HpDescription').text = $.Localize( "#" + data.name ) + data.name_addition;
	
	/*
	panel.FindChildTraverse('Boss_HpListEntry').SetPanelEvent("onactivate", function(){
		GameEvents.SendCustomGameEventToServer( "on_bossbar_select", { id: data.id, playerID: Players.GetLocalPlayer() } );
	})
	*/

	panel.name = data.name;
	
	panel.tag = data.id;
	boss_hps[data.id] = panel;
}

(function () {
  GameEvents.Subscribe( "on_new_boss_hp", OnNewBoss_Hp );
})();

function OnBoss_HpUpdateProgress(data)
{
	for(var x in boss_hps)
	{
		var boss_hp = boss_hps[x];
		if(boss_hp.tag == data.id)
		{
			SetBoss_HpProgress(boss_hp, data.progress);
			break;
		}
	}
}

(function () {
  GameEvents.Subscribe( "on_update_boss_hp", OnBoss_HpUpdateProgress );
})();

/*
function OnBossSelect(data)
{
	if (data.id != null) {

		if (selectedBoss != data.id) {
			if (selectedBoss != null) {
				var panel = boss_hps[selectedBoss];
				panel.FindChildTraverse('Boss_HpListEntry').style.border = "2px solid black;";
			}
			
			var panel = boss_hps[data.id];
			panel.FindChildTraverse('Boss_HpListEntry').style.border = "2px solid #fffc84;";
			
			selectedBoss = data.id
		}
	}
}

(function () {
  GameEvents.Subscribe( "on_boss_select", OnBossSelect );
})();
*/

function OnBoss_HpRemove(data)
{
	if (boss_hps[data.id] != null) {
		boss_hps[data.id].DeleteAsync(0);
	}
}

(function () {
  GameEvents.Subscribe( "on_remove_boss_hp", OnBoss_HpRemove );
})();

/*
function OnCastAbility(data)
{
	var panel = $.CreatePanel('Panel', $('#Casts'), '');
	panel.BLoadLayoutSnippet("Cast");
	
	panel.FindChildTraverse('CastListEntry').style.marginTop = (data.id * 25).toString() + "px;" ;

	panel.FindChildTraverse('CastAbility').abilityname = data.ability;
	
	panel.FindChildTraverse('CastDescription').text = $.Localize("#DOTA_Tooltip_ability_"+data.ability);
	panel.FindChildTraverse('CastProgress').text = "0.0 / "+data.casttime.toFixed(1).toString();
	
	for(var i=1; i < (data.casttime*10)+1; i++ ) {
		var delay = (i/10).toFixed(1);
		var castTime = 0.1;
		var steps = 86 / data.casttime;
		$.Schedule(delay, function()
		{
			panel.FindChildTraverse('CastBackground').style.width = steps * castTime + "%;";
			
			panel.FindChildTraverse('CastProgress').text = castTime.toFixed(1)+" / "+data.casttime.toFixed(1).toString();
			
			castTime += 0.1;
		});
	}
	
	$.Schedule(data.casttime, function()
	{
		panel.FindChildTraverse('CastListEntry').style.border = "2px solid #343434;" ;
		panel.FindChildTraverse('CastBackground').style.backgroundColor = "#1ccbd8;";
	});
	
	$.Schedule(data.casttime+1.5, function()
	{
		panel.DeleteAsync(0);
	});
	
	return panel;
}

(function () {
  GameEvents.Subscribe( "on_cast_ability", OnCastAbility );
})();
*/

//debug();

// Debug

var paneldebug1;

function debug()
{
	paneldebug1 = OnCastAbility( { ability: "boss4_ability1", casttime: 5.0, id: 0 } );

	$.Schedule(5, function()
	{
		//paneldebug1.DeleteAsync(0);
	});
}

