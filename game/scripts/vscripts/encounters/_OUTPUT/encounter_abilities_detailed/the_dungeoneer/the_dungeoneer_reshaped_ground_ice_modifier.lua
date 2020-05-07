the_dungeoneer_reshaped_ground_ice_modifier = class({})

function the_dungeoneer_reshaped_ground_ice_modifier:OnCreated( kv )
	self.move_speed_percentage        = self:GetAbility():GetSpecialValueFor("move_speed_percentage")
	self.earth_stun_duration          = self:GetAbility():GetSpecialValueFor("earth_stun_duration")
end

function the_dungeoneer_reshaped_ground_ice_modifier:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_PROPERTY_TOOLTIP,
	}

	return funcs
end


function the_dungeoneer_reshaped_ground_ice_modifier:GetModifierMoveSpeedBonus_Percentage( params )
	return self.move_speed_percentage
end

function the_dungeoneer_reshaped_ground_ice_modifier:OnTooltip( params )
	return self.earth_stun_duration
end


function the_dungeoneer_reshaped_ground_ice_modifier:GetAttributes()
	return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE
end

function the_dungeoneer_reshaped_ground_ice_modifier:IsHidden()
    return false
end

function the_dungeoneer_reshaped_ground_ice_modifier:IsPurgable()
	return false
end

function the_dungeoneer_reshaped_ground_ice_modifier:IsPurgeException()
	return false
end

function the_dungeoneer_reshaped_ground_ice_modifier:IsStunDebuff()
	return false
end

function the_dungeoneer_reshaped_ground_ice_modifier:IsDebuff()
	return true
end