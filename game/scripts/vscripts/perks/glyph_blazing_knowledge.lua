glyph_blazing_knowledge = class({})

function glyph_blazing_knowledge:OnCreated( data )
	-- ### VALUES START ### --
	self.value                         = 15
	self.effectiveness_earth           = 15
	self.effectiveness_shadow          = 15
	self.effectiveness_lightning       = 15
	-- ### VALUES END ### --
	
	if not IsServer() then return end
	self.perkname = data.perkName
	self.perkID = data.perkID
	self.level = data.level
	self.perkEffectiveness = data.perkEffectiveness

	Change_PerkEffectivenessStats(self, true)
end

function glyph_blazing_knowledge:OnRemoved()
	if not IsServer() then return end
	Change_PerkEffectivenessStats(self, false)
end

function glyph_blazing_knowledge:DeclareFunctions()
	local funcs = {

	}

	return funcs
end

function glyph_blazing_knowledge:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE + MODIFIER_ATTRIBUTE_MULTIPLE
end

function glyph_blazing_knowledge:IsHidden()
    return true
end

function glyph_blazing_knowledge:IsPurgable()
	return false
end

function glyph_blazing_knowledge:IsPurgeException()
	return false
end

function glyph_blazing_knowledge:IsStunDebuff()
	return false
end

function glyph_blazing_knowledge:IsDebuff()
	return false
end





















































































































































