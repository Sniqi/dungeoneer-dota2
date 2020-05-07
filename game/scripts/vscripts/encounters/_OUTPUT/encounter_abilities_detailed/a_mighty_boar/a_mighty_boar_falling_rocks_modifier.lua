a_mighty_boar_falling_rocks_modifier = class({})

function a_mighty_boar_falling_rocks_modifier:OnCreated( kv )
	self.stun                         = self:GetAbility():GetSpecialValueFor("stun")
end

function a_mighty_boar_falling_rocks_modifier:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_TOOLTIP,
	}

	return funcs
end


function a_mighty_boar_falling_rocks_modifier:OnTooltip( params )
	return self.stun
end


function a_mighty_boar_falling_rocks_modifier:GetAttributes()
	return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE
end

function a_mighty_boar_falling_rocks_modifier:IsHidden()
    return false
end

function a_mighty_boar_falling_rocks_modifier:IsPurgable()
	return false
end

function a_mighty_boar_falling_rocks_modifier:IsPurgeException()
	return false
end

function a_mighty_boar_falling_rocks_modifier:IsStunDebuff()
	return false
end

function a_mighty_boar_falling_rocks_modifier:IsDebuff()
	return true
end