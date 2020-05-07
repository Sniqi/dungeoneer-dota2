-- CONSTANTS

local DEBUG_FAST_START = true
local DEBUG_FAST_START_MODE = "Classic"

local GAME_MODES = {}

local descr = ""
descr = descr .. "Recommended for <font color='#ff6816'><b>Expert</b></font> Players only!<br><br>"
descr = descr .. "Defeat 8 pre-defined encounters in total to win. Your team has unlimited extra lifes, but deaths are extremely expensive.<br><br>"
descr = descr .. "Be careful! Bosses are much harder and there might be some additional effects going on during a fight or Encounter abilities have some other specialties.<br><br>"
descr = descr .. "As the Challenger Mode has fixed Encounter rotations, it will change reguarly to new combinations. But you will have enough time to beat the highscore!.<br><br>"
descr = descr .. " Gain <font color='#ffd800'><b>Gold</b></font> and <font color='#00d0ff'><b>Levels</b></font> after defeating an Encounter<br>"
descr = descr .. " Gain <font color='#faf2be'><b>Artifact Fragments</b></font> after defeating an Encounter<br>"
descr = descr .. " Gain <font color='#fabeea'><b>Glyph Particles</b></font> after defeating an Encounter<br>"
descr = descr .. " <b>No</b> Encounter rerolls<br>"
descr = descr .. " <b>No</b> Perk rerolls<br>"
--descr = descr .. " <font color='#f1ff2b'><b>Achievements</b></font> are <font color='#ff2626'><b>disabled</b></font>"
GAME_MODES["Challenger"] = {}
GAME_MODES["Challenger"]["name"] = "Challenger"
GAME_MODES["Challenger"]["descr"] = descr
GAME_MODES["Challenger"]["votes"] = 0

local descr = ""
descr = descr .. "Recommended for <font color='#16ff77'><b>Rookie</b></font>, <font color='#ffeb16'><b>Veteran</b></font> or <font color='#ff6816'><b>Expert</b></font> Players!<br><br>"
descr = descr .. "Defeat 6 encounters in total to win. Your team has 1 extra life. If all Heroes die, you can continue for free once. Every other time will cost points from your Score.<br><br>"
descr = descr .. "After choosing this mode, you can also activate the option \"Casual\" and \"Endless\" and choose a different Difficulty multiplier.<br><br>"
descr = descr .. " Gain <font color='#ffd800'><b>Gold</b></font> and <font color='#00d0ff'><b>Levels</b></font> after defeating an Encounter<br>"
descr = descr .. " Gain <font color='#faf2be'><b>Artifact Fragments</b></font> after defeating an Encounter<br>"
descr = descr .. " Gain <font color='#fabeea'><b>Glyph Particles</b></font> after defeating an Encounter<br>"
descr = descr .. " <b>1</b> Encounter reroll<br>"
descr = descr .. " <b>1</b> Perk reroll<br>"
--descr = descr .. " <font color='#f1ff2b'><b>Achievements</b></font> are <font color='#18d911'><b>enabled</b></font>"
GAME_MODES["Classic"] = {}
GAME_MODES["Classic"]["name"] = "Classic"
GAME_MODES["Classic"]["descr"] = descr
GAME_MODES["Classic"]["votes"] = 0

--[[
local descr = ""
descr = descr .. "Recommended for <font color='#16ff77'><b>new</b></font> players!<br><br>"
descr = descr .. "Defeat 6 encounters in total to win. Enemies are a little weaker. You can retry every boss as long as you want.<br><br>"
descr = descr .. " You get <font color='#ffd800'><b>Gold</b></font> and <font color='#00d0ff'><b>Levels</b></font> for defeating encounters<br>"
descr = descr .. " 2 <font color='#f4dc42'><b>Greater Perks</b></font><br>"
descr = descr .. " 3 <font color='#59ffeb'><b>Lesser Perks</b></font><br>"
descr = descr .. " <b>1</b> Encounter reroll<br>"
descr = descr .. " <b>1</b> Perk reroll<br><br>"
descr = descr .. " Enemies deal <font color='#d9ffba'><b>15% less damage</b></font><br>"
descr = descr .. " Enemies have <font color='#d9ffba'><b>15% less hitpoints</b></font>"
GAME_MODES["Casual"] = {}
GAME_MODES["Casual"]["name"] = "Casual"
GAME_MODES["Casual"]["descr"] = descr
GAME_MODES["Casual"]["votes"] = 0

local descr = ""
descr = descr .. "Defeat as many encounters as you can. Start is easier, but Encounters get stronger with time. Your team has 3 lifes. You can replace Perks later in the game.<br><br>"
descr = descr .. " You get <font color='#ffd800'><b>Gold</b></font> and <font color='#00d0ff'><b>Levels</b></font> for defeating encounters<br>"
descr = descr .. " 2 <font color='#f4dc42'><b>Greater Perks</b></font><br>"
descr = descr .. " 3 <font color='#59ffeb'><b>Lesser Perks</b></font><br>"
descr = descr .. " <b>3</b> Encounter rerolls<br>"
descr = descr .. " <b>3</b> Perk rerolls"
GAME_MODES["Endless"] = {}
GAME_MODES["Endless"]["name"] = "Endless"
GAME_MODES["Endless"]["descr"] = descr
GAME_MODES["Endless"]["votes"] = 0
]]

