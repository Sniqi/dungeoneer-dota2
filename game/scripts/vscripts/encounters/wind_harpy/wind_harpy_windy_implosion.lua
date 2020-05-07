wind_harpy_windy_implosion = class({})

LinkLuaModifier( 'wind_harpy_windy_implosion_modifier', 'encounters/wind_harpy/wind_harpy_windy_implosion_modifier', LUA_MODIFIER_MOTION_NONE )

function wind_harpy_windy_implosion:OnSpellStart()

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
	local duration                    = self:GetSpecialValueFor("duration")
	local delay                       = self:GetSpecialValueFor("delay")
	local push_force                  = self:GetSpecialValueFor("push_force")
	local push_damage                 = self:GetSpecialValueFor("push_damage")
	local damage_to_cancel_percentage = self:GetSpecialValueFor("damage_to_cancel_percentage")
	local move_speed_percentage       = self:GetSpecialValueFor("move_speed_percentage")

	caster:AddNewModifier(caster, self, "casting_rooted_modifier", {duration=duration+delay})
	DisableMotionControllers(caster, duration+delay)
	DelayAbilityCooldown(caster, "wind_harpy_gust", duration+delay, 5.0)

	-- Sound and Animation --
	local sound = {"naga_siren_naga_attack_05", "naga_siren_naga_attack_06",
					"naga_siren_naga_attack_07", "naga_siren_naga_attack_10"}
	EmitAnnouncerSound( sound[RandomInt(1, #sound)] )
	StartAnimation(caster, {duration=delay, activity=ACT_DOTA_FLAIL, rate=0.75})

	EncounterGroundAOEWarningSticky(victim_loc, 100, 1.0)

	local health_pct = caster:GetHealthPercent()

	local timer1 = Timers:CreateTimer(delay, function()

		-- Sound and Animation --
		EmitAnnouncerSound( "naga_siren_naga_cast_04" )
		StartAnimation(caster, {duration=duration, activity=ACT_DOTA_DISABLED, rate=0.5})

		-- Modifier --
		local modifier = victim:AddNewModifier(caster, self, "wind_harpy_windy_implosion_modifier", {duration = duration})
		PersistentModifier_Add(modifier)

		-- Particle --
		local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_windrunner/windrunner_windrun.vpcf", PATTACH_ABSORIGIN_FOLLOW, victim)
		ParticleManager:SetParticleControl( particle, 0, victim:GetAbsOrigin() )
		ParticleManager:SetParticleControl( particle, 3, victim:GetAbsOrigin() )
		PersistentParticle_Add(particle)

		local timer2 = Timers:CreateTimer(duration, function()

			ParticleManager:DestroyParticle( particle, false )
			ParticleManager:ReleaseParticleIndex( particle )
			particle = nil

			if (health_pct - caster:GetHealthPercent()) <= damage_to_cancel_percentage then
				-- Sound and Animation --
				local sound = {"naga_siren_naga_laugh_01", "naga_siren_naga_laugh_02",
								"naga_siren_naga_laugh_03", "naga_siren_naga_laugh_04"}
				EmitAnnouncerSound( sound[RandomInt(1, #sound)] )

				-- Particle --
				local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_dark_seer/dark_seer_vacuum.vpcf", PATTACH_ABSORIGIN, victim)
				ParticleManager:SetParticleControl( particle, 2, victim:GetAbsOrigin() )
				ParticleManager:ReleaseParticleIndex( particle )
				particle = nil

				local timer3 = Timers:CreateTimer(1.0, function()

					-- Particle --
					local particle = ParticleManager:CreateParticle("particles/econ/items/wisp/wisp_guardian_explosion_ti7.vpcf", PATTACH_ABSORIGIN, victim)
					ParticleManager:SetParticleControl( particle, 0, victim:GetAbsOrigin() )
					ParticleManager:ReleaseParticleIndex( particle )
					particle = nil

					-- Sound --
					victim:EmitSound("Hero_Invoker.DeafeningBlast.Immortal")

					victim:SetPhysicsFriction(0.025)
					victim:SetRebounceFrames(12)
					victim:AddPhysicsVelocity(victim:GetForwardVector() * push_force * -1)
					victim:OnBounce(function(victim, normal)
						EncounterApplyDamage(victim, caster, self, push_damage, DAMAGE_TYPE_PHYSICAL, DOTA_DAMAGE_FLAG_NONE)
					end)

					victim.victim_rebounce_protection = 10
					victim:OnPhysicsFrame(function(victim)

						if victim.victim_rebounce_protection == 10 then

							-- Particle --
							local particle = ParticleManager:CreateParticle("particles/econ/items/juggernaut/jugg_arcana/juggernaut_arcana_omni_slash_trail_dust_l.vpcf", PATTACH_ABSORIGIN, victim)
							ParticleManager:SetParticleControl( particle, 0, victim:GetAbsOrigin() )
							ParticleManager:SetParticleControl( particle, 1, victim:GetAbsOrigin() )
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
				PersistentTimer_Add(timer3)

			else
				-- Sound and Animation --
				local sound = {"naga_siren_naga_failure_01", "naga_siren_naga_failure_02",
								"naga_siren_naga_failure_03", "naga_siren_naga_failure_04"}
				EmitAnnouncerSound( sound[RandomInt(1, #sound)] )
			end

		end)
		PersistentTimer_Add(timer2)

	end)
	PersistentTimer_Add(timer1)
	
end

function wind_harpy_windy_implosion:OnAbilityPhaseStart()
	local caster			= self:GetCaster()
	local playerID			= caster:GetPlayerOwnerID()
	local player			= PlayerResource:GetPlayer(playerID)

	return true
end

function wind_harpy_windy_implosion:GetManaCost(abilitylevel)
	return self.BaseClass.GetManaCost(self, abilitylevel)
end

function wind_harpy_windy_implosion:GetCooldown(abilitylevel)
	return self.BaseClass.GetCooldown(self, abilitylevel)
end