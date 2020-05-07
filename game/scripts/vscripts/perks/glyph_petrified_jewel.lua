glyph_petrified_jewel = class({})

function glyph_petrified_jewel:OnCreated( data )
	-- ### VALUES START ### --
	self.resilience                    = 5
	self.effectiveness_supportive      = 3
	self.effectiveness_shadow          = -3.0
	-- ### VALUES END ### --
	
	if not IsServer() then return end
	self.perkname = data.perkName
	self.perkID = data.perkID
	self.level = data.level
	self.perkEffectiveness = data.perkEffectiveness

	Change_PerkEffectivenessStats(self, true)

	self.resilienceBuff = self.resilience

	self:StartIntervalThink(1.00)
end

function glyph_petrified_jewel:OnRemoved()
	if not IsServer() then return end
	Change_PerkEffectivenessStats(self, false)
end

function glyph_petrified_jewel:DeclareFunctions()
	local funcs = {

	}

	return funcs
end

function glyph_petrified_jewel:OnIntervalThink()
	if not IsServer() then return end

	self:SetStackCount( 10000 * self.perkEffectiveness )

	self.resilienceBuff = self.resilience * ( self:GetStackCount() / 10000 )
end

function glyph_petrified_jewel:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE + MODIFIER_ATTRIBUTE_MULTIPLE
end

function glyph_petrified_jewel:IsHidden()
    return true
end

function glyph_petrified_jewel:IsPurgable()
	return false
end

function glyph_petrified_jewel:IsPurgeException()
	return false
end

function glyph_petrified_jewel:IsStunDebuff()
	return false
end

function glyph_petrified_jewel:IsDebuff()
	return false
end




















































































































































