the_curse_of_agony_curse_or_get_worse_buff_modifier = class({})

function the_curse_of_agony_curse_or_get_worse_buff_modifier:OnCreated( kv )
	self.buff_attack_damage_percentage     = self:GetAbility():GetSpecialValueFor("buff_attack_damage_percentage")
	self.buff_spell_amplify_percentage= self:GetAbility():GetSpecialValueFor("buff_spell_amplify_percentage")
	self.buff_base_attack_time_constant= self:GetAbility():GetSpecialValueFor("buff_base_attack_time_constant")
	self.buff_move_speed_constant     = self:GetAbility():GetSpecialValueFor("buff_move_speed_constant")
	self.buff_incoming_damage_percentage= self:GetAbility():GetSpecialValueFor("buff_incoming_damage_percentage")
end

function the_curse_of_agony_curse_or_get_worse_buff_modifier:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_BASEDAMAGEOUTGOING_PERCENTAGE,
		MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,
		MODIFIER_PROPERTY_BASE_ATTACK_TIME_CONSTANT,
		MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE
	}

	return funcs
end

function the_curse_of_agony_curse_or_get_worse_buff_modifier:GetModifierBaseDamageOutgoing_Percentage( params )
	return self.buff_attack_damage_percentage
end

function the_curse_of_agony_curse_or_get_worse_buff_modifier:GetModifierSpellAmplify_Percentage( params )
	return self.buff_spell_amplify_percentage
end

function the_curse_of_agony_curse_or_get_worse_buff_modifier:GetModifierBaseAttackTimeConstant( params )
	return self.buff_base_attack_time_constant
end

function the_curse_of_agony_curse_or_get_worse_buff_modifier:GetModifierMoveSpeedBonus_Constant( params )
	return self.buff_move_speed_constant
end

function the_curse_of_agony_curse_or_get_worse_buff_modifier:GetModifierIncomingDamage_Percentage( params )
	return self.buff_incoming_damage_percentage
end

function the_curse_of_agony_curse_or_get_worse_buff_modifier:GetEffectName()
	return "particles/econ/items/broodmother/bm_lycosidaes/bm_lycosidaes_spiderlings_debuff.vpcf"
end

function the_curse_of_agony_curse_or_get_worse_buff_modifier:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

function the_curse_of_agony_curse_or_get_worse_buff_modifier:GetAttributes()
	return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE
end

function the_curse_of_agony_curse_or_get_worse_buff_modifier:IsHidden()
    return false
end

function the_curse_of_agony_curse_or_get_worse_buff_modifier:IsPurgable()
	return false
end

function the_curse_of_agony_curse_or_get_worse_buff_modifier:IsPurgeException()
	return false
end

function the_curse_of_agony_curse_or_get_worse_buff_modifier:IsStunDebuff()
	return false
end

function the_curse_of_agony_curse_or_get_worse_buff_modifier:IsDebuff()
	return false
end