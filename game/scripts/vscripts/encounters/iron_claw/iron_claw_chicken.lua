iron_claw_chicken = class({})

function iron_claw_chicken:OnSpellStart()

	--- Get Caster, Victim, Player, Point ---
	local caster		= self:GetCaster()
	local caster_loc	= caster:GetAbsOrigin()
	local playerID		= caster:GetPlayerOwnerID()
	local player		= PlayerResource:GetPlayer(playerID)
	local team			= caster:GetTeamNumber()
	
	--- Get Special Values ---
	local AoERadius                   = self:GetSpecialValueFor("AoERadius")
	local delay                       = self:GetSpecialValueFor("delay")
	local heal_self_percentage        = self:GetSpecialValueFor("heal_self_percentage")

	local loc = GetRandomPointWithinArena()

	EncounterGroundAOEWarningSticky(loc, AoERadius, delay+0.1)
	
	local timer1 = Timers:CreateTimer(delay, function()

		local unit = CreateUnitByName("iron_claw_chicken", loc, true, nil, nil, DOTA_TEAM_BADGUYS)
		PersistentUnit_Add(unit)

		unit:AddNewModifier(unit, nil, "modifier_dummy", {})
		unit:AddNewModifier(unit, nil, "modifier_phased", {})

		-- Sound --
		StartSoundEventReliable("Hero_ShadowShaman.Hex.Target", unit)	

		local destination = GetRandomPointWithinArena()

		unit:Stop()

		local timer2 = Timers:CreateTimer(0.1, function()

			local loc = unit:GetAbsOrigin()

			unit:MoveToPosition( destination )

			if destination == loc then
				local new_loc = GetRandomPointWithinArena()
				unit:Stop()
				unit:MoveToPosition( new_loc )
				destination = new_loc
			end

			-- DOTA_UNIT_TARGET_TEAM_FRIENDLY; DOTA_UNIT_TARGET_TEAM_ENEMY; DOTA_UNIT_TARGET_TEAM_BOTH
			local units	= FindUnitsInRadius(team, loc, nil, AoERadius, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
			for _,victim in pairs(units) do

				-- Sound --
				StartSoundEventReliable("RoshanDT.Eat", victim)					

				-- Apply Heal --
				caster:Heal( caster:GetMaxHealth() * ( heal_self_percentage / 100 ) , self)

				-- Particle -- PATTACH_ABSORIGIN-PATTACH_ABSORIGIN_FOLLOW-PATTACH_CUSTOMORIGIN
				local particle = ParticleManager:CreateParticle("particles/econ/items/sniper/sniper_charlie/sniper_assassinate_impact_blood_charlie.vpcf", PATTACH_CUSTOMORIGIN, nil)
				ParticleManager:SetParticleControl( particle, 0, loc )
				ParticleManager:SetParticleControl( particle, 1, loc )
				ParticleManager:ReleaseParticleIndex( particle )
				particle = nil

				UTIL_Remove(unit)

				return
			end

			return 0.1
		end)
		PersistentTimer_Add(timer2)

	end)
	PersistentTimer_Add(timer1)

end

function iron_claw_chicken:OnAbilityPhaseStart()
	local caster			= self:GetCaster()
	local playerID			= caster:GetPlayerOwnerID()
	local player			= PlayerResource:GetPlayer(playerID)

	return true
end

function iron_claw_chicken:GetManaCost(abilitylevel)
	return self.BaseClass.GetManaCost(self, abilitylevel)
end

function iron_claw_chicken:GetCooldown(abilitylevel)
	-- ChallengerMode 1 --
	if GameMode_Active == "Challenger" and ChallengerMode_Active == 1 then
		return self.BaseClass.GetCooldown(self, abilitylevel) * 0.35
	end
	return self.BaseClass.GetCooldown(self, abilitylevel)
end