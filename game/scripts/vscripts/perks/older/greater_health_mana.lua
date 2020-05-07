greater_health_mana = class({})

function greater_health_mana:OnCreated( data )
	-- ### VALUES START ### --
	self.health                        = 50
	self.mana                          = 1500
	-- ### VALUES END ### --
end

function greater_health_mana:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_EXTRA_HEALTH_PERCENTAGE,
		MODIFIER_PROPERTY_MANA_BONUS
	}

	return funcs
end

function greater_health_mana:GetModifierExtraHealthPercentage( params )
	return self.health / 100
end

function greater_health_mana:GetModifierManaBonus( params )
	return self.mana
end

function greater_health_mana:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE + MODIFIER_ATTRIBUTE_MULTIPLE
end

function greater_health_mana:IsHidden()
    return true
end

function greater_health_mana:IsPurgable()
	return false
end

function greater_health_mana:IsPurgeException()
	return false
end

function greater_health_mana:IsStunDebuff()
	return false
end

function greater_health_mana:IsDebuff()
	return false
end




































































































































































































































































































