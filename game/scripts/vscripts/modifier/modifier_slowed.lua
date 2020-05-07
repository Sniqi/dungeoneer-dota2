modifier_slowed = class( {} )

function modifier_slowed:OnCreated( data )
	self.slow = data.slow
end

function modifier_slowed:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
	}

	return funcs
end

function modifier_slowed:GetModifierMoveSpeedBonus_Percentage()
	return self.slow
end

function modifier_slowed:IsHidden()
	return true
end

function modifier_slowed:IsPurgable()
	return false
end

function modifier_slowed:IsPurgeException()
	return false
end

function modifier_slowed:IsStunDebuff()
	return false
end

function modifier_slowed:IsDebuff()
	return false
end
