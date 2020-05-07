item_book_of_strength_modifier = class({})

function item_book_of_strength_modifier:OnCreated( data )
	self.bonus_strength = data.bonus
end

function item_book_of_strength_modifier:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS
	}

	return funcs
end

function item_book_of_strength_modifier:GetModifierBonusStats_Strength( params )
	return self.bonus_strength
end

function item_book_of_strength_modifier:RemoveOnDeath()
	return false
end

function item_book_of_strength_modifier:IsHidden()
	return true
end

function item_book_of_strength_modifier:GetAttributes()
	return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE + MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_MULTIPLE
end

function item_book_of_strength_modifier:IsPurgable()
	return false
end

function item_book_of_strength_modifier:IsPurgeException()
	return false
end

function item_book_of_strength_modifier:IsStunDebuff()
	return false
end

function item_book_of_strength_modifier:IsDebuff()
	return false
end