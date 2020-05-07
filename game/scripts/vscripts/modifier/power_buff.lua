power_buff = class({})

function power_buff:OnCreated( kv )

end

function power_buff:DeclareFunctions()
	local funcs = {
        MODIFIER_PROPERTY_MOVESPEED_ABSOLUTE,
        MODIFIER_PROPERTY_MOVESPEED_ABSOLUTE_MAX,
        MODIFIER_PROPERTY_TURN_RATE_PERCENTAGE,
        MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
        MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE,
        MODIFIER_PROPERTY_MANA_REGEN_CONSTANT
	}

	return funcs
end

function power_buff:GetModifierMoveSpeed_Absolute( params )
    return 1000
end

function power_buff:GetModifierMoveSpeed_AbsoluteMax( params )
    return 1000
end

function power_buff:GetModifierTurnRate_Percentage( params )
    return 500
end

function power_buff:GetModifierIncomingDamage_Percentage( params )
    return -10000
end

function power_buff:GetModifierTotalDamageOutgoing_Percentage( params )
    --return 1000
end

function power_buff:GetModifierConstantManaRegen( params )
    return 1000
end

function power_buff:IsPurgable()
    return false
end

function power_buff:IsPurgeException()
    return false
end

function power_buff:IsStunDebuff()
    return false
end

function power_buff:IsDebuff()
    return false
end