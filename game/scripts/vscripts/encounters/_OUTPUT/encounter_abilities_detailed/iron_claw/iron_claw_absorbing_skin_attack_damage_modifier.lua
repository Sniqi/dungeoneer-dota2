iron_claw_absorbing_skin_attack_damage_modifier = class({})

function iron_claw_absorbing_skin_attack_damage_modifier:OnCreated( kv )
	self.damage_to_attack_damage_percentage= self:GetAbility():GetSpecialValueFor("damage_to_attack_damage_percentage")
	self.damage_to_move_speed_percentage= self:GetAbility():GetSpecialValueFor("damage_to_move_speed_percentage")
end

function iron_claw_absorbing_skin_attack_damage_modifier:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_TOOLTIP,
		MODIFIER_PROPERTY_TOOLTIP,
	}

	return funcs
end


function iron_claw_absorbing_skin_attack_damage_modifier:OnTooltip( params )
	return self.damage_to_attack_damage_percentage
end

function iron_claw_absorbing_skin_attack_damage_modifier:OnTooltip( params )
	return self.damage_to_move_speed_percentage
end


function iron_claw_absorbing_skin_attack_damage_modifier:GetAttributes()
	return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE
end

function iron_claw_absorbing_skin_attack_damage_modifier:IsHidden()
    return false
end

function iron_claw_absorbing_skin_attack_damage_modifier:IsPurgable()
	return false
end

function iron_claw_absorbing_skin_attack_damage_modifier:IsPurgeException()
	return false
end

function iron_claw_absorbing_skin_attack_damage_modifier:IsStunDebuff()
	return false
end

function iron_claw_absorbing_skin_attack_damage_modifier:IsDebuff()
	return true
end