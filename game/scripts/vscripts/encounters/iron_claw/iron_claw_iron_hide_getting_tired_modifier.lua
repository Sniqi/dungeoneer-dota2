iron_claw_iron_hide_getting_tired_modifier = class({})

function iron_claw_iron_hide_getting_tired_modifier:OnCreated( kv )
	self.move_speed_percentage        = self:GetAbility():GetSpecialValueFor("move_speed_percentage")

	if not IsServer() then return end

	local caster = self:GetParent()

	AddAnimationTranslate(caster, "injured")
end

function iron_claw_iron_hide_getting_tired_modifier:OnDestroy( kv )
	if not IsServer() then return end

	local caster = self:GetParent()

	RemoveAnimationTranslate(caster)
end

function iron_claw_iron_hide_getting_tired_modifier:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
	}

	return funcs
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
	return false
end