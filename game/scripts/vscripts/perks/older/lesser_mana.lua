lesser_mana = class({})

function lesser_mana:OnCreated( data )
	-- ### VALUES START ### --
	self.mana                          = 750
	-- ### VALUES END ### --
end

function lesser_mana:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MANA_BONUS
	}

	return funcs
end

function lesser_mana:GetModifierManaBonus( params )
	return self.mana
end

function lesser_mana:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE + MODIFIER_ATTRIBUTE_MULTIPLE
end

function lesser_mana:IsHidden()
    return true
end

function lesser_mana:IsPurgable()
	return false
end

function lesser_mana:IsPurgeException()
	return false
end

function lesser_mana:IsStunDebuff()
	return false
end

function lesser_mana:IsDebuff()
	return false
end




















































































































