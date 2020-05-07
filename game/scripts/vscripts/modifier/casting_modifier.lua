casting_modifier = class( {} )

function casting_modifier:DeclareFunctions()
	local funcs = {
	}

	return funcs
end

function casting_modifier:CheckState()
	local state = {
	[MODIFIER_STATE_SILENCED] = true,
	[MODIFIER_STATE_DISARMED] = true,
	[MODIFIER_STATE_MUTED] = true,
	}
 
	return state
end

function casting_modifier:OnDestroy()
	
end

function casting_modifier:IsHidden()
    return true
end

function casting_modifier:IsPurgable()
	return false
end

function casting_modifier:IsPurgeException()
	return false
end

function casting_modifier:IsStunDebuff()
	return false
end

function casting_modifier:IsDebuff()
	return false
end