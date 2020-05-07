casting_no_turning_modifier = class( {} )

function casting_no_turning_modifier:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_DISABLE_TURNING
	}

	return funcs
end

function casting_no_turning_modifier:CheckState()
	local state = {
	[MODIFIER_STATE_SILENCED] = true,
	[MODIFIER_STATE_DISARMED] = true,
	[MODIFIER_STATE_ROOTED] = true,
	[MODIFIER_STATE_COMMAND_RESTRICTED] = true
	}
 
	return state
end

function casting_no_turning_modifier:GetModifierDisableTurning()
	return true
end

function casting_no_turning_modifier:OnDestroy()
	
end

function casting_no_turning_modifier:IsHidden()
    return true
end

function casting_no_turning_modifier:IsPurgable()
	return false
end

function casting_no_turning_modifier:IsPurgeException()
	return false
end

function casting_no_turning_modifier:IsStunDebuff()
	return false
end

function casting_no_turning_modifier:IsDebuff()
	return false
end