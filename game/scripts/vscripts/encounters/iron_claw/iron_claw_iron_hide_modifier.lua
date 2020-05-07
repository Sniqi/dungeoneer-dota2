iron_claw_iron_hide_modifier = class({})

function iron_claw_iron_hide_modifier:OnCreated( kv )
	self.armor                        = self:GetAbility():GetSpecialValueFor("armor")
	self.magic_resist_percentage      = self:GetAbility():GetSpecialValueFor("magic_resist_percentage")
	self.status_resistance_percentage = self:GetAbility():GetSpecialValueFor("status_resistance_percentage")
end

function iron_claw_iron_hide_modifier:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
		MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,
		MODIFIER_PROPERTY_STATUS_RESISTANCE_STACKING,
	}

	return funcs
end


function iron_claw_iron_hide_modifier:GetModifierPhysicalArmorBonus( params )
	return self.armor
end

function iron_claw_iron_hide_modifier:GetModifierMagicalResistanceBonus( params )
	return self.magic_resist_percentage
end

function iron_claw_iron_hide_modifier:GetModifierStatusResistanceStacking( params )
	return self.status_resistance_percentage
end

function iron_claw_iron_hide_modifier:GetAttributes()
	return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE
end

function iron_claw_iron_hide_modifier:IsHidden()
    return false
end

function iron_claw_iron_hide_modifier:IsPurgable()
	return false
end

function iron_claw_iron_hide_modifier:IsPurgeException()
	return false
end

function iron_claw_iron_hide_modifier:IsStunDebuff()
	return false
end

function iron_claw_iron_hide_modifier:IsDebuff()
	return false
end