artifact_purifiying_mana_burst = class({})

function artifact_purifiying_mana_burst:OnCreated( data )
	-- ### VALUES START ### --
	self.mana_taken                    = 25
	self.mana_taken_tooltip            = 25
	self.mana_multiplier               = 400
	self.mana_multiplier_tooltip       = 400
	self.most_injured_portion          = 35
	self.cooldown                      = 20.0
	-- ### VALUES END ### --
	
	if not IsServer() then return end
	self.perkname = data.perkName
	self.perkID = data.perkID
	self.level = data.level
	self.perkEffectiveness = data.perkEffectiveness

	Change_PerkEffectivenessStats(self, true)

	self.last_target = nil

	self:StartIntervalThink(0.1)
end

function artifact_purifiying_mana_burst:OnRemoved()
	if not IsServer() then return end
	Change_PerkEffectivenessStats(self, false)
end

function artifact_purifiying_mana_burst:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_ATTACK_RECORD
	}

	return funcs
end

function artifact_purifiying_mana_burst:OnAttackRecord( params )
	if not IsServer() then return end
	if self:GetParent() ~= params.attacker then return end
	if self:GetParent() == params.target then return end
	if self:GetParent():GetTeamNumber() == params.target:GetTeamNumber() then return end

	self.last_target = params.target
end

function artifact_purifiying_mana_burst:OnIntervalThink()
	if not IsServer() then return end

	self:SetStackCount( 10000 * self.perkEffectiveness )

	local caster = self:GetParent()
	local caster_loc = caster:GetAbsOrigin()
	local team = caster:GetTeamNumber()
	local victim = self.last_target

	--Cast Range UI
	--local castRangeUI = self.radius * ( self:GetStackCount() / 10000 )
	--caster:SetModifierStackCount("castrange_modifier_ability", caster, castRangeUI)
	--Cooldown UI
	local cooldownUI = self.cooldown * ( self:GetStackCount() / 10000 )
	caster:SetModifierStackCount("cooldown_modifier_ability", caster, cooldownUI)

	if not self.activated then return end
	self.activated = false

	if victim == nil then victim = GetCurrentEncounterEntity() end
	if victim:IsNull() then victim = GetCurrentEncounterEntity() end

	local damage = 0

	local mana_spent = caster:GetMaxMana() * ( self.mana_taken / 100 )
	if mana_spent > caster:GetMana() then
		mana_spent = caster:GetMana()
	end

	caster:SpendMana(mana_spent, self)

	local heal = mana_spent * ( ( self.mana_multiplier / 100 ) * ( self:GetStackCount() / 10000 ) )

	-- DOTA_UNIT_TARGET_TEAM_FRIENDLY; DOTA_UNIT_TARGET_TEAM_ENEMY; DOTA_UNIT_TARGET_TEAM_BOTH
	local units	= FindUnitsInRadius(team, caster:GetAbsOrigin(), nil, 99999, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)

	local most_injured_unit = units[1]
	local most_injured_unit_id = 1
	for _,unit in pairs(units) do

		if most_injured_unit:GetHealthPercent() > unit:GetHealthPercent() then
			most_injured_unit = unit
			most_injured_unit_id = _
		end

	end

	table.remove(units, most_injured_unit_id)

	local injured_heal = heal * ( self.most_injured_portion / 100 )
	local overheal = math.abs( injured_heal - ( most_injured_unit:GetMaxHealth() - most_injured_unit:GetHealth() ) )
	damage = damage + overheal

	-- Heal --
	most_injured_unit:Heal(heal, self)

	if #units > 0 then

		local heal_divided = ( heal * ( 1 - ( self.most_injured_portion / 100 ) ) ) / #units

		for _,unit in pairs(units) do

			local injured_heal = heal_divided * ( self.most_injured_portion / 100 )
			local overheal = math.abs( injured_heal - ( unit:GetMaxHealth() - unit:GetHealth() ) )
			damage = damage + overheal

			-- Heal --
			unit:Heal(heal, self)
		end

	else
		local injured_heal = ( heal * ( 1 - ( self.most_injured_portion / 100 ) ) )
		local overheal = math.abs( injured_heal - ( most_injured_unit:GetMaxHealth() - most_injured_unit:GetHealth() ) )
		damage = damage + overheal

		-- Heal --
		most_injured_unit:Heal(heal, self)
	end

	-- Damage --
	local damageTable = {
		victim = victim,
		attacker = caster,
		damage = damage,
		damage_type = DAMAGE_TYPE_MAGICAL,
		damage_flags = DOTA_DAMAGE_FLAG_NONE,
		ability = self,
	}
	ApplyDamage(damageTable)

	-- Sound --
	caster:EmitSound("Hero_TemplarAssassin.Trap.Trigger")

	-- Particle --
	local particle = ParticleManager:CreateParticle("particles/econ/items/lanaya/lanaya_epit_trap/templar_assassin_epit_trap_start_ring.vpcf", PATTACH_ABSORIGIN, caster)
	ParticleManager:SetParticleControl( particle, 0, caster:GetAbsOrigin() )
	ParticleManager:ReleaseParticleIndex( particle )
	particle = nil

	-- Particle --
	local particle = ParticleManager:CreateParticle("particles/econ/items/lanaya/lanaya_epit_trap/templar_assassin_epit_trap_ring_inner_start.vpcf", PATTACH_ABSORIGIN, victim)
	ParticleManager:SetParticleControl( particle, 0, victim:GetAbsOrigin() )
	ParticleManager:ReleaseParticleIndex( particle )
	particle = nil

end

function artifact_purifiying_mana_burst:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE + MODIFIER_ATTRIBUTE_MULTIPLE
end

function artifact_purifiying_mana_burst:IsHidden()
    return true
end

function artifact_purifiying_mana_burst:IsPurgable()
	return false
end

function artifact_purifiying_mana_burst:IsPurgeException()
	return false
end

function artifact_purifiying_mana_burst:IsStunDebuff()
	return false
end

function artifact_purifiying_mana_burst:IsDebuff()
	return false
end




















































































































































