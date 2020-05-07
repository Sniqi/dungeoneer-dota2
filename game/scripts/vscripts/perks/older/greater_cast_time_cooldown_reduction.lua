greater_cast_time_cooldown_reduction = class({})

function greater_cast_time_cooldown_reduction:OnCreated( data )
	-- ### VALUES START ### --
	self.cast_time                     = 75
	self.cooldown                      = 30
	-- ### VALUES END ### --

	if not IsServer() then return end
	self:StartIntervalThink(0.25)
end

function greater_cast_time_cooldown_reduction:OnIntervalThink()
	if not IsServer() then return end
	local caster = self:GetParent()

	local factor1 = 65
	local factor2 = 85
	local factor3 = 0.3
	local factor4 = -1
	local factor5 = 0.1

	local count = #caster:FindAllModifiersByName("greater_cast_time_cooldown_reduction")
	
	local cdr_calculated = factor1 - factor2 * math.pow( math.exp(factor3), factor4 * ( factor5 * ( self.cooldown * count ) ) )

	cdr_calculated = cdr_calculated / count

	self:SetStackCount(cdr_calculated)
end

function greater_cast_time_cooldown_reduction:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_CASTTIME_PERCENTAGE,
		MODIFIER_PROPERTY_COOLDOWN_PERCENTAGE
	}

	return funcs
end

function greater_cast_time_cooldown_reduction:GetModifierPercentageCasttime( params )
	return self.cast_time
end

function greater_cast_time_cooldown_reduction:GetModifierPercentageCooldown( params )
	return self:GetStackCount()
end

function greater_cast_time_cooldown_reduction:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE + MODIFIER_ATTRIBUTE_MULTIPLE
end

function greater_cast_time_cooldown_reduction:IsHidden()
    return true
end

function greater_cast_time_cooldown_reduction:IsPurgable()
	return false
end

function greater_cast_time_cooldown_reduction:IsPurgeException()
	return false
end

function greater_cast_time_cooldown_reduction:IsStunDebuff()
	return false
end

function greater_cast_time_cooldown_reduction:IsDebuff()
	return false
end



































































































































































































































