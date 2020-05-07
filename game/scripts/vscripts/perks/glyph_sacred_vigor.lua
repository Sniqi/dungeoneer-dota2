glyph_sacred_vigor = class({})

function glyph_sacred_vigor:OnCreated( data )
	-- ### VALUES START ### --
	self.main_attribute                = 12
	self.effectiveness_defensive       = 8
	-- ### VALUES END ### --
	
	if not IsServer() then return end
	self.perkname = data.perkName
	self.perkID = data.perkID
	self.level = data.level
	self.perkEffectiveness = data.perkEffectiveness

	Change_PerkEffectivenessStats(self, true)

	self:StartIntervalThink(0.20)
end

function glyph_sacred_vigor:OnRemoved()
	if not IsServer() then return end
	Change_PerkEffectivenessStats(self, false)
end

function glyph_sacred_vigor:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS
	}

	return funcs
end

function glyph_sacred_vigor:OnIntervalThink()
	if not IsServer() then return end
	local caster = self:GetParent()

	self:SetStackCount( 10000 * self.perkEffectiveness )

	caster:CalculateStatBonus()
end

function glyph_sacred_vigor:GetModifierBonusStats_Strength( params )
	local caster = self:GetParent()
	if caster:GetPrimaryAttribute() == 0 then
		return ( caster:GetBaseStrength() * ( self.main_attribute / 100 ) ) * ( self:GetStackCount() / 10000 )
	else
		return 0
	end
end

function glyph_sacred_vigor:GetModifierBonusStats_Agility( params )
	local caster = self:GetParent()
	if caster:GetPrimaryAttribute() == 1 then
		return ( caster:GetBaseAgility() * ( self.main_attribute / 100 ) ) * ( self:GetStackCount() / 10000 )
	else
		return 0
	end
end

function glyph_sacred_vigor:GetModifierBonusStats_Intellect( params )
	local caster = self:GetParent()
	if caster:GetPrimaryAttribute() == 2 then
		return ( caster:GetBaseIntellect() * ( self.main_attribute / 100 ) ) * ( self:GetStackCount() / 10000 )
	else
		return 0
	end
end

function glyph_sacred_vigor:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE + MODIFIER_ATTRIBUTE_MULTIPLE
end

function glyph_sacred_vigor:IsHidden()
    return true
end

function glyph_sacred_vigor:IsPurgable()
	return false
end

function glyph_sacred_vigor:IsPurgeException()
	return false
end

function glyph_sacred_vigor:IsStunDebuff()
	return false
end

function glyph_sacred_vigor:IsDebuff()
	return false
end




















































































































































