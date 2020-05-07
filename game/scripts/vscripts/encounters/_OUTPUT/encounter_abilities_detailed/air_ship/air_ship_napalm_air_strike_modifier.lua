air_ship_napalm_air_strike_modifier = class({})

function air_ship_napalm_air_strike_modifier:OnCreated( kv )
	self.burn_damage                  = self:GetAbility():GetSpecialValueFor("burn_damage")
	self.move_speed_percentage        = self:GetAbility():GetSpecialValueFor("move_speed_percentage")
end

function air_ship_napalm_air_strike_modifier:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_TOOLTIP,
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
	}

	return funcs
end


function air_ship_napalm_air_strike_modifier:OnTooltip( params )
	return self.burn_damage
end

function air_ship_napalm_air_strike_modifier:GetModifierMoveSpeedBonus_Percentage( params )
	return self.move_speed_percentage
end


function air_ship_napalm_air_strike_modifier:GetAttributes()
	return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE
end

function air_ship_napalm_air_strike_modifier:IsHidden()
    return false
end

function air_ship_napalm_air_strike_modifier:IsPurgable()
	return false
end

function air_ship_napalm_air_strike_modifier:IsPurgeException()
	return false
end

function air_ship_napalm_air_strike_modifier:IsStunDebuff()
	return false
end

function air_ship_napalm_air_strike_modifier:IsDebuff()
	return true
end