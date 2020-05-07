ancient_siege_engine_homing_missile = class({})

LinkLuaModifier( 'ancient_siege_engine_homing_missile_modifier', 'encounters/ancient_siege_engine/ancient_siege_engine_homing_missile_modifier', LUA_MODIFIER_MOTION_NONE )

function ancient_siege_engine_homing_missile:OnSpellStart()

	--- Get Caster, Victim, Player, Point ---
	local caster		= self:GetCaster()
	local caster_loc	= caster:GetAbsOrigin()
	local playerID		= caster:GetPlayerOwnerID()
	local player		= PlayerResource:GetPlayer(playerID)
	local team			= caster:GetTeamNumber()
	
	if caster.the_dungeoneer_time_warp == true then
		local order = {
			UnitIndex = caster:entindex(),
			AbilityIndex = unit:GetAbilityByIndex( RandomInt(0, 3) ):entindex(),
			OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
			Queue = false
		}
		ExecuteOrderFromTable(order)

		return
	end

	--- Get Special Values ---
	local AoERadius                   = self:GetSpecialValueFor("AoERadius")
	local duration                    = self:GetSpecialValueFor("duration")
	local damage                      = self:GetSpecialValueFor("damage")
	local damage_duration             = self:GetSpecialValueFor("damage_duration")
	local damage_interval             = self:GetSpecialValueFor("damage_interval")
	local damage_instances            = self:GetSpecialValueFor("damage_instances")
	local delay                       = self:GetSpecialValueFor("delay")
	local missile_speed_start         = self:GetSpecialValueFor("missile_speed_start")
	local missile_speed_end           = self:GetSpecialValueFor("missile_speed_end")
	local missile_speed_up_duration   = self:GetSpecialValueFor("missile_speed_up_duration")

	caster:AddNewModifier(caster, self, "casting_rooted_modifier", {duration=delay})
	DisableMotionControllers(caster, delay)

	for _,victim in pairs(GetHeroesAliveEntities()) do

		local victim_loc = victim:GetAbsOrigin()

		--EncounterGroundAOEWarningSticky(victim_loc, AoERadius, 0.5)
		EncounterUnitWarning(victim, 2.0, true, "red") --nil=yellow, "red", "orange", "green"

		local unit = CreateUnitByName("ancient_siege_engine_homing_missile", caster_loc + caster:GetForwardVector() * 200, true, nil, nil, DOTA_TEAM_BADGUYS)
		PersistentUnit_Add(unit)

		unit:AddNewModifier(unit, nil, "modifier_dummy", {})
		unit:AddNewModifier(unit, nil, "modifier_phased", {})

		unit:Stop()

		-- Sound --
		StartSoundEventReliable("Hero_Gyrocopter.HomingMissile", unit)
		PersistentSoundEvent_Add("Hero_Gyrocopter.HomingMissile", unit)

		local timer = Timers:CreateTimer(delay, function()

			local mod = unit:AddNewModifier(caster, self, "ancient_siege_engine_homing_missile_modifier", {})

			local interval = 0.1
			local step = ( missile_speed_end / missile_speed_up_duration ) * interval

			local timer1 = Timers:CreateTimer(0, function()
				if unit:IsNull() then return end

				mod:SetStackCount( mod:GetStackCount() + step )

				return interval
			end)
			PersistentTimer_Add(timer1)

			local timer2 = Timers:CreateTimer(missile_speed_up_duration, function()

				Timers:RemoveTimer(timer1)
				timer1 = nil

			end)
			PersistentTimer_Add(timer2)

			local timer3 = Timers:CreateTimer(0, function()
				if unit == nil then return end
				if unit:IsNull() then return end
				if not unit:IsAlive() then return end

				unit:MoveToPosition( victim:GetAbsOrigin() )

				-- DOTA_UNIT_TARGET_TEAM_FRIENDLY; DOTA_UNIT_TARGET_TEAM_ENEMY; DOTA_UNIT_TARGET_TEAM_BOTH
				local units	= FindUnitsInRadius(team, unit:GetAbsOrigin(), nil, AoERadius, DOTA_UNIT_TARGET_TEAM_BOTH, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_OUT_OF_WORLD, FIND_ANY_ORDER, false)
				for _,victim in pairs(units) do

					if victim == nil then return end
					if victim:IsNull() then return end
					if not victim:IsAlive() then return end

					if victim:GetTeamNumber() == DOTA_TEAM_BADGUYS and victim:GetUnitName() == 'ancient_siege_engine_earthen_spike' then

						-- Sound --
						StopSoundEvent("Hero_Gyrocopter.HomingMissile", unit)
						StartSoundEventFromPositionReliable("Hero_Gyrocopter.HomingMissile.Target", unit:GetAbsOrigin())

						-- Particle -- PATTACH_ABSORIGIN-PATTACH_ABSORIGIN_FOLLOW-PATTACH_CUSTOMORIGIN
						local particle = ParticleManager:CreateParticle("particles/units/unit_greevil/loot_greevil_death_dust.vpcf", PATTACH_CUSTOMORIGIN, nil)
						ParticleManager:SetParticleControl( particle, 0, victim:GetAbsOrigin() )
						ParticleManager:ReleaseParticleIndex( particle )
						particle = nil

						victim:RemoveSelf()

						unit:RemoveSelf()

					elseif victim:GetTeamNumber() == DOTA_TEAM_GOODGUYS and victim:IsRealHero() then

						-- Sound --
						StopSoundEvent("Hero_Gyrocopter.HomingMissile", unit)
						StartSoundEventFromPositionReliable("Hero_Gyrocopter.HomingMissile.Destroy", unit:GetAbsOrigin() )

						-- Particle -- PATTACH_ABSORIGIN-PATTACH_ABSORIGIN_FOLLOW-PATTACH_CUSTOMORIGIN
						local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_oracle/oracle_false_promise_dmg_burst.vpcf", PATTACH_ABSORIGIN, victim)
						ParticleManager:SetParticleControl( particle, 0, victim:GetAbsOrigin() )
						ParticleManager:ReleaseParticleIndex( particle )
						particle = nil

						local timer4 = Timers:CreateTimer(0, function()
							-- Apply Damage --
							EncounterApplyDamage(victim, caster, self, damage/damage_instances, DAMAGE_TYPE_PHYSICAL, DOTA_DAMAGE_FLAG_NONE)
							
							return damage_interval
						end)
						PersistentTimer_Add(timer4)

						local timer5 = Timers:CreateTimer(damage_duration + (damage_interval/2), function()

							Timers:RemoveTimer(timer4)
							timer4 = nil

						end)
						PersistentTimer_Add(timer5)

						unit:RemoveSelf()

					end

				end

				return 0.1
			end)
			PersistentTimer_Add(timer2)

		end)
		PersistentTimer_Add(timer)

		local timer1 = Timers:CreateTimer(delay+duration, function()

			if unit ~= nil then
				if not unit:IsNull() then
					StopSoundEvent("Hero_Gyrocopter.HomingMissile", unit)
					unit:RemoveSelf()
				end
			end

		end)
		PersistentTimer_Add(timer1)
	end

end

function ancient_siege_engine_homing_missile:OnAbilityPhaseStart()
	local caster			= self:GetCaster()
	local playerID			= caster:GetPlayerOwnerID()
	local player			= PlayerResource:GetPlayer(playerID)

	return true
end

function ancient_siege_engine_homing_missile:GetManaCost(abilitylevel)
	return self.BaseClass.GetManaCost(self, abilitylevel)
end

function ancient_siege_engine_homing_missile:GetCooldown(abilitylevel)
	return self.BaseClass.GetCooldown(self, abilitylevel)
end