GAME_MODES["Free"] = {}
GAME_MODES["Free"]["name"] = "Free"
GAME_MODES["Free"]["descr"] = "<font color='#ffd800'><b>Coming soon™</b></font><br>Choose the next boss from all encounters and difficulties. You can retry every boss as long as you want and change to another at any time."
GAME_MODES["Free"]["votes"] = 0

local GameModeVote_Lock_Count = 0
local GameModeVote_Skip_Count = 0
local GameModeVote_Old_Vote = { nil, nil, nil, nil, nil }

local GAME_MODES_PICK_TIME = 60

if DEBUG then
	GAME_MODES_PICK_TIME = 6000
end

local GAME_MODE_TIMER1 = nil
local GAME_MODE_TIMER2 = nil

local GAME_MODE_CLASSIC_TIMER1 = nil
local GAME_MODE_CLASSIC_TIMER2 = nil

GameMode_Active = nil
GameMode_Difficulty = 1.0

ClassicSubMode_Casual = false
ClassicSubMode_Casual_ScoreMutliplier = 0.1
ClassicSubMode_Endless = false

-- FUNCTIONS

function GameModeVote_Initilize(playerID)
	local player = PlayerResource:GetPlayer(playerID)

	CustomGameEventManager:Send_ServerToPlayer(player, "on_new_gamemodepicker_line", { name="Choose Game Mode" } )

	local i = 3
	for mode,info in pairs(GAME_MODES) do

		local color1 = "#fbfbfbff"
		local color2 = "#c0c0c0c0"
		local enabled = true

		if info["name"] == "Free" then
			color1 = "#6b6b6bff"
			color2 = "#2d2d2dff"
			enabled = false
		end

		CustomGameEventManager:Send_ServerToPlayer(player, "on_new_gamemodepicker_line_gamemode", {
													name=info["name"],
													descr=info["descr"],
													pos=tostring(i), votes="0",
													color1=color1, color2=color2, gradient="100",
													enabled=enabled
													} )
		i = i - 1
	end

--[[
	if IsInToolsMode() then
		Timers:CreateTimer(0.1, function()
			GameModeVote_Upvote( { playerID=0, name="None" } )
			GameModeVote_Lock( { playerID=0 } )
		end)
	end
	]]
end

function GameModeVote_InitilizeAll()
	local time = GAME_MODES_PICK_TIME
	GAME_MODE_TIMER1 = Timers:CreateTimer(function()

		CustomGameEventManager:Send_ServerToAllClients("on_update_gamemode_timer", { time=time } )

		time = time - 1

		if time == -1 then return end
		return 1.0
	end)

	GAME_MODE_TIMER2 = Timers:CreateTimer(time+1, function()
		GameModeVote_AllLocked(true)
	end)

	if DEBUG and DEBUG_FAST_START then
		Timers:CreateTimer(0.2, function()
			GameMode:GameModeVote_Upvote( {name=DEBUG_FAST_START_MODE, playerID=0} )
		end)
		Timers:CreateTimer(0.4, function()
			GameMode:GameModeVote_Lock( { playerID=0 } )
		end)
		Timers:CreateTimer(0.6, function()
			if DEBUG_FAST_START_MODE == "Classic" then
				GameModeVote_ClassicSubMode_AllLocked()
			end
		end)
	end
end

function GameModeVote_Show(playerID)
	local player = PlayerResource:GetPlayer(playerID)
	CustomGameEventManager:Send_ServerToPlayer(player, "on_change_game_phase_gamemodepicker", { phase="pick" } )
end

function GameModeVote_Hide(playerID)
	local player = PlayerResource:GetPlayer(playerID)
	CustomGameEventManager:Send_ServerToPlayer(player, "on_change_game_phase_gamemodepicker", { phase="no-pick" } )
