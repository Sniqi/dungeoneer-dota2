a_mighty_boar_tremble_modifier = class({})

function a_mighty_boar_tremble_modifier:OnCreated( kv )
	self.incoming_damage_percentage   = self:GetAbility():GetSpecialValueFor("incoming_damage_percentage")
	self.vulnerable_duration          = self:GetAbility():GetSpecialValueFor("vulnerable_duration")
end

function a_mighty_boar_tremble_modifier:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
		MODIFIER_PROPERTY_TOOLTIP,
	}

	return funcs
end


function a_mighty_boar_tremble_modifier:GetModifierIncomingDamage_Percentage( params )
	return self.incoming_damage_percentage
end

function a_mighty_boar_tremble_modifier:OnTooltip( params )
	return self.vulnerable_duration
end


function a_mighty_boar_tremble_modifier:GetAttributes()
	return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE
end

function a_mighty_boar_tremble_modifier:IsHidden()
    return false
end

function a_mighty_boar_tremble_modifier:IsPurgable()
	return false
end

function a_mighty_boar_tremble_modifier:IsPurgeException()
	return false
end

function a_mighty_boar_tremble_modifier:IsStunDebuff()
	return false
end

function a_mighty_boar_tremble_modifier:IsDebuff()
	return true
end