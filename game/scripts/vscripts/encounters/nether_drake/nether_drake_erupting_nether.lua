nether_drake_erupting_nether = class({})

function nether_drake_erupting_nether:OnSpellStart()

	local victim		= GetRandomHeroEntities(1)
	if not victim then return end
	victim				= victim[1]
	local victim_loc	= victim:GetAbsOrigin()

	--- Get Caster, Victim, Player, Point ---
	local caster		= self:GetCaster()
	local caster_loc	= caster:GetAbsOrigin()
	local playerID		= caster:GetPlayerOwnerID()
	local player		= PlayerResource:GetPlayer(playerID)
	local team			= caster:GetTeamNumber()
	
	--- Get Special Values ---
	local AoERadius                   = self:GetSpecialValueFor("AoERadius")
	local damage                      = self:GetSpecialValueFor("damage")
	local delay                       = self:GetSpecialValueFor("delay")

	caster:AddNewModifier(caster, self, "casting_rooted_modifier", {duration=delay})
	DisableMotionControllers(caster, delay)

	-- Sound and Animation --
	StartAnimation(caster, {duration=delay, activity=ACT_DOTA_DISABLED, rate=0.4})

	local pattern = {}
	table.insert( pattern, { ["start"] = GetSpecificBorderPoint("point_top_left"), ["end"] = GetSpecificBorderPoint("point_right") } )
	table.insert( pattern, { ["start"] = GetSpecificBorderPoint("point_top_left"), ["end"] = GetSpecificBorderPoint("point_bottom") } )
	table.insert( pattern, { ["start"] = GetSpecificBorderPoint("point_top_right"), ["end"] = GetSpecificBorderPoint("point_left") } )
	table.insert( pattern, { ["start"] = GetSpecificBorderPoint("point_top_right"), ["end"] = GetSpecificBorderPoint("point_bottom") } )
	table.insert( pattern, { ["start"] = GetSpecificBorderPoint("point_bottom_right"), ["end"] = GetSpecificBorderPoint("point_top") } )
	table.insert( pattern, { ["start"] = GetSpecificBorderPoint("point_bottom_left"), ["end"] = GetSpecificBorderPoint("point_top") } )
	table.insert( pattern, { ["start"] = GetSpecificBorderPoint("point_top"), ["end"] = GetSpecificBorderPoint("point_bottom") } )
	table.insert( pattern, { ["start"] = GetSpecificBorderPoint("point_left"), ["end"] = GetSpecificBorderPoint("point_right") } )
	
	local chosen_pattern = pattern[RandomInt(1, #pattern)]

	local timers = {}
	for i=0,4 do

		local count = 0

		timers[i] = Timers:CreateTimer(0, function()
			loc_start = chosen_pattern["start"]
			loc_end = chosen_pattern["end"]
			loc_forward_vec = (loc_end - loc_start):Normalized()

			loc_start_cross = loc_start:Cross(loc_forward_vec)
			loc_end_cross = loc_end:Cross(loc_forward_vec)

			local factor1 = RandomFloat(1.00, 2.00)
			local factor2 = RandomFloat(3.00, 4.00)

			if i == 1 then
				loc_start = loc_start_cross * Vector(factor1,factor1,0) + loc_start
				loc_end = loc_end_cross * Vector(factor1,factor1,0) + loc_end
			end

			if i == 2 then
				loc_start = loc_start_cross * Vector(-factor1,-factor1,0) + loc_start
				loc_end = loc_end_cross * Vector(-factor1,-factor1,0) + loc_end
			end

			if i == 3 then
				loc_start = loc_start_cross * Vector(factor2,factor2,0) + loc_start
				loc_end = loc_end_cross * Vector(factor2,factor2,0) + loc_end
			end

			if i == 4 then
				loc_start = loc_start_cross * Vector(-factor2,-factor2,0) + loc_start
				loc_end = loc_end_cross * Vector(-factor2,-factor2,0) + loc_end
			end

			local initial_distance = (loc_end - loc_start):Length2D()
			local warnings_steps = AoERadius * 2
			local warnings_count = initial_distance / warnings_steps

			local point = loc_start + ( (loc_forward_vec * warnings_steps) * count )
			point = point * Vector(1,1,0)
			point = point + ( GetGroundPosition(point, caster) * Vector(0,0,1) )

			EncounterGroundAOEWarningSticky(point, AoERadius, delay+0.25)

			local timer = Timers:CreateTimer(delay, function()

				-- Sound --
				StartSoundEventFromPosition("Hero_Phoenix.FireSpirits.Target", point)

				-- Particle --
				--local particle = ParticleManager:CreateParticle("particles/dire_fx/bad_ancient002_pit_lava_blast.vpcf", PATTACH_CUSTOMORIGIN, nil)
				local particle = ParticleManager:CreateParticle("particles/econ/items/abaddon/abaddon_alliance/abaddon_death_coil_alliance_explosion.vpcf", PATTACH_CUSTOMORIGIN, nil)
				ParticleManager:SetParticleControl( particle, 1, point )
				ParticleManager:ReleaseParticleIndex( particle )
				particle = nil

				-- DOTA_UNIT_TARGET_TEAM_FRIENDLY; DOTA_UNIT_TARGET_TEAM_ENEMY; DOTA_UNIT_TARGET_TEAM_BOTH
				local units	= FindUnitsInRadius(team, point, nil, AoERadius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
				for _,victim in pairs(units) do
					-- Apply Damage --
					EncounterApplyDamage(victim, caster, self, damage, DAMAGE_TYPE_MAGICAL, DOTA_DAMAGE_FLAG_NONE)
				end

			end)
			PersistentTimer_Add(timer)

			count = count + 1
			if count >= warnings_count then
				return
			else
				return RandomFloat(0.4, 0.8)
			end
		end)
		PersistentTimer_Add(timers[i])
	end

	local timer = Timers:CreateTimer(delay+5.0, function()
		for i=0,4 do
			Timers:RemoveTimer(timers[i])
			timers[i] = nil
		end
	end)
	PersistentTimer_Add(timer)

end

function nether_drake_erupting_nether:OnAbilityPhaseStart()
	local caster			= self:GetCaster()
	local playerID			= caster:GetPlayerOwnerID()
	local player			= PlayerResource:GetPlayer(playerID)

	return true
end

function nether_drake_erupting_nether:GetManaCost(abilitylevel)
	return self.BaseClass.GetManaCost(self, abilitylevel)
end

function nether_drake_erupting_nether:GetCooldown(abilitylevel)
	return self.BaseClass.GetCooldown(self, abilitylevel)
end