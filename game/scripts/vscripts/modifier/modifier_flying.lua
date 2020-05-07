modifier_flying = class( {} )

function modifier_flying:CheckState()
	local state = {
	[MODIFIER_STATE_FLYING] = true
	}
 
	return state
end

function modifier_flying:IsHidden()
    return true
end

function modifier_flying:IsPurgable()
	return false
end

function modifier_flying:IsPurgeException()
	return false
end

function modifier_flying:IsStunDebuff()
	return false
end

function modifier_flying:IsDebuff()
	return false
end
