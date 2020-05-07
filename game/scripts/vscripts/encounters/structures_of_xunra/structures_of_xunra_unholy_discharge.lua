structures_of_xunra_unholy_discharge = class({})

function structures_of_xunra_unholy_discharge:OnSpellStart()

	--- Get Caster, Victim, Player, Point ---
	local caster		= self:GetCaster()
	local caster_loc	= caster:GetAbsOrigin()
	local playerID		= caster:GetPlayerOwnerID()
	local player		= PlayerResource:GetPlayer(playerID)
	local team			= caster:GetTeamNumber()

	
	--- Get Special Values ---
	local AoERadius                   = self:GetSpecialValueFor("AoERadius")
	local damage                      = self:GetSpecialValueFor("damage")
	local delay_min                   = self:GetSpecialValueFor("delay_min")
	local delay_max                   = self:GetSpecialValueFor("delay_max")
	local count                       = self:GetSpecialValueFor("count")

	local alive = 1

	for _,unit in pairs(caster:FindAbilityByName("structures_of_xunra_linked_obelisks").units) do
		if unit ~= nil then
		if not unit:IsNull() then
		if unit:IsAlive() then
			alive = alive + 1
		end
		end
		end
	end

	count = count / alive

	for i=1,count do
		local location = GetRandomPointWithinArena()
		local delay = RandomFloat( delay_min, delay_max )

		EncounterGroundAOEWarningSticky(location, AoERadius, delay+0.1)

		local timer = Timers:CreateTimer(delay, function()

			StartSoundEventFromPositionReliable("Hero_Pugna.NetherWard", location)

			local particle = ParticleManager:CreateParticle("particles/econ/items/pugna/pugna_ward_ti5/pugna_ward_attack_medium_ti_5.vpcf", PATTACH_CUSTOMORIGIN, nil)
			ParticleManager:SetParticleControl( particle, 0, caster:GetAbsOrigin() + Vector(0,0,400) )
			ParticleManager:SetParticleControl( particle, 1, location )
			ParticleManager:ReleaseParticleIndex( particle )
			particle = nil

			-- DOTA_UNIT_TARGET_TEAM_FRIENDLY; DOTA_UNIT_TARGET_TEAM_ENEMY; DOTA_UNIT_TARGET_TEAM_BOTH
			local units	= FindUnitsInRadius(team, location, nil, AoERadius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
			for _,victim in pairs(units) do

				-- Apply Damage --
				EncounterApplyDamage(victim, caster, self, damage, DAMAGE_TYPE_MAGICAL, DOTA_DAMAGE_FLAG_NONE)
			
			end

		end)
		PersistentTimer_Add(timer)

	end

end

function structures_of_xunra_unholy_discharge:OnAbilityPhaseStart()
	local caster			= self:GetCaster()
	local playerID			= caster:GetPlayerOwnerID()
	local player			= PlayerResource:GetPlayer(playerID)

	return true
end

function structures_of_xunra_unholy_discharge:GetManaCost(abilitylevel)
	return self.BaseClass.GetManaCost(self, abilitylevel)
end

function structures_of_xunra_unholy_discharge:GetCooldown(abilitylevel)
	return self.BaseClass.GetCooldown(self, abilitylevel)
end