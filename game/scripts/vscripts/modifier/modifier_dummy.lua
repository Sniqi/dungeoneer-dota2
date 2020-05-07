modifier_dummy = class( {} )

function modifier_dummy:OnCreated( kv )
	if not IsServer() then return end
	--self:GetParent():AddNoDraw()
end

function modifier_dummy:OnDestroy( kv )
	if not IsServer() then return end
	--self:GetParent():RemoveNoDraw()
end

function modifier_dummy:CheckState()
	local state = {
	[MODIFIER_STATE_OUT_OF_GAME] = true,
	[MODIFIER_STATE_NOT_ON_MINIMAP] = true,
	[MODIFIER_STATE_INVULNERABLE] = true,
	[MODIFIER_STATE_UNSELECTABLE] = true,
	[MODIFIER_STATE_UNTARGETABLE] = true,
	[MODIFIER_STATE_ATTACK_IMMUNE] = true,
	[MODIFIER_STATE_NO_HEALTH_BAR] = true,
	--[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
	}
 
	return state
end

function modifier_dummy:IsHidden()
    return true
end

function modifier_dummy:IsPurgable()
	return false
end

function modifier_dummy:IsPurgeException()
	return false
end

function modifier_dummy:IsStunDebuff()
	return false
end

function modifier_dummy:IsDebuff()
	return false
end
