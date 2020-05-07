a_mighty_boar_tremble = class({})

LinkLuaModifier( 'a_mighty_boar_tremble_modifier', 'encounters/a_mighty_boar/a_mighty_boar_tremble_modifier', LUA_MODIFIER_MOTION_NONE )

function a_mighty_boar_tremble:OnSpellStart()

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
	local damage                      = self:GetSpecialValueFor("damage")
	local delay                       = self:GetSpecialValueFor("delay")
	local stun                        = self:GetSpecialValueFor("stun")
	local incoming_damage_percentage  = self:GetSpecialValueFor("incoming_damage_percentage")
	local vulnerable_duration         = self:GetSpecialValueFor("vulnerable_duration")
	local phase_two                   = self:GetSpecialValueFor("phase_two")
	local earthquake_damage           = self:GetSpecialValueFor("earthquake_damage")
	local earthquake_damage_duration  = self:GetSpecialValueFor("earthquake_damage_duration")
	local earthquake_damage_interval  = self:GetSpecialValueFor("earthquake_damage_interval")
	local earthquake_count            = self:GetSpecialValueFor("earthquake_count")
	local earthquake_aoe              = self:GetSpecialValueFor("earthquake_aoe")
	local earthquake_delay            = self:GetSpecialValueFor("earthquake_delay")

	local caster_loc = caster:GetAbsOrigin() + ( caster:GetForwardVector() * (AoERadius / 2) )

	caster:AddNewModifier(caster, self, "casting_no_turning_modifier", {duration = delay+1.0})

	EncounterGroundAOEWarningSticky(caster_loc, AoERadius, delay+1.0)

	local timer1 = Timers:CreateTimer(delay, function()

		-- Animation --
		caster:StartGestureWithPlaybackRate(ACT_DOTA_SPAWN, 1.0)

		-- Sound --
		caster:EmitSound("Hero_Pangolier.TailThump.Cast")

		local timer2 = Timers:CreateTimer(1.0, function()

			-- Sound --
			caster:EmitSound("Hero_Pangolier.TailThump")

			-- Particle --
			local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_windrunner/windrunner_windrun_dust_color.vpcf", PATTACH_ABSORIGIN, caster)
			ParticleManager:SetParticleControl( particle, 0, caster_loc )
			ParticleManager:SetParticleControl( particle, 1, caster_loc )
			ParticleManager:ReleaseParticleIndex( particle )
			particle = nil
			
			-- DOTA_UNIT_TARGET_TEAM_FRIENDLY; DOTA_UNIT_TARGET_TEAM_ENEMY; DOTA_UNIT_TARGET_TEAM_BOTH
			local units	= FindUnitsInRadius(team, caster_loc, nil, AoERadius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
			local particle = {}
			for _,victim in pairs(units) do
				-- Apply Damage --
				EncounterApplyDamage(victim, caster, self, damage, DAMAGE_TYPE_PHYSICAL, DOTA_DAMAGE_FLAG_NONE)

				-- Modifier --
				local modifier = victim:AddNewModifier(caster, self, "a_mighty_boar_tremble_modifier", {duration = vulnerable_duration})
				PersistentModifier_Add(modifier)
			end

			-- PHASE 2 --
			if caster:GetHealthPercent() < phase_two then

				for i=1,earthquake_count do

					local earthquake_loc = caster_loc + Vector( RandomInt(-400,400), RandomInt(-400,400), 0 )

					EncounterGroundAOEWarningSticky(earthquake_loc, earthquake_aoe, earthquake_delay+earthquake_damage_duration)

					local timer3 = Timers:CreateTimer(earthquake_delay, function()

						-- Particle --
						local particle = ParticleManager:CreateParticle("particles/econ/items/earthshaker/egteam_set/hero_earthshaker_egset/earthshaker_fissure_fallback_low_egset.vpcf", PATTACH_ABSORIGIN, caster)
						ParticleManager:SetParticleControl( particle, 0, earthquake_loc )
						ParticleManager:SetParticleControl( particle, 1, earthquake_loc )
						ParticleManager:ReleaseParticleIndex( particle )
						particle = nil

						local timer4 = Timers:CreateTimer(0, function()

							-- Particle --
							local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_earth_spirit/espirit_spawn.vpcf", PATTACH_ABSORIGIN, caster)
							ParticleManager:SetParticleControl( particle, 0, earthquake_loc )
							ParticleManager:SetParticleControl( particle, 1, earthquake_loc )
							ParticleManager:ReleaseParticleIndex( particle )
							particle = nil

							-- DOTA_UNIT_TARGET_TEAM_FRIENDLY; DOTA_UNIT_TARGET_TEAM_ENEMY; DOTA_UNIT_TARGET_TEAM_BOTH
							local units	= FindUnitsInRadius(team, earthquake_loc, nil, earthquake_aoe, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
							for _,victim in pairs(units) do
								-- Apply Damage --
								EncounterApplyDamage(victim, caster, self, earthquake_damage*earthquake_damage_interval, DAMAGE_TYPE_PHYSICAL, DOTA_DAMAGE_FLAG_NONE)
							end

							return earthquake_damage_interval
						end)
						PersistentTimer_Add(timer4)

						local timer5 = Timers:CreateTimer(earthquake_damage_duration, function()
							Timers:RemoveTimer(timer4)
							timer4 = nil
						end)
						PersistentTimer_Add(timer5)

						
					end)
					PersistentTimer_Add(timer3)
				end

			end
			-- PHASE 2 END --

		end)
		PersistentTimer_Add(timer2)

	end)
	PersistentTimer_Add(timer1)

end

function a_mighty_boar_tremble:OnAbilityPhaseStart()
	local caster			= self:GetCaster()
	local playerID			= caster:GetPlayerOwnerID()
	local player			= PlayerResource:GetPlayer(playerID)

	return true
end

function a_mighty_boar_tremble:GetManaCost(abilitylevel)
	return self.BaseClass.GetManaCost(self, abilitylevel)
end

function a_mighty_boar_tremble:GetCooldown(abilitylevel)
	return self.BaseClass.GetCooldown(self, abilitylevel)
end