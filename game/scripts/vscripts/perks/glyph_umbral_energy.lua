glyph_umbral_energy = class({})

function glyph_umbral_energy:OnCreated( data )
	-- ### VALUES START ### --
	self.lifesteal                     = 1.5
	self.effectiveness_defensive       = 3
	self.effectiveness_supportive      = 3
	self.effectiveness_earth           = -5.0
	self.effectiveness_holy            = -5.0
	-- ### VALUES END ### --
	
	if not IsServer() then return end
	self.perkname = data.perkName
	self.perkID = data.perkID
	self.level = data.level
	self.perkEffectiveness = data.perkEffectiveness

	Change_PerkEffectivenessStats(self, true)

	self:StartIntervalThink(1.00)
end

function glyph_umbral_energy:OnRemoved()
	if not IsServer() then return end
	Change_PerkEffectivenessStats(self, false)
end

function glyph_umbral_energy:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_TAKEDAMAGE
	}

	return funcs
end

function glyph_umbral_energy:OnIntervalThink()
	if not IsServer() then return end

	self:SetStackCount( 10000 * self.perkEffectiveness )
end

function glyph_umbral_energy:OnTakeDamage( params )
	if not IsServer() then return end
	if self:GetParent() ~= params.attacker then return end

	local caster = self:GetParent()

	local lifesteal = (self.lifesteal/100) * ( self:GetStackCount() / 10000 )

	caster:Heal(params.damage * lifesteal, caster)

	-- params.unit
	-- params.damage_type
	-- params.attacker
	-- params.original_damage
	-- params.damage
	-- params.inflictor
end

function glyph_umbral_energy:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE + MODIFIER_ATTRIBUTE_MULTIPLE
end

function glyph_umbral_energy:IsHidden()
    return true
end

function glyph_umbral_energy:IsPurgable()
	return false
end

function glyph_umbral_energy:IsPurgeException()
	return false
end

function glyph_umbral_energy:IsStunDebuff()
	return false
end

function glyph_umbral_energy:IsDebuff()
	return false
end




















































































































































