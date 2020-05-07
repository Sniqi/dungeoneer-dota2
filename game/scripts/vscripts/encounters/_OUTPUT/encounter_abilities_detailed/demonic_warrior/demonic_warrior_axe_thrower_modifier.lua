demonic_warrior_axe_thrower_modifier = class({})

function demonic_warrior_axe_thrower_modifier:OnCreated( kv )
	self.move_speed_percentage        = self:GetAbility():GetSpecialValueFor("move_speed_percentage")
	self.debuff_duration              = self:GetAbility():GetSpecialValueFor("debuff_duration")
end

function demonic_warrior_axe_thrower_modifier:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_PROPERTY_TOOLTIP,
	}

	return funcs
end


function demonic_warrior_axe_thrower_modifier:GetModifierMoveSpeedBonus_Percentage( params )
	return self.move_speed_percentage
end

function demonic_warrior_axe_thrower_modifier:OnTooltip( params )
	return self.debuff_duration
end


function demonic_warrior_axe_thrower_modifier:GetAttributes()
	return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE
end

function demonic_warrior_axe_thrower_modifier:IsHidden()
    return false
end

function demonic_warrior_axe_thrower_modifier:IsPurgable()
	return false
end

function demonic_warrior_axe_thrower_modifier:IsPurgeException()
	return false
end

function demonic_warrior_axe_thrower_modifier:IsStunDebuff()
	return false
end

function demonic_warrior_axe_thrower_modifier:IsDebuff()
	return true
end