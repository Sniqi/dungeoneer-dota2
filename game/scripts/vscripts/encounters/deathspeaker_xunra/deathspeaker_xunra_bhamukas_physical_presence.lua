deathspeaker_xunra_bhamukas_physical_presence = class({})

LinkLuaModifier( 'deathspeaker_xunra_tentacle_sweep_modifier', 'encounters/deathspeaker_xunra/deathspeaker_xunra_tentacle_sweep_modifier', LUA_MODIFIER_MOTION_NONE )

function deathspeaker_xunra_bhamukas_physical_presence:OnSpellStart()

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
	local damage                      = self:GetSpecialValueFor("damage")
	local delay                       = self:GetSpecialValueFor("delay")
	local stun                        = self:GetSpecialValueFor("stun")

	caster:AddNewModifier(caster, self, "casting_modifier", {duration = delay/2})

	-- Sound and Animation --
	local sound = {"outworld_destroyer_odest_ability_imprison_05", "outworld_destroyer_odest_move_03",
					"outworld_destroyer_odest_attack_01", "outworld_destroyer_odest_cast_01"}
	EmitAnnouncerSound( sound[RandomInt(1, #sound)] )

	EncounterGroundAOEWarningSticky(victim_loc, AoERadius, delay+0.1)

	local timer = Timers:CreateTimer(delay, function()

		-- Sound --
		victim:EmitSound("Hero_Tidehunter.RavageDamage")

		-- Particle --
		local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_tidehunter/tidehunter_spell_ravage_hit.vpcf", PATTACH_CUSTOMORIGIN, nil)
		ParticleManager:SetParticleControl( particle, 0, victim_loc )
		ParticleManager:ReleaseParticleIndex( particle )

		-- DOTA_UNIT_TARGET_TEAM_FRIENDLY; DOTA_UNIT_TARGET_TEAM_ENEMY; DOTA_UNIT_TARGET_TEAM_BOTH
		local units	= FindUnitsInRadius(team, victim_loc, nil, AoERadius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
		for _,victim in pairs(units) do

			-- Knockback --
			local knockback =
				{
					knockback_duration = stun,
					duration = stun,
					knockback_distance = 200,
					knockback_height = 350,
				}
			victim:RemoveModifierByName("modifier_knockback")
			local modifier = victim:AddNewModifier(caster, self, "modifier_knockback", knockback)
			PersistentModifier_Add(modifier)

			-- Modifier --
			local modifier = victim:AddNewModifier(caster, self, "deathspeaker_xunra_tentacle_sweep_modifier", {duration = stun})
			PersistentModifier_Add(modifier)

			-- Apply Damage --
			EncounterApplyDamage(victim, caster, self, damage, DAMAGE_TYPE_PHYSICAL, DOTA_DAMAGE_FLAG_NONE)
		end

	end)
	PersistentTimer_Add(timer)

end

function deathspeaker_xunra_bhamukas_physical_presence:OnAbilityPhaseStart()
	local caster			= self:GetCaster()
	local playerID			= caster:GetPlayerOwnerID()
	local player			= PlayerResource:GetPlayer(playerID)

	return true
end

function deathspeaker_xunra_bhamukas_physical_presence:GetManaCost(abilitylevel)
	return self.BaseClass.GetManaCost(self, abilitylevel)
end

function deathspeaker_xunra_bhamukas_physical_presence:GetCooldown(abilitylevel)
	return self.BaseClass.GetCooldown(self, abilitylevel)
end