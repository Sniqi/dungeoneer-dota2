ferocious_lava_elemental_lava_eruption = class({})

function ferocious_lava_elemental_lava_eruption:OnSpellStart()

	--- Get Caster, Victim, Player, Point ---
	local caster		= self:GetCaster()
	local caster_loc	= caster:GetAbsOrigin()
	local playerID		= caster:GetPlayerOwnerID()
	local player		= PlayerResource:GetPlayer(playerID)
	local team			= caster:GetTeamNumber()
	local victim		= caster
	local victim_loc	= victim:GetAbsOrigin()
	
	--- Get Special Values ---
	local AoERadius                   = self:GetSpecialValueFor("AoERadius")
	local duration                    = self:GetSpecialValueFor("duration")
	local damage                      = self:GetSpecialValueFor("damage")
	local delay                       = self:GetSpecialValueFor("delay")
	local phase_two_percentage        = self:GetSpecialValueFor("phase_two_percentage")
	local phase_three_percentage      = self:GetSpecialValueFor("phase_three_percentage")

	caster:AddNewModifier(caster, self, "casting_rooted_modifier", {duration=duration})
	DisableMotionControllers(caster, duration)

	-- Sound and Animation --
	local sound = {"nevermore_nev_arc_ability_requiem_02", "nevermore_nev_arc_ability_requiem_03",
					"nevermore_nev_arc_ability_requiem_04", "nevermore_nev_arc_ability_requiem_12"}
	EmitAnnouncerSound( sound[RandomInt(1, #sound)] )
	StartAnimation(caster, {duration=duration, activity=ACT_DOTA_FLAIL, rate=0.5})

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
		local extra_delay = 0

		if i == 1 then extra_delay = 1.00 end
		if i == 2 then extra_delay = 1.00 end
		if i == 3 then extra_delay = 2.00 end
		if i == 4 then extra_delay = 2.00 end

		-- PHASE 3 --
		if caster:GetHealthPercent() < phase_three_percentage then
			extra_delay = RandomFloat(2.00, 3.00)
		end

		timers[i] = Timers:CreateTimer(extra_delay, function()
			loc_start = chosen_pattern["start"]
			loc_end = chosen_pattern["end"]
			loc_forward_vec = (loc_end - loc_start):Normalized()

			loc_start_cross = loc_start:Cross(loc_forward_vec)
			loc_end_cross = loc_end:Cross(loc_forward_vec)

			local factor1 = 2.00
			local factor2 = 3.90

			-- PHASE 3 --
			if caster:GetHealthPercent() < phase_three_percentage then
				factor1 = RandomFloat(1.00, 2.00)
				factor2 = RandomFloat(3.00, 4.00)
			end

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
			local warnings_steps = AoERadius
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
				local particle = ParticleManager:CreateParticle("particles/encounter/ferocious_lava_elemental/ferocious_lava_elemental_lava_eruption.vpcf", PATTACH_CUSTOMORIGIN, nil)
				ParticleManager:SetParticleControl( particle, 0, point )
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
				return RandomFloat(0.03, 0.15)
			end
		end)
		PersistentTimer_Add(timers[i])
	end

	local timer = Timers:CreateTimer(delay+5.0, function()
		Timers:RemoveTimer(timers[0])
		Timers:RemoveTimer(timers[1])
		Timers:RemoveTimer(timers[2])
		timers[0] = nil
		timers[1] = nil
		timers[2] = nil
	end)
	PersistentTimer_Add(timer)

	-- PHASE 2 --
	local timer = Timers:CreateTimer(delay+1.5, function()
		if caster:GetHealthPercent() < phase_two_percentage then
			for i=1,GetPlayerCount()*2 do
				local unit = CreateUnitByName("lesser_lava_elemental", GetSpecificBorderPoint("point_center"), true, nil, nil, DOTA_TEAM_BADGUYS)
				PersistentUnit_Add(unit)
				EncounterCreate_AttackDamage(unit)
				EncounterCreate_Health(unit)
			end
		end
	end)
	PersistentTimer_Add(timer)

end

function ferocious_lava_elemental_lava_eruption:OnAbilityPhaseStart()
	local caster			= self:GetCaster()
	local playerID			= caster:GetPlayerOwnerID()
	local player			= PlayerResource:GetPlayer(playerID)

	return true
end

function ferocious_lava_elemental_lava_eruption:GetManaCost(abilitylevel)
	return self.BaseClass.GetManaCost(self, abilitylevel)
end

function ferocious_lava_elemental_lava_eruption:GetCooldown(abilitylevel)
	return self.BaseClass.GetCooldown(self, abilitylevel)
end