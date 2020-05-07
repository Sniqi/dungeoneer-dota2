modifier_true_sight = class( {} )

function modifier_true_sight:CheckState()
	local state = {
	[MODIFIER_STATE_INVISIBLE] = false
	}
 
	return state
end

function modifier_true_sight:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE
end

function modifier_true_sight:IsHidden()
    return true
end

function modifier_true_sight:IsPurgable()
	return false
end

function modifier_true_sight:IsPurgeException()
	return false
end

function modifier_true_sight:IsStunDebuff()
	return false
end

function modifier_true_sight:IsDebuff()
	return false
end

function modifier_true_sight:RemoveOnDeath()
	return false
end

function modifier_true_sight:GetPriority()
	return MODIFIER_PRIORITY_HIGH
end

