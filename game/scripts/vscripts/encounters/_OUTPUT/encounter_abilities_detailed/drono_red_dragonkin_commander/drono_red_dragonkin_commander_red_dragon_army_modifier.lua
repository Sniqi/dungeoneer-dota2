drono_red_dragonkin_commander_red_dragon_army_modifier = class({})

function drono_red_dragonkin_commander_red_dragon_army_modifier:OnCreated( kv )
	self.killed_dragonkin_damage_to_drono_percentage= self:GetAbility():GetSpecialValueFor("killed_dragonkin_damage_to_drono_percentage")
end

function drono_red_dragonkin_commander_red_dragon_army_modifier:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_TOOLTIP,
	}

	return funcs
end


function drono_red_dragonkin_commander_red_dragon_army_modifier:OnTooltip( params )
	return self.killed_dragonkin_damage_to_drono_percentage
end


function drono_red_dragonkin_commander_red_dragon_army_modifier:GetAttributes()
	return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE
end

function drono_red_dragonkin_commander_red_dragon_army_modifier:IsHidden()
    return false
end

function drono_red_dragonkin_commander_red_dragon_army_modifier:IsPurgable()
	return false
end

function drono_red_dragonkin_commander_red_dragon_army_modifier:IsPurgeException()
	return false
end

function drono_red_dragonkin_commander_red_dragon_army_modifier:IsStunDebuff()
	return false
end

function drono_red_dragonkin_commander_red_dragon_army_modifier:IsDebuff()
	return true
end