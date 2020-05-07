glyph_sacred_bracing = class({})

function glyph_sacred_bracing:OnCreated( data )
	-- ### VALUES START ### --
	self.interval                      = 8
	self.shield                        = 5
	self.effectiveness_offensive       = 2
	self.effectiveness_shadow          = -2.0
	-- ### VALUES END ### --
	
	if not IsServer() then return end
	self.perkname = data.perkName
	self.perkID = data.perkID
	self.level = data.level
	self.perkEffectiveness = data.perkEffectiveness

	Change_PerkEffectivenessStats(self, true)

	self.shield_interval = 0
	self.shield_hp = 0

	self:StartIntervalThink(0.1)
end

function glyph_sacred_bracing:OnRemoved()
	if not IsServer() then return end
	Change_PerkEffectivenessStats(self, false)
end

function glyph_sacred_bracing:DeclareFunctions()
	local funcs = {

	}

	return funcs
end

function glyph_sacred_bracing:OnIntervalThink()
	if not IsServer() then return end

	self:SetStackCount( 10000 * self.perkEffectiveness )

	local caster = self:GetParent()

	if not caster:IsAlive() then return end

	if self.shield_interval <= 0 then

		self.shield_interval = self.interval / ( self:GetStackCount() / 10000 )

		self.shield_hp = ( caster:GetMaxHealth() * ( self.shield / 100 ) ) * ( self:GetStackCount() / 10000 )

		-- Particle --
		if caster.shield_particle ~= nil then
			ParticleManager:DestroyParticle( caster.shield_particle, false )
			ParticleManager:ReleaseParticleIndex( caster.shield_particle )
			caster.shield_particle = nil
		end
		caster.shield_particle = ParticleManager:CreateParticle("particles/perks/greater_interval_absorbing_shield.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster)
		ParticleManager:SetParticleControl( caster.shield_particle, 0, caster:GetAbsOrigin() )
		ParticleManager:SetParticleControl( caster.shield_particle, 1, caster:GetAbsOrigin() )
	else
		self.shield_interval = self.shield_interval - 0.1
	end

end

function glyph_sacred_bracing:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE + MODIFIER_ATTRIBUTE_MULTIPLE
end

function glyph_sacred_bracing:IsHidden()
    return true
end

function glyph_sacred_bracing:IsPurgable()
	return false
end

function glyph_sacred_bracing:IsPurgeException()
	return false
end

function glyph_sacred_bracing:IsStunDebuff()
	return false
end

function glyph_sacred_bracing:IsDebuff()
	return false
end




















































































































