end

function GameMode:GameModeVote_Lock(params)
	local playerID = params.playerID

	--if playerID ~= 0 then return end

	GameModeVote_Lock_Count = GameModeVote_Lock_Count + 1

	if GameModeVote_Lock_Count == GetPlayerCountConnected() then
		GameModeVote_AllLocked(false)
	end
end

function GameMode:GameModeVote_Upvote(params)
	local playerID = params.playerID
	local name = params.name

  --if playerID ~= 0 then return end

	local oldname = GameModeVote_Old_Vote[playerID+1]
	local oldvotes = nil

	if GameModeVote_Old_Vote[playerID+1] ~= nil then
		GAME_MODES[oldname]["votes"] = GAME_MODES[oldname]["votes"] - 1
		oldvotes = GAME_MODES[oldname]["votes"]
	end
	GameModeVote_Old_Vote[playerID+1] = name

	GAME_MODES[name]["votes"] = GAME_MODES[name]["votes"] + 1
	local votes = GAME_MODES[name]["votes"]

	CustomGameEventManager:Send_ServerToAllClients("on_update_gamemodepicker_line_gamemode", { name=name, votes=votes, oldname=oldname, oldvotes=oldvotes } )
end

function GameModeVote_AllLocked(timeout)
	if GAME_MODE_TIMER1 ~= nil then
		Timers:RemoveTimer(GAME_MODE_TIMER1)
		GAME_MODE_TIMER1 = nil
	end
	if GAME_MODE_TIMER2 ~= nil then
		Timers:RemoveTimer(GAME_MODE_TIMER2)
		GAME_MODE_TIMER2 = nil
	end

	CustomGameEventManager:Send_ServerToAllClients("on_change_game_phase_gamemodepicker", { phase="no-pick" } )

	if timeout then
		GameModeVote_SetGamemode("Classic")
		return
	end

	local votecount = 0

	local gamemode = ""
	local prev_votes = 0
	for mode,info in pairs(GAME_MODES) do
		if info["votes"] > prev_votes then
			gamemode = info["name"]
			votecount = info["votes"]
			prev_votes = votecount
		end
	end

	if GameModeVote_Skip_Count >= GameModeVote_Lock_Count then
		gamemode = "Classic"
		votecount = GameModeVote_Skip_Count
	end

	if gamemode == "Classic" then
		GameModeVote_ClassicSubMode()
	else
		GameModeVote_SetGamemode(gamemode)
	end
	
end

function GameModeVote_SetGamemode(gamemode)

	local txt = "Game Mode: "
	Notifications:TopToAll( { text=txt, duration=5, style={["font-size"]="40px", ["text-shadow"]="1px 1px 4px 5.0 #333333b0"}, continue=false } )
	local txt = gamemode.." "
	Notifications:TopToAll( { text=txt, duration=5, style={["color"]="#fff772", ["font-size"]="40px", ["text-shadow"]="1px 1px 4px 5.0 #333333b0"}, continue=true } )
	--local txt = "("..votecount.." votes)"
	--Notifications:TopToAll( { text=txt, duration=5, style={["color"]="#71fcff", ["font-size"]="40px", ["text-shadow"]="1px 1px 4px 5.0 #333333b0"}, continue=true } )

	if ClassicSubMode_Casual then
		local txt = "("
		Notifications:TopToAll( { text=txt, duration=5, style={["color"]="#ffffff", ["font-size"]="40px", ["text-shadow"]="1px 1px 4px 5.0 #333333b0"}, continue=true } )
		local txt = "Casual"
		Notifications:TopToAll( { text=txt, duration=5, style={["color"]="#b6ff82", ["font-size"]="40px", ["text-shadow"]="1px 1px 4px 5.0 #333333b0"}, continue=true } )
		local txt = ") "
		Notifications:TopToAll( { text=txt, duration=5, style={["color"]="#ffffff", ["font-size"]="40px", ["text-shadow"]="1px 1px 4px 5.0 #333333b0"}, continue=true } )
	end
	if ClassicSubMode_Endless then
		local txt = "("
		Notifications:TopToAll( { text=txt, duration=5, style={["color"]="#ffffff", ["font-size"]="40px", ["text-shadow"]="1px 1px 4px 5.0 #333333b0"}, continue=true } )
		local txt = "Endless"
		Notifications:TopToAll( { text=txt, duration=5, style={["color"]="#b88aff", ["font-size"]="40px", ["text-shadow"]="1px 1px 4px 5.0 #333333b0"}, continue=true } )
		local txt = ") "
		Notifications:TopToAll( { text=txt, duration=5, style={["color"]="#ffffff", ["font-size"]="40px", ["text-shadow"]="1px 1px 4px 5.0 #333333b0"}, continue=true } )
	end

	--CustomGameEventManager:Send_ServerToAllClients("info_gamemode", { gamemode=gamemode } )

	GameMode_Active = gamemode

	PerkRerollInit()

	EncounterCountdown()

	InfoSetGameMode()
	InfoTimeScore()

	ShowFirstChecklist()

	if not DEBUG then
		Timers:CreateTimer(3.0, function()
			DungeoneerLore_Voice_GameStart_Lore()
		end)
	end

	--Notifications:BottomToAll({text="Hint: To get your game onto the Leaderboard (dungeoneer-dota2.com), make sure to surrender your game - not just leaving!", duration=10, style={color="rgb(200, 200, 200)", ["font-size"]="20px", ["text-shadow"]="1px 1px 4px 5.0 #333333b0"}, continue=false})

	local gamemode = string.gsub(string.lower(GameMode_Active), " ", "_")

	if ClassicSubMode_Endless then
		gamemode = "endless"
	end

	-- Heroes --
	for i,hero in ipairs( GetHeroesEntities() ) do
		HTTP_AddToPayload("leaderboard_"..gamemode, "hero"..i, hero:GetUnitName() )
		HTTP_AddToPayload("leaderboard_"..gamemode, "player_id_"..i, tostring(PlayerResource:GetSteamID( hero:GetPlayerOwnerID() ) ) )
	end

	statCollection:sendStage2()

