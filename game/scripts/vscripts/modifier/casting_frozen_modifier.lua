casting_frozen_modifier = class( {} )

function casting_frozen_modifier:DeclareFunctions()
	local funcs = {
	}

	return funcs
end

function casting_frozen_modifier:CheckState()
	local state = {
	[MODIFIER_STATE_FROZEN] = true
	}
 
	return state
end

function casting_frozen_modifier:OnDestroy()
	
end

function casting_frozen_modifier:IsHidden()
    return true
end

function casting_frozen_modifier:IsPurgable()
	return false
end

function casting_frozen_modifier:IsPurgeException()
	return false
end

function casting_frozen_modifier:IsStunDebuff()
	return false
end

function casting_frozen_modifier:IsDebuff()
	return false
end