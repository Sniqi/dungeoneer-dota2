item_ancient_book_of_proficiency_modifier = class({})

function item_ancient_book_of_proficiency_modifier:OnCreated( data )
	self.bonus_all_stats = data.bonus
end

function item_ancient_book_of_proficiency_modifier:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS
	}

	return funcs
end

function item_ancient_book_of_proficiency_modifier:GetModifierBonusStats_Strength( params )
	return self.bonus_all_stats
end

function item_ancient_book_of_proficiency_modifier:GetModifierBonusStats_Agility( params )
	return self.bonus_all_stats
end

function item_ancient_book_of_proficiency_modifier:GetModifierBonusStats_Intellect( params )
	return self.bonus_all_stats
end

function item_ancient_book_of_proficiency_modifier:RemoveOnDeath()
	return false
end

function item_ancient_book_of_proficiency_modifier:IsHidden()
	return true
end

function item_ancient_book_of_proficiency_modifier:GetAttributes()
	return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE + MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_MULTIPLE
end

function item_ancient_book_of_proficiency_modifier:IsPurgable()
	return false
end

function item_ancient_book_of_proficiency_modifier:IsPurgeException()
	return false
end

function item_ancient_book_of_proficiency_modifier:IsStunDebuff()
	return false
end

function item_ancient_book_of_proficiency_modifier:IsDebuff()
	return false
end