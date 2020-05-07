scroll_collector_reverse_jail_damage_modifier = class({})

function scroll_collector_reverse_jail_damage_modifier:OnCreated( kv )
	self.damage                       = self:GetAbility():GetSpecialValueFor("damage")
	self.damage_interval              = self:GetAbility():GetSpecialValueFor("damage_interval")

	if not IsServer() then return end
	self:StartIntervalThink(self.damage_interval)
end

function scroll_collector_reverse_jail_damage_modifier:OnIntervalThink()
	if not IsServer() then return end

	local victim = self:GetParent()

	-- Sound --
	victim:EmitSound("Hero_TemplarAssassin.Trap.Cast")

	-- Particle --
	local particle = ParticleManager:CreateParticle("particles/econ/items/leshrac/leshrac_tormented_staff/leshrac_split_pulse_tormented.vpcf", PATTACH_ABSORIGIN, victim)
	ParticleManager:SetParticleControl( particle, 0, victim:GetAbsOrigin() )
	ParticleManager:ReleaseParticleIndex( particle )
	particle = nil

	-- Apply Damage --
	EncounterApplyDamage(victim, self:GetAbility():GetCaster(), self:GetAbility(), self.damage*self.damage_interval, DAMAGE_TYPE_MAGICAL, DOTA_DAMAGE_FLAG_NONE)
end

function scroll_collector_reverse_jail_damage_modifier:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_TOOLTIP,
	}

	return funcs
end


function scroll_collector_reverse_jail_damage_modifier:OnTooltip( params )
	return self.damage*self.damage_interval
end


function scroll_collector_reverse_jail_damage_modifier:GetAttributes()
	return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE
end

function scroll_collector_reverse_jail_damage_modifier:IsHidden()
    return false
end

function scroll_collector_reverse_jail_damage_modifier:IsPurgable()
	return false
end

function scroll_collector_reverse_jail_damage_modifier:IsPurgeException()
	return false
end

function scroll_collector_reverse_jail_damage_modifier:IsStunDebuff()
	return false
end

function scroll_collector_reverse_jail_damage_modifier:IsDebuff()
	return true
end