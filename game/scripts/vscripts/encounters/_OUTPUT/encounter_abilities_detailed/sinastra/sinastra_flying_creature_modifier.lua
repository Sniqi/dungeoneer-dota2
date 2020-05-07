sinastra_flying_creature_modifier = class({})

function sinastra_flying_creature_modifier:OnCreated( kv )
	self.phase_two_percentage         = self:GetAbility():GetSpecialValueFor("phase_two_percentage")
end

function sinastra_flying_creature_modifier:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_TOOLTIP,
	}

	return funcs
end


function sinastra_flying_creature_modifier:OnTooltip( params )
	return self.phase_two_percentage
end


function sinastra_flying_creature_modifier:GetAttributes()
	return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE
end

function sinastra_flying_creature_modifier:IsHidden()
    return false
end

function sinastra_flying_creature_modifier:IsPurgable()
	return false
end

function sinastra_flying_creature_modifier:IsPurgeException()
	return false
end

function sinastra_flying_creature_modifier:IsStunDebuff()
	return false
end

function sinastra_flying_creature_modifier:IsDebuff()
	return true
end