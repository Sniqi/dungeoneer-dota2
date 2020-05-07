glyph_mystic_rune = class({})

function glyph_mystic_rune:OnCreated( data )
	-- ### VALUES START ### --
	self.arcane_knowledge              = 10
	self.effectiveness_holy            = 3.0
	self.effectiveness_shadow          = 3.0
	self.effectiveness_fire            = -2.0
	self.effectiveness_earth           = -2.0
	self.effectiveness_lightning       = -2.0
	-- ### VALUES END ### --
	
	if not IsServer() then return end
	self.perkname = data.perkName
	self.perkID = data.perkID
	self.level = data.level
	self.perkEffectiveness = data.perkEffectiveness

	Change_PerkEffectivenessStats(self, true)

	self.arcane_knowledgeBuff = self.arcane_knowledge

	self:StartIntervalThink(1.00)
end

function glyph_mystic_rune:OnRemoved()
	if not IsServer() then return end
	Change_PerkEffectivenessStats(self, false)
end

function glyph_mystic_rune:DeclareFunctions()
	local funcs = {

	}

	return funcs
end

function glyph_mystic_rune:OnIntervalThink()
	if not IsServer() then return end

	self:SetStackCount( 10000 * self.perkEffectiveness )

	self.arcane_knowledgeBuff = self.arcane_knowledge * ( self:GetStackCount() / 10000 )
end

function glyph_mystic_rune:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE + MODIFIER_ATTRIBUTE_MULTIPLE
end

function glyph_mystic_rune:IsHidden()
    return true
end

function glyph_mystic_rune:IsPurgable()
	return false
end

function glyph_mystic_rune:IsPurgeException()
	return false
end

function glyph_mystic_rune:IsStunDebuff()
	return false
end

function glyph_mystic_rune:IsDebuff()
	return false
end




















































































































































