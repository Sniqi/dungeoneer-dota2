demonic_warrior_axe_thrower_modifier = class({})

function demonic_warrior_axe_thrower_modifier:OnCreated( kv )
	self.duration                     = self:GetAbility():GetSpecialValueFor("duration")
	self.move_speed_percentage        = self:GetAbility():GetSpecialValueFor("move_speed_percentage")
end

function demonic_warrior_axe_thrower_modifier:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_TOOLTIP,
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
	}

	return funcs
end


function demonic_warrior_axe_thrower_modifier:OnTooltip( params )
	return self.duration
end

function demonic_warrior_axe_thrower_modifier:GetModifierMoveSpeedBonus_Percentage( params )
	return self.move_speed_percentage
end


function demonic_warrior_axe_thrower_modifier:GetAttributes()
	return MODIFIER_ATTRIBUTE_MULTIPLE
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