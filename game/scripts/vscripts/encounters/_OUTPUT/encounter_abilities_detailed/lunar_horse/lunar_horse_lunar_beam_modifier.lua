lunar_horse_lunar_beam_modifier = class({})

function lunar_horse_lunar_beam_modifier:OnCreated( kv )
	self.move_speed_absolute          = self:GetAbility():GetSpecialValueFor("move_speed_absolute")
	self.turn_rate_percentage         = self:GetAbility():GetSpecialValueFor("turn_rate_percentage")
end

function lunar_horse_lunar_beam_modifier:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_ABSOLUTE,
		MODIFIER_PROPERTY_TURN_RATE_PERCENTAGE,
	}

	return funcs
end


function lunar_horse_lunar_beam_modifier:GetModifierMoveSpeed_Absolute( params )
	return self.move_speed_absolute
end

function lunar_horse_lunar_beam_modifier:GetModifierTurnRate_Percentage( params )
	return self.turn_rate_percentage
end


function lunar_horse_lunar_beam_modifier:GetAttributes()
	return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE
end

function lunar_horse_lunar_beam_modifier:IsHidden()
    return false
end

function lunar_horse_lunar_beam_modifier:IsPurgable()
	return false
end

function lunar_horse_lunar_beam_modifier:IsPurgeException()
	return false
end

function lunar_horse_lunar_beam_modifier:IsStunDebuff()
	return false
end

function lunar_horse_lunar_beam_modifier:IsDebuff()
	return true
end