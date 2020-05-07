ancient_siege_engine_burning_wheels = class({})

LinkLuaModifier( 'ancient_siege_engine_burning_wheels_modifier', 'encounters/ancient_siege_engine/ancient_siege_engine_burning_wheels_modifier', LUA_MODIFIER_MOTION_NONE )

function ancient_siege_engine_burning_wheels:OnSpellStart()

	--- Get Caster, Victim, Player, Point ---
	local caster		= self:GetCaster()
	local caster_loc	= caster:GetAbsOrigin()
	local playerID		= caster:GetPlayerOwnerID()
	local player		= PlayerResource:GetPlayer(playerID)
	local team			= caster:GetTeamNumber()
	
	--- Get Special Values ---
	local AoERadius                   = self:GetSpecialValueFor("AoERadius")
	local duration                    = self:GetSpecialValueFor("duration")
	local damage                      = self:GetSpecialValueFor("damage")
	local damage_duration             = self:GetSpecialValueFor("damage_duration")
	local damage_interval             = self:GetSpecialValueFor("damage_interval")
	local delay                       = self:GetSpecialValueFor("delay")
	local move_speed_absolute         = self:GetSpecialValueFor("move_speed_absolute")
	local move_speed_max              = self:GetSpecialValueFor("move_speed_max")
	local phase_two                   = self:GetSpecialValueFor("phase_two")
	local phase_two_move_speed_absolute= self:GetSpecialValueFor("phase_two_move_speed_absolute")
	local phase_two_move_speed_max    = self:GetSpecialValueFor("phase_two_move_speed_max")
	local phase_two_burning_duration  = self:GetSpecialValueFor("phase_two_burning_duration")

	-- PHASE 2 --
	if caster:GetHealthPercent() < phase_two then
		damage_duration = damage_duration + phase_two_burning_duration
	end

	-- Modifier --
	caster:AddNewModifier(caster, self, "casting_modifier", {duration = duration+1})
	caster:AddNewModifier(caster, self, "ancient_siege_engine_burning_wheels_modifier", {duration = duration})

	-- Sound --
	StartSoundEventReliable("Hero_Batrider.Firefly.loop", caster)

	Timers:CreateTimer(duration, function()
		StopSoundEvent("Hero_Batrider.Firefly.loop", caster)
	end)

	local timers1 = {}
	local timers2 = {}
	local particles = {}

	local prev_point = nil

	for i=1,duration/damage_interval do

		timers1[i] = Timers:CreateTimer(damage_interval * i, function()

			if i == 1 or
				i == math.floor( (duration/damage_interval) * 0.40) or
				i == math.floor( (duration/damage_interval) * 0.80) then

				if prev_point == nil then
					prev_point = GetRandomBorderPoint()
				else
					prev_point = GetRandomBorderPointCounterpart(prev_point)
				end

				caster:MoveToPosition(prev_point)
			end

			local caster_loc = caster:GetAbsOrigin() 

			-- Particle --
			particles[i] = ParticleManager:CreateParticle("particles/units/heroes/hero_batrider/batrider_firefly.vpcf", PATTACH_CUSTOMORIGIN, nil)
			ParticleManager:SetParticleControl( particles[i], 0, caster_loc )
			PersistentParticle_Add(particles[i])

			EncounterGroundAOEWarningSticky(caster_loc, AoERadius, damage_duration)

			timers2[i] = Timers:CreateTimer(0, function()

				-- DOTA_UNIT_TARGET_TEAM_FRIENDLY; DOTA_UNIT_TARGET_TEAM_ENEMY; DOTA_UNIT_TARGET_TEAM_BOTH
				local units	= FindUnitsInRadius(team, caster_loc, nil, AoERadius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
				local particle = {}
				for _,victim in pairs(units) do
				
					-- Sound --
					victim:EmitSound("Hero_Batrider.Firefly.Cast")

					-- Apply Damage --
					EncounterApplyDamage(victim, caster, self, damage*damage_interval, DAMAGE_TYPE_MAGICAL, DOTA_DAMAGE_FLAG_NONE)
				end

				return damage_interval
			end)
			PersistentTimer_Add(timers2[i])
		end)
		PersistentTimer_Add(timers1[i])

		local timer = Timers:CreateTimer( (damage_interval * i) + damage_duration, function()

			Timers:RemoveTimer(timers1[i])
			timers1[i] = nil

			Timers:RemoveTimer(timers2[i])
			timers2[i] = nil

			ParticleManager:DestroyParticle( particles[i], false )
			ParticleManager:ReleaseParticleIndex( particles[i] )
			particles[i] = nil

		end)
		PersistentTimer_Add(timer)
	end

end

function ancient_siege_engine_burning_wheels:OnAbilityPhaseStart()
	local caster			= self:GetCaster()
	local playerID			= caster:GetPlayerOwnerID()
	local player			= PlayerResource:GetPlayer(playerID)

	return true
end

function ancient_siege_engine_burning_wheels:GetManaCost(abilitylevel)
	return self.BaseClass.GetManaCost(self, abilitylevel)
end

function ancient_siege_engine_burning_wheels:GetCooldown(abilitylevel)
	return self.BaseClass.GetCooldown(self, abilitylevel)
end