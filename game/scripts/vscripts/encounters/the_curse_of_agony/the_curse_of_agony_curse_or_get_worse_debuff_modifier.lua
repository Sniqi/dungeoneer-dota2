the_curse_of_agony_curse_or_get_worse_debuff_modifier = class({})

function the_curse_of_agony_curse_or_get_worse_debuff_modifier:OnCreated( kv )
	self.debuff_attack_damage_percentage= self:GetAbility():GetSpecialValueFor("debuff_attack_damage_percentage")
	self.debuff_spell_amplify_percentage= self:GetAbility():GetSpecialValueFor("debuff_spell_amplify_percentage")
	self.debuff_incoming_damage_percentage= self:GetAbility():GetSpecialValueFor("debuff_incoming_damage_percentage")
end

function the_curse_of_agony_curse_or_get_worse_debuff_modifier:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_BASEDAMAGEOUTGOING_PERCENTAGE,
		MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,
		MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE
	}

	return funcs
end

function the_curse_of_agony_curse_or_get_worse_debuff_modifier:GetModifierBaseDamageOutgoing_Percentage( params )
	return self.debuff_attack_damage_percentage
end

function the_curse_of_agony_curse_or_get_worse_debuff_modifier:GetModifierSpellAmplify_Percentage( params )
	return self.debuff_spell_amplify_percentage
end

function the_curse_of_agony_curse_or_get_worse_debuff_modifier:GetModifierIncomingDamage_Percentage( params )
	return self.debuff_incoming_damage_percentage
end

function the_curse_of_agony_curse_or_get_worse_debuff_modifier:GetEffectName()
	return "particles/econ/items/broodmother/bm_lycosidaes/bm_lycosidaes_spiderlings_debuff.vpcf"
end

function the_curse_of_agony_curse_or_get_worse_debuff_modifier:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

function the_curse_of_agony_curse_or_get_worse_debuff_modifier:GetAttributes()
	return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE
end

function the_curse_of_agony_curse_or_get_worse_debuff_modifier:IsHidden()
    return false
end

function the_curse_of_agony_curse_or_get_worse_debuff_modifier:IsPurgable()
	return false
end

function the_curse_of_agony_curse_or_get_worse_debuff_modifier:IsPurgeException()
	return false
end

function the_curse_of_agony_curse_or_get_worse_debuff_modifier:IsStunDebuff()
	return false
end

function the_curse_of_agony_curse_or_get_worse_debuff_modifier:IsDebuff()
	return true
end