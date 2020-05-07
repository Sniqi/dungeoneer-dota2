iron_claw_bear_traps = class({})

function iron_claw_bear_traps:OnSpellStart()

	--- Get Caster, Victim, Player, Point ---
	local caster		= self:GetCaster()
	local caster_loc	= caster:GetAbsOrigin()
	local playerID		= caster:GetPlayerOwnerID()
	local player		= PlayerResource:GetPlayer(playerID)
	local team			= caster:GetTeamNumber()

	--- Get Special Values ---
	local AoERadius                   = self:GetSpecialValueFor("AoERadius")
	local delay                       = self:GetSpecialValueFor("delay")
	local damage_self_percentage      = self:GetSpecialValueFor("damage_self_percentage")
	local damage_enemies_percentage   = self:GetSpecialValueFor("damage_enemies_percentage")

	local loc = GetRandomPointWithinArena()

	EncounterGroundAOEWarningSticky(loc, AoERadius, delay+0.1)
	
	local timer1 = Timers:CreateTimer(delay, function()

		local ent = SpawnEntityFromTableSynchronous("prop_dynamic", {model = "models/items/lone_druid/bear_trap/bear_trap.vmdl", DefaultAnim="bindPose", targetname=DoUniqueString("iron_claw_bear_traps")})
		ent:SetAbsOrigin( loc )
		ent:SetModelScale( 1.0 )
		PersistentEntity_Add(ent)

		-- Sound --
		StartSoundEventReliable("Hero_Shredder.TimberChain.Impact", ent)

		local timer2 = Timers:CreateTimer(0, function()

			-- DOTA_UNIT_TARGET_TEAM_FRIENDLY; DOTA_UNIT_TARGET_TEAM_ENEMY; DOTA_UNIT_TARGET_TEAM_BOTH
			local units	= FindUnitsInRadius(team, loc, nil, AoERadius, DOTA_UNIT_TARGET_TEAM_BOTH, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
			for _,victim in pairs(units) do
				local triggered = false

				if victim:GetTeamNumber() == team then
					triggered = true

					-- Sound --
					StartSoundEventReliable("LoneDruid_SpiritBear_IdleRoar", victim)					

					-- Apply Damage --
					EncounterApplyDamage(victim, caster, self, damage_self_percentage, DAMAGE_TYPE_PHYSICAL, DOTA_DAMAGE_FLAG_IGNORES_PHYSICAL_ARMOR + DOTA_DAMAGE_FLAG_HPLOSS)
				else
					triggered = true

					-- Apply Damage --
					EncounterApplyDamage(victim, caster, self, damage_enemies_percentage, DAMAGE_TYPE_PHYSICAL, DOTA_DAMAGE_FLAG_NONE)
				end

				if triggered then

					-- Sound --
					StartSoundEventReliable("Hero_Shredder.TimberChain.Impact", victim)

					-- Particle -- PATTACH_ABSORIGIN-PATTACH_ABSORIGIN_FOLLOW-PATTACH_CUSTOMORIGIN
					local particle = ParticleManager:CreateParticle("particles/econ/items/sniper/sniper_charlie/sniper_assassinate_impact_blood_charlie.vpcf", PATTACH_CUSTOMORIGIN, nil)
					ParticleManager:SetParticleControl( particle, 0, loc )
					ParticleManager:SetParticleControl( particle, 1, loc )
					ParticleManager:ReleaseParticleIndex( particle )
					particle = nil

					UTIL_Remove(ent)

					return
				end
			
			end

			return 0.1
		end)
		PersistentTimer_Add(timer2)

	end)
	PersistentTimer_Add(timer1)

end

function iron_claw_bear_traps:OnAbilityPhaseStart()
	local caster			= self:GetCaster()
	local playerID			= caster:GetPlayerOwnerID()
	local player			= PlayerResource:GetPlayer(playerID)

	return true
end

function iron_claw_bear_traps:GetManaCost(abilitylevel)
	return self.BaseClass.GetManaCost(self, abilitylevel)
end

function iron_claw_bear_traps:GetCooldown(abilitylevel)
	-- ChallengerMode 1 --
	if GameMode_Active == "Challenger" and ChallengerMode_Active == 1 then
		return self.BaseClass.GetCooldown(self, abilitylevel) * 0.01
	end
	return self.BaseClass.GetCooldown(self, abilitylevel)
end