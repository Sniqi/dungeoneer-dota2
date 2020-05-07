-- CONSTANTS

-- ## DEBUG ## --

local encount-- = "Bhamuka, All-Consuming God"
local encount_do_nothing = false

-- ## Encounters ## --

ENCOUNTERS_CODENAME = {}
ENCOUNTERS_CODENAME["A Mighty Boar"]							= "a_mighty_boar"
ENCOUNTERS_CODENAME["Demonic Warrior"]							= "demonic_warrior"
ENCOUNTERS_CODENAME["Scroll Collector"]							= "scroll_collector"
ENCOUNTERS_CODENAME["Ancient Siege Engine"]						= "ancient_siege_engine"
ENCOUNTERS_CODENAME["Wind Harpy"]								= "wind_harpy"
ENCOUNTERS_CODENAME["Air Ship 'Blue Balloon'"]					= "air_ship"
ENCOUNTERS_CODENAME["Lunar Horse"]								= "lunar_horse"

ENCOUNTERS_CODENAME["Ferocious Lava Elemental"]					= "ferocious_lava_elemental"
ENCOUNTERS_CODENAME["Iron Claw"]								= "iron_claw"
ENCOUNTERS_CODENAME["Smodhex, Satyr Warlock"]					= "smodhex_satyr_warlock"
ENCOUNTERS_CODENAME["Nether Drake"]								= "nether_drake"
ENCOUNTERS_CODENAME["Drono, Red Dragonkin Commander"]			= "drono_red_dragonkin_commander"
ENCOUNTERS_CODENAME["Stikx, The 'Gentleman'"]					= "stikx_the_gentleman"
ENCOUNTERS_CODENAME["Treasure on a Tree"]						= "treasure_on_a_tree"
ENCOUNTERS_CODENAME["Structures of Xun'Ra"]						= "structures_of_xunra"
ENCOUNTERS_CODENAME["Shijou, Samurai of Chaos"]					= "samurai_of_chaos"
ENCOUNTERS_CODENAME["Elite Royal Guardian"]						= "elite_royal_guardian"

ENCOUNTERS_CODENAME["Bhamuka, All-Consuming God"]				= "bhamuka_all_consuming_god"
ENCOUNTERS_CODENAME["The Curse of Agony"]						= "the_curse_of_agony"
ENCOUNTERS_CODENAME["The Dungeoneer"]							= "the_dungeoneer"
ENCOUNTERS_CODENAME["Sinastra, Dragon of the Eternal Frost"]	= "sinastra"
ENCOUNTERS_CODENAME["Deathspeaker Xun'Ra"]						= "deathspeaker_xunra"

ENCOUNTERS_ORIG = {}
ENCOUNTERS_ORIG[1] = { "A Mighty Boar", "Demonic Warrior", "Scroll Collector",
						"Ancient Siege Engine", "Wind Harpy", "Air Ship 'Blue Balloon'",
						"Lunar Horse" }
ENCOUNTERS_ORIG[2] = { "Ferocious Lava Elemental", "Iron Claw", "Smodhex, Satyr Warlock",
						"Nether Drake", "Drono, Red Dragonkin Commander", "Stikx, The 'Gentleman'",
						"Treasure on a Tree", "Structures of Xun'Ra", "Shijou, Samurai of Chaos",
						"Elite Royal Guardian" }
ENCOUNTERS_ORIG[3] = { "Bhamuka, All-Consuming God", "The Curse of Agony",
						"Sinastra, Dragon of the Eternal Frost", "Deathspeaker Xun'Ra" }

ENCOUNTERS = {}
ENCOUNTERS[1] = {}
for i,encounter in ipairs( ENCOUNTERS_ORIG[1] ) do
	table.insert(ENCOUNTERS[1], i, encounter)
end
ENCOUNTERS[2] = {}
for i,encounter in ipairs( ENCOUNTERS_ORIG[2] ) do
	table.insert(ENCOUNTERS[2], i, encounter)
end
ENCOUNTERS[3] = {}
for i,encounter in ipairs( ENCOUNTERS_ORIG[3] ) do
	table.insert(ENCOUNTERS[3], i, encounter)
end

ChallengerMode_Active = 1

ENCOUNTERS_CHALLENGER = {}
ENCOUNTERS_CHALLENGER[1] = { "A Mighty Boar", "Structures of Xun'Ra", "Treasure on a Tree", "The Curse of Agony",
							"Ancient Siege Engine", "Nether Drake", "Iron Claw", "Demonic Warrior" }

ENCOUNTERS_ABILITIES_INITIAL_CD = {}
ENCOUNTERS_ABILITIES_INITIAL_CD["A Mighty Boar"]							= {0.2, 0.6, 0.5, 0.5}
ENCOUNTERS_ABILITIES_INITIAL_CD["Demonic Warrior"]							= {0.0, 0.5, 0.0, 0.5}
ENCOUNTERS_ABILITIES_INITIAL_CD["Scroll Collector"]							= {0.2, 1.1, 1.0, 0.5}
ENCOUNTERS_ABILITIES_INITIAL_CD["Ancient Siege Engine"]						= {0.3, 0.6, 0.9, 0.75, 0.75}
ENCOUNTERS_ABILITIES_INITIAL_CD["Wind Harpy"]								= {0.4, 0.2, 0.0, 0.5}
ENCOUNTERS_ABILITIES_INITIAL_CD["Air Ship 'Blue Balloon'"]					= {0.4, 0.2, 0.9, 0.8}
ENCOUNTERS_ABILITIES_INITIAL_CD["Lunar Horse"]								= {0.1, 0.4, 0.5, 0.0}

ENCOUNTERS_ABILITIES_INITIAL_CD["Ferocious Lava Elemental"]					= {0.2, 0.2, 0.8, 1.0}
ENCOUNTERS_ABILITIES_INITIAL_CD["Iron Claw"]								= {0.0, 0.0, 0.3, 0.75, 0.75}
ENCOUNTERS_ABILITIES_INITIAL_CD["Smodhex, Satyr Warlock"]					= {0.75, 0.25, 0.3, 0.8}
ENCOUNTERS_ABILITIES_INITIAL_CD["Nether Drake"]								= {0.4, 0.0, 1.0, 1.0, 0.6}
ENCOUNTERS_ABILITIES_INITIAL_CD["Drono, Red Dragonkin Commander"]			= {0.5, 1.0, 0.25, 1.0, 1.0}
ENCOUNTERS_ABILITIES_INITIAL_CD["Stikx, The 'Gentleman'"]					= {0.25, 0.5, 0.5, 0.5}
ENCOUNTERS_ABILITIES_INITIAL_CD["Treasure on a Tree"]						= {0.75, 0.4, 0.1, 0.8, 1.0}
ENCOUNTERS_ABILITIES_INITIAL_CD["Structures of Xun'Ra"]						= {0.0, 0.2, 0.05, 1000.0, 1000.0, 1000.0}
ENCOUNTERS_ABILITIES_INITIAL_CD["Shijou, Samurai of Chaos"]					= {0.3, 0.2, 0.7, 1.0}
ENCOUNTERS_ABILITIES_INITIAL_CD["Elite Royal Guardian"]						= {0.3, 0.3, 0.0, 0.8, 1.1}

ENCOUNTERS_ABILITIES_INITIAL_CD["Bhamuka, All-Consuming God"]				= {0.1, 0.5, 0.5, 0.5, 1.0, 0.0}
ENCOUNTERS_ABILITIES_INITIAL_CD["The Curse of Agony"]						= {0.0, 0.25, 0.25, 0.45, 0.85}
ENCOUNTERS_ABILITIES_INITIAL_CD["The Dungeoneer"]							= {0.4, 0.25, 0.5, 0.75, 1.0}
ENCOUNTERS_ABILITIES_INITIAL_CD["Sinastra, Dragon of the Eternal Frost"]	= {0.0, 1000.0, 0.4, 0.0, 0.5, 0.6}
ENCOUNTERS_ABILITIES_INITIAL_CD["Deathspeaker Xun'Ra"]						= {0.2, 0.2, 0.3, 0.9, 0.5, 0.8}

ENCOUNTERS_ARENA = {}
ENCOUNTERS_ARENA["A Mighty Boar"]							= { "uncharted_desert", "red_dragon_plateau" }
ENCOUNTERS_ARENA["Demonic Warrior"]							= { "ancient_garden", "the_abyss" }
ENCOUNTERS_ARENA["Scroll Collector"]						= { "ancient_garden", "red_dragon_plateau" }
ENCOUNTERS_ARENA["Ancient Siege Engine"]					= { "battlefield_of_eternity", "red_dragon_plateau" }
ENCOUNTERS_ARENA["Wind Harpy"]								= { "battlefield_of_eternity", "ancient_garden" }
ENCOUNTERS_ARENA["Air Ship 'Blue Balloon'"]					= { "battlefield_of_eternity", "red_dragon_plateau" }
ENCOUNTERS_ARENA["Lunar Horse"]								= { "battlefield_of_eternity", "the_abyss" }

ENCOUNTERS_ARENA["Ferocious Lava Elemental"]				= { "uncharted_desert", "red_dragon_plateau" }
ENCOUNTERS_ARENA["Iron Claw"]								= { "ancient_garden", "battlefield_of_eternity" }
ENCOUNTERS_ARENA["Smodhex, Satyr Warlock"]					= { "wastelands_of_blight", "battlefield_of_eternity" }
ENCOUNTERS_ARENA["Nether Drake"]							= { "the_abyss", "wastelands_of_blight" }
ENCOUNTERS_ARENA["Drono, Red Dragonkin Commander"]			= { "red_dragon_plateau", "ancient_garden" }
ENCOUNTERS_ARENA["Stikx, The 'Gentleman'"]					= { "ancient_garden", "red_dragon_plateau" }
ENCOUNTERS_ARENA["Treasure on a Tree"]						= { "wastelands_of_blight", "uncharted_desert" }
ENCOUNTERS_ARENA["Structures of Xun'Ra"]					= { "wastelands_of_blight", "uncharted_desert" }
ENCOUNTERS_ARENA["Shijou, Samurai of Chaos"]				= { "ancient_garden", "wastelands_of_blight" }
ENCOUNTERS_ARENA["Elite Royal Guardian"]					= { "battlefield_of_eternity", "uncharted_desert" }

