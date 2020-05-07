lesser_spend_mana_regenerate_mana = class({})

function lesser_spend_mana_regenerate_mana:OnCreated( data )
	-- ### VALUES START ### --
	self.mana_refund                   = 100
	self.duration                      = 8
	-- ### VALUES END ### --
end

function lesser_spend_mana_regenerate_mana:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_SPENT_MANA
	}

	return funcs
end

function lesser_spend_mana_regenerate_mana:OnSpentMana( params )
	if not IsServer() then return end

	local caster = self:GetParent()
	local mana_spent = params.cost
	local duration = self.duration
	local interval = 0.1
	local mana_refund = ( mana_spent * (self.mana_refund / 100) ) / ( duration / interval )

	local timer = Timers:CreateTimer(0, function()

		caster:GiveMana(mana_refund)

		return interval
	end)

	Timers:CreateTimer(duration, function()
		Timers:RemoveTimer(timer)
	end)

end

function lesser_spend_mana_regenerate_mana:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE + MODIFIER_ATTRIBUTE_MULTIPLE
end

function lesser_spend_mana_regenerate_mana:IsHidden()
    return true
end

function lesser_spend_mana_regenerate_mana:IsPurgable()
	return false
end

function lesser_spend_mana_regenerate_mana:IsPurgeException()
	return false
end

function lesser_spend_mana_regenerate_mana:IsStunDebuff()
	return false
end

function lesser_spend_mana_regenerate_mana:IsDebuff()
	return false
end



































































































































































































































































































