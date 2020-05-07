turn_rate_modifier = class({})

function turn_rate_modifier:OnCreated( kv )
end

function turn_rate_modifier:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_TURN_RATE_PERCENTAGE,
	}

	return funcs
end


function turn_rate_modifier:GetModifierTurnRate_Percentage( params )
	return 5000
end

function turn_rate_modifier:GetAttributes()
	return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE
end

function turn_rate_modifier:IsHidden()
    return true
end

function turn_rate_modifier:IsPurgable()
	return false
end

function turn_rate_modifier:IsPurgeException()
	return false
end

function turn_rate_modifier:IsStunDebuff()
	return false
end

function turn_rate_modifier:IsDebuff()
	return false
end