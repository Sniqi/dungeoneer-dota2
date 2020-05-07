iron_claw_iron_hide_getting_tired_modifier = class({})

function iron_claw_iron_hide_getting_tired_modifier:OnCreated( kv )
	self.armor                        = self:GetAbility():GetSpecialValueFor("armor")
	self.magic_resist_percentage      = self:GetAbility():GetSpecialValueFor("magic_resist_percentage")
	self.status_resistance_percentage = self:GetAbility():GetSpecialValueFor("status_resistance_percentage")
	self.move_speed_percentage        = self:GetAbility():GetSpecialValueFor("move_speed_percentage")
end

function iron_claw_iron_hide_getting_tired_modifier:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
		MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,
		MODIFIER_PROPERTY_STATUS_RESISTANCE_STACKING,
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
	}

	return funcs
end


function iron_claw_iron_hide_getting_tired_modifier:GetModifierPhysicalArmorBonus( params )
	return self.armor
end

function iron_claw_iron_hide_getting_tired_modifier:GetModifierMagicalResistanceBonus( params )
	return self.magic_resist_percentage
end

function iron_claw_iron_hide_getting_tired_modifier:GetModifierStatusResistanceStacking( params )
	return self.status_resistance_percentage
end

function iron_claw_iron_hide_getting_tired_modifier:GetModifierMoveSpeedBonus_Percentage( params )
	return self.move_speed_percentage
end


function iron_claw_iron_hide_getting_tired_modifier:GetAttributes()
	return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE
end

function iron_claw_iron_hide_getting_tired_modifier:IsHidden()
    return false
end

function iron_claw_iron_hide_getting_tired_modifier:IsPurgable()
	return false
end

function iron_claw_iron_hide_getting_tired_modifier:IsPurgeException()
	return false
end

function iron_claw_iron_hide_getting_tired_modifier:IsStunDebuff()
	return false
end

function iron_claw_iron_hide_getting_tired_modifier:IsDebuff()
	return true
end