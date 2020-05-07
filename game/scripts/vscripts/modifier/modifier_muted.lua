modifier_muted = class( {} )

function modifier_muted:CheckState()
	local state = {
	[MODIFIER_STATE_MUTED] = true
	}
 
	return state
end

function modifier_muted:IsHidden()
    return true
end

function modifier_muted:IsPurgable()
	return false
end

function modifier_muted:IsPurgeException()
	return false
end

function modifier_muted:IsStunDebuff()
	return false
end

function modifier_muted:IsDebuff()
	return false
end
