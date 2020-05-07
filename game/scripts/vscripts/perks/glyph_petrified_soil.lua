glyph_petrified_soil = class({})

function glyph_petrified_soil:OnCreated( data )
	-- ### VALUES START ### --
	self.health_regen_amp              = 8
	self.effectiveness_lightning       = 5
	self.effectiveness_offensive       = -5.0
	-- ### VALUES END ### --
	
	if not IsServer() then return end
	self.perkname = data.perkName
	self.perkID = data.perkID
	self.level = data.level
	self.perkEffectiveness = data.perkEffectiveness

	Change_PerkEffectivenessStats(self, true)

	self:StartIntervalThink(1.00)
end

function glyph_petrified_soil:OnRemoved()
	if not IsServer() then return end
	Change_PerkEffectivenessStats(self, false)
end

function glyph_petrified_soil:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_HP_REGEN_AMPLIFY_PERCENTAGE
	}

	return funcs
end

function glyph_petrified_soil:OnIntervalThink()
	if not IsServer() then return end

	self:SetStackCount( 10000 * self.perkEffectiveness )
end

function glyph_petrified_soil:GetModifierHPRegenAmplify_Percentage( params )
	return self.health_regen_amp * ( self:GetStackCount() / 10000 )
end

function glyph_petrified_soil:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE + MODIFIER_ATTRIBUTE_MULTIPLE
end

function glyph_petrified_soil:IsHidden()
    return true
end

function glyph_petrified_soil:IsPurgable()
	return false
end

function glyph_petrified_soil:IsPurgeException()
	return false
end

function glyph_petrified_soil:IsStunDebuff()
	return false
end

function glyph_petrified_soil:IsDebuff()
	return false
end




















































































































































