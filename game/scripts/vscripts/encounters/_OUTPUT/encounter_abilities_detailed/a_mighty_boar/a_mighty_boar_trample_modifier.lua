a_mighty_boar_trample_modifier = class({})

function a_mighty_boar_trample_modifier:OnCreated( kv )
	self.damage                       = self:GetAbility():GetSpecialValueFor("damage")
end

function a_mighty_boar_trample_modifier:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_TOOLTIP,
	}

	return funcs
end


function a_mighty_boar_trample_modifier:OnTooltip( params )
	return self.damage
end


function a_mighty_boar_trample_modifier:GetAttributes()
	return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE
end

function a_mighty_boar_trample_modifier:IsHidden()
    return false
end

function a_mighty_boar_trample_modifier:IsPurgable()
	return false
end

function a_mighty_boar_trample_modifier:IsPurgeException()
	return false
end

function a_mighty_boar_trample_modifier:IsStunDebuff()
	return false
end

function a_mighty_boar_trample_modifier:IsDebuff()
	return true
end