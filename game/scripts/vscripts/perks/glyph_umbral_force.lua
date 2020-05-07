glyph_umbral_force = class({})

function glyph_umbral_force:OnCreated( data )
	-- ### VALUES START ### --
	self.spell_damage                  = 10
	self.effectiveness_arcane          = 4
	self.effectiveness_fire            = -3.0
	self.effectiveness_defensive       = -2.0
	-- ### VALUES END ### --
	
	if not IsServer() then return end
	self.perkname = data.perkName
	self.perkID = data.perkID
	self.level = data.level
	self.perkEffectiveness = data.perkEffectiveness

	Change_PerkEffectivenessStats(self, true)

	self:StartIntervalThink(1.00)
end

function glyph_umbral_force:OnRemoved()
	if not IsServer() then return end
	Change_PerkEffectivenessStats(self, false)
end

function glyph_umbral_force:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE
	}

	return funcs
end

function glyph_umbral_force:OnIntervalThink()
	if not IsServer() then return end

	self:SetStackCount( 10000 * self.perkEffectiveness )
end

function glyph_umbral_force:GetModifierSpellAmplify_Percentage( params )
	return self.spell_damage * ( self:GetStackCount() / 10000 )
end

function glyph_umbral_force:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE + MODIFIER_ATTRIBUTE_MULTIPLE
end

function glyph_umbral_force:IsHidden()
    return true
end

function glyph_umbral_force:IsPurgable()
	return false
end

function glyph_umbral_force:IsPurgeException()
	return false
end

function glyph_umbral_force:IsStunDebuff()
	return false
end

function glyph_umbral_force:IsDebuff()
	return false
end




















































































































































