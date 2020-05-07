glyph_blazing_mind = class({})

function glyph_blazing_mind:OnCreated( data )
	-- ### VALUES START ### --
	self.all_attribute                 = 4
	self.effectiveness_defensive       = 8
	self.effectiveness_offensive       = -3
	-- ### VALUES END ### --
	
	if not IsServer() then return end
	self.perkname = data.perkName
	self.perkID = data.perkID
	self.level = data.level
	self.perkEffectiveness = data.perkEffectiveness

	Change_PerkEffectivenessStats(self, true)

	self:StartIntervalThink(0.20)
end

function glyph_blazing_mind:OnRemoved()
	if not IsServer() then return end
	Change_PerkEffectivenessStats(self, false)
end

function glyph_blazing_mind:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS
	}

	return funcs
end

function glyph_blazing_mind:OnIntervalThink()
	if not IsServer() then return end
	local caster = self:GetParent()

	self:SetStackCount( 10000 * self.perkEffectiveness )

	caster:CalculateStatBonus()
end

function glyph_blazing_mind:GetModifierBonusStats_Strength( params )
	local caster = self:GetParent()
	return ( caster:GetBaseStrength() * ( self.all_attribute / 100 ) ) * ( self:GetStackCount() / 10000 )
end

function glyph_blazing_mind:GetModifierBonusStats_Agility( params )
	local caster = self:GetParent()
	return ( caster:GetBaseAgility() * ( self.all_attribute / 100 ) ) * ( self:GetStackCount() / 10000 )
end

function glyph_blazing_mind:GetModifierBonusStats_Intellect( params )
	local caster = self:GetParent()
	return ( caster:GetBaseIntellect() * ( self.all_attribute / 100 ) ) * ( self:GetStackCount() / 10000 )
end

function glyph_blazing_mind:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE + MODIFIER_ATTRIBUTE_MULTIPLE
end

function glyph_blazing_mind:IsHidden()
    return true
end

function glyph_blazing_mind:IsPurgable()
	return false
end

function glyph_blazing_mind:IsPurgeException()
	return false
end

function glyph_blazing_mind:IsStunDebuff()
	return false
end

function glyph_blazing_mind:IsDebuff()
	return false
end





















































































































































