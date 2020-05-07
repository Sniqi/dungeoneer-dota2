artifact_crunching_ground = class({})

function artifact_crunching_ground:OnCreated( data )
	-- ### VALUES START ### --
	self.radius                        = 400
	self.stun                          = 1.0
	self.all_attributes                = 675
	self.damage_increase               = 20
	self.cooldown                      = 30.0
	-- ### VALUES END ### --
	
	if not IsServer() then return end
	self.perkname = data.perkName
	self.perkID = data.perkID
	self.level = data.level
	self.perkEffectiveness = data.perkEffectiveness

	Change_PerkEffectivenessStats(self, true)

	self:StartIntervalThink(0.1)
end

function artifact_crunching_ground:OnRemoved()
	if not IsServer() then return end
	Change_PerkEffectivenessStats(self, false)
end

function artifact_crunching_ground:DeclareFunctions()
	local funcs = {
	}

	return funcs
end

function artifact_crunching_ground:OnIntervalThink()
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

	local radius = self.radius * ( self:GetStackCount() / 10000 )

	local damage = ( caster:GetStrength() + caster:GetAgility() + caster:GetIntellect() ) * ( self.all_attributes / 100 )
	damage = damage * ( self:GetStackCount() / 10000 )

	local damage_increase = self.damage_increase * ( self:GetStackCount() / 10000 )

	local stun = self.stun * ( self:GetStackCount() / 10000 )

	-- DOTA_UNIT_TARGET_TEAM_FRIENDLY; DOTA_UNIT_TARGET_TEAM_ENEMY; DOTA_UNIT_TARGET_TEAM_BOTH
	local units	= FindUnitsInRadius(team, caster_loc, nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
	
	damage = damage * ( 1 + ( (#units * damage_increase) / 100 ) )
	damage = damage / #units

	for _,victim in pairs(units) do
		-- Apply Damage --
		local damageTable = {
			victim = victim,
			attacker = caster,
			damage = damage,
			damage_type = DAMAGE_TYPE_PHYSICAL,
			damage_flags = DOTA_DAMAGE_FLAG_NONE,
			ability = self,
		}
		ApplyDamage(damageTable)

		-- Modifier --
		local modifier = victim:AddNewModifier(caster, self, "modifier_stunned", {duration = stun})
	end

	-- Sound --
	caster:EmitSound("Hero_Pangolier.TailThump")

	-- Particle --
	local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_brewmaster/brewmaster_cinder_brew_splash_ring.vpcf", PATTACH_ABSORIGIN, caster)
	ParticleManager:SetParticleControl( particle, 1, caster_loc )
	ParticleManager:ReleaseParticleIndex( particle )
	particle = nil

end

function artifact_crunching_ground:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE + MODIFIER_ATTRIBUTE_MULTIPLE
end

function artifact_crunching_ground:IsHidden()
    return true
end

function artifact_crunching_ground:IsPurgable()
	return false
end

function artifact_crunching_ground:IsPurgeException()
	return false
end

function artifact_crunching_ground:IsStunDebuff()
	return false
end

function artifact_crunching_ground:IsDebuff()
	return false
end





















































































































































