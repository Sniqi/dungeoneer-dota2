wind_harpy_tornado = class({})

LinkLuaModifier( 'wind_harpy_tornado_checker_modifier', 'encounters/wind_harpy/wind_harpy_tornado_checker_modifier', LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( 'wind_harpy_tornado_damage_modifier', 'encounters/wind_harpy/wind_harpy_tornado_damage_modifier', LUA_MODIFIER_MOTION_NONE )

function wind_harpy_tornado:OnSpellStart()

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
	local move_speed                  = self:GetSpecialValueFor("move_speed")

	caster:AddNewModifier(caster, self, "wind_harpy_tornado_checker_modifier", {})
end

function wind_harpy_tornado:OnAbilityPhaseStart()
	local caster			= self:GetCaster()
	local playerID			= caster:GetPlayerOwnerID()
	local player			= PlayerResource:GetPlayer(playerID)

	return true
end

function wind_harpy_tornado:GetManaCost(abilitylevel)
	return self.BaseClass.GetManaCost(self, abilitylevel)
end

function wind_harpy_tornado:GetCooldown(abilitylevel)
	return self.BaseClass.GetCooldown(self, abilitylevel)
end