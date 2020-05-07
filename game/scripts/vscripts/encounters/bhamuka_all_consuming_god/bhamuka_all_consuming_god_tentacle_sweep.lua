bhamuka_all_consuming_god_tentacle_sweep = class({})

LinkLuaModifier( 'bhamuka_all_consuming_god_tentacle_sweep_modifier', 'encounters/bhamuka_all_consuming_god/bhamuka_all_consuming_god_tentacle_sweep_modifier', LUA_MODIFIER_MOTION_NONE )

function bhamuka_all_consuming_god_tentacle_sweep:OnSpellStart()

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
	local duration                    = self:GetSpecialValueFor("duration")

	-- Sound --
	local sound = {"outworld_destroyer_odest_ability_imprison_04", "outworld_destroyer_odest_ability_imprison_05",
					"outworld_destroyer_odest_ability_imprison_08", "outworld_destroyer_odest_ability_imprison_12"}
	EmitAnnouncerSound( sound[RandomInt(1, #sound)] )

	local timer = Timers:CreateTimer(delay, function()

		-- Sound --
		victim:EmitSound("Hero_Tidehunter.RavageDamage")

		-- Particle --
		local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_tidehunter/tidehunter_spell_ravage_hit.vpcf", PATTACH_ABSORIGIN, victim)
		ParticleManager:SetParticleControl( particle, 0, victim:GetAbsOrigin() )
		ParticleManager:ReleaseParticleIndex( particle )

		-- DOTA_UNIT_TARGET_TEAM_FRIENDLY; DOTA_UNIT_TARGET_TEAM_ENEMY; DOTA_UNIT_TARGET_TEAM_BOTH
		local units	= FindUnitsInRadius(team, victim_loc, nil, AoERadius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
		for _,victim in pairs(units) do
			-- Modifier --
			local modifier = victim:AddNewModifier(caster, self, "bhamuka_all_consuming_god_tentacle_sweep_modifier", {duration = duration})
			PersistentModifier_Add(modifier)

			-- Knockback --
			local knockback =
				{
					knockback_duration = duration,
					duration = duration,
					knockback_distance = 200,
					knockback_height = 350,
				}
			victim:RemoveModifierByName("modifier_knockback")
			local modifier = victim:AddNewModifier(caster, self, "modifier_knockback", knockback)
			PersistentModifier_Add(modifier)

			-- Apply Damage --
			EncounterApplyDamage(victim, caster, self, damage, DAMAGE_TYPE_PHYSICAL, DOTA_DAMAGE_FLAG_NONE)
		end

	end)
	PersistentTimer_Add(timer)

end

function bhamuka_all_consuming_god_tentacle_sweep:OnAbilityPhaseStart()
	local caster			= self:GetCaster()
	local playerID			= caster:GetPlayerOwnerID()
	local player			= PlayerResource:GetPlayer(playerID)

	return true
end

function bhamuka_all_consuming_god_tentacle_sweep:GetManaCost(abilitylevel)
	return self.BaseClass.GetManaCost(self, abilitylevel)
end

function bhamuka_all_consuming_god_tentacle_sweep:GetCooldown(abilitylevel)
	return self.BaseClass.GetCooldown(self, abilitylevel)
end