demonic_warrior_rest_modifier = class({})

function demonic_warrior_rest_modifier:OnCreated( kv )
	self.duration                     = self:GetAbility():GetSpecialValueFor("duration")

	if not IsServer() then return end

	local caster = self:GetParent()

	-- Particle --
	self.particle = ParticleManager:CreateParticle("particles/generic_gameplay/generic_sleep.vpcf", PATTACH_OVERHEAD_FOLLOW, caster)
	ParticleManager:SetParticleControl( self.particle, 0, caster:GetAbsOrigin() )
end

function demonic_warrior_rest_modifier:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_TOOLTIP
	}

	return funcs
end

function demonic_warrior_rest_modifier:CheckState()
	local state = {
	[MODIFIER_STATE_SILENCED] = true,
	[MODIFIER_STATE_DISARMED] = true,
	[MODIFIER_STATE_ROOTED] = true,
	[MODIFIER_STATE_COMMAND_RESTRICTED] = true
	}
 
	return state
end

function demonic_warrior_rest_modifier:OnDestroy( kv )
	if not IsServer() then return end

	local caster = self:GetParent()

	caster:RemoveGesture(ACT_DOTA_DISABLED)

	ParticleManager:DestroyParticle( self.particle, false )
	ParticleManager:ReleaseParticleIndex( self.particle )
	self.particle = nil
end

function demonic_warrior_rest_modifier:OnTooltip( params )
	return self.duration
end

function demonic_warrior_rest_modifier:GetAttributes()
	return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE
end

function demonic_warrior_rest_modifier:IsHidden()
    return false
end

function demonic_warrior_rest_modifier:IsPurgable()
	return false
end

function demonic_warrior_rest_modifier:IsPurgeException()
	return false
end

function demonic_warrior_rest_modifier:IsStunDebuff()
	return false
end

function demonic_warrior_rest_modifier:IsDebuff()
	return true
end