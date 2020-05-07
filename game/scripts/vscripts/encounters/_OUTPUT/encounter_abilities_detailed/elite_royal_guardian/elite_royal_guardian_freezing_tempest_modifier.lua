elite_royal_guardian_freezing_tempest_modifier = class({})

function elite_royal_guardian_freezing_tempest_modifier:OnCreated( kv )
	self.move_speed_percentage        = self:GetAbility():GetSpecialValueFor("move_speed_percentage")
end

function elite_royal_guardian_freezing_tempest_modifier:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
	}

	return funcs
end


function elite_royal_guardian_freezing_tempest_modifier:GetModifierMoveSpeedBonus_Percentage( params )
	return self.move_speed_percentage
end


function elite_royal_guardian_freezing_tempest_modifier:GetAttributes()
	return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE
end

function elite_royal_guardian_freezing_tempest_modifier:IsHidden()
    return false
end

function elite_royal_guardian_freezing_tempest_modifier:IsPurgable()
	return false
end

function elite_royal_guardian_freezing_tempest_modifier:IsPurgeException()
	return false
end

function elite_royal_guardian_freezing_tempest_modifier:IsStunDebuff()
	return false
end

function elite_royal_guardian_freezing_tempest_modifier:IsDebuff()
	return true
end