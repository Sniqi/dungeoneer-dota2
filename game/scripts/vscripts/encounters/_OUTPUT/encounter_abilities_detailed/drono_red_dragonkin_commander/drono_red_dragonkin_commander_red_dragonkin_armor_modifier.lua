drono_red_dragonkin_commander_red_dragonkin_armor_modifier = class({})

function drono_red_dragonkin_commander_red_dragonkin_armor_modifier:OnCreated( kv )
	self.killed_dragonkin_damage_to_drono_percentage= self:GetAbility():GetSpecialValueFor("killed_dragonkin_damage_to_drono_percentage")
end

function drono_red_dragonkin_commander_red_dragonkin_armor_modifier:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_TOOLTIP,
	}

	return funcs
end


function drono_red_dragonkin_commander_red_dragonkin_armor_modifier:OnTooltip( params )
	return self.killed_dragonkin_damage_to_drono_percentage
end


function drono_red_dragonkin_commander_red_dragonkin_armor_modifier:GetAttributes()
	return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE
end

function drono_red_dragonkin_commander_red_dragonkin_armor_modifier:IsHidden()
    return false
end

function drono_red_dragonkin_commander_red_dragonkin_armor_modifier:IsPurgable()
	return false
end

function drono_red_dragonkin_commander_red_dragonkin_armor_modifier:IsPurgeException()
	return false
end

function drono_red_dragonkin_commander_red_dragonkin_armor_modifier:IsStunDebuff()
	return false
end

function drono_red_dragonkin_commander_red_dragonkin_armor_modifier:IsDebuff()
	return true
end