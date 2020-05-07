lesser_health = class({})

function lesser_health:OnCreated( data )
	-- ### VALUES START ### --
	self.health                        = 35
	-- ### VALUES END ### --
end

function lesser_health:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_EXTRA_HEALTH_PERCENTAGE
	}

	return funcs
end

function lesser_health:GetModifierExtraHealthPercentage( params )
	return self.health / 100
end

function lesser_health:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE + MODIFIER_ATTRIBUTE_MULTIPLE
end

function lesser_health:IsHidden()
    return true
end

function lesser_health:IsPurgable()
	return false
end

function lesser_health:IsPurgeException()
	return false
end

function lesser_health:IsStunDebuff()
	return false
end

function lesser_health:IsDebuff()
	return false
end



















































































































































































































































