glyph_blazing_power = class({})

function glyph_blazing_power:OnCreated( data )
	-- ### VALUES START ### --
	self.attack_damage                 = 10
	self.effectiveness_shadow          = -3.0
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

function glyph_blazing_power:OnRemoved()
	if not IsServer() then return end
	Change_PerkEffectivenessStats(self, false)
end

function glyph_blazing_power:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_BASEDAMAGEOUTGOING_PERCENTAGE
	}

	return funcs
end

function glyph_blazing_power:OnIntervalThink()
	if not IsServer() then return end

	self:SetStackCount( 10000 * self.perkEffectiveness )
end

function glyph_blazing_power:GetModifierBaseDamageOutgoing_Percentage( params )
	return self.attack_damage * ( self:GetStackCount() / 10000 )
end

function glyph_blazing_power:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE + MODIFIER_ATTRIBUTE_MULTIPLE
end

function glyph_blazing_power:IsHidden()
    return true
end

function glyph_blazing_power:IsPurgable()
	return false
end

function glyph_blazing_power:IsPurgeException()
	return false
end

function glyph_blazing_power:IsStunDebuff()
	return false
end

function glyph_blazing_power:IsDebuff()
	return false
end




















































































































































