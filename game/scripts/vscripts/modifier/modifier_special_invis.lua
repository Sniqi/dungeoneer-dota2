modifier_special_invis = class( {} )

function modifier_special_invis:OnCreated( kv )
	if not IsServer() then return end
	self:GetParent():AddNoDraw()
end

function modifier_special_invis:OnDestroy( kv )
	if not IsServer() then return end
	self:GetParent():RemoveNoDraw()
end

function modifier_special_invis:CheckState()
	local state = {
	[MODIFIER_STATE_NOT_ON_MINIMAP] = true,
	[MODIFIER_STATE_INVULNERABLE] = true,
	[MODIFIER_STATE_UNSELECTABLE] = true,
	[MODIFIER_STATE_FROZEN] = true,
	[MODIFIER_STATE_NO_HEALTH_BAR] = true,
	[MODIFIER_STATE_NO_UNIT_COLLISION] = true
	}
 
	return state
end

function modifier_special_invis:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_INVISIBILITY_LEVEL
	}

	return funcs
end

function modifier_special_invis:GetModifierInvisibilityLevel()
	return 100
end

function modifier_special_invis:IsHidden()
    return true
end

function modifier_special_invis:IsPurgable()
	return false
end

function modifier_special_invis:IsPurgeException()
	return false
end

function modifier_special_invis:IsStunDebuff()
	return false
end

function modifier_special_invis:IsDebuff()
	return false
end
