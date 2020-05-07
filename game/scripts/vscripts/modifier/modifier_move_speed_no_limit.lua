modifier_move_speed_no_limit = class( {} )

function modifier_move_speed_no_limit:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_MAX,
	}

	return funcs
end

function modifier_move_speed_no_limit:GetModifierMoveSpeed_Max()
	return 99999
end

function modifier_move_speed_no_limit:IsHidden()
	return true
end

function modifier_move_speed_no_limit:IsPurgable()
	return false
end

function modifier_move_speed_no_limit:IsPurgeException()
	return false
end

function modifier_move_speed_no_limit:IsStunDebuff()
	return false
end

function modifier_move_speed_no_limit:IsDebuff()
	return false
end
