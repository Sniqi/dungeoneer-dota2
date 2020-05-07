treasure_on_a_tree_green_mines_modifier = class({})

function treasure_on_a_tree_green_mines_modifier:OnCreated( kv )
	self.move_speed_percentage        = self:GetAbility():GetSpecialValueFor("move_speed_percentage")
end

function treasure_on_a_tree_green_mines_modifier:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
	}

	return funcs
end


function treasure_on_a_tree_green_mines_modifier:GetModifierMoveSpeedBonus_Percentage( params )
	return self.move_speed_percentage
end


function treasure_on_a_tree_green_mines_modifier:GetAttributes()
	return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE
end

function treasure_on_a_tree_green_mines_modifier:IsHidden()
    return false
end

function treasure_on_a_tree_green_mines_modifier:IsPurgable()
	return false
end

function treasure_on_a_tree_green_mines_modifier:IsPurgeException()
	return false
end

function treasure_on_a_tree_green_mines_modifier:IsStunDebuff()
	return false
end

function treasure_on_a_tree_green_mines_modifier:IsDebuff()
	return true
end