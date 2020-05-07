function Tutorial(playerID)

	local player = PlayerResource:GetPlayer(playerID)

	local panelName = "Items"
	local title = "Items"
	local tooltip = [[Buy and sell items at the shop.<br>
	The shop is active until the start of a fight.]]

	CustomGameEventManager:Send_ServerToPlayer(player, "on_new_tutorial_tooltip", { panelName=panelName, title=title, tooltip=tooltip } )
----------------------------

	local panelName = "Gold"
	local title = "Gold"
	local tooltip = [[You start with <font color='#ffdd00'>]]..STARTING_GOLD..[[</font> gold.<br>
You can and should spend gold for items.<br>
Get gold by defeating encounters.<br>
An encounter currently grants <font color='#ffdd00'>]]..CalculateGoldLoot(0)..[[</font> gold.]]

	CustomGameEventManager:Send_ServerToPlayer(player, "on_new_tutorial_tooltip", { panelName=panelName, title=title, tooltip=tooltip } )
----------------------------

	local panelName = "Artifacts"
	local title = "Artifacts"
	local tooltip = [[After defeating encounters you can choose to upgrade Artifacts, sell them and buy new ones.<br>
Selling an Artifact only refunds the costs of the <b>current</b> level!<br><br>
Get Artifact Fragments by defeating encounters.<br>
You can empower the gain of Artifact Fragments after defeating an encounter by <font color='#ffdd00'>]]..((EmpowerMultiplier-1)*100)..[[%</font>.<br>
An encounter currently grants <font color='#ffdd00'>]]..CalculateCurrencyLoot("artifact")..[[</font> Artifact Fragments.<br><br>
Each Artifact can be upgraded to a maximum level of <font color='#ffdd00'>]]..PERK_MAX_LEVEL..[[</font>.<br>
Every level grants <font color='#ffdd00'>+]]..(PERK_LEVEL_EFFECTIVENESS*100)..[[%</font> effectiveness.<br><br>
You only can have up to <font color='#ffdd00'>]]..PERK_ACTIVE_MAX["artifact"]..[[</font> Artifact at the same time.]]

	CustomGameEventManager:Send_ServerToPlayer(player, "on_new_tutorial_tooltip", { panelName=panelName, title=title, tooltip=tooltip } )
----------------------------

	local panelName = "Glyphs"
	local title = "Glyphs"
	local tooltip = [[After defeating encounters you can choose to upgrade Glyphs, sell them and buy new ones.<br>
Selling a Glyph only refunds the costs of the <b>current</b> level!<br><br>
Get Glyph Particles by defeating encounters.<br>
You can empower the gain of Glyph Particles after defeating an encounter by <font color='#ffdd00'>]]..((EmpowerMultiplier-1)*100)..[[%</font>.<br>
An encounter currently grants <font color='#ffdd00'>]]..CalculateCurrencyLoot("glyph")..[[</font> Glyph Particles.<br><br>
Each Glyph can be upgraded to a maximum level of <font color='#ffdd00'>]]..PERK_MAX_LEVEL..[[</font>.<br>
Every level grants <font color='#ffdd00'>+]]..(PERK_LEVEL_EFFECTIVENESS*100)..[[%</font> effectiveness.<br><br>
You only can have up to <font color='#ffdd00'>]]..PERK_ACTIVE_MAX["glyph"]..[[</font> Glyphs at the same time.]]

	CustomGameEventManager:Send_ServerToPlayer(player, "on_new_tutorial_tooltip", { panelName=panelName, title=title, tooltip=tooltip } )
----------------------------

	local panelName = "DefeatedBosses"
	local title = "Defeated bosses"
	local tooltip = [[Defeated encounters grant <font color='#ffd800'>Gold</font>, <font color='#faf2be'>Artifact Fragments</font>
, <font color='#fabeea'>Glyph Particles</font>, <font color='#00d0ff'>Hero Levels</font> and <font color='#b5ff6b'>Score</font>.<br><br>

Gold: <font color='#ffd800'>+]]..CalculateGoldLoot(0)..[[</font><br>
Artifact Fragments: <font color='#faf2be'>+]]..CalculateCurrencyLoot("artifact")..[[</font><br>
Glyph Particles: <font color='#fabeea'>+]]..CalculateCurrencyLoot("glyph")..[[</font><br>
Hero Levels: <font color='#00d0ff'>+]]..(LootXP[ GameMode_Active or "Classic" ]/100)..[[</font><br>
Map score: <font color='#b5ff6b'>+]]..ScoreData_Encounter[ GameMode_Active or "Classic" ]..[[</font>]]
	
	CustomGameEventManager:Send_ServerToPlayer(player, "on_new_tutorial_tooltip", { panelName=panelName, title=title, tooltip=tooltip } )

----------------------------
	local panelName = "MapScore"
	local title = "Map score"
	local tooltip = [[Map score is influenced by encounter kills, encounter retries (after failing), hero deaths and elapsed time.<br><br>

Encounter kills: <font color='#b5ff6b'>+]]..ScoreData_Encounter[ GameMode_Active or "Classic" ]..[[</font> per kill<br>
Encounter retry: <font color='#ff866b'>-]]..ExtraLifesCost[ GameMode_Active or "Classic" ]..[[</font> per retry<br>
Hero death: <font color='#ff866b'>]]..ScoreData_Death[ GameMode_Active or "Classic" ]..[[</font> per death<br>
Elapsed time: <font color='#ff866b'>]]..ScoreData_Time[ GameMode_Active or "Classic" ]..[[</font> every <font color='#ffdd00'>]]..ScoreTimeCycle..[[</font> seconds<br><br>

Finished or surrendered games will appear on the official leaderboard:<br>
<b>https://dungeoneer-dota2.com</b>]]

	CustomGameEventManager:Send_ServerToPlayer(player, "on_new_tutorial_tooltip", { panelName=panelName, title=title, tooltip=tooltip } )

----------------------------
	local panelName = "HeroDeaths"
	local title = "Hero deaths"
	local tooltip = [[Hero death will reduce your map score by <font color='#ff866b'>]]..ScoreData_Death[ GameMode_Active or "Classic" ]..[[</font>.]]
	
	CustomGameEventManager:Send_ServerToPlayer(player, "on_new_tutorial_tooltip", { panelName=panelName, title=title, tooltip=tooltip } )

----------------------------
	local panelName = "Time"
	local title = "Time"
	local tooltip = [[Every <font color='#ffdd00'>]]..ScoreTimeCycle..[[</font> seconds your map score is reduced by <font color='#ff866b'>]]..ScoreData_Time[ GameMode_Active or "Classic" ]..[[</font>.]]
	
	CustomGameEventManager:Send_ServerToPlayer(player, "on_new_tutorial_tooltip", { panelName=panelName, title=title, tooltip=tooltip } )

----------------------------
	local panelName = "Retries"
	local title = "Retries"
	local tooltip = [[Every time you want to retry a boss, you have to pay <font color='#ff866b'>]]..ExtraLifesCost[ GameMode_Active or "Classic" ]..[[</font> Score to continue.]]
	
	CustomGameEventManager:Send_ServerToPlayer(player, "on_new_tutorial_tooltip", { panelName=panelName, title=title, tooltip=tooltip } )
end