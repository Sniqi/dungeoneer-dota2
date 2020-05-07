artifact_holy_gush = class({})

function artifact_holy_gush:OnCreated( data )
	-- ### VALUES START ### --
	self.health_to_heal                = 30
	self.health_to_heal_tooltip        = 30
	self.overheal_to_heal              = 30
	self.overheal_to_heal_tooltip      = 30
	self.overheal_to_damage            = 60
	self.overheal_to_damage_tooltip    = 60
	self.radius                        = 1200.0
	self.cooldown                      = 20.0
	-- ### VALUES END ### --
	
	if not IsServer() then return end
	self.perkname = data.perkName
	self.perkID = data.perkID
	self.level = data.level
	self.perkEffectiveness = data.perkEffectiveness

	Change_PerkEffectivenessStats(self, true)

	self:StartIntervalThink(0.1)
end

function artifact_holy_gush:OnRemoved()
	if not IsServer() then return end
	Change_PerkEffectivenessStats(self, false)
end

function artifact_holy_gush:DeclareFunctions()
	local funcs = {
	}

	return funcs
end

function artifact_holy_gush:OnIntervalThink()
	if not IsServer() then return end

	self:SetStackCount( 10000 * self.perkEffectiveness )

	local caster = self:GetParent()
	local caster_loc = caster:GetAbsOrigin()
	local team = caster:GetTeamNumber()

	--Cast Range UI
	local castRangeUI = self.radius * ( self:GetStackCount() / 10000 )
	caster:SetModifierStackCount("castrange_modifier_ability", caster, castRangeUI)
	--Cooldown UI
	local cooldownUI = self.cooldown * ( self:GetStackCount() / 10000 )
	caster:SetModifierStackCount("cooldown_modifier_ability", caster, cooldownUI)

	if not self.activated then return end
	self.activated = false

	local heal = caster:GetMaxHealth() * ( ( self.health_to_heal / 100 ) * ( self:GetStackCount() / 10000 ) )
	local overheal = math.abs( heal - ( caster:GetMaxHealth() - caster:GetHealth() ) )

	local heal_friends = overheal * ( ( self.overheal_to_heal / 100 ) * ( self:GetStackCount() / 10000 ) )
	local damage_enemies = overheal * ( ( self.overheal_to_damage / 100 ) * ( self:GetStackCount() / 10000 ) )

	caster:Heal(heal, self)

	local radius = self.radius * ( self:GetStackCount() / 10000 )

	-- DOTA_UNIT_TARGET_TEAM_FRIENDLY; DOTA_UNIT_TARGET_TEAM_ENEMY; DOTA_UNIT_TARGET_TEAM_BOTH
	local units	= FindUnitsInRadius(team, caster:GetAbsOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
	for _,unit in pairs(units) do
		-- Heal --
		unit:Heal(heal_friends, self)

		-- Particle --
		local particle = ParticleManager:CreateParticle("particles/econ/items/monkey_king/arcana/fire/mk_arcana_fire_spring_channel_rings.vpcf", PATTACH_ABSORIGIN, caster)
		ParticleManager:SetParticleControl( particle, 0, caster:GetAbsOrigin() )
		ParticleManager:ReleaseParticleIndex( particle )
		particle = nil
	end

	-- DOTA_UNIT_TARGET_TEAM_FRIENDLY; DOTA_UNIT_TARGET_TEAM_ENEMY; DOTA_UNIT_TARGET_TEAM_BOTH
	local units	= FindUnitsInRadius(team, caster:GetAbsOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
	for _,unit in pairs(units) do
		-- Damage --
		local damageTable = {
			victim = unit,
			attacker = caster,
			damage = damage_enemies,
			damage_type = DAMAGE_TYPE_MAGICAL,
			damage_flags = DOTA_DAMAGE_FLAG_NONE,
			ability = self,
		}
		ApplyDamage(damageTable)

		-- Particle --
		local particle = ParticleManager:CreateParticle("particles/econ/items/monkey_king/arcana/fire/mk_arcana_fire_spring_channel_rings.vpcf", PATTACH_ABSORIGIN, caster)
		ParticleManager:SetParticleControl( particle, 0, caster:GetAbsOrigin() )
		ParticleManager:ReleaseParticleIndex( particle )
		particle = nil
	end

	-- Sound --
	caster:EmitSound("Hero_Omniknight.Purification.Wingfall")

	-- Particle --
	local particle = ParticleManager:CreateParticle("particles/econ/items/monkey_king/arcana/fire/mk_arcana_fire_spring_ring_radial.vpcf", PATTACH_ABSORIGIN, caster)
	ParticleManager:SetParticleControl( particle, 0, caster:GetAbsOrigin() )
	ParticleManager:ReleaseParticleIndex( particle )
	particle = nil

end

function artifact_holy_gush:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE + MODIFIER_ATTRIBUTE_MULTIPLE
end

function artifact_holy_gush:IsHidden()
    return true
end

function artifact_holy_gush:IsPurgable()
	return false
end

function artifact_holy_gush:IsPurgeException()
	return false
end

function artifact_holy_gush:IsStunDebuff()
	return false
end

function artifact_holy_gush:IsDebuff()
	return false
end





















































































































































