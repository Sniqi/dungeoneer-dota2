cooldown_modifier_ability = class({})

function cooldown_modifier_ability:OnCreated( data )

end

function cooldown_modifier_ability:OnRemoved()

end

function cooldown_modifier_ability:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE + MODIFIER_ATTRIBUTE_MULTIPLE
end

function cooldown_modifier_ability:IsHidden()
    return true
end

function cooldown_modifier_ability:IsPurgable()
	return false
end

function cooldown_modifier_ability:IsPurgeException()
	return false
end

function cooldown_modifier_ability:IsStunDebuff()
	return false
end

function cooldown_modifier_ability:IsDebuff()
	return false
end
