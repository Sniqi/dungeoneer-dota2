demonic_warrior_rest_enhancement_modifier = class({})

function demonic_warrior_rest_enhancement_modifier:OnCreated( kv )
	self.duration                     = self:GetAbility():GetSpecialValueFor("duration")
	self.attack_speed_constant        = self:GetAbility():GetSpecialValueFor("attack_speed_constant")
end

function demonic_warrior_rest_enhancement_modifier:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_TOOLTIP,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
	}

	return funcs
end


function demonic_warrior_rest_enhancement_modifier:OnTooltip( params )
	return self.duration
end

function demonic_warrior_rest_enhancement_modifier:GetModifierAttackSpeedBonus_Constant( params )
	return self.attack_speed_constant
end


function demonic_warrior_rest_enhancement_modifier:GetAttributes()
	return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE
end

function demonic_warrior_rest_enhancement_modifier:IsHidden()
    return false
end

function demonic_warrior_rest_enhancement_modifier:IsPurgable()
	return false
end

function demonic_warrior_rest_enhancement_modifier:IsPurgeException()
	return false
end

function demonic_warrior_rest_enhancement_modifier:IsStunDebuff()
	return false
end

function demonic_warrior_rest_enhancement_modifier:IsDebuff()
	return true
end