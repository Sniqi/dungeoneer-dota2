-- CONSTANTS

local ARENAS = { "ancient_garden", "uncharted_desert", "battlefield_of_eternity", "red_dragon_plateau", "wastelands_of_blight", "the_abyss" }
--local ARENAS = { "red_dragon_plateau" }

local ARENA_READABLE = {}
ARENA_READABLE["ancient_garden"] = "Ancient Garden"
ARENA_READABLE["uncharted_desert"] = "Uncharted Desert"
ARENA_READABLE["battlefield_of_eternity"] = "Battlefield of Eternity"
ARENA_READABLE["red_dragon_plateau"] = "Red Dragon Plateau"
ARENA_READABLE["wastelands_of_blight"] = "Wastelands of Blight"
ARENA_READABLE["the_abyss"] = "The Abyss"

local ACTIVE_ARENA = nil

-- FUNCTIONS

function ConvertArenaName(arenaName)
	return ARENA_READABLE[arenaName]
end

function GetRandomPointWithinArena(offset)

	if offset == nil then
		offset = 150
	end

	local arena = GetActiveArena()

	local point_left_x         = Entities:FindByName( nil, arena.."_border_left"):GetAbsOrigin().x + offset
	local point_right_x        = Entities:FindByName( nil, arena.."_border_right"):GetAbsOrigin().x - offset
	local point_top_y          = Entities:FindByName( nil, arena.."_border_top"):GetAbsOrigin().y - offset
	local point_bottom_y       = Entities:FindByName( nil, arena.."_border_bottom"):GetAbsOrigin().y + offset

	local random_loc = Vector( RandomFloat(point_left_x, point_right_x) , RandomFloat(point_top_y, point_bottom_y) , 0 )

	random_loc = GetGroundPosition( random_loc, GetCurrentEncounterEntity() )

	return random_loc
end

function GetSpecificBorderPoint(point)

	local arena = GetActiveArena()

	if point == "point_center" then
		return Entities:FindByName( nil, arena.."_center"):GetAbsOrigin()
	end
	if point == "point_left" then
		return Entities:FindByName( nil, arena.."_border_left"):GetAbsOrigin()
	end
	if point == "point_top" then
		return Entities:FindByName( nil, arena.."_border_top"):GetAbsOrigin()
	end
	if point == "point_right" then
		return Entities:FindByName( nil, arena.."_border_right"):GetAbsOrigin()
	end
	if point == "point_bottom" then
		return Entities:FindByName( nil, arena.."_border_bottom"):GetAbsOrigin()
	end
	if point == "point_top_left" then
		return Entities:FindByName( nil, arena.."_border_top_left"):GetAbsOrigin()
	end
	if point == "point_top_right" then
		return Entities:FindByName( nil, arena.."_border_top_right"):GetAbsOrigin()
	end
	if point == "point_bottom_right" then
		return Entities:FindByName( nil, arena.."_border_bottom_right"):GetAbsOrigin()
	end
	if point == "point_bottom_left" then
		return Entities:FindByName( nil, arena.."_border_bottom_left"):GetAbsOrigin()
	end

	return nil
end

