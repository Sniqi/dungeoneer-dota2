ancient_siege_engine_burning_wheels_modifier = class({})

function ancient_siege_engine_burning_wheels_modifier:OnCreated( kv )
	self.move_speed_absolute          = self:GetAbility():GetSpecialValueFor("move_speed_absolute")
	self.move_speed_max               = self:GetAbility():GetSpecialValueFor("move_speed_max")
end

function ancient_siege_engine_burning_wheels_modifier:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_ABSOLUTE,
		MODIFIER_PROPERTY_MOVESPEED_ABSOLUTE_MAX,
	}

	return funcs
end


function ancient_siege_engine_burning_wheels_modifier:GetModifierMoveSpeed_Absolute( params )
	return self.move_speed_absolute
end

function ancient_siege_engine_burning_wheels_modifier:GetModifierMoveSpeed_AbsoluteMax( params )
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
	return true
end