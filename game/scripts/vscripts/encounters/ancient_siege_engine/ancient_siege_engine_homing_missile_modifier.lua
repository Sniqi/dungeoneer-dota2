ancient_siege_engine_homing_missile_modifier = class({})

function ancient_siege_engine_homing_missile_modifier:OnCreated( kv )

end

function ancient_siege_engine_homing_missile_modifier:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_ABSOLUTE
	}

	return funcs
end


function ancient_siege_engine_homing_missile_modifier:GetModifierMoveSpeed_Absolute( params )
	return self:GetStackCount()
end

function ancient_siege_engine_homing_missile_modifier:GetAttributes()
	return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE
end

function ancient_siege_engine_homing_missile_modifier:IsHidden()
    return false
end

function ancient_siege_engine_homing_missile_modifier:IsPurgable()
	return false
end

function ancient_siege_engine_homing_missile_modifier:IsPurgeException()
	return false
end

function ancient_siege_engine_homing_missile_modifier:IsStunDebuff()
	return false
end

function ancient_siege_engine_homing_missile_modifier:IsDebuff()
	return true
end