drono_red_dragonkin_commander_fiery_cleave_modifier = class({})

function drono_red_dragonkin_commander_fiery_cleave_modifier:OnCreated( kv )
	self.attack_speed_constant        = self:GetAbility():GetSpecialValueFor("attack_speed_constant")
	self.move_speed_percentage        = self:GetAbility():GetSpecialValueFor("move_speed_percentage")
end

function drono_red_dragonkin_commander_fiery_cleave_modifier:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
	}

	return funcs
end


function drono_red_dragonkin_commander_fiery_cleave_modifier:GetModifierAttackSpeedBonus_Constant( params )
	return self.attack_speed_constant
end

function drono_red_dragonkin_commander_fiery_cleave_modifier:GetModifierMoveSpeedBonus_Percentage( params )
	return self.move_speed_percentage
end


function drono_red_dragonkin_commander_fiery_cleave_modifier:GetAttributes()
	return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE
end

function drono_red_dragonkin_commander_fiery_cleave_modifier:IsHidden()
    return false
end

function drono_red_dragonkin_commander_fiery_cleave_modifier:IsPurgable()
	return false
end

function drono_red_dragonkin_commander_fiery_cleave_modifier:IsPurgeException()
	return false
end

function drono_red_dragonkin_commander_fiery_cleave_modifier:IsStunDebuff()
	return false
end

function drono_red_dragonkin_commander_fiery_cleave_modifier:IsDebuff()
	return true
end