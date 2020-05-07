glyph_sparking_thunder = class({})

function glyph_sparking_thunder:OnCreated( data )
	-- ### VALUES START ### --
	self.value                         = 20
	self.effectiveness_arcane          = 20
	self.effectiveness_shadow          = 20
	self.effectiveness_offensive       = -4.0
	-- ### VALUES END ### --
	
	if not IsServer() then return end
	self.perkname = data.perkName
	self.perkID = data.perkID
	self.level = data.level
	self.perkEffectiveness = data.perkEffectiveness

	Change_PerkEffectivenessStats(self, true)

	self:StartIntervalThink(1.00)
end

function glyph_sparking_thunder:OnRemoved()
	if not IsServer() then return end
	Change_PerkEffectivenessStats(self, false)
end

function glyph_sparking_thunder:DeclareFunctions()
	local funcs = {

	}

	return funcs
end

function glyph_sparking_thunder:OnIntervalThink()
	if not IsServer() then return end

	self:SetStackCount( 10000 * self.perkEffectiveness )
end

function glyph_sparking_thunder:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE + MODIFIER_ATTRIBUTE_MULTIPLE
end

function glyph_sparking_thunder:IsHidden()
    return true
end

function glyph_sparking_thunder:IsPurgable()
	return false
end

function glyph_sparking_thunder:IsPurgeException()
	return false
end

function glyph_sparking_thunder:IsStunDebuff()
	return false
end

function glyph_sparking_thunder:IsDebuff()
	return false
end




















































































































































