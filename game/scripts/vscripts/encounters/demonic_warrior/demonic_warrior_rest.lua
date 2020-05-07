demonic_warrior_rest = class({})

LinkLuaModifier( 'demonic_warrior_rest_modifier', 'encounters/demonic_warrior/demonic_warrior_rest_modifier', LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( 'demonic_warrior_rest_enhancement_modifier', 'encounters/demonic_warrior/demonic_warrior_rest_enhancement_modifier', LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( 'demonic_warrior_rest_checker_modifier', 'encounters/demonic_warrior/demonic_warrior_rest_checker_modifier', LUA_MODIFIER_MOTION_NONE )

function demonic_warrior_rest:OnSpellStart()

	--- Get Caster, Victim, Player, Point ---
	local caster		= self:GetCaster()
	local caster_loc	= caster:GetAbsOrigin()
	local playerID		= caster:GetPlayerOwnerID()
	local player		= PlayerResource:GetPlayer(playerID)
	local team			= caster:GetTeamNumber()
	local victim		= caster
	local victim_loc	= victim:GetAbsOrigin()
	
	--- Get Special Values ---
	local duration                    = self:GetSpecialValueFor("duration")
	local attack_speed_constant       = self:GetSpecialValueFor("attack_speed_constant")

	-- Modifier --
	caster:AddNewModifier(caster, self, "demonic_warrior_rest_checker_modifier", {})
end

function demonic_warrior_rest:OnAbilityPhaseStart()
	local caster			= self:GetCaster()
	local playerID			= caster:GetPlayerOwnerID()
	local player			= PlayerResource:GetPlayer(playerID)

	return true
end

function demonic_warrior_rest:GetManaCost(abilitylevel)
	return self.BaseClass.GetManaCost(self, abilitylevel)
end

function demonic_warrior_rest:GetCooldown(abilitylevel)
	return self.BaseClass.GetCooldown(self, abilitylevel)
end