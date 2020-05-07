deathspeaker_xunra_deathly_scythe = class({})

LinkLuaModifier( 'deathspeaker_xunra_deathly_scythe_modifier', 'encounters/deathspeaker_xunra/deathspeaker_xunra_deathly_scythe_modifier', LUA_MODIFIER_MOTION_NONE )

function deathspeaker_xunra_deathly_scythe:OnSpellStart()

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
	local duration                    = self:GetSpecialValueFor("duration")
	local damage                      = self:GetSpecialValueFor("damage")
	local delay                       = self:GetSpecialValueFor("delay")
	local move_speed_percentage       = self:GetSpecialValueFor("move_speed_percentage")
	local magic_resist_percentage     = self:GetSpecialValueFor("magic_resist_percentage")
	local phase_two_percentage        = self:GetSpecialValueFor("phase_two_percentage")
	local phase_two_delay             = self:GetSpecialValueFor("phase_two_delay")

	-- PHASE 2 --
	if caster:GetHealthPercent() < phase_two_percentage then
		delay = phase_two_delay
	end

	caster:AddNewModifier(caster, self, "casting_rooted_modifier", {duration=1.0})
	DisableMotionControllers(caster, 1.0)

	TurnToLoc(caster, victim_loc, 1.0)

	-- Sound and Animation --
	local sound = {"necrolyte_necr_ability_reap_01", "necrolyte_necr_ability_reap_02",
					"necrolyte_necr_ability_reap_03", "necrolyte_necr_attack_11"}
	EmitAnnouncerSound( sound[RandomInt(1, #sound)] )
	
	StartAnimation(caster, {duration=1.0, activity=ACT_DOTA_CAST_ABILITY_1, rate=0.94})

	EncounterGroundAOEWarningSticky(victim_loc, AoERadius, delay+0.1)

	local timer = Timers:CreateTimer(delay-1.5, function()

		-- Particle -- PATTACH_ABSORIGIN-PATTACH_ABSORIGIN_FOLLOW-PATTACH_CUSTOMORIGIN
		local particle = ParticleManager:CreateParticle("particles/econ/items/necrolyte/necro_sullen_harvest/necro_ti7_immortal_scythe_start.vpcf", PATTACH_CUSTOMORIGIN, nil)
		ParticleManager:SetParticleControl( particle, 0, victim_loc )
		ParticleManager:SetParticleControl( particle, 1, victim_loc )
		ParticleManager:SetParticleControl( particle, 4, ( caster_loc - victim_loc ):Normalized() )
		ParticleManager:ReleaseParticleIndex( particle )
		particle = nil

		-- Sound --
		StartSoundEventFromPositionReliable("Hero_Necrolyte.ReapersScythe.Cast", victim_loc)
		-- Sound --
		StartSoundEventFromPositionReliable("Hero_Necrolyte.ReapersScythe.Target", victim_loc)

	end)
	PersistentTimer_Add(timer)
	
	local timer = Timers:CreateTimer(delay, function()



		-- DOTA_UNIT_TARGET_TEAM_FRIENDLY; DOTA_UNIT_TARGET_TEAM_ENEMY; DOTA_UNIT_TARGET_TEAM_BOTH
		local units	= FindUnitsInRadius(team, victim_loc, nil, AoERadius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
		for _,victim in pairs(units) do

			-- Modifier --
			victim:AddNewModifier(caster, self, "deathspeaker_xunra_deathly_scythe_modifier", {duration = duration})

			-- Apply Damage --
			EncounterApplyDamage(victim, caster, self, damage, DAMAGE_TYPE_MAGICAL, DOTA_DAMAGE_FLAG_NONE)
		
		end

	end)
	PersistentTimer_Add(timer)

end

function deathspeaker_xunra_deathly_scythe:OnAbilityPhaseStart()
	local caster			= self:GetCaster()
	local playerID			= caster:GetPlayerOwnerID()
	local player			= PlayerResource:GetPlayer(playerID)

	return true
end

function deathspeaker_xunra_deathly_scythe:GetManaCost(abilitylevel)
	return self.BaseClass.GetManaCost(self, abilitylevel)
end

function deathspeaker_xunra_deathly_scythe:GetCooldown(abilitylevel)
	return self.BaseClass.GetCooldown(self, abilitylevel)
end