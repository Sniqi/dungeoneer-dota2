smodhex_satyr_warlock_critical_mass_modifier = class({})

function smodhex_satyr_warlock_critical_mass_modifier:OnCreated( kv )
	self.delay                        = self:GetAbility():GetSpecialValueFor("delay")
end

function smodhex_satyr_warlock_critical_mass_modifier:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_TOOLTIP,
	}

	return funcs
end


function smodhex_satyr_warlock_critical_mass_modifier:OnTooltip( params )
	return self.delay
end


function smodhex_satyr_warlock_critical_mass_modifier:GetAttributes()
	return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE
end

function smodhex_satyr_warlock_critical_mass_modifier:IsHidden()
    return false
end

function smodhex_satyr_warlock_critical_mass_modifier:IsPurgable()
	return false
end

function smodhex_satyr_warlock_critical_mass_modifier:IsPurgeException()
	return false
end

function smodhex_satyr_warlock_critical_mass_modifier:IsStunDebuff()
	return false
end

function smodhex_satyr_warlock_critical_mass_modifier:IsDebuff()
	return true
end