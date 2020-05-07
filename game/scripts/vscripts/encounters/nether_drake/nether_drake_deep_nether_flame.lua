nether_drake_deep_nether_flame = class({})

function nether_drake_deep_nether_flame:OnSpellStart()

	local caster		= self:GetCaster()

	local victim		= GetNearestHeroEntity(caster)
	if not victim then return end
	local victim_loc	= victim:GetAbsOrigin()

	--- Get Caster, Victim, Player, Point ---
	local caster_loc	= caster:GetAbsOrigin()
	local playerID		= caster:GetPlayerOwnerID()
	local player		= PlayerResource:GetPlayer(playerID)
	local team			= caster:GetTeamNumber()
	
	--- Get Special Values ---
	local AoERadius                   = self:GetSpecialValueFor("AoERadius")
	local damage                      = self:GetSpecialValueFor("damage")
	local damage_interval             = self:GetSpecialValueFor("damage_interval")
	local delay                       = self:GetSpecialValueFor("delay")
	local damage_per_sec              = self:GetSpecialValueFor("damage_per_sec")
	local burning_ground_aoe          = self:GetSpecialValueFor("burning_ground_aoe")

	if caster.deep_nether_flame_locations == nil then caster.deep_nether_flame_locations = {} end
	if caster.deep_nether_flame_particles == nil then caster.deep_nether_flame_particles = {} end
	if caster.deep_nether_flame_timers == nil then caster.deep_nether_flame_timers = {} end

	caster:AddNewModifier(caster, self, "casting_rooted_modifier", {duration=delay})
	DisableMotionControllers(caster, delay)
	
	TurnToLoc(caster, victim_loc, delay)

	local location
	local turn_delay = 0.5
	local anim_delay = 0.45

	local timer = Timers:CreateTimer(turn_delay, function()

		location = caster_loc + ( caster:GetForwardVector() * 300 )
		location = GetGroundPosition(location, caster)

		table.insert(caster.deep_nether_flame_locations, location)

		EncounterGroundAOEWarningSticky(location, AoERadius, delay+0.5)

	end)
	PersistentTimer_Add(timer)

	local timer1 = Timers:CreateTimer(delay-turn_delay-anim_delay, function()

		-- Animation --
		StartAnimation(caster, {duration=2, activity=ACT_DOTA_CAST_ABILITY_1, rate=1.0})

		local timer2 = Timers:CreateTimer(anim_delay, function()

			-- Particle --
			local particle = ParticleManager:CreateParticle("particles/encounter/nether_drake/nether_drake_deep_nether_flame.vpcf", PATTACH_CUSTOMORIGIN, nil)
			ParticleManager:SetParticleControl( particle, 0, caster_loc + ( caster:GetForwardVector() * 100 ) + Vector(0,0,200) )
			ParticleManager:SetParticleControl( particle, 1, caster:GetForwardVector() * 1000 )
			ParticleManager:SetParticleControl( particle, 3, caster_loc + ( caster:GetForwardVector() * 100 ) + Vector(0,0,200) )
			ParticleManager:ReleaseParticleIndex( particle )
			particle = nil

			-- Sound --
			StartSoundEventFromPositionReliable("Hero_Jakiro.DualBreath.Cast", location)

			-- DOTA_UNIT_TARGET_TEAM_FRIENDLY; DOTA_UNIT_TARGET_TEAM_ENEMY; DOTA_UNIT_TARGET_TEAM_BOTH
			local units	= FindUnitsInRadius(team, location, nil, AoERadius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
			for _,victim in pairs(units) do
				-- Apply Damage --
				EncounterApplyDamage(victim, caster, self, damage, DAMAGE_TYPE_MAGICAL, DOTA_DAMAGE_FLAG_NONE)
			end
			
			-- Particle --
			local particle = ParticleManager:CreateParticle("particles/encounter/nether_drake/nether_drake_deep_nether_flame_ground.vpcf", PATTACH_CUSTOMORIGIN, nil)
			ParticleManager:SetParticleControl( particle, 0, location )
			ParticleManager:SetParticleControl( particle, 3, location )
			PersistentParticle_Add(particle)

			table.insert(caster.deep_nether_flame_particles, particle)
			PersistentParticle_Add(particle)

			EncounterGroundAOEWarningSticky(location, burning_ground_aoe, 5)

			local timer3 = Timers:CreateTimer(1, function()

				-- DOTA_UNIT_TARGET_TEAM_FRIENDLY; DOTA_UNIT_TARGET_TEAM_ENEMY; DOTA_UNIT_TARGET_TEAM_BOTH
				local units	= FindUnitsInRadius(team, location, nil, burning_ground_aoe, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
				for _,victim in pairs(units) do
					-- Apply Damage --
					EncounterApplyDamage(victim, caster, self, damage_per_sec*damage_interval, DAMAGE_TYPE_MAGICAL, DOTA_DAMAGE_FLAG_NONE)
				end

				return damage_interval
			end)

			table.insert(caster.deep_nether_flame_timers, timer)
			PersistentTimer_Add(timer3)
		end)
		PersistentTimer_Add(timer2)

	end)
	PersistentTimer_Add(timer1)

end

function nether_drake_deep_nether_flame:OnAbilityPhaseStart()
	local caster			= self:GetCaster()
	local playerID			= caster:GetPlayerOwnerID()
	local player			= PlayerResource:GetPlayer(playerID)

	return true
end

function nether_drake_deep_nether_flame:GetManaCost(abilitylevel)
	return self.BaseClass.GetManaCost(self, abilitylevel)
end

function nether_drake_deep_nether_flame:GetCooldown(abilitylevel)
	return self.BaseClass.GetCooldown(self, abilitylevel)
end