-- CONSTANTS

CurrencyTranslate = {}
CurrencyTranslate["gold"] = "Gold"
CurrencyTranslate["artifact"] = "Artifact Fragments"
CurrencyTranslate["glyph"] = "Glyph Particles"
CurrencyTranslate["level"] = "Level"

PlayerCurrencies = {}

local PlayerEmpowers = {}

local Player_Currency_Loot = {}
local Player_Currency_Multipliers = {}

EmpowerMultiplier = 1.25

local LOOT_OVERVIEW_PICK_TIME = 30
local LOOT_OVERVIEW_TIMER1 = {}
local LOOT_OVERVIEW_TIMER2 = {}

local CurrenciesInitialize_Done = false

-- FUNCTIONS

function CurrenciesInitialize()

	if DEBUG then
		print("DEBUG - CurrenciesInitialize() ===")
		CustomGameEventManager:Send_ServerToAllClients("debug_msg", { msg="DEBUG - CurrenciesInitialize() === " } )
	end

	for playerID=0,GetPlayerCount()-1 do

		PlayerCurrencies[playerID] = {}
		PlayerEmpowers[playerID] = {}
		Player_Currency_Loot[playerID] = {}
		Player_Currency_Multipliers[playerID] = {}

		PlayerEmpowers[playerID] = "gold"

		for currency,currencyReadable in pairs(CurrencyTranslate) do

			PlayerCurrencies[playerID][currency] = 0
			if DEBUG then
				PlayerCurrencies[playerID][currency] = 100000
			end
			Player_Currency_Loot[playerID][currency] = 0
			Player_Currency_Multipliers[playerID][currency] = 1.0

			if currency == "glyph" or currency == "artifact" then
				CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(playerID), "on_new_currency", { name=currency, name_readable=CurrencyTranslate[currency], value=PlayerCurrencies[playerID][currency] } )
			end

		end

		LOOT_OVERVIEW_TIMER1[playerID] = nil
		LOOT_OVERVIEW_TIMER2[playerID] = nil

	end

end

function Currency_Modify(playerID, value, currency)
	PlayerCurrencies[playerID][currency] = PlayerCurrencies[playerID][currency] + value
	
	CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(playerID), "currency_update", { name=currency, name_readable=CurrencyTranslate[currency], value=PlayerCurrencies[playerID][currency], diff=value } )
end

function CalculateCurrencyMultiplier_Round(playerID, currency)

	if DEBUG then
		print("DEBUG - CalculateCurrency_Round() ===", currency)
		CustomGameEventManager:Send_ServerToAllClients("debug_msg", { msg="DEBUG - CalculateCurrency_Round() === "..currency } )
	end

	local hero = PlayerResource:GetPlayer(playerID):GetAssignedHero()

	local value = 1.0

	--Perks
	local perks = hero:FindAllModifiers()
	if #perks > 0 then
		for _,perk in pairs(perks) do
			if perk["currency_"..currency] ~= nil then
				value = value + ( perk["currency_"..currency] ) / 100
			end
		end
	end

	return value

end

function CalculateGoldLoot(time_spent)
	return CalculateGold_Round() + math.floor( CalculateBonusGold_Time(time_spent) )
end

function CalculateCurrencyLoot(currency)
	local round = GetRound() + 1
	return LootCurrency[currency][ GameMode_Active or "Classic" ] * ( ( round - 1 ) * ( round / 2 ) )
end

