demonic_warrior_deep_cutting_axe_wound_modifier = class({})

function demonic_warrior_deep_cutting_axe_wound_modifier:OnCreated( kv )
	self.armor                        = self:GetAbility():GetSpecialValueFor("armor")
	self.magic_resist_percentage      = self:GetAbility():GetSpecialValueFor("magic_resist_percentage")
end

function demonic_warrior_deep_cutting_axe_wound_modifier:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
		MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,
	}

	return funcs
end


function demonic_warrior_deep_cutting_axe_wound_modifier:GetModifierPhysicalArmorBonus( params )
	return self.armor * self:GetStackCount()
end

function demonic_warrior_deep_cutting_axe_wound_modifier:GetModifierMagicalResistanceBonus( params )
	return self.magic_resist_percentage * self:GetStackCount()
end

function demonic_warrior_deep_cutting_axe_wound_modifier:GetAttributes()
	--return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE
end

function demonic_warrior_deep_cutting_axe_wound_modifier:IsHidden()
    return false
end

function demonic_warrior_deep_cutting_axe_wound_modifier:IsPurgable()
	return false
end

function demonic_warrior_deep_cutting_axe_wound_modifier:IsPurgeException()
	return false
end

function demonic_warrior_deep_cutting_axe_wound_modifier:IsStunDebuff()
	return false
end

function demonic_warrior_deep_cutting_axe_wound_modifier:IsDebuff()
	return true
end