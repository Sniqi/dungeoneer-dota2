nether_drake_tail_lash = class({})

LinkLuaModifier( 'nether_drake_tail_lash_modifier', 'encounters/nether_drake/nether_drake_tail_lash_modifier', LUA_MODIFIER_MOTION_NONE )

function nether_drake_tail_lash:OnSpellStart()

	--- Get Caster, Victim, Player, Point ---
	local caster		= self:GetCaster()
	local caster_loc	= caster:GetAbsOrigin()
	local playerID		= caster:GetPlayerOwnerID()
	local player		= PlayerResource:GetPlayer(playerID)
	local team			= caster:GetTeamNumber()
	local victim		= caster
	local victim_loc	= victim:GetAbsOrigin()
	
	--- Get Special Values ---
	local AoERadius                   = self:GetSpecialValueFor("AoERadius")
	local damage                      = self:GetSpecialValueFor("damage")
	local delay                       = self:GetSpecialValueFor("delay")
	local stun                        = self:GetSpecialValueFor("stun")

	-- Modifier --
	caster:AddNewModifier(caster, self, "nether_drake_tail_lash_modifier", {})

end

function nether_drake_tail_lash:OnAbilityPhaseStart()
	local caster			= self:GetCaster()
	local playerID			= caster:GetPlayerOwnerID()
	local player			= PlayerResource:GetPlayer(playerID)

	return true
end

function nether_drake_tail_lash:GetManaCost(abilitylevel)
	return self.BaseClass.GetManaCost(self, abilitylevel)
end

function nether_drake_tail_lash:GetCooldown(abilitylevel)
	return self.BaseClass.GetCooldown(self, abilitylevel)
end