ancient_siege_engine_burning_wheels_modifier = class({})

function ancient_siege_engine_burning_wheels_modifier:OnCreated( kv )
	self.move_speed_absolute          = self:GetAbility():GetSpecialValueFor("move_speed_absolute")
	self.move_speed_max               = self:GetAbility():GetSpecialValueFor("move_speed_max")
	self.phase_two                    = self:GetAbility():GetSpecialValueFor("phase_two")
	self.phase_two_move_speed_absolute= self:GetAbility():GetSpecialValueFor("phase_two_move_speed_absolute")
	self.phase_two_move_speed_max     = self:GetAbility():GetSpecialValueFor("phase_two_move_speed_max")
end

function ancient_siege_engine_burning_wheels_modifier:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_ABSOLUTE,
		MODIFIER_PROPERTY_MOVESPEED_ABSOLUTE_MAX,
	}

	return funcs
end


function ancient_siege_engine_burning_wheels_modifier:GetModifierMoveSpeed_Absolute( params )
	if not IsServer() then return end

	local caster = self:GetCaster()

	-- PHASE 2 --
	if caster:GetHealthPercent() < self.phase_two then
		return self.phase_two_move_speed_absolute
	end

	return self.move_speed_absolute
end

function ancient_siege_engine_burning_wheels_modifier:GetModifierMoveSpeed_AbsoluteMax( params )
	if not IsServer() then return end

	local caster = self:GetCaster()

	-- PHASE 2 --
	if caster:GetHealthPercent() < self.phase_two then
		return self.phase_two_move_speed_max
	end

	return self.move_speed_max
end


function ancient_siege_engine_burning_wheels_modifier:GetAttributes()
	return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE
end

function ancient_siege_engine_burning_wheels_modifier:IsHidden()
    return false
end

function ancient_siege_engine_burning_wheels_modifier:IsPurgable()
	return false
end

function ancient_siege_engine_burning_wheels_modifier:IsPurgeException()
	return false
end

function ancient_siege_engine_burning_wheels_modifier:IsStunDebuff()
	return false
end

function ancient_siege_engine_burning_wheels_modifier:IsDebuff()
	return false
end