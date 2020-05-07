iron_claw_absorbing_skin = class({})

LinkLuaModifier( 'iron_claw_absorbing_skin_modifier', 'encounters/iron_claw/iron_claw_absorbing_skin_modifier', LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( 'iron_claw_absorbing_skin_attack_damage_modifier', 'encounters/iron_claw/iron_claw_absorbing_skin_attack_damage_modifier', LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( 'iron_claw_absorbing_skin_move_speed_modifier', 'encounters/iron_claw/iron_claw_absorbing_skin_move_speed_modifier', LUA_MODIFIER_MOTION_NONE )

function iron_claw_absorbing_skin:OnSpellStart()

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
	local damage_to_attack_damage_percentage= self:GetSpecialValueFor("damage_to_attack_damage_percentage")
	local damage_to_move_speed_percentage= self:GetSpecialValueFor("damage_to_move_speed_percentage")
	
	-- Modifier --
	caster:AddNewModifier(caster, self, "iron_claw_absorbing_skin_modifier", {})
	-- Modifier --
	caster:AddNewModifier(caster, self, "iron_claw_absorbing_skin_attack_damage_modifier", {})
	-- Modifier --
	caster:AddNewModifier(caster, self, "iron_claw_absorbing_skin_move_speed_modifier", {})
end

function iron_claw_absorbing_skin:OnAbilityPhaseStart()
	local caster			= self:GetCaster()
	local playerID			= caster:GetPlayerOwnerID()
	local player			= PlayerResource:GetPlayer(playerID)

	return true
end

function iron_claw_absorbing_skin:GetManaCost(abilitylevel)
	return self.BaseClass.GetManaCost(self, abilitylevel)
end

function iron_claw_absorbing_skin:GetCooldown(abilitylevel)
	return self.BaseClass.GetCooldown(self, abilitylevel)
end