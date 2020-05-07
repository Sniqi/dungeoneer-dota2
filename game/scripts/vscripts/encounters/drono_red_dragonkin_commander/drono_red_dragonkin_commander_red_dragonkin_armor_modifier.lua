drono_red_dragonkin_commander_red_dragonkin_armor_modifier = class({})

function drono_red_dragonkin_commander_red_dragonkin_armor_modifier:OnCreated( kv )
end

function drono_red_dragonkin_commander_red_dragonkin_armor_modifier:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_PHYSICAL,
		MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_MAGICAL,
		MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_PURE
	}

	return funcs
end

function drono_red_dragonkin_commander_red_dragonkin_armor_modifier:GetAbsoluteNoDamagePhysical()
	return 1
end

function drono_red_dragonkin_commander_red_dragonkin_armor_modifier:GetAbsoluteNoDamageMagical()
	return 1
end

function drono_red_dragonkin_commander_red_dragonkin_armor_modifier:GetAbsoluteNoDamagePure()
	return 1
end

function drono_red_dragonkin_commander_red_dragonkin_armor_modifier:GetTexture()
	return "dragon_knight_dragon_tail"
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
	return false
end