ENCOUNTERS_ARENA["Bhamuka, All-Consuming God"]				= { "wastelands_of_blight", "battlefield_of_eternity" }
ENCOUNTERS_ARENA["The Curse of Agony"]						= { "the_abyss", "wastelands_of_blight" }
ENCOUNTERS_ARENA["The Dungeoneer"]							= { "wastelands_of_blight", "battlefield_of_eternity", "ancient_garden", "uncharted_desert" }
ENCOUNTERS_ARENA["Sinastra, Dragon of the Eternal Frost"]	= { "battlefield_of_eternity", "battlefield_of_eternity" }
ENCOUNTERS_ARENA["Deathspeaker Xun'Ra"]						= { "wastelands_of_blight", "uncharted_desert" }


ENCOUNTERS_ATTACK_TYPE = {}
ENCOUNTERS_ATTACK_TYPE["A Mighty Boar"]								= "spell_melee"
ENCOUNTERS_ATTACK_TYPE["Demonic Warrior"]							= "normal_attack"
ENCOUNTERS_ATTACK_TYPE["Scroll Collector"]							= "spell_ranged"
ENCOUNTERS_ATTACK_TYPE["Ancient Siege Engine"]						= "spell_ranged"
ENCOUNTERS_ATTACK_TYPE["Wind Harpy"]								= "spell_ranged"
ENCOUNTERS_ATTACK_TYPE["Air Ship 'Blue Balloon'"]					= "normal_attack"
ENCOUNTERS_ATTACK_TYPE["Lunar Horse"]								= "spell_ranged"

ENCOUNTERS_ATTACK_TYPE["Ferocious Lava Elemental"]					= "spell_ranged"
ENCOUNTERS_ATTACK_TYPE["Iron Claw"]									= "normal_attack"
ENCOUNTERS_ATTACK_TYPE["Smodhex, Satyr Warlock"]					= "spell_ranged"
ENCOUNTERS_ATTACK_TYPE["Nether Drake"]								= "spell_melee"
ENCOUNTERS_ATTACK_TYPE["Drono, Red Dragonkin Commander"]			= "spell_melee"
ENCOUNTERS_ATTACK_TYPE["Stikx, The 'Gentleman'"]					= "spell_ranged"
ENCOUNTERS_ATTACK_TYPE["Treasure on a Tree"]						= "normal_attack"
ENCOUNTERS_ATTACK_TYPE["Structures of Xun'Ra"]						= "normal_attack"
ENCOUNTERS_ATTACK_TYPE["Shijou, Samurai of Chaos"]					= "spell_ranged"
ENCOUNTERS_ATTACK_TYPE["Elite Royal Guardian"]						= "spell_melee"

ENCOUNTERS_ATTACK_TYPE["Bhamuka, All-Consuming God"]				= "normal_attack"
ENCOUNTERS_ATTACK_TYPE["The Curse of Agony"]						= "spell_melee"
ENCOUNTERS_ATTACK_TYPE["The Dungeoneer"]							= "spell_ranged"
ENCOUNTERS_ATTACK_TYPE["Sinastra, Dragon of the Eternal Frost"]		= "spell_ranged"
ENCOUNTERS_ATTACK_TYPE["Deathspeaker Xun'Ra"]						= "spell_ranged"

-- Special options for Debug only
if DEBUG then
	if encount then

		if encount_do_nothing then
			ENCOUNTERS_ATTACK_TYPE[encount] = nil

			for _,data in pairs(ENCOUNTERS_ABILITIES_INITIAL_CD[encount]) do
				ENCOUNTERS_ABILITIES_INITIAL_CD[encount][_] = 0
			end
		end
		
		for i=1,#ENCOUNTERS do
			for _,data in pairs(ENCOUNTERS[i]) do
				ENCOUNTERS[i][_] = encount
			end
		end

		for i=1,#ENCOUNTERS_CHALLENGER do
			for _,data in pairs(ENCOUNTERS_CHALLENGER[i]) do
				ENCOUNTERS_CHALLENGER[i][_] = encount
			end
		end

	end
end

-- Encounter Round/Stage
ENCOUNTERS["round"] = 1
ENCOUNTERS["stage"] = 1

-- Encounter General
ENCOUNTERS["current"] = nil

ENCOUNTER_FIGHTS = {}

local EncounterEntity = nil
local EncounterOriginalList

-- Encounter Reroll
local EncounterRerollCount = {}
EncounterRerollCount["Classic"] = 1
if ClassicSubMode_Endless then
	EncounterRerollCount["Classic"] = 3
end
if ClassicSubMode_Casual then
	EncounterRerollCount["Classic"] = 1
end
EncounterRerollCount["Challenger"] = 0
EncounterRerollCount["Free"] = 999999

if DEBUG then
	EncounterRerollCount["Classic"] = 999999
	EncounterRerollCount["Challenger"] = 999999
	EncounterRerollCount["Free"] = 999999
end

local EncounterRerollVotes = 0
local EncounterRetryVotes = 0
local EncounterReadyVotes = 0

-- Encounter Retry
local EncounterRetryVotes_Timer = nil
local EncounterReadyVotes_Timer = nil

-- Encounter Timers
local EncounterCountdown_Timer = nil
local EncounterCountdown_End_Timer = nil
local EncounterDuration_Timer = nil

local EncounterCountdown_Duration = 90
local EncounterCountdown_DurationRetry = 3
local EncounterShowdown_Duration = 6
local EncounterShowdownCountdown_Delay = 2
local EncounterShowdownCountdown_Duration = 3

Timers:CreateTimer(1.0, function()
	if DEBUG then
		EncounterCountdown_Duration = 600--90
		EncounterCountdown_DurationRetry = 5--5
		EncounterShowdown_Duration = 1--6
		EncounterShowdownCountdown_Delay = 0--2
		EncounterShowdownCountdown_Duration = 0--3
	else
		EncounterCountdown_Duration = 90
		EncounterCountdown_DurationRetry = 5
		EncounterShowdown_Duration = 6
		EncounterShowdownCountdown_Delay = 2
		EncounterShowdownCountdown_Duration = 3
	end

	return 1.0
end)

-- Encounter Stats
EncounterTries = 0

EncounterHealthMultiplier = 0
EncounterHealthMultiplier_Last = 0

EncounterHealthMultiplierByMode = {}
EncounterHealthMultiplierByMode["Classic"] = 1.00
EncounterHealthMultiplierByMode["Challenger"] = 1.25
EncounterHealthMultiplierByMode["Free"] = 1.00

EncounterDamageMultiplierByMode = {}
EncounterDamageMultiplierByMode["Classic"] = 1.00
EncounterDamageMultiplierByMode["Challenger"] = 1.25
EncounterDamageMultiplierByMode["Free"] = 1.00

EncounterDamageMultiplierEndless = 2
EncounterHealthMultiplierEndless = 20

-- ## Loot ## --

LootGold = {}
LootGold["Classic"] = 1600
LootGold["Challenger"] = 1600
LootGold["Free"] = 1600

LootGoldEndlessMin = 500

LootXP = {}
LootXP["Classic"] = 500
LootXP["Challenger"] = 500
LootXP["Free"] = 500

LootXPEndless = 200

LootCurrency = {}
LootCurrency["artifact"] = {}
LootCurrency["artifact"]["Classic"] = 100
LootCurrency["artifact"]["Challenger"] = 100
LootCurrency["artifact"]["Free"] = 100
LootCurrency["glyph"] = {}
LootCurrency["glyph"]["Classic"] = 500
LootCurrency["glyph"]["Challenger"] = 500
LootCurrency["glyph"]["Free"] = 500

-- ## Score ## --

Score = 0

ScoreTimeCycle = 6

ScoreData_Encounter = {}
ScoreData_Encounter["Classic"] = 1000
if ClassicSubMode_Endless then
	ScoreData_Encounter["Classic"] = 1000
end
if ClassicSubMode_Casual then
	ScoreData_Encounter["Classic"] = 100
end
ScoreData_Encounter["Challenger"] = 1000
ScoreData_Encounter["Free"] = 1000

ScoreData_Time = {}
ScoreData_Time["Classic"] = -1
if ClassicSubMode_Endless then
	ScoreData_Time["Classic"] = -1
end
if ClassicSubMode_Casual then
	ScoreData_Time["Classic"] = -1
end
ScoreData_Time["Challenger"] = -1
ScoreData_Time["Free"] = -1

ScoreData_Death = {}
ScoreData_Death["Classic"] = -250
if ClassicSubMode_Endless then
	ScoreData_Death["Classic"] = -250
end
if ClassicSubMode_Casual then
	ScoreData_Death["Classic"] = ScoreData_Death["Classic"] / 10
end
ScoreData_Death["Challenger"] = -500
ScoreData_Death["Free"] = -10

-- ## Extra Lifes ## --

ExtraLifes_CONSTANT = {}
ExtraLifes_CONSTANT["Classic"] = 1
if ClassicSubMode_Endless then
	ExtraLifes_CONSTANT["Classic"] = 3
end
if ClassicSubMode_Casual then
	ExtraLifes_CONSTANT["Classic"] = 999999
end
ExtraLifes_CONSTANT["Challenger"] = 999999
ExtraLifes_CONSTANT["Free"] = 999999

ExtraLifes = {}
ExtraLifes["Classic"] = ExtraLifes_CONSTANT["Classic"]
ExtraLifes["Challenger"] = ExtraLifes_CONSTANT["Challenger"]
ExtraLifes["Free"] = ExtraLifes_CONSTANT["Free"]

