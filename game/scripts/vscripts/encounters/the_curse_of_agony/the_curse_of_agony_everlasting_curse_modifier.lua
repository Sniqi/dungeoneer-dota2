the_curse_of_agony_everlasting_curse_modifier = class({})

function the_curse_of_agony_everlasting_curse_modifier:OnCreated( kv )
	self.damage                       = self:GetAbility():GetSpecialValueFor("damage")
end

function the_curse_of_agony_everlasting_curse_modifier:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_TOOLTIP,
	}

	return funcs
end


function the_curse_of_agony_everlasting_curse_modifier:OnTooltip( params )
	return self.damage
end


function the_curse_of_agony_everlasting_curse_modifier:GetAttributes()
	return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE + MODIFIER_ATTRIBUTE_MULTIPLE
end

function the_curse_of_agony_everlasting_curse_modifier:IsHidden()
    return false
end

function the_curse_of_agony_everlasting_curse_modifier:IsPurgable()
	return false
end

function the_curse_of_agony_everlasting_curse_modifier:IsPurgeException()
	return false
end

function the_curse_of_agony_everlasting_curse_modifier:IsStunDebuff()
	return false
end

function the_curse_of_agony_everlasting_curse_modifier:IsDebuff()
	return true
end