modifier_out_of_world = class( {} )

function modifier_out_of_world:OnCreated( kv )
	if not IsServer() then return end
	self:GetParent():AddNoDraw()
end

function modifier_out_of_world:OnDestroy( kv )
	if not IsServer() then return end
	self:GetParent():RemoveNoDraw()
end

function modifier_out_of_world:CheckState()
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

function modifier_out_of_world:IsHidden()
    return true
end

function modifier_out_of_world:IsPurgable()
	return false
end

function modifier_out_of_world:IsPurgeException()
	return false
end

function modifier_out_of_world:IsStunDebuff()
	return false
end

function modifier_out_of_world:IsDebuff()
	return false
end
