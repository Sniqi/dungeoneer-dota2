local HttpDataSend = false

function HTTP_Aggregate_Data(win)
	if HttpDataSend then return end

	local gamemode = string.gsub(string.lower(GameMode_Active), " ", "_")

	if ClassicSubMode_Endless then
		gamemode = "endless"
	end

	HTTP_AddToPayload("leaderboard_"..gamemode, "version", DUNGEONEER_VERSION )

	if ClassicSubMode_Endless then
		HTTP_AddToPayload("leaderboard_"..gamemode, "game_mode", "endless" )
	else
		HTTP_AddToPayload("leaderboard_"..gamemode, "game_mode", GameMode_Active )
	end

	HTTP_AddToPayload("leaderboard_"..gamemode, "casual", ClassicSubMode_Casual )
	HTTP_AddToPayload("leaderboard_"..gamemode, "difficulty", GameMode_Difficulty )
	HTTP_AddToPayload("leaderboard_"..gamemode, "map", GetMapName() )

	HTTP_AddToPayload("leaderboard_"..gamemode, "player_count_start", PlayerCount_Start )

	HTTP_AddToPayload("leaderboard_"..gamemode, "win", win )

	HTTP_AddToPayload("leaderboard_"..gamemode, "round", GetRound() )
	HTTP_AddToPayload("leaderboard_"..gamemode, "stage", GetStage() )

	HTTP_AddToPayload("leaderboard_"..gamemode, "score", Score )
	HTTP_AddToPayload("leaderboard_"..gamemode, "time_spent", GameRules:GetGameTime() ) --Time() GameRules:GetGameTime()

	HTTP_AddToPayload("leaderboard_"..gamemode, "extra_lifes_constant", ExtraLifes_CONSTANT[GameMode_Active] )
	HTTP_AddToPayload("leaderboard_"..gamemode, "extra_lifes", ExtraLifes[GameMode_Active] )

	-- Heroes --
	for _,hero in ipairs( GetHeroesEntities() ) do
		--HTTP_AddToPayload("leaderboard_"..gamemode, "hero".._, hero:GetUnitName() )

		-- Level --
		HTTP_AddToPayload("leaderboard_"..gamemode, "hero".._.."_level", hero:GetLevel() )

		-- Perks --
		for j,perkType in pairs( PERKTYPES ) do
			if GetPerkPickCount(hero, perkType) > 0 then
				for i,mod in pairs( GetPerksPicked(hero, perkType) ) do
					HTTP_AddToPayload("leaderboard_"..gamemode, "hero".._.."_perk_"..perkType..i, mod:GetName().."="..mod.level )
				end
			end
		end
	end

	-- Steam Names & Other stats --
	local deaths		= 0
	local damageDone	= 0
	local damageTaken	= 0
	local healingDone	= 0

	for _,hero in ipairs( GetHeroesEntities() ) do
		--HTTP_AddToPayload("leaderboard_"..gamemode, "player_id_".._, tostring(PlayerResource:GetSteamID(_-1)))

		deaths = deaths + PlayerResource:GetDeaths(_-1)
		damageDone = damageDone + PlayerResource:GetRawPlayerDamage(_-1)
		damageTaken = damageTaken + PlayerResource:GetHeroDamageTaken(_-1, true)
		damageTaken = damageTaken + PlayerResource:GetCreepDamageTaken(_-1, true)
		healingDone = healingDone + PlayerResource:GetHealing(_-1)
	end

	HTTP_AddToPayload("leaderboard_"..gamemode, "deaths", deaths)
	HTTP_AddToPayload("leaderboard_"..gamemode, "damageDone", damageDone)
	HTTP_AddToPayload("leaderboard_"..gamemode, "damageTaken", damageTaken)
	HTTP_AddToPayload("leaderboard_"..gamemode, "healingDone", healingDone)

	-- Items --
	local items = {}
	for _,hero in ipairs( GetHeroesEntities() ) do
		for i=0,14 do

			local item = hero:GetItemInSlot(i)
			if item ~= nil then
				HTTP_AddToPayload("leaderboard_"..gamemode, "hero".._.."_item"..i, item:GetAbilityName())

				if item.buytime == nil then item.buytime = 0 end
				HTTP_AddToPayload("leaderboard_"..gamemode, "hero".._.."_item"..i.."_buytime", item.buytime )
			end

		end
	end

	-- Encounter Fights --
	for fight,data in pairs(ENCOUNTER_FIGHTS) do

		data["duration"] = data["time_end"] - data["time_start"]

		for key,value in pairs(data) do
			if type(value) == "table" then
				for k,v in pairs(value) do
					HTTP_AddToPayload("leaderboard_"..gamemode, "fight_"..fight.."_"..key.."_"..k, v )
				end
			else
				HTTP_AddToPayload("leaderboard_"..gamemode, "fight_"..fight.."_"..key, value )
			end
		end
	end

	HTTP_Send("/submit_post.php", "leaderboard_"..gamemode)

	HttpDataSend = true
end

function HTTP_AddToPayload(name, key, value)
	if GameRules.HTTP_PAYLOAD[name] == nil then
		GameRules.HTTP_PAYLOAD[name] = ""
	end
	GameRules.HTTP_PAYLOAD[name] = GameRules.HTTP_PAYLOAD[name]..tostring(key)..","..tostring(value)..";"
end

function HTTP_Send(path, name)
	--if not IsDedicatedServer() then return end
	if IsInToolsMode() then
		return
		--if tostring(PlayerResource:GetSteamAccountID(0)) ~= "41536950" and tostring(PlayerResource:GetSteamID(0)) ~= "76561198001802678" then return end
	end
	if not IsInToolsMode() and GameRules:IsCheatMode() then return end


	local host = "http://dungeoneer-dota2.com:1338"..path
	local key	= name
	local value	= GameRules.HTTP_PAYLOAD[name]

	-- Create the request
	local req = CreateHTTPRequestScriptVM('POST', host)
	--local encoded = json.encode(value)
	
	-- Add the data
	req:SetHTTPRequestGetOrPostParameter(key, value)

	-- Send the request
	req:Send(function(res)
		if res.StatusCode ~= 200 or not res.Body then
			if IsInToolsMode() then
				print("--HTTP-ERROR--")
				print(key)
				print(res.StatusCode)
				print(errorFailedToContactServer)
				print("--HTTP-ERROR--")
			end
			return
		end

		-- Try to decode the result
		local obj, pos, err = json.decode(res.Body, 1, nil)

		if IsInToolsMode() then
			print("--HTTP--")
			print(key)
			print(res.StatusCode)
			print("--Payload",key,value)
			print(res.Body)
			print(obj, pos, err)
			print("--HTTP--")
		end
		-- Feed the result into our callback
		--callback(err, obj)
	end)

	GameRules.HTTP_PAYLOAD[name] = ""

	return true
end