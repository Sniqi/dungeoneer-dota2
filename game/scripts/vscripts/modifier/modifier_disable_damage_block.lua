modifier_disable_damage_block = class( {} )

function modifier_disable_damage_block:CheckState()
	local state = {
	[MODIFIER_STATE_BLOCK_DISABLED] = true
	}
 
	return state
end

function modifier_disable_damage_block:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE
end

function modifier_disable_damage_block:IsHidden()
    return true
end

function modifier_disable_damage_block:IsPurgable()
	return false
end

function modifier_disable_damage_block:IsPurgeException()
	return false
end

function modifier_disable_damage_block:IsStunDebuff()
	return false
end

function modifier_disable_damage_block:IsDebuff()
	return false
end

function modifier_disable_damage_block:RemoveOnDeath()
	return false
end

function modifier_disable_damage_block:GetPriority()
	return MODIFIER_PRIORITY_HIGH
end

