lesser_move_speed = class({})

function lesser_move_speed:OnCreated( data )
	-- ### VALUES START ### --
	self.move_speed                    = 14
	-- ### VALUES END ### --
end

function lesser_move_speed:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
	}

	return funcs
end

function lesser_move_speed:GetModifierMoveSpeedBonus_Percentage( params )
	return self.move_speed
end

function lesser_move_speed:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE + MODIFIER_ATTRIBUTE_MULTIPLE
end

function lesser_move_speed:IsHidden()
    return true
end

function lesser_move_speed:IsPurgable()
	return false
end

function lesser_move_speed:IsPurgeException()
	return false
end

function lesser_move_speed:IsStunDebuff()
	return false
end

function lesser_move_speed:IsDebuff()
	return false
end
















































































































































































