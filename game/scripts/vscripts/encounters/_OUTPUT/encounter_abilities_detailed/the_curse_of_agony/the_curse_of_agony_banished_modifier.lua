the_curse_of_agony_banished_modifier = class({})

function the_curse_of_agony_banished_modifier:OnCreated( kv )
	self.duration                     = self:GetAbility():GetSpecialValueFor("duration")
end

function the_curse_of_agony_banished_modifier:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_TOOLTIP,
	}

	return funcs
end


function the_curse_of_agony_banished_modifier:OnTooltip( params )
	return self.duration
end


function the_curse_of_agony_banished_modifier:GetAttributes()
	return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE
end

function the_curse_of_agony_banished_modifier:IsHidden()
    return false
end

function the_curse_of_agony_banished_modifier:IsPurgable()
	return false
end

function the_curse_of_agony_banished_modifier:IsPurgeException()
	return false
end

function the_curse_of_agony_banished_modifier:IsStunDebuff()
	return false
end

function the_curse_of_agony_banished_modifier:IsDebuff()
	return true
end