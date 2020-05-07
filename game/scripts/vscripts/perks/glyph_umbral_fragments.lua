glyph_umbral_fragments = class({})

function glyph_umbral_fragments:OnCreated( data )
	-- ### VALUES START ### --
	self.currency_artifact             = 10
	self.effectiveness_lightning       = 4
	self.effectiveness_offensive       = -5.0
	-- ### VALUES END ### --
	
	if not IsServer() then return end
	self.perkname = data.perkName
	self.perkID = data.perkID
	self.level = data.level
	self.perkEffectiveness = data.perkEffectiveness

	Change_PerkEffectivenessStats(self, true)

	self.currency_artifact_orig = self.currency_artifact

	self:StartIntervalThink(1.00)
end

function glyph_umbral_fragments:OnRemoved()
	if not IsServer() then return end
	Change_PerkEffectivenessStats(self, false)
end

function glyph_umbral_fragments:DeclareFunctions()
	local funcs = {

	}

	return funcs
end

function glyph_umbral_fragments:OnIntervalThink()
	if not IsServer() then return end

	self:SetStackCount( 10000 * self.perkEffectiveness )

	self.currency_artifact = self.currency_artifact_orig * ( self:GetStackCount() / 10000 )
end

function glyph_umbral_fragments:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE + MODIFIER_ATTRIBUTE_MULTIPLE
end

function glyph_umbral_fragments:IsHidden()
    return true
end

function glyph_umbral_fragments:IsPurgable()
	return false
end

function glyph_umbral_fragments:IsPurgeException()
	return false
end

function glyph_umbral_fragments:IsStunDebuff()
	return false
end

function glyph_umbral_fragments:IsDebuff()
	return false
end




















































































































































