artifact_crackling_lightning = class({})

function artifact_crackling_lightning:OnCreated( data )
	-- ### VALUES START ### --
	self.all_attributes                = 340
	self.radius                        = 800
	self.damage_reduction              = 50
	self.max_jumps                     = 4
	self.single_target_damage_increase = 40
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

function artifact_crackling_lightning:OnRemoved()
	if not IsServer() then return end
	Change_PerkEffectivenessStats(self, false)
end

function artifact_crackling_lightning:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_ATTACK_RECORD
	}

	return funcs
end

function artifact_crackling_lightning:OnAttackRecord( params )
	if not IsServer() then return end
	if self:GetParent() ~= params.attacker then return end
	if self:GetParent() == params.target then return end
	if self:GetParent():GetTeamNumber() == params.target:GetTeamNumber() then return end

	self.last_target = params.target
end

function artifact_crackling_lightning:OnIntervalThink()
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

	if GetCurrentEncounterEntity() == nil then return end
	if victim == nil then victim = GetCurrentEncounterEntity() end
	if victim:IsNull() then victim = GetCurrentEncounterEntity() end
	if not victim:IsAlive() then victim = GetCurrentEncounterEntity() end

	local damage = ( caster:GetStrength() + caster:GetAgility() + caster:GetIntellect() ) * ( self.all_attributes / 100 )
	damage = damage * ( self:GetStackCount() / 10000 )

	local radius = self.radius

	local damage_reduction = self.damage_reduction
	damage_reduction = damage_reduction / ( self:GetStackCount() / 10000 )

	local max_jumps = self.max_jumps

	local single_target_damage_increase = self.single_target_damage_increase

	-- DOTA_UNIT_TARGET_TEAM_FRIENDLY; DOTA_UNIT_TARGET_TEAM_ENEMY; DOTA_UNIT_TARGET_TEAM_BOTH
	local units	= FindUnitsInRadius(team, victim:GetAbsOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_CLOSEST, false)

	if #units == 1 then
		damage = damage * ( 1 + (single_target_damage_increase / 100) )
	end

	-- Apply Damage --
	local damageTable = {
		victim = victim,
		attacker = caster,
		damage = damage,
		damage_type = DAMAGE_TYPE_MAGICAL,
		damage_flags = DOTA_DAMAGE_FLAG_NONE,
		ability = self,
	}
	ApplyDamage(damageTable)

	-- Particle --
	local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_zuus/zuus_arc_lightning.vpcf", PATTACH_POINT_FOLLOW, caster)
	ParticleManager:SetParticleControlEnt( particle, 0, caster, PATTACH_POINT_FOLLOW, "attach_hitloc", caster:GetAttachmentOrigin(caster:ScriptLookupAttachment("attach_attack1")), true)
	ParticleManager:SetParticleControlEnt( particle, 1, victim, PATTACH_POINT_FOLLOW, "attach_hitloc", victim:GetAttachmentOrigin(victim:ScriptLookupAttachment("attach_hitloc")), true)

	Timers:CreateTimer(1.0, function()
		ParticleManager:DestroyParticle( particle, false )
		ParticleManager:ReleaseParticleIndex( particle )
		particle = nil
	end)

	local victims_hit = {}
	local old_victims = nil
	local particle = {}

	if #units > 1 then

		for i=1,max_jumps do

			-- DOTA_UNIT_TARGET_TEAM_FRIENDLY; DOTA_UNIT_TARGET_TEAM_ENEMY; DOTA_UNIT_TARGET_TEAM_BOTH
			local units	= FindUnitsInRadius(team, victim:GetAbsOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_CLOSEST, false)

			if #victims_hit > 0 then
				for i,unit in pairs(units) do
					for j,victim in pairs(victims_hit) do
						if unit == victim then
							table.remove(units, i)
						end
					end
				end
			end

			if #units > 1 then

				old_victim = victim
				table.insert(victims_hit, old_victim)
				victim = units[2]

				damage = damage * ( 1 - (damage_reduction / 100) )

				-- Apply Damage --
				local damageTable = {
					victim = victim,
					attacker = caster,
					damage = damage,
					damage_type = DAMAGE_TYPE_MAGICAL,
					damage_flags = DOTA_DAMAGE_FLAG_NONE,
					ability = self,
				}
				ApplyDamage(damageTable)

				-- Particle --
				particle[i] = ParticleManager:CreateParticle("particles/units/heroes/hero_zuus/zuus_arc_lightning.vpcf", PATTACH_POINT_FOLLOW, old_victim)
				ParticleManager:SetParticleControlEnt( particle[i], 0, old_victim, PATTACH_POINT_FOLLOW, "attach_hitloc", old_victim:GetAttachmentOrigin(old_victim:ScriptLookupAttachment("attach_hitloc")), true)
				ParticleManager:SetParticleControlEnt( particle[i], 1, victim, PATTACH_POINT_FOLLOW, "attach_hitloc", victim:GetAttachmentOrigin(victim:ScriptLookupAttachment("attach_hitloc")), true)

				Timers:CreateTimer(1.0, function()
					ParticleManager:DestroyParticle( particle[i], false )
					ParticleManager:ReleaseParticleIndex( particle[i] )
					particle[i] = nil
				end)

			else
				break
			end

		end

	end

	-- Sound --
	caster:EmitSound("Hero_Zuus.ArcLightning.Cast")

end

function artifact_crackling_lightning:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE + MODIFIER_ATTRIBUTE_MULTIPLE
end

function artifact_crackling_lightning:IsHidden()
    return true
end

function artifact_crackling_lightning:IsPurgable()
	return false
end

function artifact_crackling_lightning:IsPurgeException()
	return false
end

function artifact_crackling_lightning:IsStunDebuff()
	return false
end

function artifact_crackling_lightning:IsDebuff()
	return false
end






















































































































