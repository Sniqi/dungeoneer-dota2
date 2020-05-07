modifier_fake_ally = class( {} )

function modifier_fake_ally:CheckState()
	local state = {
	[MODIFIER_STATE_ATTACK_IMMUNE] = true
	}

	return state
end

function modifier_fake_ally:IsHidden()
	return true
end

function modifier_fake_ally:IsPurgable()
	return false
end

function modifier_fake_ally:IsPurgeException()
	return false
end

function modifier_fake_ally:IsStunDebuff()
	return false
end

function modifier_fake_ally:IsDebuff()
	return false
end
