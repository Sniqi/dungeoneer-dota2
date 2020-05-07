greater_low_health_defense = class({})

function greater_low_health_defense:OnCreated( data )
	-- ### VALUES START ### --
	self.health_trigger                = 70
	self.resilience                    = 20
	-- ### VALUES END ### --

	if not IsServer() then return end
	self:StartIntervalThink(0.1)
end

function greater_low_health_defense:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_TAKEDAMAGE
	}

	return funcs
end

function greater_low_health_defense:OnIntervalThink()
	if not IsServer() then return end

	local caster = self:GetParent()

	if caster:GetHealth() <= ( caster:GetMaxHealth() * ( self.health_trigger / 100 ) ) then
		self:SetStackCount(self.resilience)
	else
		self:SetStackCount(0)
	end
end

function greater_low_health_defense:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE + MODIFIER_ATTRIBUTE_MULTIPLE
end

function greater_low_health_defense:IsHidden()
    return true
end

function greater_low_health_defense:IsPurgable()
	return false
end

function greater_low_health_defense:IsPurgeException()
	return false
end

function greater_low_health_defense:IsStunDebuff()
	return false
end

function greater_low_health_defense:IsDebuff()
	return false
end




























































































































