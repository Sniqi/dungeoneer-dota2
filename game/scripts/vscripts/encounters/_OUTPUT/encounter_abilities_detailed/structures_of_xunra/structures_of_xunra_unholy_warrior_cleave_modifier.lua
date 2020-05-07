structures_of_xunra_unholy_warrior_cleave_modifier = class({})

function structures_of_xunra_unholy_warrior_cleave_modifier:OnCreated( kv )
	self.move_speed_percentage        = self:GetAbility():GetSpecialValueFor("move_speed_percentage")
end

function structures_of_xunra_unholy_warrior_cleave_modifier:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
	}

	return funcs
end


function structures_of_xunra_unholy_warrior_cleave_modifier:GetModifierMoveSpeedBonus_Percentage( params )
	return self.move_speed_percentage
end


function structures_of_xunra_unholy_warrior_cleave_modifier:GetAttributes()
	return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE
end

function structures_of_xunra_unholy_warrior_cleave_modifier:IsHidden()
    return false
end

function structures_of_xunra_unholy_warrior_cleave_modifier:IsPurgable()
	return false
end

function structures_of_xunra_unholy_warrior_cleave_modifier:IsPurgeException()
	return false
end

function structures_of_xunra_unholy_warrior_cleave_modifier:IsStunDebuff()
	return false
end

function structures_of_xunra_unholy_warrior_cleave_modifier:IsDebuff()
	return true
end