ExtraLifesCost = {}
ExtraLifesCost["Classic"] = 300
if ClassicSubMode_Endless then
	ExtraLifesCost["Classic"] = 500
end
if ClassicSubMode_Casual then
	ExtraLifesCost["Classic"] = 0
end
ExtraLifesCost["Challenger"] = 0
ExtraLifesCost["Free"] = 0

ExtraLifesVotes_Continue = 0
ExtraLifesVotes_Surrender = 0

Continue_PickTime = 9
Continue_Timer1 = nil
Continue_Timer2 = nil

-- FUNCTIONS

function CalculateHealth()

	if DEBUG then
		print("DEBUG - CalculateHealth() ===")
		CustomGameEventManager:Send_ServerToAllClients("debug_msg", { msg="DEBUG - CalculateHealth() ===" } )
	end

--[[
	if GetRound() == 1 then 
		EncounterHealthMultiplier = 1.55
		EncounterHealthMultiplier_Last = EncounterHealthMultiplier
	else
		EncounterHealthMultiplier_Last = EncounterHealthMultiplier

		local factor1 = 1.50
		local factor2 = 3.90
		local factor3 = 2.20

		EncounterHealthMultiplier = ( EncounterHealthMultiplier + factor1 ) * ( factor2 - ( GetRound() / factor3 ) )
	end
]]

	if GetRound() == 1 then

		EncounterHealthMultiplier = 3.00

	elseif GetRound() == 2 then

		EncounterHealthMultiplier = 12.00

	elseif GetRound() == 3 then

		EncounterHealthMultiplier = 30.00

	elseif GetRound() == 4 then

		EncounterHealthMultiplier = 57.00

	elseif GetRound() == 5 then

		EncounterHealthMultiplier = 100.00

	elseif GetRound() == 6 then

		EncounterHealthMultiplier = 200.00

	elseif GetRound() >= 7 then

		if GameMode_Active == "Challenger" then

			if GetRound() == 7 then

				EncounterHealthMultiplier = 300.00

			elseif GetRound() == 8 then

				EncounterHealthMultiplier = 400.00

			end

		end

		if ClassicSubMode_Endless then

			EncounterHealthMultiplier = 200.00

			EncounterHealthMultiplier = EncounterHealthMultiplier + ( EncounterHealthMultiplierEndless * ( GetRound() - 6 ) )

			local dps = 0

			for round,table in pairs(ENCOUNTER_FIGHTS) do

				if string.match(round, GetRound()-1 .. "_" ) then

					if table["boss_hp_pct"] == 0 then

						for HERO,DPS in pairs( table["dps"] ) do

							dps = dps + DPS

						end

						-- Special Health values
						if table["name"] == "Treasure on a Tree" then
							dps = dps / 1.33
						end
						if table["name"] == "Structures of Xun'Ra" then
							dps = dps / 2.25
						end
						if table["name"] == "Bhamuka, All-Consuming God" then
							dps = dps / 2.25
						end

					end
				end

			end

			CalculatedDPSHealth_Min = ( ( dps * 85 ) / 1000 ) + ( EncounterHealthMultiplierEndless * ( GetRound() - 6 ) )
			CalculatedDPSHealth_Max = ( ( dps * 105 ) / 1000 ) + ( EncounterHealthMultiplierEndless * ( GetRound() - 6 ) )

			if EncounterHealthMultiplier < CalculatedDPSHealth_Min then
				EncounterHealthMultiplier = CalculatedDPSHealth_Min
			elseif EncounterHealthMultiplier > CalculatedDPSHealth_Max then
				EncounterHealthMultiplier = CalculatedDPSHealth_Max
			end

			--EncounterHealthMultiplier = EncounterHealthMultiplier + ( EncounterHealthMultiplierEndless * ( GetRound() - 6 ) )

			--EncounterHealthMultiplierByMode[ GameMode_Active ] = 1.0

		end

	end

	if GetPlayerCount() == 2 then EncounterHealthMultiplier = EncounterHealthMultiplier * 1.70 end
	if GetPlayerCount() == 3 then EncounterHealthMultiplier = EncounterHealthMultiplier * 2.40 end
	if GetPlayerCount() == 4 then EncounterHealthMultiplier = EncounterHealthMultiplier * 3.10 end
	if GetPlayerCount() == 5 then EncounterHealthMultiplier = EncounterHealthMultiplier * 3.80 end

	EncounterHealthMultiplier = EncounterHealthMultiplier * EncounterHealthMultiplierByMode[ GameMode_Active ]

	EncounterHealthMultiplier = EncounterHealthMultiplier * 100

--[[
	if GetPlayerCount() > 1 then
		local factor1 = 1.00
		local factor2 = 0.75
		local factor3 = 0.75

		EncounterHealthMultiplier = EncounterHealthMultiplier * ( factor1 + ( ( GetPlayerCount() * factor2 ) / GetRound() ) )
	end
	]]

	if DEBUG then
		print("DEBUG - CalculateHealth() === MULTIPLIER:",EncounterHealthMultiplier)
		CustomGameEventManager:Send_ServerToAllClients("debug_msg", { msg="DEBUG - CalculateHealth() === MULTIPLIER: "..EncounterHealthMultiplier } )
	end

end

function CalculateGold_Round()

	if DEBUG then
		print("DEBUG - CalculateGold_Round() ===")
		CustomGameEventManager:Send_ServerToAllClients("debug_msg", { msg="DEBUG - CalculateGold_Round() ===" } )
	end

	local value
	local factor1 = 700
	local factor2 = 0

	if ClassicSubMode_Endless and GetRound() > 5 then
		factor1 = 1000
		factor2 = 20
	end

	value = ( LootGold[ GameMode_Active or "Classic" ] * GetRound() ) - ( ( factor1 + GetRound() * factor2 ) * GetRound() )

	if value < LootGoldEndlessMin then
		value = LootGoldEndlessMin
	end

	return value

end

function CalculateBonusGold_Time(time_spent)

	if DEBUG then
		print("DEBUG - CalculateBonusGold_Time() ===")
		CustomGameEventManager:Send_ServerToAllClients("debug_msg", { msg="DEBUG - CalculateBonusGold_Time() ===" } )
	end

	local round = GetRound()
	local time_spent = time_spent
	local base_gold = 45000
	local factor1 = 0.75
	local factor2 = 150

	if ClassicSubMode_Endless and GetRound() > 5 then
		round = 5
	end

	return ( base_gold * ( round + factor1 ) ) / ( time_spent + factor2 )
end

function CalculateExtraLifeCost() --return int

	if DEBUG then
		print("DEBUG - CalculateExtraLifeCost() ===")
		CustomGameEventManager:Send_ServerToAllClients("debug_msg", { msg="DEBUG - CalculateExtraLifeCost() ===" } )
	end

	if ClassicSubMode_Casual then
		return 0
	end

	local lifeCosts = ExtraLifesCost[ GameMode_Active ]
	lifeCosts = lifeCosts * GameMode_Difficulty

	return lifeCosts	
end
function ConvertEncounterName(bossNameReadable)
	local bossName = string.lower(bossNameReadable)
	bossName = string.gsub(bossName, ",", "")
	bossName = string.gsub(bossName, "-", "_")
	bossName = string.gsub(bossName, " ", "_")
	bossName = string.gsub(bossName, "\'", "")
	return bossName
end

function GetEncounterCodeName(bossNameReadable)
	return ENCOUNTERS_CODENAME[bossNameReadable]
end

function SetCurrentEncounterEntity(unit)
	EncounterEntity = unit
	return EncounterEntity
end

function GetCurrentEncounterEntity()
	return EncounterEntity
end

