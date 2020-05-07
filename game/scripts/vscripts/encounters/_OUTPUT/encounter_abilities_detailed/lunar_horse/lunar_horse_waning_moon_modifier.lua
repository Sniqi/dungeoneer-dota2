lunar_horse_waning_moon_modifier = class({})

function lunar_horse_waning_moon_modifier:OnCreated( kv )
	self.phase_two_percentage         = self:GetAbility():GetSpecialValueFor("phase_two_percentage")
end

function lunar_horse_waning_moon_modifier:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_TOOLTIP,
	}

	return funcs
end


function lunar_horse_waning_moon_modifier:OnTooltip( params )
	return self.phase_two_percentage
end


function lunar_horse_waning_moon_modifier:GetAttributes()
	return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE
end

function lunar_horse_waning_moon_modifier:IsHidden()
    return false
end

function lunar_horse_waning_moon_modifier:IsPurgable()
	return false
end

function lunar_horse_waning_moon_modifier:IsPurgeException()
	return false
end

function lunar_horse_waning_moon_modifier:IsStunDebuff()
	return false
end

function lunar_horse_waning_moon_modifier:IsDebuff()
	return true
end