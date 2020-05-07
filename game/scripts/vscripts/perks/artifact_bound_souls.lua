artifact_bound_souls = class({})

function artifact_bound_souls:OnCreated( data )
	-- ### VALUES START ### --
	self.slow                          = 20
	self.all_attributes                = 50
	self.tick_interval                 = 1.0
	self.damage_increase               = 30
	self.all_attributes_total          = 525
	self.tick_count                    = 6
	self.duration                      = 5.0
	self.break_range                   = 400
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

function artifact_bound_souls:OnRemoved()
	if not IsServer() then return end
	Change_PerkEffectivenessStats(self, false)
end

function artifact_bound_souls:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_ATTACK_RECORD
	}

	return funcs
end

function artifact_bound_souls:OnAttackRecord( params )
	if not IsServer() then return end
	if self:GetParent() ~= params.attacker then return end
	if self:GetParent() == params.target then return end
	if self:GetParent():GetTeamNumber() == params.target:GetTeamNumber() then return end

	self.last_target = params.target
end

function artifact_bound_souls:OnIntervalThink()
	if not IsServer() then return end

	self:SetStackCount( 10000 * self.perkEffectiveness )

	local caster = self:GetParent()
	local caster_loc = caster:GetAbsOrigin()
	local team = caster:GetTeamNumber()
	local victim = self.last_target

	--Cast Range UI
	local castRangeUI = self.break_range * ( self:GetStackCount() / 10000 )
	caster:SetModifierStackCount("castrange_modifier_ability", caster, castRangeUI)
	--Cooldown UI
	local cooldownUI = self.cooldown * ( self:GetStackCount() / 10000 )
	caster:SetModifierStackCount("cooldown_modifier_ability", caster, cooldownUI)

	if not self.activated then return end
	self.activated = false

	if GetCurrentEncounterEntity() == nil then return end
	if victim == nil then victim = GetCurrentEncounterEntity() end
	if victim:IsNull() then victim = GetCurrentEncounterEntity() end
	if not victim:IsAlive() then victim = GetCurrentEncounterEntity() end

	local slow = self.slow

	local damage = ( caster:GetStrength() + caster:GetAgility() + caster:GetIntellect() ) * ( self.all_attributes / 100 )
	damage = damage * ( self:GetStackCount() / 10000 )
	local base_damage = damage

	local tick_interval = self.tick_interval / ( self:GetStackCount() / 10000 )

	local damage_increase = self.damage_increase * ( self:GetStackCount() / 10000 )

	local tick_count = self.tick_count

	local duration = self.duration / ( self:GetStackCount() / 10000 )

	local break_range = self.break_range * ( self:GetStackCount() / 10000 )



	if (victim:GetAbsOrigin() - caster:GetAbsOrigin()):Length2D() > break_range then
		caster:FindAbilityByName("artifact_ability"):EndCooldown()
		Notifications:Bottom(caster:GetPlayerOwnerID(), {text="Target not in range.", duration=1.5, style={color="rgb(200, 32, 32)", ["font-size"]="24px", ["text-shadow"]="1px 1px 4px 5.0 #333333b0"}, continue=false})
	end

	-- Sound --
	caster:EmitSound("Hero_EarthSpirit.GeomagneticGrip.Cast")

	-- Particle --
	local particle = ParticleManager:CreateParticle("particles/perks/artifact_bound_souls_beam_1.vpcf", PATTACH_POINT_FOLLOW, caster)
	ParticleManager:SetParticleControlEnt( particle, 0, victim, PATTACH_POINT_FOLLOW, "attach_hitloc", victim:GetAttachmentOrigin(victim:ScriptLookupAttachment("attach_hitloc")), true)
	ParticleManager:SetParticleControlEnt( particle, 1, caster, PATTACH_POINT_FOLLOW, "attach_hitloc", caster:GetAttachmentOrigin(caster:ScriptLookupAttachment("attach_attack1")), true)
	ParticleManager:SetParticleControl( particle, 10, Vector(1,0,0) )
	ParticleManager:SetParticleControl( particle, 11, Vector(1,0,0) )

	local link_broken = false

	local timer1 = Timers:CreateTimer(0, function()

		if caster:GetRangeToUnit(victim) >= break_range or not caster:IsAlive() then
			link_broken = true

			-- Sound --
			caster:EmitSound("Hero_EarthSpirit.GeomagneticGrip.Target")

			if particle ~= nil then
				ParticleManager:DestroyParticle( particle, false )
				ParticleManager:ReleaseParticleIndex( particle )
				particle = nil
			end

			return
		end

		return 0.1
	end)
	Timers:CreateTimer(duration*1.1, function()
		Timers:RemoveTimer(timer1)
		timer1 = nil

		if particle ~= nil then
			ParticleManager:DestroyParticle( particle, false )
			ParticleManager:ReleaseParticleIndex( particle )
			particle = nil
		end
	end)


	for i=0,tick_count-1 do

		Timers:CreateTimer(i*tick_interval, function()

			if link_broken then return end

			damage = base_damage * ( 1 + ( (damage_increase * i) / 100 ) )

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

			-- Modifier --
			local modifier = victim:AddNewModifier(caster, self, "modifier_slowed", {duration = tick_interval, slow = slow})		

		end)

	end

end

function artifact_bound_souls:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE + MODIFIER_ATTRIBUTE_MULTIPLE
end

function artifact_bound_souls:IsHidden()
    return true
end

function artifact_bound_souls:IsPurgable()
	return false
end

function artifact_bound_souls:IsPurgeException()
	return false
end

function artifact_bound_souls:IsStunDebuff()
	return false
end

function artifact_bound_souls:IsDebuff()
	return false
end





















































































































































