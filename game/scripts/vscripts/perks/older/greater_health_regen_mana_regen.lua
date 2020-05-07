greater_health_regen_mana_regen = class({})

function greater_health_regen_mana_regen:OnCreated( data )
	-- ### VALUES START ### --
	self.health_regen                  = 3
	self.mana_regen                    = 2
	-- ### VALUES END ### --
end

function greater_health_regen_mana_regen:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_HEALTH_REGEN_PERCENTAGE,
		MODIFIER_PROPERTY_MANA_REGEN_TOTAL_PERCENTAGE
	}

	return funcs
end

function greater_health_regen_mana_regen:GetModifierHealthRegenPercentage( params )
	return self.health_regen
end

function greater_health_regen_mana_regen:GetModifierTotalPercentageManaRegen( params )
	return self.mana_regen
end

function greater_health_regen_mana_regen:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE + MODIFIER_ATTRIBUTE_MULTIPLE
end

function greater_health_regen_mana_regen:IsHidden()
    return true
end

function greater_health_regen_mana_regen:IsPurgable()
	return false
end

function greater_health_regen_mana_regen:IsPurgeException()
	return false
end

function greater_health_regen_mana_regen:IsStunDebuff()
	return false
end

function greater_health_regen_mana_regen:IsDebuff()
	return false
end




































































































































































































































































































