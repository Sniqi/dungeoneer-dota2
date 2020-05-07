modifier_gold_multiplier = class( {} )

function modifier_gold_multiplier:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_BOUNTY_CREEP_MULTIPLIER,
		MODIFIER_PROPERTY_BOUNTY_OTHER_MULTIPLIER
	}

	return funcs
end

function modifier_gold_multiplier:GetModifierBountyCreepMultiplier()
	return -99999
end

function modifier_gold_multiplier:GetModifierBountyOtherMultiplier()
	return -99999
end

function modifier_gold_multiplier:IsHidden()
	return true
end

function modifier_gold_multiplier:IsPurgable()
	return false
end

function modifier_gold_multiplier:IsPurgeException()
	return false
end

function modifier_gold_multiplier:IsStunDebuff()
	return false
end

function modifier_gold_multiplier:IsDebuff()
	return false
end
