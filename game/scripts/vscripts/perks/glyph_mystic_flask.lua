glyph_mystic_flask = class({})

function glyph_mystic_flask:OnCreated( data )
	-- ### VALUES START ### --
	self.mana_refund                   = 10
	self.duration                      = 8
	self.effectiveness_offensive       = 6
	-- ### VALUES END ### --
	
	if not IsServer() then return end
	self.perkname = data.perkName
	self.perkID = data.perkID
	self.level = data.level
	self.perkEffectiveness = data.perkEffectiveness

	Change_PerkEffectivenessStats(self, true)

	self:StartIntervalThink(1.00)
end

function glyph_mystic_flask:OnRemoved()
	if not IsServer() then return end
	Change_PerkEffectivenessStats(self, false)
end

function glyph_mystic_flask:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_SPENT_MANA
	}

	return funcs
end

function glyph_mystic_flask:OnIntervalThink()
	if not IsServer() then return end

	self:SetStackCount( 10000 * self.perkEffectiveness )
end

function glyph_mystic_flask:OnSpentMana( params )
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

function glyph_mystic_flask:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE + MODIFIER_ATTRIBUTE_MULTIPLE
end

function glyph_mystic_flask:IsHidden()
    return true
end

function glyph_mystic_flask:IsPurgable()
	return false
end

function glyph_mystic_flask:IsPurgeException()
	return false
end

function glyph_mystic_flask:IsStunDebuff()
	return false
end

function glyph_mystic_flask:IsDebuff()
	return false
end




















































































































































