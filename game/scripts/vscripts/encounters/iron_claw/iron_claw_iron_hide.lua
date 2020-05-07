iron_claw_iron_hide = class({})

LinkLuaModifier( 'iron_claw_iron_hide_modifier', 'encounters/iron_claw/iron_claw_iron_hide_modifier', LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( 'iron_claw_iron_hide_getting_tired_modifier', 'encounters/iron_claw/iron_claw_iron_hide_getting_tired_modifier', LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( 'iron_claw_iron_hide_resting_modifier', 'encounters/iron_claw/iron_claw_iron_hide_resting_modifier', LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( 'iron_claw_iron_hide_checker_modifier', 'encounters/iron_claw/iron_claw_iron_hide_checker_modifier', LUA_MODIFIER_MOTION_NONE )

function iron_claw_iron_hide:OnSpellStart()

	--- Get Caster, Victim, Player, Point ---
	local caster		= self:GetCaster()
	local caster_loc	= caster:GetAbsOrigin()
	local playerID		= caster:GetPlayerOwnerID()
	local player		= PlayerResource:GetPlayer(playerID)
	local team			= caster:GetTeamNumber()
	local victim		= caster
	local victim_loc	= victim:GetAbsOrigin()
	
	--- Get Special Values ---
	local armor                       = self:GetSpecialValueFor("armor")
	local magic_resist_percentage     = self:GetSpecialValueFor("magic_resist_percentage")
	local status_resistance_percentage= self:GetSpecialValueFor("status_resistance_percentage")
	local move_speed_percentage       = self:GetSpecialValueFor("move_speed_percentage")
	local rest_time                   = self:GetSpecialValueFor("rest_time")

	-- Modifier --
	caster:AddNewModifier(caster, self, "iron_claw_iron_hide_modifier", {})
	-- Modifier --
	caster:AddNewModifier(caster, self, "iron_claw_iron_hide_checker_modifier", {})
end

function iron_claw_iron_hide:OnAbilityPhaseStart()
	local caster			= self:GetCaster()
	local playerID			= caster:GetPlayerOwnerID()
	local player			= PlayerResource:GetPlayer(playerID)

	return true
end

function iron_claw_iron_hide:GetManaCost(abilitylevel)
	return self.BaseClass.GetManaCost(self, abilitylevel)
end

function iron_claw_iron_hide:GetCooldown(abilitylevel)
	return self.BaseClass.GetCooldown(self, abilitylevel)
end