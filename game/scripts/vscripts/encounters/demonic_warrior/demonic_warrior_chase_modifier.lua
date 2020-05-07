demonic_warrior_chase_modifier = class({})

function demonic_warrior_chase_modifier:OnCreated( kv )
	self.move_speed_absolute          = self:GetAbility():GetSpecialValueFor("move_speed_absolute")
	self.move_speed_max               = self:GetAbility():GetSpecialValueFor("move_speed_max")
end

function demonic_warrior_chase_modifier:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_ABSOLUTE,
		MODIFIER_PROPERTY_MOVESPEED_ABSOLUTE_MAX,
	}

	return funcs
end


function demonic_warrior_chase_modifier:GetModifierMoveSpeed_Absolute( params )
	return self.move_speed_absolute
end

function demonic_warrior_chase_modifier:GetModifierMoveSpeed_AbsoluteMax( params )
	return self.move_speed_max
end


function demonic_warrior_chase_modifier:GetAttributes()
	return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE
end

function demonic_warrior_chase_modifier:IsHidden()
    return false
end

function demonic_warrior_chase_modifier:IsPurgable()
	return false
end

function demonic_warrior_chase_modifier:IsPurgeException()
	return false
end

function demonic_warrior_chase_modifier:IsStunDebuff()
	return false
end

function demonic_warrior_chase_modifier:IsDebuff()
	return false
end