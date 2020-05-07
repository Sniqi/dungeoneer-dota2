the_dungeoneer_reshaped_ground_earth_modifier = class({})

function the_dungeoneer_reshaped_ground_earth_modifier:OnCreated( kv )
	self.earth_stun_interval          = self:GetAbility():GetSpecialValueFor("earth_stun_interval")
	self.earth_stun_duration          = self:GetAbility():GetSpecialValueFor("earth_stun_duration")
end

function the_dungeoneer_reshaped_ground_earth_modifier:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_TOOLTIP,
		MODIFIER_PROPERTY_TOOLTIP,
	}

	return funcs
end


function the_dungeoneer_reshaped_ground_earth_modifier:OnTooltip( params )
	return self.earth_stun_interval
end

function the_dungeoneer_reshaped_ground_earth_modifier:OnTooltip( params )
	return self.earth_stun_duration
end


function the_dungeoneer_reshaped_ground_earth_modifier:GetAttributes()
	return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE
end

function the_dungeoneer_reshaped_ground_earth_modifier:IsHidden()
    return false
end

function the_dungeoneer_reshaped_ground_earth_modifier:IsPurgable()
	return false
end

function the_dungeoneer_reshaped_ground_earth_modifier:IsPurgeException()
	return false
end

function the_dungeoneer_reshaped_ground_earth_modifier:IsStunDebuff()
	return false
end

function the_dungeoneer_reshaped_ground_earth_modifier:IsDebuff()
	return true
end