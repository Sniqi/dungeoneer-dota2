sinastra_cold_presence = class({})

LinkLuaModifier( 'sinastra_cold_presence_modifier', 'encounters/sinastra/sinastra_cold_presence_modifier', LUA_MODIFIER_MOTION_NONE )

function sinastra_cold_presence:OnSpellStart()

	if self.casted then return end
	self.casted = true

	--- Get Caster, Victim, Player, Point ---
	local caster		= self:GetCaster()
	local caster_loc	= caster:GetAbsOrigin()
	local playerID		= caster:GetPlayerOwnerID()
	local player		= PlayerResource:GetPlayer(playerID)
	local team			= caster:GetTeamNumber()
	
	--- Get Special Values ---
	local damage                      = self:GetSpecialValueFor("damage")
	local damage_interval             = self:GetSpecialValueFor("damage_interval")
	local move_speed_percentage       = self:GetSpecialValueFor("move_speed_percentage")
	local no_movement_duration        = self:GetSpecialValueFor("no_movement_duration")
	local ice_block_duration          = self:GetSpecialValueFor("ice_block_duration")

	for _,victim in pairs( GetHeroesEntities() ) do
		-- Modifier --
		local modifier = victim:AddNewModifier(caster, self, "sinastra_cold_presence_modifier", {})
		PersistentModifier_Add(modifier)
	end
	
end

function sinastra_cold_presence:OnAbilityPhaseStart()
	local caster			= self:GetCaster()
	local playerID			= caster:GetPlayerOwnerID()
	local player			= PlayerResource:GetPlayer(playerID)

	return true
end

function sinastra_cold_presence:GetManaCost(abilitylevel)
	return self.BaseClass.GetManaCost(self, abilitylevel)
end

function sinastra_cold_presence:GetCooldown(abilitylevel)
	return self.BaseClass.GetCooldown(self, abilitylevel)
end