demonic_warrior_deep_cutting_axe = class({})

LinkLuaModifier( 'demonic_warrior_deep_cutting_axe_modifier', 'encounters/demonic_warrior/demonic_warrior_deep_cutting_axe_modifier', LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( 'demonic_warrior_deep_cutting_axe_wound_modifier', 'encounters/demonic_warrior/demonic_warrior_deep_cutting_axe_wound_modifier', LUA_MODIFIER_MOTION_NONE )

function demonic_warrior_deep_cutting_axe:OnSpellStart()

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

	-- Modifier --
	caster:AddNewModifier(caster, self, "demonic_warrior_deep_cutting_axe_modifier", {})
	
end

function demonic_warrior_deep_cutting_axe:OnAbilityPhaseStart()
	local caster			= self:GetCaster()
	local playerID			= caster:GetPlayerOwnerID()
	local player			= PlayerResource:GetPlayer(playerID)

	return true
end

function demonic_warrior_deep_cutting_axe:GetManaCost(abilitylevel)
	return self.BaseClass.GetManaCost(self, abilitylevel)
end

function demonic_warrior_deep_cutting_axe:GetCooldown(abilitylevel)
	return self.BaseClass.GetCooldown(self, abilitylevel)
end