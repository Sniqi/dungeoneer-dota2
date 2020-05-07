modifier_player_disconnected = class( {} )

function modifier_player_disconnected:CheckState()
	local state = {
	[MODIFIER_STATE_OUT_OF_GAME] = true,
	[MODIFIER_STATE_NOT_ON_MINIMAP] = true,
	[MODIFIER_STATE_INVULNERABLE] = true,
	[MODIFIER_STATE_UNSELECTABLE] = true,
	[MODIFIER_STATE_FROZEN] = true,
	[MODIFIER_STATE_COMMAND_RESTRICTED] = true,
	[MODIFIER_STATE_NO_HEALTH_BAR] = true,
	[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
	}
 
	return state
end

function modifier_player_disconnected:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE
end

function modifier_player_disconnected:IsHidden()
    return true
end

function modifier_player_disconnected:IsPurgable()
	return false
end

function modifier_player_disconnected:IsPurgeException()
	return false
end

function modifier_player_disconnected:IsStunDebuff()
	return false
end

function modifier_player_disconnected:IsDebuff()
	return false
end
