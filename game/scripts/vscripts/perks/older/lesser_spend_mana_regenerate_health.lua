lesser_spend_mana_regenerate_health = class({})

function lesser_spend_mana_regenerate_health:OnCreated( data )
	-- ### VALUES START ### --
	self.health_refund                 = 400
	self.duration                      = 8
	-- ### VALUES END ### --
	
	if not IsServer() then return end
	self:StartIntervalThink(0.06)
end

function lesser_spend_mana_regenerate_health:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_SPENT_MANA
	}

	return funcs
end

function lesser_spend_mana_regenerate_health:OnSpentMana( params )
	if not IsServer() then return end

	local caster = self:GetParent()
	local mana_spent = params.cost
	local duration = self.duration
	local interval = 0.1
	local health_refund = ( mana_spent * (self.health_refund / 100) ) / ( duration / interval )

	local timer = Timers:CreateTimer(0, function()

		caster:Heal(health_refund, nil)

		return interval
	end)

	Timers:CreateTimer(duration, function()
		Timers:RemoveTimer(timer)
	end)

end

function lesser_spend_mana_regenerate_health:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE + MODIFIER_ATTRIBUTE_MULTIPLE
end

function lesser_spend_mana_regenerate_health:IsHidden()
    return true
end

function lesser_spend_mana_regenerate_health:IsPurgable()
	return false
end

function lesser_spend_mana_regenerate_health:IsPurgeException()
	return false
end

function lesser_spend_mana_regenerate_health:IsStunDebuff()
	return false
end

function lesser_spend_mana_regenerate_health:IsDebuff()
	return false
end















































































































































































































































