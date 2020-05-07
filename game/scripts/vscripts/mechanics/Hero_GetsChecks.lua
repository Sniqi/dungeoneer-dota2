function GetPlayerCount() --returns int
	return PlayerResource:GetPlayerCountForTeam(DOTA_TEAM_GOODGUYS)
end

function GetPlayerCountConnected() --returns int
	return PlayerResource:GetTeamPlayerCount()
end

function CheckHeroesAlive() --returns bool
	local alive = false
	--for i=0,GetPlayerCount()-1 do
	for i,hero in pairs(HeroEntities) do
		--local hero = PlayerResource:GetPlayer(i):GetAssignedHero()

		if DEBUG then
			--print("DEBUG - CheckHeroesAlive() ===", hero:GetUnitName(), hero:IsAlive())
			--CustomGameEventManager:Send_ServerToAllClients("debug_msg", { msg="DEBUG - CheckHeroesAlive() === "..tostring(hero:GetUnitName())..tostring(hero:IsAlive()) } )
		end

		if hero:IsAlive() then
			return true
		end
	end
	return false
end

function CheckHeroesAlive_Active() --returns bool
	local alive = false
	--for i=0,GetPlayerCount()-1 do
	for i,hero in pairs(HeroEntities) do
		--local hero = PlayerResource:GetPlayer(i):GetAssignedHero()
		local mod = hero:FindModifierByName("modifier_player_disconnected")

		if mod == nil then
			if DEBUG then
				--print("DEBUG - CheckHeroesAlive() ===", hero:GetUnitName(), hero:IsAlive())
				--CustomGameEventManager:Send_ServerToAllClients("debug_msg", { msg="DEBUG - CheckHeroesAlive() === "..tostring(hero:GetUnitName())..tostring(hero:IsAlive()) } )
			end

			if hero:IsAlive() then
				return true
			end
		end
	end
	return false
end

function GetHeroesAliveCount() --returns int
	local alive = 0
	--for i=0,GetPlayerCount()-1 do
	for i,hero in pairs(HeroEntities) do
		--local hero = PlayerResource:GetPlayer(i):GetAssignedHero()

		if DEBUG then
			--print("DEBUG - GetHeroesAliveCount() ===", hero:GetUnitName(), hero:IsAlive())
			--CustomGameEventManager:Send_ServerToAllClients("debug_msg", { msg="DEBUG - GetHeroesAliveCount() === "..tostring(hero:GetUnitName())..tostring(hero:IsAlive()) } )
		end

		if hero:IsAlive() then
			alive = alive + 1
		end
	end
	return alive
end

function GetHeroesAliveCount_Active() --returns int
	local alive = 0
	--for i=0,GetPlayerCount()-1 do
	for i,hero in pairs(HeroEntities) do
		--local hero = PlayerResource:GetPlayer(i):GetAssignedHero()
		local mod = hero:FindModifierByName("modifier_player_disconnected")

		if mod == nil then
			if DEBUG then
				--print("DEBUG - GetHeroesAliveCount_Active() ===", hero:GetUnitName(), hero:IsAlive())
				--CustomGameEventManager:Send_ServerToAllClients("debug_msg", { msg="DEBUG - GetHeroesAliveCount_Active() === "..tostring(hero:GetUnitName())..tostring(hero:IsAlive()) } )
			end

			if hero:IsAlive() then
				alive = alive + 1
			end
		end
	end
	return alive
end

function GetHeroesEntities() --returns table with entities
--[[
	local heroes = {}
	for i=0,GetPlayerCount()-1 do
		local player = PlayerResource:GetPlayer(i)
		if player ~= nil then
			local hero = player:GetAssignedHero()
			if hero ~= nil then
				table.insert(heroes, hero)
			end
		end
	end
	return heroes]]
	return HeroEntities
end

