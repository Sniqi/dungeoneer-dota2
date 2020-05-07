lesser_healthy_heart = class({})

function lesser_healthy_heart:OnCreated( data )
	-- ### VALUES START ### --
	self.health_regen                  = 1
	self.mana_refund                   = 50
	self.duration                      = 8
	self.effectiveness_offensive       = 50.0
	-- ### VALUES END ### --
	
	if not IsServer() then return end
	self.perkname = data.perkName
	self.perkID = data.perkID
	self.level = data.level
	self.perkEffectiveness = data.perkEffectiveness

	Change_PerkEffectivenessStats(self, true)

	self:StartIntervalThink(1.00)
end

function lesser_healthy_heart:OnRemoved()
	if not IsServer() then return end
	Change_PerkEffectivenessStats(self, false)
end

function lesser_healthy_heart:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_HEALTH_REGEN_PERCENTAGE,
		MODIFIER_EVENT_ON_SPENT_MANA
	}

	return funcs
end

function lesser_healthy_heart:OnIntervalThink()
	if not IsServer() then return end

	self:SetStackCount( 10000 * self.perkEffectiveness )
end

function lesser_healthy_heart:OnSpentMana( params )
	if not IsServer() then return end

	local caster = self:GetParent()
	local mana_spent = params.cost
	local duration = self.duration
	local interval = 0.1
	local mana_refund = ( mana_spent * (self.mana_refund / 100) ) / ( duration / interval )
	mana_refund = mana_refund * ( self:GetStackCount() / 10000 )

	local timer = Timers:CreateTimer(0, function()

		caster:GiveMana(mana_refund)

		return interval
	end)

	Timers:CreateTimer(duration, function()
		Timers:RemoveTimer(timer)
	end)

end

function lesser_healthy_heart:GetModifierHealthRegenPercentage( params )
	return self.health_regen * ( self:GetStackCount() / 10000 )
end

function lesser_healthy_heart:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE + MODIFIER_ATTRIBUTE_MULTIPLE
end

function lesser_healthy_heart:IsHidden()
    return true
end

function lesser_healthy_heart:IsPurgable()
	return false
end

function lesser_healthy_heart:IsPurgeException()
	return false
end

function lesser_healthy_heart:IsStunDebuff()
	return false
end

function lesser_healthy_heart:IsDebuff()
	return false
end






















