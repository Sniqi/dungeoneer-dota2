artifact_time_anomaly = class({})

function artifact_time_anomaly:OnCreated( data )
	-- ### VALUES START ### --
	self.cooldown_reduction            = 30
	self.mana_cost_reduction           = 40
	self.cast_time_reduction           = 20
	self.spell_damage                  = 30
	self.duration                      = 4
	self.cooldown                      = 45.0
	-- ### VALUES END ### --
	
	if not IsServer() then return end
	self.perkname = data.perkName
	self.perkID = data.perkID
	self.level = data.level
	self.perkEffectiveness = data.perkEffectiveness

	Change_PerkEffectivenessStats(self, true)

	self:StartIntervalThink(0.1)
end

function artifact_time_anomaly:OnRemoved()
	if not IsServer() then return end
	Change_PerkEffectivenessStats(self, false)
end

function artifact_time_anomaly:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_COOLDOWN_PERCENTAGE,
		MODIFIER_PROPERTY_MANACOST_PERCENTAGE_STACKING,
		MODIFIER_PROPERTY_CASTTIME_PERCENTAGE,
		MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE
	}

	return funcs
end

function artifact_time_anomaly:OnIntervalThink()
	if not IsServer() then return end
	if not self.activated then return end
	self.activated = false
	
	self:SetStackCount( 10000 * self.perkEffectiveness )

	local caster = self:GetParent()
	local caster_loc = caster:GetAbsOrigin()
	local team = caster:GetTeamNumber()

	--Cast Range UI
	--local castRangeUI = self.radius * ( self:GetStackCount() / 10000 )
	--caster:SetModifierStackCount("castrange_modifier_ability", caster, castRangeUI)
	--Cooldown UI
	local cooldownUI = self.cooldown * ( self:GetStackCount() / 10000 )
	caster:SetModifierStackCount("cooldown_modifier_ability", caster, cooldownUI)



	local duration = self.duration * ( self:GetStackCount() / 10000 )

	for i=0,9 do
		local ability = caster:GetAbilityByIndex(i)
		if ability ~= nil then
			if ability:GetCooldownTimeRemaining() > 0 and ability:GetAbilityName() ~= "artifact_ability" then
				ability:EndCooldown()
			end
		end
	end

	-- Sound --
	caster:EmitSound("Hero_FacelessVoid.TimeWalk")
	
	-- Particle --
	local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_lone_druid/lone_druid_true_form_runes.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster)
	ParticleManager:SetParticleControl( particle, 3, caster:GetAbsOrigin() )
	ParticleManager:ReleaseParticleIndex( particle )
	particle = nil

	Timers:CreateTimer(duration, function()
		self:SetStackCount(0)

		if particle ~= nil then
			ParticleManager:DestroyParticle( particle, false )
			ParticleManager:ReleaseParticleIndex( particle )
			particle = nil
		end
	end)
end

function artifact_time_anomaly:GetModifierPercentageCooldown( params )
	return self.cooldown_reduction
end

function artifact_time_anomaly:GetModifierPercentageManacostStacking( params )
	return self.mana_cost_reduction * ( self:GetStackCount() / 10000 )
end

function artifact_time_anomaly:GetModifierPercentageCasttime( params )
	return self.cast_time_reduction * ( self:GetStackCount() / 10000 )
end

function artifact_time_anomaly:GetModifierSpellAmplify_Percentage( params )
	return self.spell_damage * ( self:GetStackCount() / 10000 )
end

function artifact_time_anomaly:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE + MODIFIER_ATTRIBUTE_MULTIPLE
end

function artifact_time_anomaly:IsHidden()
    return true
end

function artifact_time_anomaly:IsPurgable()
	return false
end

function artifact_time_anomaly:IsPurgeException()
	return false
end

function artifact_time_anomaly:IsStunDebuff()
	return false
end

function artifact_time_anomaly:IsDebuff()
	return false
end





















































































































