function GetRandomBorderPoint()

	local arena = GetActiveArena()

	local point_left         = Entities:FindByName( nil, arena.."_border_left"):GetAbsOrigin()
	local point_top          = Entities:FindByName( nil, arena.."_border_top"):GetAbsOrigin()
	local point_right        = Entities:FindByName( nil, arena.."_border_right"):GetAbsOrigin()
	local point_bottom       = Entities:FindByName( nil, arena.."_border_bottom"):GetAbsOrigin()
	local point_top_left     = Entities:FindByName( nil, arena.."_border_top_left"):GetAbsOrigin()
	local point_top_right    = Entities:FindByName( nil, arena.."_border_top_right"):GetAbsOrigin()
	local point_bottom_right = Entities:FindByName( nil, arena.."_border_bottom_right"):GetAbsOrigin()
	local point_bottom_left  = Entities:FindByName( nil, arena.."_border_bottom_left"):GetAbsOrigin()

	local random_points = {point_left, point_top, point_right, point_bottom,
						point_top_left, point_top_right, point_bottom_right, point_bottom_left}

	local random_point = random_points[ RandomInt(1, #random_points) ]

	return random_point
end

function GetRandomCornerPoint()

	local arena = GetActiveArena()

	local point_top_left     = Entities:FindByName( nil, arena.."_border_top_left"):GetAbsOrigin()
	local point_top_right    = Entities:FindByName( nil, arena.."_border_top_right"):GetAbsOrigin()
	local point_bottom_right = Entities:FindByName( nil, arena.."_border_bottom_right"):GetAbsOrigin()
	local point_bottom_left  = Entities:FindByName( nil, arena.."_border_bottom_left"):GetAbsOrigin()

	local random_points = {point_top_left, point_top_right, point_bottom_right, point_bottom_left}

	local random_point = random_points[ RandomInt(1, #random_points) ]

	return random_point
end

function GetRandomBorderPoint_Name()

	local arena = GetActiveArena()

	local point_left         = "point_left"
	local point_top          = "point_top"
	local point_right        = "point_right"
	local point_bottom       = "point_bottom"
	local point_top_left     = "point_top_left"
	local point_top_right    = "point_top_right"
	local point_bottom_right = "point_bottom_left"
	local point_bottom_left  = "point_bottom_right"

	local random_points = {point_left, point_top, point_right, point_bottom,
						point_top_left, point_top_right, point_bottom_right, point_bottom_left}

	local random_point = random_points[ RandomInt(1, #random_points) ]

	return random_point
end

function GetRandomBorderPointCounterpart(point)

	local arena = GetActiveArena()

	local point_left         = Entities:FindByName( nil, arena.."_border_left"):GetAbsOrigin()
	local point_top          = Entities:FindByName( nil, arena.."_border_top"):GetAbsOrigin()
	local point_right        = Entities:FindByName( nil, arena.."_border_right"):GetAbsOrigin()
	local point_bottom       = Entities:FindByName( nil, arena.."_border_bottom"):GetAbsOrigin()
	local point_top_left     = Entities:FindByName( nil, arena.."_border_top_left"):GetAbsOrigin()
	local point_top_right    = Entities:FindByName( nil, arena.."_border_top_right"):GetAbsOrigin()
	local point_bottom_right = Entities:FindByName( nil, arena.."_border_bottom_right"):GetAbsOrigin()
	local point_bottom_left  = Entities:FindByName( nil, arena.."_border_bottom_left"):GetAbsOrigin()

	local all_points = {point_left, point_top, point_right, point_bottom,
						point_top_left, point_top_right, point_bottom_right, point_bottom_left}

	local border_left         = {"border_left", point_top_left, point_left, point_bottom_left}
	local border_top          = {"border_top", point_top_left, point_top, point_top_right}
	local border_right        = {"border_right", point_top_right, point_right, point_bottom_right}
	local border_bottom       = {"border_bottom", point_bottom_left, point_bottom, point_bottom_right}
	local corner_top_left     = {"corner_top_left", point_top, point_left, point_top_left}
	local corner_top_right    = {"corner_top_right", point_top, point_right, point_top_right}
	local corner_bottom_left  = {"corner_bottom_left", point_bottom, point_left, point_bottom_left}
	local corner_bottom_right = {"corner_bottom_right", point_bottom, point_right, point_bottom_right}

	local random_points = {border_left, border_top, border_right, border_bottom,
						corner_top_left, corner_top_right, corner_bottom_left, corner_bottom_right}

	local potential_border = {}
	for _,pnts in pairs(random_points) do
		local test = false
		for _,pnt in pairs(pnts) do
			if point == pnt then test = true end
		end
		if test then table.insert(potential_border, pnts) end
	end

	local chosen_border = potential_border[ RandomInt(1, #potential_border) ]

	local counterpart = {}

	counterpart["border_left"]         = border_right
	counterpart["border_top"]          = border_bottom
	counterpart["border_right"]        = border_left
	counterpart["border_bottom"]       = border_top
	counterpart["corner_top_left"]     = corner_bottom_right
	counterpart["corner_top_right"]    = corner_bottom_left
	counterpart["corner_bottom_left"]  = corner_top_right
	counterpart["corner_bottom_right"] = corner_top_left

	local counter_point = counterpart[ chosen_border[1] ]

	counter_point = counter_point[ RandomInt(2, #counter_point) ]

	return counter_point
end

function SetActiveArena(arena)
	ACTIVE_ARENA = arena
end

function GetActiveArena()
	return ACTIVE_ARENA
end

function GetRandomArena()
	return ARENAS[ RandomInt(1, #ARENAS) ]
end

function GetEncounterArena()

	local possible_arenas = {}

	possible_arenas = ENCOUNTERS_ARENA[ GetCurrentEncounter() ]

	if RandomInt(0, 100) < 33 then
		ACTIVE_ARENA = possible_arenas[ RandomInt(2, #possible_arenas) ]
	else
		ACTIVE_ARENA = possible_arenas[1]
	end
end

function ArenaOutOfBoundsDetector()

	-- Out of Bounds Detector --
	Timers:CreateTimer(function()

		if not DEBUG then

			local min_x = GetSpecificBorderPoint("point_top_left").x
			if GetSpecificBorderPoint("point_left").x < min_x then min_x = GetSpecificBorderPoint("point_left").x end
			if GetSpecificBorderPoint("point_bottom_left").x < min_x then min_x = GetSpecificBorderPoint("point_bottom_left").x end

			local min_y = GetSpecificBorderPoint("point_bottom_left").y
			if GetSpecificBorderPoint("point_bottom").y < min_y then min_y = GetSpecificBorderPoint("point_bottom").y end
			if GetSpecificBorderPoint("point_bottom_right").y < min_y then min_y = GetSpecificBorderPoint("point_bottom_right").y end

			local max_x = GetSpecificBorderPoint("point_top_right").x
			if GetSpecificBorderPoint("point_right").x > max_x then max_x = GetSpecificBorderPoint("point_right").x end
			if GetSpecificBorderPoint("point_bottom_right").x > max_x then max_x = GetSpecificBorderPoint("point_bottom_right").x end

			local max_y = GetSpecificBorderPoint("point_top_left").y
			if GetSpecificBorderPoint("point_top").y > max_y then max_y = GetSpecificBorderPoint("point_top").y end
			if GetSpecificBorderPoint("point_top_right").y > max_y then max_y = GetSpecificBorderPoint("point_top_right").y end

			for _,hero in pairs(GetHeroesEntities()) do

				if hero:GetAbsOrigin().z < -10000 or
					hero:GetAbsOrigin().x < min_x-250 or hero:GetAbsOrigin().y < min_y-250 or
					hero:GetAbsOrigin().x > max_x+250 or hero:GetAbsOrigin().y > max_y+250 then

					FindClearSpaceForUnit(hero, GetSpecificBorderPoint("point_center"), false)

					Notifications:Bottom(hero:GetPlayerOwnerID(), {text="You cannot escape the Dungeoneer's will.", duration=5.0, style={color="rgb(200, 32, 32)", ["font-size"]="24px", ["text-shadow"]="1px 1px 4px 5.0 #333333b0"}, continue=false})

					PlayerResource:SetCameraTarget(hero:GetPlayerOwnerID(), hero)

					Timers:CreateTimer(0.5, function()
						PlayerResource:SetCameraTarget(hero:GetPlayerOwnerID(), nil)
					end)
				end
			end

		end

		return 1.0
	end)

end