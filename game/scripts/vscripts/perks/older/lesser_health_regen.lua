lesser_health_regen = class({})

function lesser_health_regen:OnCreated( data )
	-- ### VALUES START ### --
	self.health_regen                  = 1.5
	-- ### VALUES END ### --
end

function lesser_health_regen:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_HEALTH_REGEN_PERCENTAGE
	}

	return funcs
end

function lesser_health_regen:GetModifierHealthRegenPercentage( params )
	return self.health_regen
end

function lesser_health_regen:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE + MODIFIER_ATTRIBUTE_MULTIPLE
end

function lesser_health_regen:IsHidden()
    return true
end

function lesser_health_regen:IsPurgable()
	return false
end

function lesser_health_regen:IsPurgeException()
	return false
end

function lesser_health_regen:IsStunDebuff()
	return false
end

function lesser_health_regen:IsDebuff()
	return false
end



































































































































































































































































