end

--////////////////////////////////////////////////////////////////////////
--/////////////////////////// CLASSIC SUB MODE ///////////////////////////
--////////////////////////////////////////////////////////////////////////

function GameModeVote_ClassicSubMode()
	local time = GAME_MODES_PICK_TIME
	GAME_MODE_CLASSIC_TIMER1 = Timers:CreateTimer(function()

		CustomGameEventManager:Send_ServerToAllClients("on_update_submode_classic_timer", { time=time } )

		time = time - 1

		if time == -1 then return end
		return 1.0
	end)

	GAME_MODE_CLASSIC_TIMER2 = Timers:CreateTimer(time+1, function()
		GameModeVote_AllLocked(true)
	end)

	CustomGameEventManager:Send_ServerToAllClients("on_change_game_phase_submode_classicpicker", { phase="pick" } )

	for playerID=1,4 do
		local player = PlayerResource:GetPlayer(playerID)
		CustomGameEventManager:Send_ServerToPlayer(player, "submode_classic_nonhost", nil )
	end
end

function GameModeVote_ClassicSubMode_AllLocked()
	Timers:RemoveTimer(GAME_MODE_CLASSIC_TIMER1)
	Timers:RemoveTimer(GAME_MODE_CLASSIC_TIMER2)
	GAME_MODE_CLASSIC_TIMER1 = nil
	GAME_MODE_CLASSIC_TIMER2 = nil

	CustomGameEventManager:Send_ServerToAllClients("on_change_game_phase_submode_classicpicker", { phase="no-pick" } )

	GameModeVote_SetGamemode("Classic")
end

function GameMode:GameModeVote_ClassicSubMode_Lock(params)
	GameModeVote_ClassicSubMode_AllLocked()
end

function GameMode:GameModeVote_ClassicSubMode_Difficulty(params)
	GameMode_Difficulty = tonumber(params.difficulty) / 10

	for playerID=1,4 do
		local player = PlayerResource:GetPlayer(playerID)
		CustomGameEventManager:Send_ServerToPlayer(player, "on_update_submode_classic_difficulty", { difficulty=params.difficulty } )
	end
end

function GameMode:GameModeVote_ClassicSubMode_CasualMode(params)
	if params.active == 1 then
		ClassicSubMode_Casual = true
	else
		ClassicSubMode_Casual = false
	end

	for playerID=1,4 do
		local player = PlayerResource:GetPlayer(playerID)
		CustomGameEventManager:Send_ServerToPlayer(player, "on_update_submode_classic_casualmode", { active=params.active } )
	end
end

function GameMode:GameModeVote_ClassicSubMode_EndlessMode(params)
	if params.active == 1 then
		ClassicSubMode_Endless = true
	else
		ClassicSubMode_Endless = false
	end

	for playerID=1,4 do
		local player = PlayerResource:GetPlayer(playerID)
		CustomGameEventManager:Send_ServerToPlayer(player, "on_update_submode_classic_endlessmode", { active=params.active } )
	end
end