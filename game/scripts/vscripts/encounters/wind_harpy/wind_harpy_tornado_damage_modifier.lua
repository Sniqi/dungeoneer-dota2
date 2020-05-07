wind_harpy_tornado_damage_modifier = class({})

function wind_harpy_tornado_damage_modifier:OnCreated( kv )
	self.AoERadius                    = self:GetAbility():GetSpecialValueFor("AoERadius")
	self.damage                       = self:GetAbility():GetSpecialValueFor("damage")
	self.damage_interval              = self:GetAbility():GetSpecialValueFor("damage_interval")
	self.move_speed                   = self:GetAbility():GetSpecialValueFor("move_speed")
	self.phase_two                    = self:GetAbility():GetSpecialValueFor("phase_two")
	self.phase_two_move_speed         = self:GetAbility():GetSpecialValueFor("phase_two_move_speed")
	self.phase_two_radius_percentage  = self:GetAbility():GetSpecialValueFor("phase_two_radius_percentage")
	self.phase_three                  = self:GetAbility():GetSpecialValueFor("phase_three")
	self.phase_three_move_speed       = self:GetAbility():GetSpecialValueFor("phase_three_move_speed")
	self.phase_three_radius_percentage= self:GetAbility():GetSpecialValueFor("phase_three_radius_percentage")

	if not IsServer() then return end

	local unit = self:GetParent()

	-- Particle --
	self.particle = ParticleManager:CreateParticle("particles/units/heroes/hero_brewmaster/brewmaster_cyclone.vpcf", PATTACH_ABSORIGIN_FOLLOW, unit)
	ParticleManager:SetParticleControlEnt( self.particle, 0, unit, PATTACH_ABSORIGIN_FOLLOW, nil, unit:GetAbsOrigin(), true)
	PersistentParticle_Add(self.particle)

	self:StartIntervalThink(self.damage_interval)
end

function wind_harpy_tornado_damage_modifier:OnIntervalThink()
	if not IsServer() then return end

	local caster = self:GetCaster()
	local unit = self:GetParent()
	local unit_loc = unit:GetAbsOrigin()
	local team = caster:GetTeamNumber()

	local AoERadius = self.AoERadius
	local damage = self.damage * self.damage_interval

	-- PHASE 2 --
	if caster:GetHealthPercent() < self.phase_two then
		AoERadius = AoERadius * ( 1 + (self.phase_two_radius_percentage / 100) )
	end
	-- PHASE 3 --
	if caster:GetHealthPercent() < self.phase_three then
		AoERadius = AoERadius * ( 1 + (self.phase_three_radius_percentage / 100) )
	end

	-- DOTA_UNIT_TARGET_TEAM_FRIENDLY; DOTA_UNIT_TARGET_TEAM_ENEMY; DOTA_UNIT_TARGET_TEAM_BOTH
	local units	= FindUnitsInRadius(team, unit_loc, nil, AoERadius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
	for _,victim in pairs(units) do
		-- Apply Damage --
		EncounterApplyDamage(victim, caster, self:GetAbility(), damage, DAMAGE_TYPE_MAGICAL, DOTA_DAMAGE_FLAG_NONE)
	end

	-- Movement --

	if self.time == nil or self.time >= 10 then
		self.time = 0

		if self.prev_point == nil then
			self.prev_point = GetRandomBorderPoint()
		else
			self.prev_point = GetRandomBorderPointCounterpart(self.prev_point)
		end

		unit:MoveToPosition(self.prev_point)
	end

	self.time = self.time + self.damage_interval
end

function wind_harpy_tornado_damage_modifier:OnDestroy()
	if not IsServer() then return end
	if self.particle == nil then return end
	if self.particle:IsNull() then return end

	ParticleManager:DestroyParticle( self.particle, false )
	ParticleManager:ReleaseParticleIndex( self.particle )
	self.particle = nil
end

function wind_harpy_tornado_damage_modifier:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_ABSOLUTE,
		MODIFIER_PROPERTY_MOVESPEED_ABSOLUTE_MAX,
		MODIFIER_PROPERTY_TOOLTIP,
		--MODIFIER_PROPERTY_MODEL_CHANGE,
		--MODIFIER_PROPERTY_MODEL_SCALE
	}

	return funcs
end

--[[
function wind_harpy_tornado_damage_modifier:GetModifierModelChange()
	return "particles/units/heroes/hero_brewmaster/brewmaster_cyclone.vpcf"
end

function wind_harpy_tornado_damage_modifier:GetModifierModelScale()
	return 1.0
end
]]

function wind_harpy_tornado_damage_modifier:GetModifierMoveSpeed_Absolute( params )
	if not IsServer() then return end

	local caster = self:GetCaster()

	-- PHASE 2 --
	if caster:GetHealthPercent() < self.phase_two then
		return self.phase_two_move_speed
	end

	-- PHASE 3 --
	if caster:GetHealthPercent() < self.phase_three then
		return self.phase_three_move_speed
	end
	
	return self.move_speed
end

function wind_harpy_tornado_damage_modifier:GetModifierMoveSpeed_AbsoluteMax( params )
	if not IsServer() then return end

	local caster = self:GetCaster()

	-- PHASE 2 --
	if caster:GetHealthPercent() < self.phase_two then
		return self.phase_two_move_speed
	end

	-- PHASE 3 --
	if caster:GetHealthPercent() < self.phase_three then
		return self.phase_three_move_speed
	end
	
	return self.move_speed
end

function wind_harpy_tornado_damage_modifier:OnTooltip( params )
	return self.damage
end

function wind_harpy_tornado_damage_modifier:GetAttributes()
	return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE
end

function wind_harpy_tornado_damage_modifier:IsHidden()
    return true
end

function wind_harpy_tornado_damage_modifier:IsPurgable()
	return false
end

function wind_harpy_tornado_damage_modifier:IsPurgeException()
	return false
end

function wind_harpy_tornado_damage_modifier:IsStunDebuff()
	return false
end

function wind_harpy_tornado_damage_modifier:IsDebuff()
	return false
end