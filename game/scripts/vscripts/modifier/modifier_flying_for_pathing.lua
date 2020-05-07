modifier_flying_for_pathing = class( {} )

function modifier_flying_for_pathing:CheckState()
	local state = {
	[MODIFIER_STATE_FLYING_FOR_PATHING_PURPOSES_ONLY] = true
	}
 
	return state
end

function modifier_flying_for_pathing:IsHidden()
    return true
end

function modifier_flying_for_pathing:IsPurgable()
	return false
end

function modifier_flying_for_pathing:IsPurgeException()
	return false
end

function modifier_flying_for_pathing:IsStunDebuff()
	return false
end

function modifier_flying_for_pathing:IsDebuff()
	return false
end
