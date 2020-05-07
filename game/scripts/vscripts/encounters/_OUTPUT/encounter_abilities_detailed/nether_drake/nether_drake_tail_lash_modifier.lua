nether_drake_tail_lash_modifier = class({})

function nether_drake_tail_lash_modifier:OnCreated( kv )
	self.damage                       = self:GetAbility():GetSpecialValueFor("damage")
end

function nether_drake_tail_lash_modifier:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_TOOLTIP,
	}

	return funcs
end


function nether_drake_tail_lash_modifier:OnTooltip( params )
	return self.damage
end


function nether_drake_tail_lash_modifier:GetAttributes()
	return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE
end

function nether_drake_tail_lash_modifier:IsHidden()
    return false
end

function nether_drake_tail_lash_modifier:IsPurgable()
	return false
end

function nether_drake_tail_lash_modifier:IsPurgeException()
	return false
end

function nether_drake_tail_lash_modifier:IsStunDebuff()
	return false
end

function nether_drake_tail_lash_modifier:IsDebuff()
	return true
end