item_book_of_intelligence_modifier = class({})

function item_book_of_intelligence_modifier:OnCreated( data )
	self.bonus_intelligence = data.bonus
end

function item_book_of_intelligence_modifier:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS
	}

	return funcs
end

function item_book_of_intelligence_modifier:GetModifierBonusStats_Intellect( params )
	return self.bonus_intelligence
end

function item_book_of_intelligence_modifier:RemoveOnDeath()
	return false
end

function item_book_of_intelligence_modifier:IsHidden()
	return true
end

function item_book_of_intelligence_modifier:GetAttributes()
	return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE + MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_MULTIPLE
end

function item_book_of_intelligence_modifier:IsPurgable()
	return false
end

function item_book_of_intelligence_modifier:IsPurgeException()
	return false
end

function item_book_of_intelligence_modifier:IsStunDebuff()
	return false
end

function item_book_of_intelligence_modifier:IsDebuff()
	return false
end