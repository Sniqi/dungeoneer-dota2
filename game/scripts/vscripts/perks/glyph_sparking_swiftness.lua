glyph_sparking_swiftness = class({})

function glyph_sparking_swiftness:OnCreated( data )
	-- ### VALUES START ### --
	self.move_speed                    = 5
	self.effectiveness_earth           = -3.0
	-- ### VALUES END ### --
	
	if not IsServer() then return end
	self.perkname = data.perkName
	self.perkID = data.perkID
	self.level = data.level
	self.perkEffectiveness = data.perkEffectiveness

	Change_PerkEffectivenessStats(self, true)

	self:StartIntervalThink(1.00)
end

function glyph_sparking_swiftness:OnRemoved()
	if not IsServer() then return end
	Change_PerkEffectivenessStats(self, false)
end

function glyph_sparking_swiftness:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
	}

	return funcs
end

function glyph_sparking_swiftness:OnIntervalThink()
	if not IsServer() then return end

	self:SetStackCount( 10000 * self.perkEffectiveness )
end

function glyph_sparking_swiftness:GetModifierMoveSpeedBonus_Percentage( params )
	return self.move_speed * ( self:GetStackCount() / 10000 )
end

function glyph_sparking_swiftness:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE + MODIFIER_ATTRIBUTE_MULTIPLE
end

function glyph_sparking_swiftness:IsHidden()
    return true
end

function glyph_sparking_swiftness:IsPurgable()
	return false
end

function glyph_sparking_swiftness:IsPurgeException()
	return false
end

function glyph_sparking_swiftness:IsStunDebuff()
	return false
end

function glyph_sparking_swiftness:IsDebuff()
	return false
end




















































































































































