glyph_mystic_book = class({})

function glyph_mystic_book:OnCreated( data )
	-- ### VALUES START ### --
	self.cooldown                      = 10
	self.effectiveness_holy            = 5
	self.effectiveness_economic        = -3.0
	-- ### VALUES END ### --
	
	if not IsServer() then return end
	self.perkname = data.perkName
	self.perkID = data.perkID
	self.level = data.level
	self.perkEffectiveness = data.perkEffectiveness

	Change_PerkEffectivenessStats(self, true)

	self:StartIntervalThink(1.00)
end

function glyph_mystic_book:OnRemoved()
	if not IsServer() then return end
	Change_PerkEffectivenessStats(self, false)
end

function glyph_mystic_book:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_COOLDOWN_PERCENTAGE
	}

	return funcs
end

function glyph_mystic_book:OnIntervalThink()
	if not IsServer() then return end

	self:SetStackCount( 10000 * self.perkEffectiveness )
end

function glyph_mystic_book:GetModifierPercentageCooldown( params )
	return self.cooldown * ( self:GetStackCount() / 10000 )
end

function glyph_mystic_book:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE + MODIFIER_ATTRIBUTE_MULTIPLE
end

function glyph_mystic_book:IsHidden()
    return true
end

function glyph_mystic_book:IsPurgable()
	return false
end

function glyph_mystic_book:IsPurgeException()
	return false
end

function glyph_mystic_book:IsStunDebuff()
	return false
end

function glyph_mystic_book:IsDebuff()
	return false
end




















































































































































