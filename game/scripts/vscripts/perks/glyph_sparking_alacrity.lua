glyph_sparking_alacrity = class({})

function glyph_sparking_alacrity:OnCreated( data )
	-- ### VALUES START ### --
	self.cast_time                     = 20
	self.effectiveness_arcane          = 2
	self.effectiveness_earth           = -2.0
	-- ### VALUES END ### --
	
	if not IsServer() then return end
	self.perkname = data.perkName
	self.perkID = data.perkID
	self.level = data.level
	self.perkEffectiveness = data.perkEffectiveness

	Change_PerkEffectivenessStats(self, true)

	self:StartIntervalThink(1.00)
end

function glyph_sparking_alacrity:OnRemoved()
	if not IsServer() then return end
	Change_PerkEffectivenessStats(self, false)
end

function glyph_sparking_alacrity:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_CASTTIME_PERCENTAGE
	}

	return funcs
end

function glyph_sparking_alacrity:OnIntervalThink()
	if not IsServer() then return end

	self:SetStackCount( 10000 * self.perkEffectiveness )
end

function glyph_sparking_alacrity:GetModifierPercentageCasttime( params )
	return self.cast_time * ( self:GetStackCount() / 10000 )
end

function glyph_sparking_alacrity:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE + MODIFIER_ATTRIBUTE_MULTIPLE
end

function glyph_sparking_alacrity:IsHidden()
    return true
end

function glyph_sparking_alacrity:IsPurgable()
	return false
end

function glyph_sparking_alacrity:IsPurgeException()
	return false
end

function glyph_sparking_alacrity:IsStunDebuff()
	return false
end

function glyph_sparking_alacrity:IsDebuff()
	return false
end




















































































































































