wind_harpy_tornado_damage_modifier = class({})

function wind_harpy_tornado_damage_modifier:OnCreated( kv )
	self.damage                       = self:GetAbility():GetSpecialValueFor("damage")
end

function wind_harpy_tornado_damage_modifier:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_TOOLTIP,
	}

	return funcs
end


function wind_harpy_tornado_damage_modifier:OnTooltip( params )
	return self.damage
end


function wind_harpy_tornado_damage_modifier:GetAttributes()
	return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE
end

function wind_harpy_tornado_damage_modifier:IsHidden()
    return false
end

function wind_harpy_tornado_damage_modifier:IsPurgable()
	return false
end

function wind_harpy_tornado_damage_modifier:IsPurgeException()
	return false
end

function wind_harpy_tornado_damage_modifier:IsStunDebuff()
	return false
end

function wind_harpy_tornado_damage_modifier:IsDebuff()
	return true
end