function LootOverviewStart(time_spent)
	if not CurrenciesInitialize_Done then
		CurrenciesInitialize_Done = true
		CurrenciesInitialize()
	end

	CustomGameEventManager:Send_ServerToAllClients("loot_show", {} )

	for playerID=0,GetPlayerCount()-1 do

		-- base loot

		Player_Currency_Loot[playerID]["gold"] = CalculateGoldLoot(time_spent)
		--local bonus_gold_time = math.floor( CalculateBonusGold_Time(time_spent) )

		Player_Currency_Loot[playerID]["artifact"] = CalculateCurrencyLoot("artifact")--LootCurrency["artifact"][ GameMode_Active ]

		Player_Currency_Loot[playerID]["glyph"] = CalculateCurrencyLoot("glyph")--LootCurrency["glyph"][ GameMode_Active ]

		Player_Currency_Loot[playerID]["level"] = LootXP[ GameMode_Active ]
		if GetRound() >= 6 and ClassicSubMode_Endless then
			Player_Currency_Loot[playerID]["level"] = LootXPEndless
		end

		-- player based loot modifier

		Player_Currency_Multipliers[playerID]["gold"] = CalculateCurrencyMultiplier_Round(playerID, "gold")
		Player_Currency_Multipliers[playerID]["artifact"] = CalculateCurrencyMultiplier_Round(playerID, "artifact")
		Player_Currency_Multipliers[playerID]["glyph"] = CalculateCurrencyMultiplier_Round(playerID, "glyph")
		Player_Currency_Multipliers[playerID]["level"] = CalculateCurrencyMultiplier_Round(playerID, "level")

		CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(playerID), "on_new_loot_line", { name="gold", descr="Gold", value=Player_Currency_Loot[playerID]["gold"], multiplier=Player_Currency_Multipliers[playerID]["gold"], empower=EmpowerMultiplier-1, delay="0.0" } )
		CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(playerID), "on_new_loot_line", { name="artifact", descr=CurrencyTranslate["artifact"], value=Player_Currency_Loot[playerID]["artifact"], multiplier=Player_Currency_Multipliers[playerID]["artifact"], empower=EmpowerMultiplier-1, delay="0.1" } )
		CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(playerID), "on_new_loot_line", { name="glyph", descr=CurrencyTranslate["glyph"], value=Player_Currency_Loot[playerID]["glyph"], multiplier=Player_Currency_Multipliers[playerID]["glyph"], empower=EmpowerMultiplier-1, delay="0.2" } )
		CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(playerID), "on_new_loot_line", { name="level", descr="Level", value=(Player_Currency_Loot[playerID]["level"]/100), multiplier=Player_Currency_Multipliers[playerID]["level"], empower=nil, delay="0.3" } )

		local time = LOOT_OVERVIEW_PICK_TIME
		LOOT_OVERVIEW_TIMER1[playerID] = Timers:CreateTimer(function()

			CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(playerID), "on_update_loot_overview_timer", { time=time } )

			time = time - 1

			if time == -1 then return end
			return 1.0
		end)

		LOOT_OVERVIEW_TIMER2[playerID] = Timers:CreateTimer(time+1, function()
			GiveLoot(playerID)
		end)

	end
end

function GiveLoot(playerID)

	local hero = PlayerResource:GetPlayer(playerID):GetAssignedHero()

	CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(playerID), "loot_hide", {} )

	Timers:RemoveTimer(LOOT_OVERVIEW_TIMER1[playerID])
	Timers:RemoveTimer(LOOT_OVERVIEW_TIMER2[playerID])
	LOOT_OVERVIEW_TIMER1[playerID] = nil
	LOOT_OVERVIEW_TIMER2[playerID] = nil

	Player_Currency_Loot[playerID]["gold"] = Player_Currency_Loot[playerID]["gold"] * Player_Currency_Multipliers[playerID]["gold"]
	Player_Currency_Loot[playerID]["artifact"] = Player_Currency_Loot[playerID]["artifact"] * Player_Currency_Multipliers[playerID]["artifact"]
	Player_Currency_Loot[playerID]["glyph"] = Player_Currency_Loot[playerID]["glyph"] * Player_Currency_Multipliers[playerID]["glyph"]
	Player_Currency_Loot[playerID]["level"] = Player_Currency_Loot[playerID]["level"] * Player_Currency_Multipliers[playerID]["level"]

	if PlayerEmpowers[playerID] == "gold" then
		Player_Currency_Loot[playerID]["gold"] = Player_Currency_Loot[playerID]["gold"] * EmpowerMultiplier
	end
	if PlayerEmpowers[playerID] == "artifact" then
		Player_Currency_Loot[playerID]["artifact"] = Player_Currency_Loot[playerID]["artifact"] * EmpowerMultiplier
	end
	if PlayerEmpowers[playerID] == "glyph" then
		Player_Currency_Loot[playerID]["glyph"] = Player_Currency_Loot[playerID]["glyph"] * EmpowerMultiplier
	end
	if PlayerEmpowers[playerID] == "level" then
		Player_Currency_Loot[playerID]["level"] = Player_Currency_Loot[playerID]["level"] * EmpowerMultiplier
	end
	
	hero:ModifyGold(Player_Currency_Loot[playerID]["gold"], true, DOTA_ModifyGold_Unspecified)
	Currency_Modify(playerID, Player_Currency_Loot[playerID]["artifact"], "artifact")
	Currency_Modify(playerID, Player_Currency_Loot[playerID]["glyph"], "glyph")
	hero:AddExperience(Player_Currency_Loot[playerID]["level"], DOTA_ModifyXP_HeroKill, false, true)

	-- Loot Perks
	Timers:CreateTimer(1.0, function()
		LootPerks( playerID, nil, "artifact" )
		ChecklistUpdateItems(playerID, {"empower"}, "done")
		ChecklistUpdateItems(playerID, {"artifact"}, "in_progress")
	end)

end

function GameMode:Loot_Lock( data )
	local playerID = data.playerID

	GiveLoot(playerID)
end

function GameMode:Loot_Empower( data )
	local playerID = data.playerID
	PlayerEmpowers[playerID] = data.empower
end