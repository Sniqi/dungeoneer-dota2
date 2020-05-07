drono_red_dragonkin_commander_rally_modifier = class({})

function drono_red_dragonkin_commander_rally_modifier:OnCreated( kv )
	self.move_speed_percentage        = self:GetAbility():GetSpecialValueFor("move_speed_percentage")
	self.armor                        = self:GetAbility():GetSpecialValueFor("armor")
	self.magic_resist_percentage      = self:GetAbility():GetSpecialValueFor("magic_resist_percentage")
end

function drono_red_dragonkin_commander_rally_modifier:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
		MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,
	}

	return funcs
end


function drono_red_dragonkin_commander_rally_modifier:GetModifierMoveSpeedBonus_Percentage( params )
	return self.move_speed_percentage
end

function drono_red_dragonkin_commander_rally_modifier:GetModifierPhysicalArmorBonus( params )
	return self.armor
end

function drono_red_dragonkin_commander_rally_modifier:GetModifierMagicalResistanceBonus( params )
	return self.magic_resist_percentage
end


function drono_red_dragonkin_commander_rally_modifier:GetAttributes()
	return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE
end

function drono_red_dragonkin_commander_rally_modifier:IsHidden()
    return false
end

function drono_red_dragonkin_commander_rally_modifier:IsPurgable()
	return false
end

function drono_red_dragonkin_commander_rally_modifier:IsPurgeException()
	return false
end

function drono_red_dragonkin_commander_rally_modifier:IsStunDebuff()
	return false
end

function drono_red_dragonkin_commander_rally_modifier:IsDebuff()
	return true
end