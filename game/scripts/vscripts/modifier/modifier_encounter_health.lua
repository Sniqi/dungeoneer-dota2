modifier_encounter_health = class({})

function modifier_encounter_health:OnCreated( params )
	if not IsServer() then return end
	if params.factor == nil then
		self.factor = 1.0
	else
		self.factor = params.factor
	end
end

function modifier_encounter_health:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_EXTRA_HEALTH_PERCENTAGE
	}

	return funcs
end

function modifier_encounter_health:GetModifierExtraHealthPercentage( params )
	if not IsServer() then return end
	return EncounterHealthMultiplier * self.factor
end

function modifier_encounter_health:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE
end

function modifier_encounter_health:IsHidden()
    return true
end

function modifier_encounter_health:IsPurgable()
	return false
end

function modifier_encounter_health:IsPurgeException()
	return false
end

function modifier_encounter_health:IsStunDebuff()
	return false
end

function modifier_encounter_health:IsDebuff()
	return false
end




































