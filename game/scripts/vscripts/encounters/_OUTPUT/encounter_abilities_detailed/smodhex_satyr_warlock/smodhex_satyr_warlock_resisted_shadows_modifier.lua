smodhex_satyr_warlock_resisted_shadows_modifier = class({})

function smodhex_satyr_warlock_resisted_shadows_modifier:OnCreated( kv )
	self.damage                       = self:GetAbility():GetSpecialValueFor("damage")
end

function smodhex_satyr_warlock_resisted_shadows_modifier:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_TOOLTIP,
	}

	return funcs
end


function smodhex_satyr_warlock_resisted_shadows_modifier:OnTooltip( params )
	return self.damage
end


function smodhex_satyr_warlock_resisted_shadows_modifier:GetAttributes()
	return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE
end

function smodhex_satyr_warlock_resisted_shadows_modifier:IsHidden()
    return false
end

function smodhex_satyr_warlock_resisted_shadows_modifier:IsPurgable()
	return false
end

function smodhex_satyr_warlock_resisted_shadows_modifier:IsPurgeException()
	return false
end

function smodhex_satyr_warlock_resisted_shadows_modifier:IsStunDebuff()
	return false
end

function smodhex_satyr_warlock_resisted_shadows_modifier:IsDebuff()
	return true
end