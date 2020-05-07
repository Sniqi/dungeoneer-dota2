modifier_untargetable = class( {} )

function modifier_untargetable:CheckState()
	local state = {
	[MODIFIER_STATE_UNTARGETABLE] = true
	}

	return state
end

function modifier_untargetable:IsHidden()
	return true
end

function modifier_untargetable:IsPurgable()
	return false
end

function modifier_untargetable:IsPurgeException()
	return false
end

function modifier_untargetable:IsStunDebuff()
	return false
end

function modifier_untargetable:IsDebuff()
	return false
end
