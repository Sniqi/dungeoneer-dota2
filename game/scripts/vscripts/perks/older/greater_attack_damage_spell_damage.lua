greater_attack_damage_spell_damage = class({})

function greater_attack_damage_spell_damage:OnCreated( data )
	-- ### VALUES START ### --
	self.attack_damage                 = 10
	self.spell_damage                  = 10
	-- ### VALUES END ### --
end

function greater_attack_damage_spell_damage:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_BASEDAMAGEOUTGOING_PERCENTAGE,
		MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE
	}

	return funcs
end

function greater_attack_damage_spell_damage:GetModifierBaseDamageOutgoing_Percentage( params )
	return self.attack_damage
end

function greater_attack_damage_spell_damage:GetModifierSpellAmplify_Percentage( params )
	return self.spell_damage
end

function greater_attack_damage_spell_damage:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE + MODIFIER_ATTRIBUTE_MULTIPLE
end

function greater_attack_damage_spell_damage:IsHidden()
    return true
end

function greater_attack_damage_spell_damage:IsPurgable()
	return false
end

function greater_attack_damage_spell_damage:IsPurgeException()
	return false
end

function greater_attack_damage_spell_damage:IsStunDebuff()
	return false
end

function greater_attack_damage_spell_damage:IsDebuff()
	return false
end



















































































































































































































































































