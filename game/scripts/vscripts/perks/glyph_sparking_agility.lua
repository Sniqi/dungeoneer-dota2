glyph_sparking_agility = class({})

function glyph_sparking_agility:OnCreated( data )
	-- ### VALUES START ### --
	self.attack_speed                  = 25
	self.effectiveness_shadow          = 3.0
	self.effectiveness_holy            = -4.0
	-- ### VALUES END ### --
	
	if not IsServer() then return end
	self.perkname = data.perkName
	self.perkID = data.perkID
	self.level = data.level
	self.perkEffectiveness = data.perkEffectiveness

	Change_PerkEffectivenessStats(self, true)

	self:StartIntervalThink(1.00)
end

function glyph_sparking_agility:OnRemoved()
	if not IsServer() then return end
	Change_PerkEffectivenessStats(self, false)
end

function glyph_sparking_agility:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT
	}

	return funcs
end

function glyph_sparking_agility:OnIntervalThink()
	if not IsServer() then return end

	self:SetStackCount( 10000 * self.perkEffectiveness )
end

function glyph_sparking_agility:GetModifierAttackSpeedBonus_Constant( params )
	return self.attack_speed * ( self:GetStackCount() / 10000 )
end

function glyph_sparking_agility:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE + MODIFIER_ATTRIBUTE_MULTIPLE
end

function glyph_sparking_agility:IsHidden()
    return true
end

function glyph_sparking_agility:IsPurgable()
	return false
end

function glyph_sparking_agility:IsPurgeException()
	return false
end

function glyph_sparking_agility:IsStunDebuff()
	return false
end

function glyph_sparking_agility:IsDebuff()
	return false
end




















































































































































