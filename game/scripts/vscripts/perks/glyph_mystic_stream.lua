glyph_mystic_stream = class({})

function glyph_mystic_stream:OnCreated( data )
	-- ### VALUES START ### --
	self.mana_regen_amp                = 15
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

function glyph_mystic_stream:OnRemoved()
	if not IsServer() then return end
	Change_PerkEffectivenessStats(self, false)
end

function glyph_mystic_stream:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MP_REGEN_AMPLIFY_PERCENTAGE
	}

	return funcs
end

function glyph_mystic_stream:OnIntervalThink()
	if not IsServer() then return end

	self:SetStackCount( 10000 * self.perkEffectiveness )
end

function glyph_mystic_stream:GetModifierMPRegenAmplify_Percentage( params )
	return self.mana_regen_amp * ( self:GetStackCount() / 10000 )
end

function glyph_mystic_stream:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE + MODIFIER_ATTRIBUTE_MULTIPLE
end

function glyph_mystic_stream:IsHidden()
    return true
end

function glyph_mystic_stream:IsPurgable()
	return false
end

function glyph_mystic_stream:IsPurgeException()
	return false
end

function glyph_mystic_stream:IsStunDebuff()
	return false
end

function glyph_mystic_stream:IsDebuff()
	return false
end




















































































































































