iron_claw_rear_up_modifier = class({})

function iron_claw_rear_up_modifier:OnCreated( kv )
	self.duration                     = self:GetAbility():GetSpecialValueFor("duration")
end

function iron_claw_rear_up_modifier:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_TOOLTIP,
	}

	return funcs
end


function iron_claw_rear_up_modifier:OnTooltip( params )
	return self.duration
end


function iron_claw_rear_up_modifier:GetAttributes()
	return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE
end

function iron_claw_rear_up_modifier:IsHidden()
    return false
end

function iron_claw_rear_up_modifier:IsPurgable()
	return false
end

function iron_claw_rear_up_modifier:IsPurgeException()
	return false
end

function iron_claw_rear_up_modifier:IsStunDebuff()
	return false
end

function iron_claw_rear_up_modifier:IsDebuff()
	return true
end