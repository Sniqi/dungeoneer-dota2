scroll_collector_reverse_jail_safe_zone_modifier = class({})

function scroll_collector_reverse_jail_safe_zone_modifier:OnCreated( kv )
	self.damage                       = self:GetAbility():GetSpecialValueFor("damage")
end

function scroll_collector_reverse_jail_safe_zone_modifier:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_TOOLTIP,
	}

	return funcs
end


function scroll_collector_reverse_jail_safe_zone_modifier:OnTooltip( params )
	return self.damage
end


function scroll_collector_reverse_jail_safe_zone_modifier:GetAttributes()
	return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE
end

function scroll_collector_reverse_jail_safe_zone_modifier:IsHidden()
    return false
end

function scroll_collector_reverse_jail_safe_zone_modifier:IsPurgable()
	return false
end

function scroll_collector_reverse_jail_safe_zone_modifier:IsPurgeException()
	return false
end

function scroll_collector_reverse_jail_safe_zone_modifier:IsStunDebuff()
	return false
end

function scroll_collector_reverse_jail_safe_zone_modifier:IsDebuff()
	return true
end