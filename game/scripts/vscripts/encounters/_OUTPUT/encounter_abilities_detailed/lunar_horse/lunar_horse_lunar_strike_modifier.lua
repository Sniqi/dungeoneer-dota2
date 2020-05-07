lunar_horse_lunar_strike_modifier = class({})

function lunar_horse_lunar_strike_modifier:OnCreated( kv )
	self.delay                        = self:GetAbility():GetSpecialValueFor("delay")
end

function lunar_horse_lunar_strike_modifier:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_TOOLTIP,
	}

	return funcs
end


function lunar_horse_lunar_strike_modifier:OnTooltip( params )
	return self.delay
end


function lunar_horse_lunar_strike_modifier:GetAttributes()
	return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE
end

function lunar_horse_lunar_strike_modifier:IsHidden()
    return false
end

function lunar_horse_lunar_strike_modifier:IsPurgable()
	return false
end

function lunar_horse_lunar_strike_modifier:IsPurgeException()
	return false
end

function lunar_horse_lunar_strike_modifier:IsStunDebuff()
	return false
end

function lunar_horse_lunar_strike_modifier:IsDebuff()
	return true
end