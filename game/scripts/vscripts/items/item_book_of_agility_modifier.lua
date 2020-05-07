item_book_of_agility_modifier = class({})

function item_book_of_agility_modifier:OnCreated( data )
	self.bonus_agility = data.bonus
end

function item_book_of_agility_modifier:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS
	}

	return funcs
end

function item_book_of_agility_modifier:GetModifierBonusStats_Agility( params )
	return self.bonus_agility
end

function item_book_of_agility_modifier:RemoveOnDeath()
	return false
end

function item_book_of_agility_modifier:IsHidden()
	return true
end

function item_book_of_agility_modifier:GetAttributes()
	return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE + MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_MULTIPLE
end

function item_book_of_agility_modifier:IsPurgable()
	return false
end

function item_book_of_agility_modifier:IsPurgeException()
	return false
end

function item_book_of_agility_modifier:IsStunDebuff()
	return false
end

function item_book_of_agility_modifier:IsDebuff()
	return false
end