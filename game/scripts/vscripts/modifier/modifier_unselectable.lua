modifier_unselectable = class( {} )

function modifier_unselectable:CheckState()
	local state = {
	[MODIFIER_STATE_UNSELECTABLE] = true
	}
 
	return state
end

function modifier_unselectable:IsHidden()
    return true
end

function modifier_unselectable:IsPurgable()
	return false
end

function modifier_unselectable:IsPurgeException()
	return false
end

function modifier_unselectable:IsStunDebuff()
	return false
end

function modifier_unselectable:IsDebuff()
	return false
end
