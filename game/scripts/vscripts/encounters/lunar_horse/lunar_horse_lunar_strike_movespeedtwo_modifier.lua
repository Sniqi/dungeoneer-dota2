lunar_horse_lunar_strike_movespeedtwo_modifier = class({})

function lunar_horse_lunar_strike_movespeedtwo_modifier:OnCreated( kv )
	self.phase_two_move_step                        = self:GetAbility():GetSpecialValueFor("phase_two_move_step")
end

function lunar_horse_lunar_strike_movespeedtwo_modifier:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_ABSOLUTE,
	}

	return funcs
end


function lunar_horse_lunar_strike_movespeedtwo_modifier:GetModifierMoveSpeed_Absolute( params )
	return self.phase_two_move_step
end


function lunar_horse_lunar_strike_movespeedtwo_modifier:GetAttributes()
	return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE
end

function lunar_horse_lunar_strike_movespeedtwo_modifier:IsHidden()
    return false
end

function lunar_horse_lunar_strike_movespeedtwo_modifier:IsPurgable()
	return false
end

function lunar_horse_lunar_strike_movespeedtwo_modifier:IsPurgeException()
	return false
end

function lunar_horse_lunar_strike_movespeedtwo_modifier:IsStunDebuff()
	return false
end

function lunar_horse_lunar_strike_movespeedtwo_modifier:IsDebuff()
	return true
end