ancient_siege_engine_earthen_spike = class({})

function ancient_siege_engine_earthen_spike:OnSpellStart()

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
	local delay                       = self:GetSpecialValueFor("delay")
	local push_force                  = self:GetSpecialValueFor("push_force")
	local push_damage                 = self:GetSpecialValueFor("push_damage")

	caster:AddNewModifier(caster, self, "casting_rooted_modifier", {duration=delay})
	DisableMotionControllers(caster, delay)

	for _,victim in pairs(GetHeroesAliveEntities()) do

		local victim_loc = victim:GetAbsOrigin()

		EncounterGroundAOEWarningSticky(victim_loc, AoERadius, delay+0.1)

		local unit

		local timer = Timers:CreateTimer(delay, function()

			unit = CreateUnitByName("ancient_siege_engine_earthen_spike", victim_loc, true, nil, nil, DOTA_TEAM_BADGUYS)
			PersistentUnit_Add(unit)

			unit:AddNewModifier(unit, nil, "modifier_dummy", {})

			-- Sound --
			StartSoundEventReliable("Ability.SandKing_BurrowStrike", unit)

			-- Particle -- PATTACH_ABSORIGIN-PATTACH_ABSORIGIN_FOLLOW-PATTACH_CUSTOMORIGIN
			local particle = ParticleManager:CreateParticle("particles/econ/events/fall_major_2016/cyclone_fm06_ground_dust.vpcf", PATTACH_ABSORIGIN, unit)
			ParticleManager:SetParticleControl( particle, 0, unit:GetAbsOrigin() )
			ParticleManager:ReleaseParticleIndex( particle )
			particle = nil

			-- Particle -- PATTACH_ABSORIGIN-PATTACH_ABSORIGIN_FOLLOW-PATTACH_CUSTOMORIGIN
			local particle = ParticleManager:CreateParticle("particles/econ/items/earthshaker/earthshaker_totem_ti6/earthshaker_totem_ti6_leap_impact_dust.vpcf", PATTACH_ABSORIGIN, unit)
			ParticleManager:SetParticleControl( particle, 0, unit:GetAbsOrigin() )
			ParticleManager:ReleaseParticleIndex( particle )
			particle = nil

			unit:SetAbsOrigin( unit:GetAbsOrigin() + Vector(0,0,-500) )

			-- Model --
			local model = {"models/props_rock/stalagmite_01.vmdl", "models/props_rock/stalagmite_02.vmdl",
							"models/props_rock/stalagmite_03.vmdl"}
			model = model[RandomInt(1, #model)]

			unit:SetOriginalModel( model )
			unit:SetModel( model )
			unit:ManageModelChanges()

			local i = 0
			local timer1 = Timers:CreateTimer(0, function()

				if unit:GetAbsOrigin().z < GetGroundPosition( unit:GetAbsOrigin(), caster ).z then
					unit:SetAbsOrigin( unit:GetAbsOrigin() + Vector(0,0,100) )
				end

				return 0.03
			end)
			PersistentTimer_Add(timer1)

			local timer2 = Timers:CreateTimer(1.0, function()

				Timers:RemoveTimer(timer1)
				timer1 = nil

			end)
			PersistentTimer_Add(timer2)

			-- DOTA_UNIT_TARGET_TEAM_FRIENDLY; DOTA_UNIT_TARGET_TEAM_ENEMY; DOTA_UNIT_TARGET_TEAM_BOTH
			local units	= FindUnitsInRadius(team, unit:GetAbsOrigin(), nil, AoERadius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
			for _,victim in pairs(units) do

				-- Apply Damage --
				EncounterApplyDamage(victim, caster, self, damage, DAMAGE_TYPE_PHYSICAL, DOTA_DAMAGE_FLAG_NONE)

				if IsPhysicsUnit(victim) then

					victim:SetPhysicsFriction(0.06)
					victim:SetRebounceFrames(100)
					victim:AddPhysicsVelocity( (victim:GetAbsOrigin() - unit:GetAbsOrigin()):Normalized() * push_force)
					victim:OnBounce(function(victim, normal)
						EncounterApplyDamage(victim, caster, self, push_damage, DAMAGE_TYPE_PHYSICAL, DOTA_DAMAGE_FLAG_NONE)
					end)
					victim:OnPhysicsFrame(function(victim)
						-- Particle --
						local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_brewmaster/brewmaster_storm_death_dust.vpcf", PATTACH_ABSORIGIN, victim)
						ParticleManager:SetParticleControl( particle, 0, victim:GetAbsOrigin() )
						ParticleManager:SetParticleControl( particle, 3, victim:GetAbsOrigin() )
						ParticleManager:SetParticleControl( particle, 4, victim:GetAbsOrigin() )
						ParticleManager:SetParticleControl( particle, 5, victim:GetAbsOrigin() )
						ParticleManager:ReleaseParticleIndex( particle )
						particle = nil
					end)
				
				end

			end

		end)
		PersistentTimer_Add(timer)

		local timer1 = Timers:CreateTimer(delay+duration, function()

			if unit == nil then return end
			if unit:IsNull() then return end
			if not unit:IsAlive() then return end

			-- Particle -- PATTACH_ABSORIGIN-PATTACH_ABSORIGIN_FOLLOW-PATTACH_CUSTOMORIGIN
			local particle = ParticleManager:CreateParticle("particles/units/unit_greevil/loot_greevil_death_dust.vpcf", PATTACH_CUSTOMORIGIN, nil)
			ParticleManager:SetParticleControl( particle, 0, unit:GetAbsOrigin() )
			ParticleManager:ReleaseParticleIndex( particle )
			particle = nil

			if unit ~= nil then
				if not unit:IsNull() then
					unit:RemoveSelf()
				end
			end

		end)
		PersistentTimer_Add(timer1)
	end

end

function ancient_siege_engine_earthen_spike:OnAbilityPhaseStart()
	local caster			= self:GetCaster()
	local playerID			= caster:GetPlayerOwnerID()
	local player			= PlayerResource:GetPlayer(playerID)

	return true
end

function ancient_siege_engine_earthen_spike:GetManaCost(abilitylevel)
	return self.BaseClass.GetManaCost(self, abilitylevel)
end

function ancient_siege_engine_earthen_spike:GetCooldown(abilitylevel)
	return self.BaseClass.GetCooldown(self, abilitylevel)
end