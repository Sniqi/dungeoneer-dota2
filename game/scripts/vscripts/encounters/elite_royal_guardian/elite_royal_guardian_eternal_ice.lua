elite_royal_guardian_eternal_ice = class({})

function elite_royal_guardian_eternal_ice:OnSpellStart()
	if self.abilityUsed then return false end
	self.abilityUsed = true

	--- Get Caster, Victim, Player, Point ---
	local caster		= self:GetCaster()
	local caster_loc	= caster:GetAbsOrigin()
	local playerID		= caster:GetPlayerOwnerID()
	local player		= PlayerResource:GetPlayer(playerID)
	local team			= caster:GetTeamNumber()
	
	--- Get Special Values ---
	local AoERadius                   = self:GetSpecialValueFor("AoERadius")
	local damage                      = self:GetSpecialValueFor("damage")
	local damage_interval             = self:GetSpecialValueFor("damage_interval")
	local interval                    = self:GetSpecialValueFor("interval")
	local radius_increase             = self:GetSpecialValueFor("radius_increase")

	local loc = GetRandomCornerPoint()
	loc.z = loc.z - 24

	caster.elite_royal_guardian_eternal_ice_chosenPoint = loc

	local counter = radius_increase
	local timer = Timers:CreateTimer(function()

		-- Particle -- PATTACH_ABSORIGIN-PATTACH_ABSORIGIN_FOLLOW-PATTACH_CUSTOMORIGIN
		local particle = ParticleManager:CreateParticle("particles/encounter/elite_royal_guardian/elite_royal_guardian_eternal_ice.vpcf", PATTACH_CUSTOMORIGIN, nil)
		ParticleManager:SetParticleControl( particle, 0, loc )
		ParticleManager:SetParticleControl( particle, 1, Vector(AoERadius + counter,0.2,0) )

		-- DOTA_UNIT_TARGET_TEAM_FRIENDLY; DOTA_UNIT_TARGET_TEAM_ENEMY; DOTA_UNIT_TARGET_TEAM_BOTH
		local units	= FindUnitsInRadius(team, loc, nil, AoERadius + counter, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
		for _,victim in pairs(units) do
			-- Apply Damage --
			EncounterApplyDamage(victim, caster, self, damage * interval, DAMAGE_TYPE_MAGICAL, DOTA_DAMAGE_FLAG_NONE)
		end

		counter = counter + radius_increase
		return interval
	end)
	PersistentTimer_Add(timer)

end

function elite_royal_guardian_eternal_ice:OnAbilityPhaseStart()
	local caster			= self:GetCaster()
	local playerID			= caster:GetPlayerOwnerID()
	local player			= PlayerResource:GetPlayer(playerID)

	return true
end

function elite_royal_guardian_eternal_ice:GetManaCost(abilitylevel)
	return self.BaseClass.GetManaCost(self, abilitylevel)
end

function elite_royal_guardian_eternal_ice:GetCooldown(abilitylevel)
	return self.BaseClass.GetCooldown(self, abilitylevel)
end