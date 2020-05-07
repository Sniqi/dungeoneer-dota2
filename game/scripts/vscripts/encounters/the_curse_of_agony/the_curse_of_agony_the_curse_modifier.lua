the_curse_of_agony_the_curse_modifier = class({})

function the_curse_of_agony_the_curse_modifier:OnCreated( kv )
	self.duration                     = self:GetAbility():GetSpecialValueFor("duration")
end

function the_curse_of_agony_the_curse_modifier:GetState( kv )
	self.duration                     = self:GetAbility():GetSpecialValueFor("duration")
end

function the_curse_of_agony_the_curse_modifier:CheckState()
	local state = {
	[MODIFIER_STATE_NOT_ON_MINIMAP] = true,
	[MODIFIER_STATE_INVULNERABLE] = true,
	[MODIFIER_STATE_NO_HEALTH_BAR] = true,
	[MODIFIER_STATE_NO_UNIT_COLLISION] = true
	}
 
	return state
end

function the_curse_of_agony_the_curse_modifier:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_TOOLTIP,
	}

	return funcs
end


function the_curse_of_agony_the_curse_modifier:OnTooltip( params )
	return self.duration
end


function the_curse_of_agony_the_curse_modifier:GetAttributes()
	return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE
end

function the_curse_of_agony_the_curse_modifier:IsHidden()
    return false
end

function the_curse_of_agony_the_curse_modifier:IsPurgable()
	return false
end

function the_curse_of_agony_the_curse_modifier:IsPurgeException()
	return false
end

function the_curse_of_agony_the_curse_modifier:IsStunDebuff()
	return false
end

function the_curse_of_agony_the_curse_modifier:IsDebuff()
	return false
end