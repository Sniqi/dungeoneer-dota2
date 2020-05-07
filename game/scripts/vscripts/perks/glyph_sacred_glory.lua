glyph_sacred_glory = class({})

function glyph_sacred_glory:OnCreated( data )
	-- ### VALUES START ### --
	self.value                         = 20
	self.effectiveness_fire            = 20
	self.effectiveness_arcane          = 20
	self.effectiveness_supportive      = -4.0
	-- ### VALUES END ### --
	
	if not IsServer() then return end
	self.perkname = data.perkName
	self.perkID = data.perkID
	self.level = data.level
	self.perkEffectiveness = data.perkEffectiveness

	Change_PerkEffectivenessStats(self, true)

	self:StartIntervalThink(1.00)
end

function glyph_sacred_glory:OnRemoved()
	if not IsServer() then return end
	Change_PerkEffectivenessStats(self, false)
end

function glyph_sacred_glory:DeclareFunctions()
	local funcs = {
	}

	return funcs
end

function glyph_sacred_glory:OnIntervalThink()
	if not IsServer() then return end

	self:SetStackCount( 10000 * self.perkEffectiveness )
end

function glyph_sacred_glory:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE + MODIFIER_ATTRIBUTE_MULTIPLE
end

function glyph_sacred_glory:IsHidden()
    return true
end

function glyph_sacred_glory:IsPurgable()
	return false
end

function glyph_sacred_glory:IsPurgeException()
	return false
end

function glyph_sacred_glory:IsStunDebuff()
	return false
end

function glyph_sacred_glory:IsDebuff()
	return false
end




















































































































































