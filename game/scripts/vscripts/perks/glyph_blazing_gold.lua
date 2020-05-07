glyph_blazing_gold = class({})

function glyph_blazing_gold:OnCreated( data )
	-- ### VALUES START ### --
	self.currency_gold                 = 10
	self.effectiveness_holy            = 4
	self.effectiveness_offensive       = -5.0
	-- ### VALUES END ### --
	
	if not IsServer() then return end
	self.perkname = data.perkName
	self.perkID = data.perkID
	self.level = data.level
	self.perkEffectiveness = data.perkEffectiveness

	Change_PerkEffectivenessStats(self, true)

	self.currency_gold_orig = self.currency_gold

	self:StartIntervalThink(1.00)
end

function glyph_blazing_gold:OnRemoved()
	if not IsServer() then return end
	Change_PerkEffectivenessStats(self, false)
end

function glyph_blazing_gold:DeclareFunctions()
	local funcs = {
		
	}

	return funcs
end

function glyph_blazing_gold:OnIntervalThink()
	if not IsServer() then return end

	self:SetStackCount( 10000 * self.perkEffectiveness )

	self.currency_gold = self.currency_gold_orig * ( self:GetStackCount() / 10000 )
end

function glyph_blazing_gold:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE + MODIFIER_ATTRIBUTE_MULTIPLE
end

function glyph_blazing_gold:IsHidden()
    return true
end

function glyph_blazing_gold:IsPurgable()
	return false
end

function glyph_blazing_gold:IsPurgeException()
	return false
end

function glyph_blazing_gold:IsStunDebuff()
	return false
end

function glyph_blazing_gold:IsDebuff()
	return false
end





















































































































































