lesser_spell_damage = class({})

function lesser_spell_damage:OnCreated( data )
	-- ### VALUES START ### --
	self.spell_damage                  = 40
	-- ### VALUES END ### --
end

function lesser_spell_damage:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE
	}

	return funcs
end

function lesser_spell_damage:GetModifierSpellAmplify_Percentage( params )
	return self.spell_damage
end

function lesser_spell_damage:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE + MODIFIER_ATTRIBUTE_MULTIPLE
end

function lesser_spell_damage:IsHidden()
    return true
end

function lesser_spell_damage:IsPurgable()
	return false
end

function lesser_spell_damage:IsPurgeException()
	return false
end

function lesser_spell_damage:IsStunDebuff()
	return false
end

function lesser_spell_damage:IsDebuff()
	return false
end















































































































































































































































