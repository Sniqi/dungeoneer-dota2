air_ship_whirlpool_modifier = class({})

function air_ship_whirlpool_modifier:OnCreated( kv )
	self.damage                       = self:GetAbility():GetSpecialValueFor("damage")
end

function air_ship_whirlpool_modifier:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_TOOLTIP,
	}

	return funcs
end


function air_ship_whirlpool_modifier:OnTooltip( params )
	return self.damage
end


function air_ship_whirlpool_modifier:GetAttributes()
	return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE
end

function air_ship_whirlpool_modifier:IsHidden()
    return false
end

function air_ship_whirlpool_modifier:IsPurgable()
	return false
end

function air_ship_whirlpool_modifier:IsPurgeException()
	return false
end

function air_ship_whirlpool_modifier:IsStunDebuff()
	return false
end

function air_ship_whirlpool_modifier:IsDebuff()
	return true
end