elite_royal_guardian_icy_cleave_modifier = class({})

function elite_royal_guardian_icy_cleave_modifier:OnCreated( kv )
	self.attack_speed_constant        = self:GetAbility():GetSpecialValueFor("attack_speed_constant")
	self.move_speed_percentage        = self:GetAbility():GetSpecialValueFor("move_speed_percentage")
end

function elite_royal_guardian_icy_cleave_modifier:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
	}

	return funcs
end


function elite_royal_guardian_icy_cleave_modifier:GetModifierAttackSpeedBonus_Constant( params )
	return self.attack_speed_constant
end

function elite_royal_guardian_icy_cleave_modifier:GetModifierMoveSpeedBonus_Percentage( params )
	return self.move_speed_percentage
end


function elite_royal_guardian_icy_cleave_modifier:GetAttributes()
	return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE
end

function elite_royal_guardian_icy_cleave_modifier:IsHidden()
    return false
end

function elite_royal_guardian_icy_cleave_modifier:IsPurgable()
	return false
end

function elite_royal_guardian_icy_cleave_modifier:IsPurgeException()
	return false
end

function elite_royal_guardian_icy_cleave_modifier:IsStunDebuff()
	return false
end

function elite_royal_guardian_icy_cleave_modifier:IsDebuff()
	return true
end