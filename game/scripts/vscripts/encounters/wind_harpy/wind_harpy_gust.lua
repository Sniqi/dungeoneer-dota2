wind_harpy_gust = class({})

function wind_harpy_gust:OnSpellStart()

	--- Get Caster, Victim, Player, Point ---
	local caster		= self:GetCaster()
	local caster_loc	= caster:GetAbsOrigin()
	local playerID		= caster:GetPlayerOwnerID()
	local player		= PlayerResource:GetPlayer(playerID)
	local team			= caster:GetTeamNumber()

	--- Get Special Values ---
	local AoERadius                   = self:GetSpecialValueFor("AoERadius")
	local duration                    = self:GetSpecialValueFor("duration")
	local push_force                  = self:GetSpecialValueFor("push_force")
	local push_damage                 = self:GetSpecialValueFor("push_damage")
	local push_interval               = self:GetSpecialValueFor("push_interval")

	caster:AddNewModifier(caster, self, "casting_rooted_modifier", {duration=duration})
	DisableMotionControllers(caster, duration)

	-- Sound and Animation --
	local sound = {"naga_siren_naga_laugh_01", "naga_siren_naga_laugh_02",
					"naga_siren_naga_laugh_03", "naga_siren_naga_laugh_04"}
	EmitAnnouncerSound( sound[RandomInt(1, #sound)] )

	local rad = 18

	for i=0, (duration / push_interval) - 1 do

		local timer1 = Timers:CreateTimer(i*push_interval, function()

			-- Sound and Animation --
			caster:EmitSound("Hero_Invoker.Tornado.Cast")
			StartAnimation(caster, {duration=2.0, activity=ACT_DOTA_CAST_ABILITY_1, rate=0.8})

			for i=0,19 do

				local direction = RotateVector2D(caster:GetForwardVector(),math.rad(i*rad))

				-- Particle --
				local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_drow/drow_silence_wave.vpcf", PATTACH_ABSORIGIN, caster)
				ParticleManager:SetParticleControl( particle, 0, caster:GetAbsOrigin() )
				ParticleManager:SetParticleControl( particle, 1, direction * 2500 )
				ParticleManager:SetParticleControl( particle, 3, direction * 2500 )
				ParticleManager:SetParticleControl( particle, 4, direction * 2500 )
				ParticleManager:SetParticleControl( particle, 5, direction * 2500 )
				ParticleManager:ReleaseParticleIndex( particle )
				particle = nil
			end

			for _,victim in pairs(GetHeroesAliveEntities()) do
				if IsPhysicsUnit(victim) then

					local timer2 = Timers:CreateTimer((victim:GetAbsOrigin() - caster:GetAbsOrigin()):Length2D()/3000, function()

						victim:SetPhysicsFriction(0.06)
						victim:SetRebounceFrames(100)
						victim:AddPhysicsVelocity( (victim:GetAbsOrigin() - caster:GetAbsOrigin()):Normalized() * push_force)
						victim:OnBounce(function(victim, normal)
							EncounterApplyDamage(victim, caster, self, push_damage, DAMAGE_TYPE_PHYSICAL, DOTA_DAMAGE_FLAG_NONE)
						end)

						victim.victim_rebounce_protection = 10
						victim:OnPhysicsFrame(function(victim)

							if victim.victim_rebounce_protection == 10 then

								-- Particle --
								local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_brewmaster/brewmaster_storm_death_dust.vpcf", PATTACH_ABSORIGIN, victim)
								ParticleManager:SetParticleControl( particle, 0, victim:GetAbsOrigin() )
								ParticleManager:SetParticleControl( particle, 3, victim:GetAbsOrigin() )
								ParticleManager:SetParticleControl( particle, 4, victim:GetAbsOrigin() )
								ParticleManager:SetParticleControl( particle, 5, victim:GetAbsOrigin() )
								ParticleManager:ReleaseParticleIndex( particle )
								particle = nil

								local units	= FindUnitsInRadius(victim:GetTeamNumber(), victim:GetAbsOrigin(), nil, 80, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_INVULNERABLE, FIND_ANY_ORDER, false)
								for _,unit in pairs(units) do
									if unit:GetUnitName() == "wind_harpy_thorny_blockage" then
										victim:ClearStaticVelocity()
										victim:AddPhysicsVelocity( (victim:GetAbsOrigin() - unit:GetAbsOrigin()):Normalized() * push_force)
									
										local ability = caster:FindAbilityByName("wind_harpy_thorny_blockage")
										local bounce_damage = ability:GetSpecialValueFor("bounce_damage")

										-- Apply Damage --
										EncounterApplyDamage(victim, caster, ability, bounce_damage, DAMAGE_TYPE_PHYSICAL, DOTA_DAMAGE_FLAG_NONE)
									
									end
								end

								victim.victim_rebounce_protection = 0
							end

							victim.victim_rebounce_protection = victim.victim_rebounce_protection + 1

						end)
						
					end)
					PersistentTimer_Add(timer2)
					
				end

			end
		end)
		PersistentTimer_Add(timer1)
	end

end

function wind_harpy_gust:OnAbilityPhaseStart()
	local caster			= self:GetCaster()
	local playerID			= caster:GetPlayerOwnerID()
	local player			= PlayerResource:GetPlayer(playerID)

	return true
end

function wind_harpy_gust:GetManaCost(abilitylevel)
	return self.BaseClass.GetManaCost(self, abilitylevel)
end

function wind_harpy_gust:GetCooldown(abilitylevel)
	return self.BaseClass.GetCooldown(self, abilitylevel)
end