greater_lifesteal = class({})

function greater_lifesteal:OnCreated( data )
	-- ### VALUES START ### --
	self.lifesteal                     = 15
	-- ### VALUES END ### --
end

function greater_lifesteal:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_TAKEDAMAGE
	}

	return funcs
end

function greater_lifesteal:OnTakeDamage( params )
	if not IsServer() then return end
	if self:GetParent() ~= params.attacker then return end

	local caster = self:GetParent()

	caster:Heal(params.damage * (self.lifesteal/100), caster)

	-- params.unit
	-- params.damage_type
	-- params.attacker
	-- params.original_damage
	-- params.damage
	-- params.inflictor
end

function greater_lifesteal:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE + MODIFIER_ATTRIBUTE_MULTIPLE
end

function greater_lifesteal:IsHidden()
    return true
end

function greater_lifesteal:IsPurgable()
	return false
end

function greater_lifesteal:IsPurgeException()
	return false
end

function greater_lifesteal:IsStunDebuff()
	return false
end

function greater_lifesteal:IsDebuff()
	return false
end




































































































































































































































































































