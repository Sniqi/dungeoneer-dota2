casting_rooted_modifier = class( {} )

function casting_rooted_modifier:DeclareFunctions()
	local funcs = {
	}

	return funcs
end

function casting_rooted_modifier:CheckState()
	local state = {
	[MODIFIER_STATE_SILENCED] = true,
	[MODIFIER_STATE_DISARMED] = true,
	[MODIFIER_STATE_ROOTED] = true
	}
 
	return state
end

function casting_rooted_modifier:OnDestroy()
	
end

function casting_rooted_modifier:IsHidden()
    return true
end

function casting_rooted_modifier:IsPurgable()
	return false
end

function casting_rooted_modifier:IsPurgeException()
	return false
end

function casting_rooted_modifier:IsStunDebuff()
	return false
end

function casting_rooted_modifier:IsDebuff()
	return false
end