function GetHeroesAliveEntities() --returns table with entities
	local heroes = {}
	--for i=0,GetPlayerCount()-1 do
	for i,hero in pairs(HeroEntities) do
		--local hero = PlayerResource:GetPlayer(i):GetAssignedHero()

		if DEBUG then
			--print("DEBUG - GetHeroesAliveEntities() ===", hero:GetUnitName(), hero:IsAlive())
			--CustomGameEventManager:Send_ServerToAllClients("debug_msg", { msg="DEBUG - GetHeroesAliveEntities() === "..tostring(hero:GetUnitName())..tostring(hero:IsAlive()) } )
		end

		if hero:IsAlive() then
			table.insert(heroes, hero)
		end
	end
	return heroes
end

function GetHeroesAliveEntities_Active() --returns table with entities
	local heroes = {}
	--for i=0,GetPlayerCount()-1 do
	for i,hero in pairs(HeroEntities) do
		--local hero = PlayerResource:GetPlayer(i):GetAssignedHero()
		local mod = hero:FindModifierByName("modifier_player_disconnected")

		if mod == nil then
			if DEBUG then
				--print("DEBUG - GetHeroesAliveEntities() ===", hero:GetUnitName(), hero:IsAlive())
				--CustomGameEventManager:Send_ServerToAllClients("debug_msg", { msg="DEBUG - GetHeroesAliveEntities() === "..tostring(hero:GetUnitName())..tostring(hero:IsAlive()) } )
			end

			if hero:IsAlive() then
				table.insert(heroes, hero)
			end
		end
	end
	return heroes
end

function GetHeroesDeadEntities() --returns table with entities
	local heroes = {}
	--for i=0,GetPlayerCount()-1 do
	for i,hero in pairs(HeroEntities) do
		--local hero = PlayerResource:GetPlayer(i):GetAssignedHero()
		if not hero:IsAlive() then
			table.insert(heroes, hero)
		end
	end
	return heroes
end

function GetRandomHeroEntities(count) --returns table with entities
	if not CheckHeroesAlive_Active() then return false end

	local possible_heroes = GetHeroesAliveEntities_Active()

	if DEBUG then
		--print("DEBUG - GetRandomHeroEntities() ===", count)
		--CustomGameEventManager:Send_ServerToAllClients("debug_msg", { msg="DEBUG - GetRandomHeroEntities() === "..tostring(count) } )
		
		for i,hero in pairs(possible_heroes) do
			--print("DEBUG - GetRandomHeroEntities() possible_heroes ===", hero:GetUnitName(), hero:IsAlive())
			--CustomGameEventManager:Send_ServerToAllClients("debug_msg", { msg="DEBUG - GetRandomHeroEntities() possible_heroes === "..tostring(hero:GetUnitName())..tostring(hero:IsAlive()) } )
		end
	end

	if count >= #possible_heroes then
		return possible_heroes
	end

	local selected_victims = {}
	local selected_numbers = {}
	local number
	local numberused = false

	local test = true
	while test do
		number = RandomInt( 1, #possible_heroes )
		numberused = false

		if #selected_numbers > 0 then

			for k,v in pairs(selected_numbers) do
				if number == v then numberused = true end
			end

			if not numberused then
				table.insert(selected_numbers, number)
				table.insert(selected_victims, possible_heroes[number])
			end

		else
			table.insert(selected_numbers, number)
			table.insert(selected_victims, possible_heroes[number])
		end

		if #selected_victims == count then
			test = false
		end
	end

	return selected_victims
end

function GetNearestHeroEntity(unit) --returns entity
	if not CheckHeroesAlive_Active() then return false end

	local nearest_hero = {}

	for _,hero in pairs( GetHeroesAliveEntities_Active() ) do

		local unit_loc = unit:GetAbsOrigin()
		local hero_loc = hero:GetAbsOrigin()
		local length = ( hero_loc - unit_loc ):Length2D()

		if nearest_hero["hero"] == nil then
			nearest_hero["hero"] = hero
			nearest_hero["length"] = length
		elseif length < nearest_hero["length"] then
			nearest_hero["hero"] = hero
			nearest_hero["length"] = length
		end

	end

	return nearest_hero["hero"]
end