function SetCurrentEncounter()
	--DeepPrintTable(ENCOUNTERS)

	if GameMode_Active == "Challenger" then

		ENCOUNTERS["current"] = ENCOUNTERS_CHALLENGER[ChallengerMode_Active][GetRound()]

	else

		if ENCOUNTERS[ GetStage() ][1] == nil then
			for i,encounter in ipairs( ENCOUNTERS_ORIG[ GetStage() ] ) do
				table.insert(ENCOUNTERS[ GetStage() ], i, encounter)
			end
		end

		ENCOUNTERS["current"] = ENCOUNTERS[ GetStage() ][ RandomInt( 1, #ENCOUNTERS[ GetStage() ] ) ]

	end

	if DEBUG then
		print("DEBUG - SetCurrentEncounter() ===", ENCOUNTERS["current"])
		CustomGameEventManager:Send_ServerToAllClients("debug_msg", { msg="DEBUG - SetCurrentEncounter() === "..tostring(ENCOUNTERS["current"]) } )
		DeepPrintTable( ENCOUNTERS[ GetStage() ] )
	end

	return ENCOUNTERS["current"]
end

function GetCurrentEncounter()
	return ENCOUNTERS["current"]
end

function EnforceCurrentEncounter(stage)
	if stage then
		InsertEncounterToList( GetCurrentEncounter() )

		EncounterOriginalList = ENCOUNTERS[ GetStage() ]

		for i,encounter in pairs( EncounterOriginalList ) do
			if encounter == GetCurrentEncounter() then
				table.remove( EncounterOriginalList, i )
			end
		end

		ENCOUNTERS[ GetStage() ] = { GetCurrentEncounter() }
	else
		ENCOUNTERS[ GetStage() ] = EncounterOriginalList
	end

	if DEBUG then
		print("DEBUG - EnforceCurrentEncounter(stage) ===", stage)
		CustomGameEventManager:Send_ServerToAllClients("debug_msg", { msg="DEBUG - EnforceCurrentEncounter(stage) === "..tostring(stage) } )
		DeepPrintTable( ENCOUNTERS[ GetStage() ] )
	end
end

function InsertEncounterToList(encounter)
	table.insert( ENCOUNTERS[ GetStage() ], encounter )

	if DEBUG then
		print("DEBUG - InsertEncounterToList(encounter) ===", encounter)
		CustomGameEventManager:Send_ServerToAllClients("debug_msg", { msg="DEBUG - InsertEncounterToList(encounter) === "..tostring(encounter) } )
	end
end

function RemoveEncounterFromList()
	for i,encounter in pairs( ENCOUNTERS[ GetStage() ] ) do
		if encounter == GetCurrentEncounter() then
			table.remove( ENCOUNTERS[ GetStage() ], i )

			if DEBUG then
				print("DEBUG - RemoveEncounterFromList(stage) ===", encounter)
				CustomGameEventManager:Send_ServerToAllClients("debug_msg", { msg="DEBUG - RemoveEncounterFromList(stage) === "..tostring(encounter) } )
			end

		end
	end
end

function SetRound(x)
	ENCOUNTERS["round"] = tonumber(x)

	if DEBUG then
		print("DEBUG - SetRound(x) ===", x)
		CustomGameEventManager:Send_ServerToAllClients("debug_msg", { msg="DEBUG - SetRound(x) === "..tostring(x) } )
	end

	return ENCOUNTERS["round"]
end

function GetRound()
	return ENCOUNTERS["round"] or 1
end

function IncrementRound()
	ENCOUNTERS["round"] = ENCOUNTERS["round"] + 1

	if DEBUG then
		print("DEBUG - IncrementRound() ===", ENCOUNTERS["round"])
		CustomGameEventManager:Send_ServerToAllClients("debug_msg", { msg="DEBUG - IncrementRound() === "..tostring(ENCOUNTERS["round"]) } )
	end

	return ENCOUNTERS["round"]
end

function SetStage(x)
	ENCOUNTERS["stage"] = tonumber(x)

	if DEBUG then
		print("DEBUG - SetStage(x) ===", x)
		CustomGameEventManager:Send_ServerToAllClients("debug_msg", { msg="DEBUG - SetStage(x) === "..tostring(x) } )
	end

	return ENCOUNTERS["stage"]
end

function GetStage()
	return ENCOUNTERS["stage"]
end

function IncrementStage()
	ENCOUNTERS["stage"] = ENCOUNTERS["stage"] + 1

	if DEBUG then
		print("DEBUG - IncrementStage() ===", ENCOUNTERS["stage"])
		CustomGameEventManager:Send_ServerToAllClients("debug_msg", { msg="DEBUG - IncrementStage() === "..tostring(ENCOUNTERS["stage"]) } )
	end

	return ENCOUNTERS["stage"]
end







function EncounterCountdown(continue)
	if EncounterCountdown_Timer ~= nil then return end

	if DEBUG then
		print("DEBUG - EncounterCountdown(continue) ===", continue)
		CustomGameEventManager:Send_ServerToAllClients("debug_msg", { msg="DEBUG - EncounterCountdown(continue) === "..tostring(continue) } )
	end

	if GameMode_Active == "Classic" then
		EncounterHealthMultiplierByMode["Classic"] = tonumber(GameMode_Difficulty)
		EncounterDamageMultiplierByMode["Classic"] = tonumber(GameMode_Difficulty)
	end

	for _,hero in pairs(GetHeroesAliveEntities()) do
		hero:AddNewModifier(hero, nil, "casting_modifier", {})
	end

	CustomGameEventManager:Send_ServerToAllClients("enable_ready", {} )

	EncounterCountdown_Create( false )

	if continue then
		EnforceCurrentEncounter(false)
	end

	EncounterRerollVotes = 0
	EncounterRetryVotes = 0
	CustomGameEventManager:Send_ServerToAllClients("toggle_boss_info_visibility", { visible=true } )

	local CountdownSound = "Custom.EncounterCountdown"
	if GetStage() == 1 then CountdownSound = CountdownSound .. "One" end
	if GetStage() == 2 then CountdownSound = CountdownSound .. "Two" end
	if GetStage() == 3 then CountdownSound = CountdownSound .. "Three" end

	if not DEBUG and not continue then
		EmitGlobalSound(CountdownSound)
	end

	local duration = EncounterCountdown_Duration
	local duration_txt = 6
	local counter = 0

	if continue then
		duration = EncounterCountdown_DurationRetry
		duration_txt = EncounterCountdown_DurationRetry
	end

	--Notifications:TopToAll({text="Time until next Encounter starts: ", duration=duration_txt, style={["font-size"]="40px", ["text-shadow"]="1px 1px 4px 5.0 #333333b0"}, continue=false})

	EncounterCountdown_Timer = Timers:CreateTimer(0.0, function()
		--Notifications:TopToAll({text=duration, duration=1, style={["font-size"]="45px", ["text-shadow"]="1px 1px 4px 5.0 #333333b0"}, continue=false})

		local time_minutes = math.floor( duration / 60 )
		local time_seconds = math.floor( (duration - (time_minutes*60) ) )

		local leading_zero_minutes = "0"
		if time_minutes > 9 then leading_zero_minutes = "" end
		local leading_zero_seconds = "0"
		if time_seconds > 9 then leading_zero_seconds = "" end
		local time_readable = leading_zero_minutes..time_minutes..":"..leading_zero_seconds..time_seconds

		CustomGameEventManager:Send_ServerToAllClients("timer", { txt="Fight Countdown:", time=time_readable } )

		duration = duration - 1
		return 1.0
	end)

	EncounterCountdown_End_Timer = Timers:CreateTimer(duration+0.5, function()
		EncounterCountdown_End()
	end)

end

function EncounterCountdown_End()

	if DEBUG then
		print("DEBUG - EncounterCountdown_End() ===")
		CustomGameEventManager:Send_ServerToAllClients("debug_msg", { msg="DEBUG - EncounterCountdown_End() === " } )
	end

	CustomGameEventManager:Send_ServerToAllClients("disable_ready", {} )

	Timers:RemoveTimer(EncounterCountdown_Timer)
	EncounterCountdown_Timer = nil

	EncounterShowdown()
end

function EncounterCountdown_Create( reroll )

	if DEBUG then
		print("DEBUG - EncounterCountdown_Create() ===")
		CustomGameEventManager:Send_ServerToAllClients("debug_msg", { msg="DEBUG - EncounterCountdown_Create() === " } )
	end

	if EncounterEntity ~= nil then
		if not EncounterEntity:IsNull() then
			EncounterEntity:RemoveSelf()
			EncounterEntity = nil
		end
	end

	SetCurrentEncounter()

	GetEncounterArena()

	EncounterCreate()

	HeroesTeleportToArena()

	RemoveEncounterFromList()

	Encounter_SpecialCountdown()

	Timers:CreateTimer(0.1, function()

		local bossname = GetCurrentEncounter()
		local bossEntity = GetCurrentEncounterEntity()

		for i=0,23 do
			local ability = bossEntity:GetAbilityByIndex(i)
			if ability ~= nil then
				CustomGameEventManager:Send_ServerToAllClients("add_boss_abilities", { boss_unitname=GetEncounterCodeName(bossname), ability_pos=i, ability_name=ability:GetAbilityName() } )
			end
		end

		CustomGameEventManager:Send_ServerToAllClients("add_boss_list_entry", { boss_unitname=GetEncounterCodeName(bossname), pos=0, bosscount=7  } )

		if EncounterRerollCount[ GameMode_Active ] > 0 and not reroll then
			CustomGameEventManager:Send_ServerToAllClients("boss_info_reroll_boss_show", {} )
		else
			CustomGameEventManager:Send_ServerToAllClients("boss_info_reroll_boss_hide", {} )
		end

	end)
end

function EncounterShowdown()

	if DEBUG then
		print("DEBUG - EncounterShowdown() ===")
		CustomGameEventManager:Send_ServerToAllClients("debug_msg", { msg="DEBUG - EncounterShowdown() === " } )
	end

	--Checklist
	if GetRound() == 1 then
		RemoveFirstChecklist()
	else
		RemoveEncounterDefeatedChecklist()
	end

	local bossNameReadable = GetCurrentEncounter()
	local bossName = GetEncounterCodeName(bossNameReadable)--ConvertEncounterName(bossNameReadable)

	local arenaName = GetActiveArena()
	local arenaNameReadable = ConvertArenaName(arenaName)

	CustomGameEventManager:Send_ServerToAllClients("toggle_boss_info_visibility", { visible=false } )

	CustomGameEventManager:Send_ServerToAllClients("show_boss_banner", {bossName=bossName, bossNameReadable=bossNameReadable} )

	CustomGameEventManager:Send_ServerToAllClients("show_arena_banner", {arenaName=arenaName, arenaNameReadable=arenaNameReadable} )

	local ShowdownSound = "Custom.EncounterShowdown"
	if GetStage() == 1 then ShowdownSound = ShowdownSound .. "One" end
	if GetStage() == 2 then ShowdownSound = ShowdownSound .. "Two" end
	if GetStage() == 3 then ShowdownSound = ShowdownSound .. "Three" end
	EmitGlobalSound(ShowdownSound)

	Timers:CreateTimer(EncounterShowdown_Duration, function()
		EncounterPreparation()
	end)
end

function EncounterPreparation()

	if DEBUG then
		print("DEBUG - EncounterPreparation() ===")
		CustomGameEventManager:Send_ServerToAllClients("debug_msg", { msg="DEBUG - EncounterPreparation() === " } )
	end

	EncounterTries = EncounterTries + 1

	-- Shop
	Entities:FindByName(nil, "shop"):Disable()

	EmitGlobalSound("announcer_announcer_battle_prepare_01")

	local delay = EncounterShowdownCountdown_Delay

	local i = EncounterShowdownCountdown_Duration
	local timer = Timers:CreateTimer(delay, function()
		EmitGlobalSound("announcer_ann_custom_countdown_0" .. i)
		Notifications:TopToAll({text=i, duration=1, style={color="rgb(200, 32, 32)", ["font-size"]="70px", ["text-shadow"]="1px 1px 4px 5.0 #333333b0"}, continue=false})
		i = i - 1
		return 1.0
	end)

	Timers:CreateTimer(delay + i - 0.1, function()
		Timers:RemoveTimer(timer)

		EmitGlobalSound( "announcer_ann_custom_round_0" .. GetRound() )

		local finalRoundDelay = 0
		if GetRound() == 6 and not ClassicSubMode_Endless and not GameMode_Active == "Challenger" then
			finalRoundDelay = 2
			Timers:CreateTimer(1.5, function()
				
				EmitGlobalSound("announcer_ann_custom_round_final")
			end)
		end
		if GetRound() == 8 and GameMode_Active == "Challenger" then
			finalRoundDelay = 2
			Timers:CreateTimer(1.5, function()
				
				EmitGlobalSound("announcer_ann_custom_round_final")
			end)
		end

		Timers:CreateTimer(1.5 + finalRoundDelay, function()
			EmitGlobalSound("announcer_ann_custom_begin")--announcer_announcer_battle_begin_01

			--Notifications:TopToAll({text="FIGHT!", duration=1, style={color="rgb(200, 32, 32)", ["font-size"]="70px", ["text-shadow"]="1px 1px 4px 5.0 #333333b0"}, continue=false})

			for _,hero in pairs(GetHeroesEntities()) do
				hero:Heal(999999, nil)
				hero:GiveMana(999999)

				for i=0,30 do
					local ability = hero:GetAbilityByIndex(i)
					if ability ~= nil then
						if ability:GetCooldownTimeRemaining() ~= nil then
							if ability:GetCooldownTimeRemaining() > 0 then
								ability:EndCooldown()
							end
						end
					end
				end

				for i=0,14 do
					if hero:GetItemInSlot(i) ~= nil then
						if hero:GetItemInSlot(i):GetCooldownTimeRemaining() > 0 then
							hero:GetItemInSlot(i):EndCooldown()
						end
					end
				end

				local perk_cheat_death = hero:FindAllModifiersByName("greater_crusader_shield")

				if perk_cheat_death ~= nil then
					for i,perk in pairs( perk_cheat_death ) do

						if perk.current_cooldown > 2 then
							perk.current_cooldown = 2
						end

					end
				end

				hero:FindModifierByName("casting_modifier"):Destroy()
			end

			EncounterCreate_HPBars(GetCurrentEncounterEntity())
			EncounterCreate_Unfreeze()
			EncounterCreate_SetInitialCD()
			Encounter_SpecialPreparation()
			EncounterDamageMeter()			

			CustomGameEventManager:Send_ServerToAllClients("enable_retryfight", {} )

			local duration = 0
			EncounterDuration_Timer = Timers:CreateTimer(1.0, function()
				--Notifications:TopToAll({text=duration, duration=1, style={["font-size"]="45px", ["text-shadow"]="1px 1px 4px 5.0 #333333b0"}, continue=false})

				local time_minutes = math.floor( duration / 60 )
				local time_seconds = math.floor( (duration - (time_minutes*60) ) )

				local leading_zero_minutes = "0"
				if time_minutes > 9 then leading_zero_minutes = "" end
				local leading_zero_seconds = "0"
				if time_seconds > 9 then leading_zero_seconds = "" end
				local time_readable = leading_zero_minutes..time_minutes..":"..leading_zero_seconds..time_seconds

				CustomGameEventManager:Send_ServerToAllClients("timer", { txt="Fight Duration:", time=time_readable } )

				duration = duration + 1
				return 1.0
			end)

			Timers:CreateTimer(2.0, function()
				DungeoneerLore_Voice_BeginningBattle()
			end)

		end)

	end)

	ENCOUNTER_FIGHTS[ GetRound() .. "_" .. EncounterTries ] = {}
	ENCOUNTER_FIGHTS[ GetRound() .. "_" .. EncounterTries ]["stage"] = GetStage()
	ENCOUNTER_FIGHTS[ GetRound() .. "_" .. EncounterTries ]["name"] = GetCurrentEncounter()
	ENCOUNTER_FIGHTS[ GetRound() .. "_" .. EncounterTries ]["time_start"] = Time()
	ENCOUNTER_FIGHTS[ GetRound() .. "_" .. EncounterTries ]["time_end"] = nil
	ENCOUNTER_FIGHTS[ GetRound() .. "_" .. EncounterTries ]["deaths"] = 0
	ENCOUNTER_FIGHTS[ GetRound() .. "_" .. EncounterTries ]["boss_hp"] = 0
	ENCOUNTER_FIGHTS[ GetRound() .. "_" .. EncounterTries ]["boss_hp_pct"] = 0
	ENCOUNTER_FIGHTS[ GetRound() .. "_" .. EncounterTries ]["dps"] = {}
	ENCOUNTER_FIGHTS[ GetRound() .. "_" .. EncounterTries ]["damage_done"] = {}
	ENCOUNTER_FIGHTS[ GetRound() .. "_" .. EncounterTries ]["damage_done_pct"] = {}
	for _,hero in pairs(GetHeroesEntities()) do
		ENCOUNTER_FIGHTS[ GetRound() .. "_" .. EncounterTries ]["dps"][hero:GetUnitName()] = 0
		ENCOUNTER_FIGHTS[ GetRound() .. "_" .. EncounterTries ]["damage_done"][hero:GetUnitName()] = 0
		ENCOUNTER_FIGHTS[ GetRound() .. "_" .. EncounterTries ]["damage_done_pct"][hero:GetUnitName()] = 0
	end

end

function EncounterCreate()

	if DEBUG then
		print("DEBUG - EncounterCreate() ===")
		CustomGameEventManager:Send_ServerToAllClients("debug_msg", { msg="DEBUG - EncounterCreate() === " } )
	end

	local bossNameReadable = GetCurrentEncounter()
	local bossName = GetEncounterCodeName(bossNameReadable)--ConvertEncounterName(bossNameReadable)

	local bossNameUnit = "npc_dota_hero_" .. bossName

	local point = GetSpecificBorderPoint("point_center")
	local unit = CreateUnitByName(bossNameUnit, point, true, nil, nil, DOTA_TEAM_BADGUYS)

	SetCurrentEncounterEntity(unit)

	unit:AddNewModifier(unit, nil, "modifier_invulnerable", {})
	unit:AddNewModifier(unit, nil, "modifier_unselectable", {})
	unit:AddNewModifier(unit, nil, "casting_no_turning_modifier", {})
	unit:AddNewModifier(unit, nil, "modifier_flying_for_pathing", {})

	CalculateHealth()

	EncounterCreate_AttackDamage(unit)
	EncounterCreate_Health(unit)

	unit:SetHullRadius(20)

	unit:SetMaximumGoldBounty(0)
	unit:SetMinimumGoldBounty(0)

	-- DEBUG -- -- Sniqi only commands --
	if DEBUG and tostring(PlayerResource:GetSteamAccountID(0)) == "41536950" and tostring(PlayerResource:GetSteamID(0)) == "76561198001802678" then
		unit:SetControllableByPlayer(0, false)
	end

	unit:AddExperience(2900, 0, false, true)

	EncounterCreate_Abilities()

	Timers:CreateTimer(0.1, function()
		unit:MoveToPosition( unit:GetAbsOrigin() + Vector(0,-1,0) )
	end)

	return unit
end

function EncounterCreate_HPBars(unit, name_addition)

	if DEBUG then
		print("DEBUG - EncounterCreate_HPBars() ===")
		CustomGameEventManager:Send_ServerToAllClients("debug_msg", { msg="DEBUG - EncounterCreate_HPBars() === " } )
	end

	if name_addition == nil then name_addition = "" end

	CustomGameEventManager:Send_ServerToAllClients("on_new_boss_hp", { name=unit:GetUnitName(), name_addition=name_addition, id=unit:entindex() } )
	PersistentBossHp_Add( unit:entindex() )

	local timer = Timers:CreateTimer(0.0, function()
		if unit == nil then return end
		if unit:IsNull() then return end

		CustomGameEventManager:Send_ServerToAllClients("on_update_boss_hp", { progress=unit:GetHealthPercent(), id=unit:entindex() } )

		return 0.1
	end)
	PersistentTimer_Add(timer)

end

function EncounterCreate_Unfreeze()

	if DEBUG then
		print("DEBUG - EncounterCreate_Unfreeze() ===")
		CustomGameEventManager:Send_ServerToAllClients("debug_msg", { msg="DEBUG - EncounterCreate_Unfreeze() === " } )
	end

	local unit = GetCurrentEncounterEntity()
	unit:RemoveModifierByName("modifier_invulnerable")
	unit:RemoveModifierByName("modifier_unselectable")
	unit:RemoveModifierByName("casting_no_turning_modifier")

	for _,hero in pairs(GetHeroesAliveEntities()) do
		FindClearSpaceForUnit(hero, hero:GetAbsOrigin(), false)
	end
end

function EncounterCreate_SetInitialCD()

	if DEBUG then
		print("DEBUG - EncounterCreate_SetInitialCD() ===")
		CustomGameEventManager:Send_ServerToAllClients("debug_msg", { msg="DEBUG - EncounterCreate_SetInitialCD() === " } )
	end

	local unit = GetCurrentEncounterEntity()
	local table = ENCOUNTERS_ABILITIES_INITIAL_CD[GetCurrentEncounter()]

	for i,multiplier in pairs(table) do
		local ability = unit:GetAbilityByIndex(i-1)
		ability:StartCooldown( ability:GetCooldown(ability:GetLevel()) * multiplier )
	end
end

function EncounterCreate_Health(unit, factor)

	if DEBUG then
		print("DEBUG - EncounterCreate_Health(unit) ===", unit:GetUnitName())
		CustomGameEventManager:Send_ServerToAllClients("debug_msg", { msg="DEBUG - EncounterCreate_Health(unit) === "..tostring(unit:GetUnitName()) } )
	end

	unit:AddNewModifier(unit, nil, "modifier_encounter_health", {factor = factor})

	unit:AddNewModifier(unit, nil, "modifier_encounter_damage", {})

	unit:AddNewModifier(unit, nil, "modifier_disable_damage_block", {})

	--Damage meter
	unit:AddNewModifier(unit, nil, "damage_meter", {})
end

function EncounterCreate_AttackDamage(unit)

	if DEBUG then
		print("DEBUG - EncounterCreate_AttackDamage(unit) ===", unit:GetUnitName())
		CustomGameEventManager:Send_ServerToAllClients("debug_msg", { msg="DEBUG - EncounterCreate_AttackDamage(unit) === "..tostring(unit:GetUnitName()) } )
	end

	unit:AddNewModifier(unit, nil, "percentage_based_auto_attack_damage", { })
end

function EncounterCreate_Abilities()

	if DEBUG then
		print("DEBUG - EncounterCreate_Abilities() ===")
		CustomGameEventManager:Send_ServerToAllClients("debug_msg", { msg="DEBUG - EncounterCreate_Abilities() === " } )
	end

	local unit = GetCurrentEncounterEntity()

	local level = 0

	if GetStage() == 1 then
		if GetRound() == 1 then level = 1 end
		if GetRound() == 2 then level = 2 end
		if GetRound() >= 7 and ClassicSubMode_Endless then level = 2 end
	elseif GetStage() == 2 then
		if GetRound() == 3 then level = 1 end
		if GetRound() == 4 then level = 2 end
		if GetRound() == 5 then level = 3 end
		if GetRound() >= 7 and ClassicSubMode_Endless then level = 3 end
	elseif GetStage() == 3 then
		if GetRound() == 6 then level = 1 end
		if GetRound() >= 7 and ClassicSubMode_Endless then level = 1 end
	end

	if GameMode_Active == "Challenger" then
		level = unit:GetAbilityByIndex(0):GetMaxLevel()
	end

	EncounterCreate_AbilitiesLvlUp(unit, level)

	EncounterDefaultAI( ENCOUNTERS_ATTACK_TYPE[GetCurrentEncounter()], level)

end

function EncounterCreate_AbilitiesLvlUp(unit, x)

	if DEBUG then
		print("DEBUG - EncounterCreate_AbilitiesLvlUp(unit, x) ===", unit:GetUnitName(), x)
		CustomGameEventManager:Send_ServerToAllClients("debug_msg", { msg="DEBUG - EncounterCreate_AbilitiesLvlUp(unit, x) === "..tostring(unit:GetUnitName()).." === "..tostring(x) } )
	end

	for i=0,9 do
		local ability = unit:GetAbilityByIndex(i)
		if ability ~= nil then ability:SetLevel(x) end
	end
end

function HeroesTeleportToArena()

	if DEBUG then
		print("DEBUG - HeroesTeleportToArena() ===")
		CustomGameEventManager:Send_ServerToAllClients("debug_msg", { msg="DEBUG - HeroesTeleportToArena() === " } )
	end

	for _,hero in pairs(GetHeroesAliveEntities()) do
		FindClearSpaceForUnit(hero, GetSpecificBorderPoint("point_center") + Vector(0,-500,0), false)

		-- Camera --
		PlayerResource:SetCameraTarget(_-1, hero)
		Timers:CreateTimer(2.00, function()
			PlayerResource:SetCameraTarget(_-1, nil)
		end)
	end
end

function GameMode:Encounter_Reroll()

	if DEBUG then
		print("DEBUG - GameMode:Encounter_Reroll() ===")
		CustomGameEventManager:Send_ServerToAllClients("debug_msg", { msg="DEBUG - GameMode:Encounter_Reroll() === " } )
	end

	if EncounterRerollCount[ GameMode_Active ] < 1 then return end

	local playerCount = GetPlayerCountConnected()
	local votesNeeded = math.floor(playerCount / 2) + 1

	if playerCount == 1 then
		EncounterReroll()
		return
	end	

	EncounterRerollVotes = EncounterRerollVotes + 1

	Notifications:TopToAll({text="Encounter reroll votes: " .. EncounterRerollVotes .. " / " .. votesNeeded, duration=12, style={color="rgb(32, 132, 200)", ["font-size"]="40px", ["text-shadow"]="1px 1px 4px 5.0 #333333b0"}, continue=false})

	if EncounterRerollVotes >= votesNeeded then
		EncounterReroll()
	end
end

function EncounterReroll()

	if DEBUG then
		print("DEBUG - EncounterReroll() ===")
		CustomGameEventManager:Send_ServerToAllClients("debug_msg", { msg="DEBUG - EncounterReroll() === " } )
	end

	Notifications:TopToAll({text="Rerolling Encounter...", style={["font-size"]="40px", ["text-shadow"]="1px 1px 4px 5.0 #333333b0"}, continue=false, duration=duration})

	CustomGameEventManager:Send_ServerToAllClients("boss_info_reroll_boss_hide", {} )

	EncounterRerollCount[ GameMode_Active ] = EncounterRerollCount[ GameMode_Active ] - 1

	-- Cleanup Persistents
	Cleanup_Persistents( false )

	Timers:CreateTimer(3.00, function()
		EncounterCountdown_Create( true )
	end)

	EmitGlobalSound("Custom.EncounterReroll")
end

function EncounterDefeated()

	if DEBUG then
		print("DEBUG - EncounterDefeated() ===")
		CustomGameEventManager:Send_ServerToAllClients("debug_msg", { msg="DEBUG - EncounterDefeated() === " } )
	end

	for _,hero in pairs(GetHeroesAliveEntities()) do
		hero:AddNewModifier(hero, nil, "modifier_invulnerable", { duration = 5.0 } )
		hero:AddNewModifier(hero, nil, "casting_modifier", {})
	end

	Timers:RemoveTimer(EncounterDuration_Timer)
	EncounterDuration_Timer = nil

	EncounterDamageMeterStop()

	ENCOUNTER_FIGHTS[ GetRound() .. "_" .. EncounterTries ]["time_end"] = Time()

	local time_spent = ENCOUNTER_FIGHTS[ GetRound() .. "_" .. EncounterTries ]["time_end"] - ENCOUNTER_FIGHTS[ GetRound() .. "_" .. EncounterTries ]["time_start"]

	local time_spent_minutes = math.floor( time_spent / 60 )
	local time_spent_seconds = math.floor( (time_spent - (time_spent_minutes*60) ) )

	local leading_zero_minutes = "0"
	if time_spent_minutes > 9 then leading_zero_minutes = "" end
	local leading_zero_seconds = "0"
	if time_spent_seconds > 9 then leading_zero_seconds = "" end
	local time_spent_readable = leading_zero_minutes..time_spent_minutes..":"..leading_zero_seconds..time_spent_seconds

	CustomGameEventManager:Send_ServerToAllClients("disable_retryfight", {} )

	EmitGlobalSound("Custom.EncounterDefeated")

	-- Cleanup Persistents
	Cleanup_Persistents( false )

	-- Score
	InfoAlterScore(ScoreData_Encounter[GameMode_Active])

	if ( GetRound() == 6 and GameMode_Active == "Classic" and not ClassicSubMode_Endless ) or
		( GetRound() == 8 and GameMode_Active == "Challenger" ) then

		HTTP_Aggregate_Data(true)

		Notifications:TopToAll({text="Congratulations!", duration=20, style={color="rgb(50, 255, 50)", ["font-size"]="70px", ["text-shadow"]="1px 1px 4px 5.0 #333333b0"}, continue=false})
		Notifications:TopToAll({text="Your final score is ", duration=20, style={color="rgb(200, 200, 200)", ["font-size"]="50px", ["text-shadow"]="1px 1px 4px 5.0 #333333b0"}, continue=false})
		Notifications:TopToAll({text=math.floor(Score), duration=20, style={color="rgb(220, 0, 180)", ["font-size"]="50px", ["text-shadow"]="1px 1px 4px 5.0 #333333b0"}, continue=true})

		if not IsInToolsMode() and not GameRules:IsCheatMode() then
			Notifications:BottomToAll({text="Check [dungeoneer-dota2.com] to see how you ranked!", duration=20, style={color="rgb(200, 200, 200)", ["font-size"]="30px", ["text-shadow"]="1px 1px 4px 5.0 #333333b0"}, continue=false})
		else
			Notifications:BottomToAll({text="Cheat Mode is not eligible to get ranked.", duration=20, style={color="rgb(200, 200, 200)", ["font-size"]="30px", ["text-shadow"]="1px 1px 4px 5.0 #333333b0"}, continue=false})
			Notifications:BottomToAll({text="Check [dungeoneer-dota2.com] to see how other people ranked!", duration=20, style={color="rgb(200, 200, 200)", ["font-size"]="30px", ["text-shadow"]="1px 1px 4px 5.0 #333333b0"}, continue=false})
		end

		Notifications:BottomToAll({text="Game ends in..", duration=20, style={color="rgb(200, 200, 200)", ["font-size"]="24px", ["text-shadow"]="1px 1px 4px 5.0 #333333b0"}, continue=false})
		local count = 20
		Timers:CreateTimer(0.0, function()
		Notifications:BottomToAll({text=count, duration=1.0, style={color="rgb(200, 200, 200)", ["font-size"]="24px", ["text-shadow"]="1px 1px 4px 5.0 #333333b0"}, continue=false})
			count = count - 1
			return 1.0
		end)

	end

	EncounterTries = 0

	Timers:CreateTimer(2.0, function()
		Notifications:TopToAll({text="Encounter defeated!", duration=5, style={color="rgb(32, 200, 32)", ["font-size"]="55px", ["text-shadow"]="1px 1px 4px 5.0 #333333b0"}, continue=false})
		EmitGlobalSound("announcer_ann_custom_end_01")

		HeroesRevive()

		-- Checklist
		ShowEncounterDefeatedChecklist()

		Timers:CreateTimer(2.0, function()

			if GetRound() < 6 or ClassicSubMode_Endless or (GetRound() < 8 and GameMode_Active == "Challenger") then

				EmitGlobalSound("announcer_ann_custom_round_begin_01")

				-- Loot
				LootOverviewStart(time_spent)
				ChecklistUpdateItems(nil, {"empower"}, "in_progress")

				-- Shop
				Entities:FindByName(nil, "shop"):Enable()

				-- Heroe Reset
				for _,hero in pairs(GetHeroesEntities()) do

					hero:Heal(999999, nil)
					hero:GiveMana(999999)

					for i=0,30 do
						local ability = hero:GetAbilityByIndex(i)
						if ability ~= nil then
							if ability:GetCooldownTimeRemaining() ~= nil then
								if ability:GetCooldownTimeRemaining() > 0 then
									ability:EndCooldown()
								end
							end
						end
					end

					hero:SetPhysicsAcceleration(Vector(0,0,0))
					hero:SetPhysicsVelocity(Vector(0,0,0))
					hero:OnPhysicsFrame(nil)
				end
			
				Timers:CreateTimer(3.0, function()
					IncrementRound()

					CustomGameEventManager:Send_ServerToAllClients("info_round", { round=GetRound() } )

					if GameMode_Active ~= "Challenger" then
						if GetRound() == 3 then
							IncrementStage()
						elseif GetRound() == 6 then
							IncrementStage()
						elseif GetRound() >= 7 and ClassicSubMode_Endless then

							if GetRound() % 12 == 0 then
								SetStage( 3 )
							else
								SetStage( RandomInt(1, 2) )
							end

						end
					end

					Timers:CreateTimer(0.1, function()
						EncounterCountdown(false)
					end)
				end)
								
			else
				Timers:CreateTimer(16.0, function()
					GameRules:SetGameWinner(DOTA_TEAM_GOODGUYS)
				end)
			end

		end)
	end)
	
end

function PlayersDefeated()

	if DEBUG then
		print("DEBUG - PlayersDefeated() ===")
		CustomGameEventManager:Send_ServerToAllClients("debug_msg", { msg="DEBUG - PlayersDefeated() === " } )
	end

	Timers:RemoveTimer(EncounterDuration_Timer)
	EncounterDuration_Timer = nil

	EncounterDamageMeterStop()

	ENCOUNTER_FIGHTS[ GetRound() .. "_" .. EncounterTries ]["boss_hp"] = GetCurrentEncounterEntity():GetHealth()
	ENCOUNTER_FIGHTS[ GetRound() .. "_" .. EncounterTries ]["boss_hp_pct"] = GetCurrentEncounterEntity():GetHealthPercent()
	ENCOUNTER_FIGHTS[ GetRound() .. "_" .. EncounterTries ]["time_end"] = Time()

	CustomGameEventManager:Send_ServerToAllClients("disable_retryfight", {} )

	EmitGlobalSound("Custom.PlayersDefeated")

	Cleanup_Persistents( true )
end

function PlayersDefeated_ShowContinue()

	if DEBUG then
		print("DEBUG - PlayersDefeated_ShowContinue() ===")
		CustomGameEventManager:Send_ServerToAllClients("debug_msg", { msg="DEBUG - PlayersDefeated_ShowContinue() === " } )
	end

	local costs = CalculateExtraLifeCost()

	if ExtraLifes[ GameMode_Active ] > 0 then
		costs = 0
	end

	if costs > 0 and ExtraLifes[ GameMode_Active ] == 0 then
		if Score-costs <= 0 then
			costs = -1

			HTTP_Aggregate_Data(false)
		end
	end

	CustomGameEventManager:Send_ServerToAllClients("on_show_continue", { phase="pick", costs=costs } )

	Notifications:BottomToAll({text="Hint: To get your game onto the Leaderboard (dungeoneer-dota2.com), make sure to surrender your game - not just leaving!", duration=Continue_PickTime, style={color="rgb(200, 200, 200)", ["font-size"]="20px", ["text-shadow"]="1px 1px 4px 5.0 #333333b0"}, continue=false})

	local time = Continue_PickTime
	Continue_Timer1 = Timers:CreateTimer(function()

		CustomGameEventManager:Send_ServerToAllClients("on_update_continue_timer", { time=time } )

		time = time - 1

		if time == -1 then return end
		return 1.0
	end)


	Continue_Timer2 = Timers:CreateTimer(time, function()
		
		if costs ~= -1 then
			HTTP_Aggregate_Data(false)
		end

		GameRules:SetGameWinner(DOTA_TEAM_NEUTRALS)
	end)

end

function GameMode:Continue_Vote(params)

	if DEBUG then
		print("DEBUG - GameMode:Continue_Vote(params) ===", DeepPrintTable(params))
		CustomGameEventManager:Send_ServerToAllClients("debug_msg", { msg="DEBUG - GameMode:Continue_Vote(params) === " } )
	end

	local vote = params.vote
	local playerID = params.playerID
	local player = PlayerResource:GetPlayer(playerID)
	local hero = player:GetAssignedHero()
	local playerName = PlayerResource:GetPlayerName(playerID)

	if vote == "continue" then
		ExtraLifesVotes_Continue = ExtraLifesVotes_Continue + 1
	elseif vote == "surrender" then
		ExtraLifesVotes_Surrender = ExtraLifesVotes_Surrender + 1
	end

	-- Notification

	local txt
	local color

	if vote == "continue" then
		txt = "wants to continue!"
		color = "green"
	elseif vote == "surrender" then
		txt = "is ready to surrender.."
		color = "red"
	end

	local duration = 3.0
	Notifications:BottomToAll({hero=hero:GetUnitName(), duration=duration})
	Notifications:BottomToAll({text=playerName.." ", style={["font-size"]="18px", ["text-shadow"]="1px 1px 4px 5.0 #333333b0", ["text-shadow"]="1px 1px 4px 5.0 #333333b0"}, continue=true, duration=duration})
	Notifications:BottomToAll({text=" "..txt, style={["font-size"]="18px", ["text-shadow"]="1px 1px 4px 5.0 #333333b0", ["text-shadow"]="1px 1px 4px 5.0 #333333b0"}, color=color, continue=true, duration=duration})

	-- All players voted

	if ExtraLifesVotes_Continue + ExtraLifesVotes_Surrender == GetPlayerCountConnected() then

		Timers:RemoveTimer(Continue_Timer1)
		Timers:RemoveTimer(Continue_Timer2)

		-- Continue
		if ExtraLifesVotes_Continue > ExtraLifesVotes_Surrender then

			if ExtraLifes[ GameMode_Active ] > 0 then
				ExtraLifes[ GameMode_Active ] = ExtraLifes[ GameMode_Active ] - 1
			else
				InfoAlterScore(CalculateExtraLifeCost() * -1)
			end

			HeroesRevive()

			EncounterHealthMultiplier = EncounterHealthMultiplier_Last

			Timers:CreateTimer(0.5, function()
				EnforceCurrentEncounter(true)
			end)

			Timers:CreateTimer(1.0, function()
				EncounterCountdown(true)
			end)

			Notifications:TopToAll({text="The game goes on!", style={["font-size"]="40px", ["text-shadow"]="1px 1px 4px 5.0 #333333b0"}, continue=false, duration=duration})

		-- Surrender
		else
			HTTP_Aggregate_Data(false)
			GameRules:SetGameWinner(DOTA_TEAM_NEUTRALS)
		end

		ExtraLifesVotes_Continue = 0
		ExtraLifesVotes_Surrender = 0

	end
end

function GameMode:Encounter_Retry()

	if DEBUG then
		print("DEBUG - GameMode:Encounter_Retry() ===")
		CustomGameEventManager:Send_ServerToAllClients("debug_msg", { msg="DEBUG - GameMode:Encounter_Retry() === " } )
	end

	local playerCount = GetPlayerCountConnected()
	local votesNeeded = math.floor(playerCount / 2) + 1

	if playerCount == 1 then
		EncounterRetry()
		return
	end

	if EncounterRetryVotes_Timer == nil then
		EncounterRetryVotes_Timer = Timers:CreateTimer(10, function()

			EncounterRetryVotes = 0

			CustomGameEventManager:Send_ServerToAllClients("enable_retryfight", {} )

			Notifications:TopToAll({text="Encounter retry vote not passed", duration=5, style={color="#ff802b", ["font-size"]="40px", ["text-shadow"]="1px 1px 4px 5.0 #333333b0"}, continue=false})

			EncounterRetryVotes_Timer = nil
		end)
		PersistentTimer_Add(EncounterRetryVotes_Timer)
	end

	EncounterRetryVotes = EncounterRetryVotes + 1

	Notifications:TopToAll({text="Encounter retry votes: " .. EncounterRetryVotes .. " / " .. votesNeeded, duration=12, style={color="rgb(32, 132, 200)", ["font-size"]="40px", ["text-shadow"]="1px 1px 4px 5.0 #333333b0"}, continue=false})

	if EncounterRetryVotes >= votesNeeded then

		Timers:RemoveTimer(EncounterRetryVotes_Timer)
		EncounterRetryVotes_Timer = nil

		EncounterRetryVotes = 0

		EncounterRetry()
	end
end

function EncounterRetry()

	if DEBUG then
		print("DEBUG - EncounterRetry() ===")
		CustomGameEventManager:Send_ServerToAllClients("debug_msg", { msg="DEBUG - EncounterRetry() === " } )
	end

	local timer = Timers:CreateTimer(0, function()
		if CheckHeroesAlive() then

			for _,hero in pairs( GetHeroesAliveEntities() ) do

				local mod1 = hero:FindAllModifiersByName("greater_cheat_death")
				local mod2 = hero:FindAllModifiersByName("greater_cheat_death_buff1")

				if mod1[1] ~= nil then
					for i,modifier in pairs(mod1) do
						modifier.deactivated = true
					end
					for i,modifier in pairs(mod2) do
						modifier.deactivated = true
					end

					Timers:CreateTimer(0.1, function()
						EncounterApplyDamage(hero, GetCurrentEncounterEntity(), nil, 10000, DAMAGE_TYPE_PURE, DOTA_DAMAGE_FLAG_BYPASSES_INVULNERABILITY + DOTA_DAMAGE_FLAG_BYPASSES_BLOCK + DOTA_DAMAGE_FLAG_NO_DAMAGE_MULTIPLIERS)
					end)

					Timers:CreateTimer(0.2, function()
						for i,modifier in pairs(mod1) do
							modifier.deactivated = false
						end
						for i,modifier in pairs(mod2) do
							modifier.deactivated = false
						end
					end)
				else
					EncounterApplyDamage(hero, GetCurrentEncounterEntity(), nil, 10000, DAMAGE_TYPE_PURE, DOTA_DAMAGE_FLAG_BYPASSES_INVULNERABILITY + DOTA_DAMAGE_FLAG_BYPASSES_BLOCK + DOTA_DAMAGE_FLAG_NO_DAMAGE_MULTIPLIERS)
				end

			end

			return 0.05
		else
			return
		end
	end)

	Timers:CreateTimer(1.0, function()
		Timers:RemoveTimer(timer)
		timer = nil
	end)

end

function GameMode:Encounter_Ready()

	if DEBUG then
		print("DEBUG - GameMode:Encounter_Ready() ===")
		CustomGameEventManager:Send_ServerToAllClients("debug_msg", { msg="DEBUG - GameMode:Encounter_Ready() === " } )
	end

	local playerCount = GetPlayerCountConnected()
	local votesNeeded = GetPlayerCountConnected()--math.floor(playerCount / 2) + 1

	if playerCount == 1 then

		EncounterReadyVotes = 0

		Timers:RemoveTimer(EncounterCountdown_End_Timer)
		EncounterCountdown_End_Timer = nil

		EncounterCountdown_End()
		return
	end

	if EncounterReadyVotes_Timer == nil then
		EncounterReadyVotes_Timer = Timers:CreateTimer(20, function()

			EncounterReadyVotes = 0

			CustomGameEventManager:Send_ServerToAllClients("enable_ready", {} )

			Notifications:TopToAll({text="Ready check not passed", duration=5, style={color="#ff802b", ["font-size"]="40px", ["text-shadow"]="1px 1px 4px 5.0 #333333b0"}, continue=false})

			EncounterReadyVotes_Timer = nil
		end)
		PersistentTimer_Add(EncounterReadyVotes_Timer)
	end

	EncounterReadyVotes = EncounterReadyVotes + 1

	Notifications:TopToAll({text="Ready check: " .. EncounterReadyVotes .. " / " .. votesNeeded, duration=12, style={color="rgb(32, 132, 200)", ["font-size"]="40px", ["text-shadow"]="1px 1px 4px 5.0 #333333b0"}, continue=false})

	if EncounterReadyVotes >= votesNeeded then

		Timers:RemoveTimer(EncounterReadyVotes_Timer)
		EncounterReadyVotes_Timer = nil

		EncounterReadyVotes = 0

		Timers:RemoveTimer(EncounterCountdown_End_Timer)
		EncounterCountdown_End_Timer = nil

		EncounterCountdown_End()
	end

end


function HeroesRevive()

	if DEBUG then
		print("DEBUG - HeroesRevive() ===")
		CustomGameEventManager:Send_ServerToAllClients("debug_msg", { msg="DEBUG - HeroesRevive() === " } )
	end

	for _,hero in pairs(GetHeroesDeadEntities()) do
		hero:RespawnHero(false, false)
		Timers:CreateTimer(0.1, function()
			FindClearSpaceForUnit(hero, GetSpecificBorderPoint("point_center"), false)
			hero:AddNewModifier(hero, nil, "modifier_invulnerable", { duration = 5.0 } )

			if PlayerResource:GetConnectionState(_-1) == 2 then
				-- Camera --
				PlayerResource:SetCameraTarget(_-1, hero)
				Timers:CreateTimer(2.00, function()
					PlayerResource:SetCameraTarget(_-1, nil)
				end)
			end
		end)
	end
end

function EncounterDamageMeter()

	if DEBUG then
		print("DEBUG - EncounterDamageMeter() ===")
		CustomGameEventManager:Send_ServerToAllClients("debug_msg", { msg="DEBUG - EncounterDamageMeter() === " } )
	end

	GetCurrentEncounterEntity():AddNewModifier(GetCurrentEncounterEntity(), nil, "damage_meter", {})

	for _,hero in pairs( GetHeroesEntities() ) do
		GameRules.DAMAGE_METER[hero:GetUnitName()] = nil
	end

	GameRules.DAMAGE_METER_BOSS_TIMER_TIME = 0
	GameRules.DAMAGE_METER_BOSS_TIMER[ GetEncounterCodeName(GetCurrentEncounter()) ] = Timers:CreateTimer(function()
		local heroData = {}
		local sort = {}
		local heroesTotalDamage = {}

		GameRules.DAMAGE_METER_TOTAL_DAMAGE = 0

		for _,hero in pairs( GetHeroesEntities() ) do
			heroesTotalDamage[hero:GetUnitName()] = 0
			if GameRules.DAMAGE_METER[hero:GetUnitName()] ~= nil then
				for _,damage in pairs(GameRules.DAMAGE_METER[hero:GetUnitName()]) do
					heroesTotalDamage[hero:GetUnitName()] = math.floor( heroesTotalDamage[hero:GetUnitName()] + damage )
				end
			end

			GameRules.DAMAGE_METER_TOTAL_DAMAGE = math.floor( GameRules.DAMAGE_METER_TOTAL_DAMAGE + heroesTotalDamage[hero:GetUnitName()] )

		end

		for _,hero in pairs( GetHeroesEntities() ) do
			local name = hero:GetUnitName()
			local label = PlayerResource:GetPlayerName( hero:GetPlayerOwnerID() )--GameRules.HERO_TRANSLATE_READABLE[hero:GetUnitName()]
			local value = math.floor( heroesTotalDamage[hero:GetUnitName()] )

			GameRules.DAMAGE_METER_TOTAL_DAMAGE_HERO[name] = value

			local percentage
			if GameRules.DAMAGE_METER_TOTAL_DAMAGE > 0 and heroesTotalDamage[hero:GetUnitName()] > 0 then
				percentage = math.floor( ( heroesTotalDamage[hero:GetUnitName()] / GameRules.DAMAGE_METER_TOTAL_DAMAGE ) * 100 )
			elseif percentage == nil then
				percentage = 0
			end

			local dps = math.floor(value / GameRules.DAMAGE_METER_BOSS_TIMER_TIME)

			GameRules.DAMAGE_METER_DPS_HERO[name] = dps
			GameRules.DAMAGE_METER_DAMAGE_PERCENTAGE_HERO[name] = percentage

			heroData[_] = {name=name, label=label, value=value, percentage=percentage, dps=dps}
			table.insert(sort, value)

		end

		table.sort(sort)

		for i=#sort,1,-1 do
			for _,v in pairs(heroData) do

				if sort[i] == v.value then
					CustomGameEventManager:Send_ServerToAllClients("on_remove_damagemeter_line", { name=v.name } )
					CustomGameEventManager:Send_ServerToAllClients("on_new_damagemeter_line", { name=v.name, label=v.label, value=v.value, percentage=v.percentage, dps=v.dps } )
				end

			end
		end
		
		GameRules.DAMAGE_METER_BOSS_TIMER_TIME = GameRules.DAMAGE_METER_BOSS_TIMER_TIME + 0.25
		return 0.25
	end)
end

function EncounterDamageMeterStop()

	if DEBUG then
		print("DEBUG - EncounterDamageMeterStop() ===")
		CustomGameEventManager:Send_ServerToAllClients("debug_msg", { msg="DEBUG - EncounterDamageMeterStop() === " } )
	end

	for _,hero in pairs(GetHeroesEntities()) do
		if ENCOUNTER_FIGHTS[ GetRound() .. "_" .. EncounterTries ] then
		if ENCOUNTER_FIGHTS[ GetRound() .. "_" .. EncounterTries ]["dps"] then
		if ENCOUNTER_FIGHTS[ GetRound() .. "_" .. EncounterTries ]["dps"][hero:GetUnitName()] then
		if GameRules.DAMAGE_METER_DPS_HERO[hero:GetUnitName()] ~= nil then

			ENCOUNTER_FIGHTS[ GetRound() .. "_" .. EncounterTries ]["dps"][hero:GetUnitName()] = GameRules.DAMAGE_METER_DPS_HERO[hero:GetUnitName()]
			ENCOUNTER_FIGHTS[ GetRound() .. "_" .. EncounterTries ]["damage_done"][hero:GetUnitName()] = GameRules.DAMAGE_METER_TOTAL_DAMAGE_HERO[hero:GetUnitName()]
			ENCOUNTER_FIGHTS[ GetRound() .. "_" .. EncounterTries ]["damage_done_pct"][hero:GetUnitName()] = GameRules.DAMAGE_METER_DAMAGE_PERCENTAGE_HERO[hero:GetUnitName()]
		
		end
		end
		end
		end
	end

	Timers:RemoveTimer(GameRules.DAMAGE_METER_BOSS_TIMER[ GetEncounterCodeName(GetCurrentEncounter()) ])
	GameRules.DAMAGE_METER_BOSS_TIMER[ GetEncounterCodeName(GetCurrentEncounter()) ] = nil

end
