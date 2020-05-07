modifier_no_turning = class( {} )

function modifier_no_turning:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_DISABLE_TURNING
	}

	return funcs
end

function modifier_no_turning:GetModifierDisableTurning()
	return true
end

function modifier_no_turning:IsHidden()
    return true
end

function modifier_no_turning:IsPurgable()
	return false
end

function modifier_no_turning:IsPurgeException()
	return false
end

function modifier_no_turning:IsStunDebuff()
	return false
end

function modifier_no_turning:IsDebuff()
	return false
end