lesser_mana_regen = class({})

function lesser_mana_regen:OnCreated( data )
	-- ### VALUES START ### --
	self.mana_regen                    = 1
	-- ### VALUES END ### --
end

function lesser_mana_regen:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MANA_REGEN_TOTAL_PERCENTAGE
	}

	return funcs
end

function lesser_mana_regen:GetModifierTotalPercentageManaRegen( params )
	return self.mana_regen
end

function lesser_mana_regen:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE + MODIFIER_ATTRIBUTE_MULTIPLE
end

function lesser_mana_regen:IsHidden()
    return true
end

function lesser_mana_regen:IsPurgable()
	return false
end

function lesser_mana_regen:IsPurgeException()
	return false
end

function lesser_mana_regen:IsStunDebuff()
	return false
end

function lesser_mana_regen:IsDebuff()
	return false
end



















































































































