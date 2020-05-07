nether_drake_spreading_nether = class({})

function nether_drake_spreading_nether:OnSpellStart()

	--- Get Caster, Victim, Player, Point ---
	local caster		= self:GetCaster()
	local caster_loc	= caster:GetAbsOrigin()
	local playerID		= caster:GetPlayerOwnerID()
	local player		= PlayerResource:GetPlayer(playerID)
	local team			= caster:GetTeamNumber()
	local victim		= caster
	local victim_loc	= victim:GetAbsOrigin()

	--- Get Special Values ---
	local ability = caster:FindAbilityByName("nether_drake_deep_nether_flame")
	local AoERadius                   = ability:GetSpecialValueFor("AoERadius")
	local damage_interval             = ability:GetSpecialValueFor("damage_interval")
	local damage_per_sec              = ability:GetSpecialValueFor("damage_per_sec")
	local burning_ground_aoe          = ability:GetSpecialValueFor("burning_ground_aoe")
	
	--- Get Special Values ---
	local delay                       = self:GetSpecialValueFor("delay")
	local delay_animation = 0.45

	if caster.deep_nether_flame_locations == nil then return end

	-- Animation --
	StartAnimation(caster, {duration=2, activity=ACT_DOTA_ATTACK, rate=1.0})

	local timer = Timers:CreateTimer(delay_animation, function()
		-- Sound --
		caster:EmitSound("Hero_Jakiro.IcePath.Cast")
	end)
	PersistentTimer_Add(timer)

	local timer1 = Timers:CreateTimer(delay-delay_animation, function()

		local new_locs = {}
		local count = 0
	                   
		--for _,loc in pairs( caster.deep_nether_flame_locations ) do
		for i = #caster.deep_nether_flame_locations, 1, -1 do

			loc = caster.deep_nether_flame_locations[i]

			if count < 8 then

				local location = RandomLocationMinDistance( loc, 250)
				location = GetGroundPosition(location, caster)

				table.insert(new_locs, location)

				-- Particle --
				local particle = ParticleManager:CreateParticle("particles/encounter/nether_drake/nether_drake_deep_nether_flame_ground.vpcf", PATTACH_CUSTOMORIGIN, nil)
				ParticleManager:SetParticleControl( particle, 0, location )
				ParticleManager:SetParticleControl( particle, 3, location )
				PersistentParticle_Add(particle)

				table.insert(caster.deep_nether_flame_particles, particle)
				PersistentParticle_Add(particle)

				EncounterGroundAOEWarningSticky(location, burning_ground_aoe, 5)

				local timer2 = Timers:CreateTimer(1, function()

					-- DOTA_UNIT_TARGET_TEAM_FRIENDLY; DOTA_UNIT_TARGET_TEAM_ENEMY; DOTA_UNIT_TARGET_TEAM_BOTH
					local units	= FindUnitsInRadius(team, location, nil, burning_ground_aoe, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
					for _,victim in pairs(units) do
						-- Apply Damage --
						EncounterApplyDamage(victim, caster, self, damage_per_sec*damage_interval, DAMAGE_TYPE_MAGICAL, DOTA_DAMAGE_FLAG_NONE)
					end

					return damage_interval
				end)

				table.insert(caster.deep_nether_flame_timers, timer)
				PersistentTimer_Add(timer2)

			end

			count = count + 1

		end

		for _,loc in pairs( new_locs ) do
			table.insert(caster.deep_nether_flame_locations, loc)
		end

	end)
	PersistentTimer_Add(timer1)

end

function nether_drake_spreading_nether:OnAbilityPhaseStart()
	local caster			= self:GetCaster()
	local playerID			= caster:GetPlayerOwnerID()
	local player			= PlayerResource:GetPlayer(playerID)

	return true
end

function nether_drake_spreading_nether:GetManaCost(abilitylevel)
	return self.BaseClass.GetManaCost(self, abilitylevel)
end

function nether_drake_spreading_nether:GetCooldown(abilitylevel)
	-- ChallengerMode 1 --
	if GameMode_Active == "Challenger" and ChallengerMode_Active == 1 then
		return self.BaseClass.GetCooldown(self, abilitylevel) * 0.35
	end
	return self.BaseClass.GetCooldown(self, abilitylevel)
end