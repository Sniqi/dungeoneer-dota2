deathspeaker_xunra_bhamukas_mental_presence = class({})

function deathspeaker_xunra_bhamukas_mental_presence:OnSpellStart()

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
	local AbilityCastRange            = self:GetSpecialValueFor("AbilityCastRange")
	local AoERadius                   = self:GetSpecialValueFor("AoERadius")
	local damage                      = self:GetSpecialValueFor("damage")
	local delay                       = self:GetSpecialValueFor("delay")

	caster:AddNewModifier(caster, self, "casting_modifier", {duration = delay/2})

	-- Sound and Animation --
	local sound = {"outworld_destroyer_odest_move_10", "outworld_destroyer_odest_attack_03",
					"outworld_destroyer_odest_move_08", "outworld_destroyer_odest_attack_05"}
	EmitAnnouncerSound( sound[RandomInt(1, #sound)] )

	local loc_start = GetRandomBorderPoint()
	local loc_forward = ( victim_loc - loc_start ):Normalized()
	local loc_end = loc_start + ( loc_forward * AbilityCastRange )

	EncounterGroundLineWarning(caster, AoERadius, AoERadius, loc_start, loc_forward, AbilityCastRange, delay+0.1)

	StartSoundEventFromPositionReliable("Hero_Terrorblade.Metamorphosis", loc_start)

	local unit = CreateUnitByName("dummy", loc_start, true, nil, nil, DOTA_TEAM_BADGUYS)
	PersistentUnit_Add(unit)

	unit:AddNewModifier(caster, self, "modifier_invulnerable", {})
	unit:AddNewModifier(caster, self, "modifier_unselectable", {})
	unit:AddNewModifier(caster, self, "modifier_phased", {})

	TurnToLoc(unit, loc_end, 0.1)

	local particle

	local timer = Timers:CreateTimer(0.1, function()
		-- Particle -- PATTACH_ABSORIGIN-PATTACH_ABSORIGIN_FOLLOW-PATTACH_CUSTOMORIGIN
		particle = ParticleManager:CreateParticle("particles/econ/items/chaos_knight/chaos_knight_ti7_shield/chaos_knight_ti7_reality_rift.vpcf", PATTACH_CUSTOMORIGIN, nil)
		ParticleManager:SetParticleControl( particle, 1, unit:GetAbsOrigin() )
		ParticleManager:SetParticleControl( particle, 2, unit:GetAbsOrigin() )
		ParticleManager:SetParticleControlOrientation( particle, 1, unit:GetForwardVector(), unit:GetRightVector(), unit:GetUpVector() )
		ParticleManager:SetParticleControlOrientation( particle, 2, unit:GetForwardVector(), unit:GetRightVector(), unit:GetUpVector() )
		PersistentParticle_Add(particle)
	end)

	local timer = Timers:CreateTimer(delay, function()

		ParticleManager:DestroyParticle( particle, false )
		ParticleManager:ReleaseParticleIndex( particle )
		particle = nil

		-- Particle -- PATTACH_ABSORIGIN-PATTACH_ABSORIGIN_FOLLOW-PATTACH_CUSTOMORIGIN
		local particle = ParticleManager:CreateParticle("particles/encounter/deathspeaker_xunra/deathspeaker_xunra_bhamukas_mental_presence_lightning.vpcf", PATTACH_CUSTOMORIGIN, nil)
		ParticleManager:SetParticleControl( particle, 0, loc_start )
		ParticleManager:SetParticleControl( particle, 1, loc_end )
		ParticleManager:ReleaseParticleIndex( particle )
		particle = nil

		-- DOTA_UNIT_TARGET_TEAM_FRIENDLY; DOTA_UNIT_TARGET_TEAM_ENEMY; DOTA_UNIT_TARGET_TEAM_BOTH
		local units	= FindUnitsInLine(team, loc_start, loc_end, nil, AoERadius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE)
		for _,victim in pairs(units) do

			-- Apply Damage --
			EncounterApplyDamage(victim, caster, self, damage, DAMAGE_TYPE_MAGICAL, DOTA_DAMAGE_FLAG_NONE)

		end

	end)
	PersistentTimer_Add(timer)

end

function deathspeaker_xunra_bhamukas_mental_presence:OnAbilityPhaseStart()
	local caster			= self:GetCaster()
	local playerID			= caster:GetPlayerOwnerID()
	local player			= PlayerResource:GetPlayer(playerID)

	return true
end

function deathspeaker_xunra_bhamukas_mental_presence:GetManaCost(abilitylevel)
	return self.BaseClass.GetManaCost(self, abilitylevel)
end

function deathspeaker_xunra_bhamukas_mental_presence:GetCooldown(abilitylevel)
	return self.BaseClass.GetCooldown(self, abilitylevel)
end