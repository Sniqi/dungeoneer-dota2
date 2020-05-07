sinastra_flying_creature_modifier = class({})

function sinastra_flying_creature_modifier:OnCreated( kv )
end

function sinastra_flying_creature_modifier:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_PHYSICAL,
		MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_MAGICAL,
		MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_PURE
	}

	return funcs
end

function sinastra_flying_creature_modifier:GetAbsoluteNoDamagePhysical()
	return 1
end

function sinastra_flying_creature_modifier:GetAbsoluteNoDamageMagical()
	return 1
end

function sinastra_flying_creature_modifier:GetAbsoluteNoDamagePure()
	return 1
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