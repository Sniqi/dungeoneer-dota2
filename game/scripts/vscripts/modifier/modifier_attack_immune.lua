modifier_attack_immune = class( {} )

function modifier_attack_immune:CheckState()
	local state = {
	[MODIFIER_STATE_ATTACK_IMMUNE] = true
	}
 
	return state
end

function modifier_attack_immune:IsHidden()
	return true
end

function modifier_attack_immune:IsPurgable()
	return false
end

function modifier_attack_immune:IsPurgeException()
	return false
end

function modifier_attack_immune:IsStunDebuff()
	return false
end

function modifier_attack_immune:IsDebuff()
	return false
end
