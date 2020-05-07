glyph_petrified_particles = class({})

function glyph_petrified_particles:OnCreated( data )
	-- ### VALUES START ### --
	self.currency_glyph                = 10
	self.effectiveness_fire            = 4
	self.effectiveness_offensive       = -5.0
	-- ### VALUES END ### --
	
	if not IsServer() then return end
	self.perkname = data.perkName
	self.perkID = data.perkID
	self.level = data.level
	self.perkEffectiveness = data.perkEffectiveness

	Change_PerkEffectivenessStats(self, true)

	self.currency_glyph_orig = self.currency_glyph

	self:StartIntervalThink(1.00)
end

function glyph_petrified_particles:OnRemoved()
	if not IsServer() then return end
	Change_PerkEffectivenessStats(self, false)
end

function glyph_petrified_particles:DeclareFunctions()
	local funcs = {

	}

	return funcs
end

function glyph_petrified_particles:OnIntervalThink()
	if not IsServer() then return end

	self:SetStackCount( 10000 * self.perkEffectiveness )

	self.currency_glyph = self.currency_glyph_orig * ( self:GetStackCount() / 10000 )
end

function glyph_petrified_particles:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE + MODIFIER_ATTRIBUTE_MULTIPLE
end

function glyph_petrified_particles:IsHidden()
    return true
end

function glyph_petrified_particles:IsPurgable()
	return false
end

function glyph_petrified_particles:IsPurgeException()
	return false
end

function glyph_petrified_particles:IsStunDebuff()
	return false
end

function glyph_petrified_particles:IsDebuff()
	return false
end




















































































































































