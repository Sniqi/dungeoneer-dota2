demonic_warrior_rest_checker_modifier = class({})

function demonic_warrior_rest_checker_modifier:OnCreated( kv )
	self.duration                     = self:GetAbility():GetSpecialValueFor("duration")

	if not IsServer() then return end
	-- ChallengerMode 1 --
	if GameMode_Active == "Challenger" and ChallengerMode_Active == 1 then self.duration = 1.0 end
	
	self.activations = 0
	self:StartIntervalThink(0.25)
end

function demonic_warrior_rest_checker_modifier:OnIntervalThink()
	if not IsServer() then return end

	local caster = self:GetParent()
	local health_pct = caster:GetHealthPercent()

	if health_pct <= 80 and self.activations == 0 then
		self.activations = self.activations + 1
		demonic_warrior_rest_checker_modifier:SetResting(self)
	end

	if health_pct <= 60 and self.activations == 1 then
		self.activations = self.activations + 1
		demonic_warrior_rest_checker_modifier:SetResting(self)
	end

	if health_pct <= 40 and self.activations == 2 then
		self.activations = self.activations + 1
		demonic_warrior_rest_checker_modifier:SetResting(self)
	end
end

function demonic_warrior_rest_checker_modifier:SetResting(self)
	local caster = self:GetParent()

	-- Modifier --
	caster:AddNewModifier(caster, self:GetAbility(), "demonic_warrior_rest_modifier", {duration = self.duration})

	local buff = caster:FindModifierByNameAndCaster("demonic_warrior_rest_enhancement_modifier", caster)

	if buff == nil then	
		buff = caster:AddNewModifier(caster, self:GetAbility(), "demonic_warrior_rest_enhancement_modifier", {})
	end

	buff:IncrementStackCount()

	-- Animation --
	caster:StartGestureWithPlaybackRate(ACT_DOTA_DISABLED, 1.0)
end

function demonic_warrior_rest_checker_modifier:GetAttributes()
	return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE
end

function demonic_warrior_rest_checker_modifier:IsHidden()
    return true
end

function demonic_warrior_rest_checker_modifier:IsPurgable()
	return false
end

function demonic_warrior_rest_checker_modifier:IsPurgeException()
	return false
end

function demonic_warrior_rest_checker_modifier:IsStunDebuff()
	return false
end

function demonic_warrior_rest_checker_modifier:IsDebuff()
	return false
end