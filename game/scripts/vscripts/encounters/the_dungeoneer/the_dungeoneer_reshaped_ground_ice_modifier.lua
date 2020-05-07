the_dungeoneer_reshaped_ground_ice_modifier = class({})

function the_dungeoneer_reshaped_ground_ice_modifier:OnCreated( kv )
	self.ice_move_speed_percentage    = self:GetAbility():GetSpecialValueFor("ice_move_speed_percentage")
end

function the_dungeoneer_reshaped_ground_ice_modifier:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
	}

	return funcs
end


function the_dungeoneer_reshaped_ground_ice_modifier:GetModifierMoveSpeedBonus_Percentage( params )
	return self.ice_move_speed_percentage
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