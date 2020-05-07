greater_interval_absorbing_shield = class({})

function greater_interval_absorbing_shield:OnCreated( data )
	-- ### VALUES START ### --
	self.shield                        = 35
	self.interval                      = 5
	-- ### VALUES END ### --
	
	if not IsServer() then return end
	self.perkname = data.perkName
	self.perkID = data.perkID
	self.level = data.level
	self.perkEffectiveness = data.perkEffectiveness

	self:StartIntervalThink(1.0)
	self:SetStackCount(self.interval)
	self.shield_hp = 0
end

function greater_interval_absorbing_shield:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_TOOLTIP
	}

	return funcs
end

function greater_interval_absorbing_shield:OnIntervalThink()
	if not IsServer() then return end

	if self:GetStackCount() == 0 then

		self:SetStackCount(self.interval)

		local caster = self:GetParent()

		local abilities = {}

		if not caster:IsAlive() then return end

		self.shield_hp = caster:GetMaxHealth() * ( self.shield / 100 )

		-- Particle --
		if caster.greater_interval_absorbing_shield_particle ~= nil then
			ParticleManager:DestroyParticle( caster.greater_interval_absorbing_shield_particle, false )
			ParticleManager:ReleaseParticleIndex( caster.greater_interval_absorbing_shield_particle )
			caster.greater_interval_absorbing_shield_particle = nil
		end
		caster.greater_interval_absorbing_shield_particle = ParticleManager:CreateParticle("particles/perks/greater_interval_absorbing_shield.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster)
		ParticleManager:SetParticleControl( caster.greater_interval_absorbing_shield_particle, 0, caster:GetAbsOrigin() )
		ParticleManager:SetParticleControl( caster.greater_interval_absorbing_shield_particle, 1, caster:GetAbsOrigin() )

		PerkAppearance_Active(self:GetParent():GetPlayerOwnerID(), self.perkname, self.perkID, "#ffcb21", "!")

	else
		self:DecrementStackCount()

		PerkAppearance_Inactive(self:GetParent():GetPlayerOwnerID(), self.perkname, self.perkID, self:GetStackCount())
	end
end

function greater_interval_absorbing_shield:OnTooltip()
	return self.duration
end

function greater_interval_absorbing_shield:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE + MODIFIER_ATTRIBUTE_MULTIPLE
end

function greater_interval_absorbing_shield:IsHidden()
    return true
end

function greater_interval_absorbing_shield:IsPurgable()
	return false
end

function greater_interval_absorbing_shield:IsPurgeException()
	return false
end

function greater_interval_absorbing_shield:IsStunDebuff()
	return false
end

function greater_interval_absorbing_shield:IsDebuff()
	return false
end

function greater_interval_absorbing_shield:GetTexture()
	return "greater_interval_absorbing_shield"
end
























































































































































































































































































