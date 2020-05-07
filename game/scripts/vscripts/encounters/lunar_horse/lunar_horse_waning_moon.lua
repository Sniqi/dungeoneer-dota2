lunar_horse_waning_moon = class({})

LinkLuaModifier( 'lunar_horse_waning_moon_modifier', 'encounters/lunar_horse/lunar_horse_waning_moon_modifier', LUA_MODIFIER_MOTION_NONE )

function lunar_horse_waning_moon:OnSpellStart()

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
	local steps                       = self:GetSpecialValueFor("steps")
	local phase_two_percentage        = self:GetSpecialValueFor("phase_two_percentage")
	local phase_two_slow_percentage   = self:GetSpecialValueFor("phase_two_slow_percentage")
	local phase_two_duration          = self:GetSpecialValueFor("phase_two_duration")

	--caster:AddNewModifier(caster, self, "casting_rooted_modifier", {duration=delay})
	--DisableMotionControllers(caster, delay)

	local forwardVector = caster:GetForwardVector()
	local explosion_delay = 0
	
	local i = 0
	for x=1,steps do

		local radius = AoERadius - ( x * ( AoERadius / steps ) )
		local rad = ( 90 / steps )
		local distance = AoERadius - ( x * ( AoERadius / steps ) )

		local direction = RotateVector2D( forwardVector, math.rad(x*rad) )
		local pos = ( victim:GetAbsOrigin() + ( victim:GetForwardVector() * 100 ) ) + (direction * distance)
		pos = GetGroundPosition(pos, victim)
		pos.z = pos.z + 10

		explosion_delay = ( 1.2 - (x/steps) ) + explosion_delay

		local timer = Timers:CreateTimer( explosion_delay, function()
			EncounterGroundAOEWarningSticky(pos, radius, delay )
		end)
		PersistentTimer_Add(timer)

		local timer = Timers:CreateTimer( delay + explosion_delay, function()

			-- Particle --
			local particle = ParticleManager:CreateParticle("particles/encounter/lunar_horse/lunar_horse_waning_moon.vpcf", PATTACH_CUSTOMORIGIN, nil)
			ParticleManager:SetParticleControl( particle, 0, pos )
			ParticleManager:SetParticleControl( particle, 1, Vector(radius,0,0) )
			ParticleManager:ReleaseParticleIndex( particle )
			particle = nil
			--PersistentParticle_Add(particle)

			-- Sound --
			StartSoundEventFromPositionReliable("Hero_Luna.Eclipse.NoTarget", pos)

			-- DOTA_UNIT_TARGET_TEAM_FRIENDLY; DOTA_UNIT_TARGET_TEAM_ENEMY; DOTA_UNIT_TARGET_TEAM_BOTH
			local units	= FindUnitsInRadius(team, pos, nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
			for _,victim in pairs(units) do

				-- Sound --
				StartSoundEventReliable("Hero_Luna.LucentBeam.Target", victim)

				-- Apply Damage --
				EncounterApplyDamage(victim, caster, self, damage, DAMAGE_TYPE_MAGICAL, DOTA_DAMAGE_FLAG_NONE)
			end

			-- PHASE 2 --
			if caster:GetHealthPercent() < phase_two_percentage then

				-- Particle --
				local particle = ParticleManager:CreateParticle("particles/encounter/lunar_horse/lunar_horse_waning_moon_slow.vpcf", PATTACH_CUSTOMORIGIN, nil)
				ParticleManager:SetParticleControl( particle, 0, pos )
				ParticleManager:SetParticleControl( particle, 1, Vector(radius,0,0) )
				PersistentParticle_Add(particle)

				local timer1 = Timers:CreateTimer(0, function()

					-- DOTA_UNIT_TARGET_TEAM_FRIENDLY; DOTA_UNIT_TARGET_TEAM_ENEMY; DOTA_UNIT_TARGET_TEAM_BOTH
					local units	= FindUnitsInRadius(team, pos, nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
					for _,victim in pairs(units) do

						-- Modifier --
						victim:AddNewModifier(caster, self, "lunar_horse_waning_moon_modifier", {duration = phase_two_duration/2})
					
					end

					return 0.2
				end)
				PersistentTimer_Add(timer1)

				local timer2 = Timers:CreateTimer(phase_two_duration, function()

					Timers:RemoveTimer(timer1)
					timer1 = nil

					ParticleManager:DestroyParticle( particle, false )
					ParticleManager:ReleaseParticleIndex( particle )
					particle = nil

				end)
				PersistentTimer_Add(timer2)

			end



		end)
		PersistentTimer_Add(timer)

		i = i + 1
	end

end

function lunar_horse_waning_moon:OnAbilityPhaseStart()
	local caster			= self:GetCaster()
	local playerID			= caster:GetPlayerOwnerID()
	local player			= PlayerResource:GetPlayer(playerID)

	return true
end

function lunar_horse_waning_moon:GetManaCost(abilitylevel)
	return self.BaseClass.GetManaCost(self, abilitylevel)
end

function lunar_horse_waning_moon:GetCooldown(abilitylevel)
	return self.BaseClass.GetCooldown(self, abilitylevel)
end