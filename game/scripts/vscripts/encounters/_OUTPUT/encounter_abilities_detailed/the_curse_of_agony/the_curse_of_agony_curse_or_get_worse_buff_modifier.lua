the_curse_of_agony_curse_or_get_worse_buff_modifier = class({})

function the_curse_of_agony_curse_or_get_worse_buff_modifier:OnCreated( kv )
	self.attack_damage_percentage     = self:GetAbility():GetSpecialValueFor("attack_damage_percentage")
	self.buff_spell_amplify_percentage= self:GetAbility():GetSpecialValueFor("buff_spell_amplify_percentage")
	self.buff_base_attack_time_constant= self:GetAbility():GetSpecialValueFor("buff_base_attack_time_constant")
	self.buff_move_speed_constant     = self:GetAbility():GetSpecialValueFor("buff_move_speed_constant")
	self.buff_incoming_damage_percentage= self:GetAbility():GetSpecialValueFor("buff_incoming_damage_percentage")
	self.debuff_attack_damage_percentage= self:GetAbility():GetSpecialValueFor("debuff_attack_damage_percentage")
	self.debuff_spell_amplify_percentage= self:GetAbility():GetSpecialValueFor("debuff_spell_amplify_percentage")
	self.debuff_incoming_damage_percentage= self:GetAbility():GetSpecialValueFor("debuff_incoming_damage_percentage")
end

function the_curse_of_agony_curse_or_get_worse_buff_modifier:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_BASEDAMAGEOUTGOING_PERCENTAGE,
		MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,
		MODIFIER_PROPERTY_BASE_ATTACK_TIME_CONSTANT,
		MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
		MODIFIER_PROPERTY_BASEDAMAGEOUTGOING_PERCENTAGE,
		MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,
		MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
	}

	return funcs
end


function the_curse_of_agony_curse_or_get_worse_buff_modifier:GetModifierBaseDamageOutgoing_Percentage( params )
	return self.attack_damage_percentage
end

function the_curse_of_agony_curse_or_get_worse_buff_modifier:OnTooltip( params )
	return self.buff_spell_amplify_percentage
end

function the_curse_of_agony_curse_or_get_worse_buff_modifier:OnTooltip( params )
	return self.buff_base_attack_time_constant
end

function the_curse_of_agony_curse_or_get_worse_buff_modifier:OnTooltip( params )
	return self.buff_move_speed_constant
end

function the_curse_of_agony_curse_or_get_worse_buff_modifier:OnTooltip( params )
	return self.buff_incoming_damage_percentage
end

function the_curse_of_agony_curse_or_get_worse_buff_modifier:OnTooltip( params )
	return self.debuff_attack_damage_percentage
end

function the_curse_of_agony_curse_or_get_worse_buff_modifier:OnTooltip( params )
	return self.debuff_spell_amplify_percentage
end

function the_curse_of_agony_curse_or_get_worse_buff_modifier:OnTooltip( params )
	return self.debuff_incoming_damage_percentage
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
	return true
end