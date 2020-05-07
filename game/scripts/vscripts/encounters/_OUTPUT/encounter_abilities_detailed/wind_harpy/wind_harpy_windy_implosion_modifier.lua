wind_harpy_windy_implosion_modifier = class({})

function wind_harpy_windy_implosion_modifier:OnCreated( kv )
	self.duration                     = self:GetAbility():GetSpecialValueFor("duration")
	self.move_speed_percentage        = self:GetAbility():GetSpecialValueFor("move_speed_percentage")
end

function wind_harpy_windy_implosion_modifier:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_TOOLTIP,
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
	}

	return funcs
end


function wind_harpy_windy_implosion_modifier:OnTooltip( params )
	return self.duration
end

function wind_harpy_windy_implosion_modifier:GetModifierMoveSpeedBonus_Percentage( params )
	return self.move_speed_percentage
end


function wind_harpy_windy_implosion_modifier:GetAttributes()
	return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE
end

function wind_harpy_windy_implosion_modifier:IsHidden()
    return false
end

function wind_harpy_windy_implosion_modifier:IsPurgable()
	return false
end

function wind_harpy_windy_implosion_modifier:IsPurgeException()
	return false
end

function wind_harpy_windy_implosion_modifier:IsStunDebuff()
	return false
end

function wind_harpy_windy_implosion_modifier:IsDebuff()
	return true
end