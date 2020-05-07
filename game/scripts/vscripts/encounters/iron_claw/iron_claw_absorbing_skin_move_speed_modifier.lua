iron_claw_absorbing_skin_move_speed_modifier = class({})

function iron_claw_absorbing_skin_move_speed_modifier:OnCreated( kv )
	self.damage_to_move_speed_percentage= self:GetAbility():GetSpecialValueFor("damage_to_move_speed_percentage")
	self.move_speed_limit_ignore        = self:GetAbility():GetSpecialValueFor("move_speed_limit_ignore")
end

function iron_claw_absorbing_skin_move_speed_modifier:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_IGNORE_MOVESPEED_LIMIT,
	}

	return funcs
end

function iron_claw_absorbing_skin_move_speed_modifier:GetModifierMoveSpeedBonus_Constant( params )
	return self:GetStackCount() / 1000--self.damage_to_move_speed_percentage
end

function iron_claw_absorbing_skin_move_speed_modifier:GetModifierIgnoreMovespeedLimit( params )
	return self.move_speed_limit_ignore
end


function iron_claw_absorbing_skin_move_speed_modifier:GetAttributes()
	return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE
end

function iron_claw_absorbing_skin_move_speed_modifier:IsHidden()
    return false
end

function iron_claw_absorbing_skin_move_speed_modifier:IsPurgable()
	return false
end

function iron_claw_absorbing_skin_move_speed_modifier:IsPurgeException()
	return false
end

function iron_claw_absorbing_skin_move_speed_modifier:IsStunDebuff()
	return false
end

function iron_claw_absorbing_skin_move_speed_modifier:IsDebuff()
	return false
end