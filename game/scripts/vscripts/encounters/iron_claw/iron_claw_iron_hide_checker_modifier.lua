iron_claw_iron_hide_checker_modifier = class({})

function iron_claw_iron_hide_checker_modifier:OnCreated( kv )
	self.rest_distance = self:GetAbility():GetSpecialValueFor("rest_distance")
	self.rest_time = self:GetAbility():GetSpecialValueFor("rest_time")

	if not IsServer() then return end
	-- ChallengerMode 1 --
	if GameMode_Active == "Challenger" and ChallengerMode_Active == 1 then self.rest_time = self.rest_time * 0.5 end

	self.last_loc = self:GetParent():GetAbsOrigin()
	self.tired_triggered = false
	self.distance = 0
	self:StartIntervalThink(0.25)
end

function iron_claw_iron_hide_checker_modifier:OnIntervalThink()
	if not IsServer() then return end

	local caster = self:GetParent()
	local current_loc = caster:GetAbsOrigin()

	local distance_resting = self.rest_distance
	local distance_tired = distance_resting * 0.75

	self.distance = self.distance + (self.last_loc - current_loc):Length2D()

	if self.distance >= distance_tired and not self.tired_triggered then
		self.tired_triggered = true

		-- Modifier --
		caster:AddNewModifier(caster, self:GetAbility(), "iron_claw_iron_hide_getting_tired_modifier", {})
	end

	if self.distance >= distance_resting then
		self.distance = 0
		self.tired_triggered = false

		-- Modifier --
		caster:RemoveModifierByName("iron_claw_iron_hide_modifier")
		caster:RemoveModifierByName("iron_claw_iron_hide_getting_tired_modifier")
		caster:AddNewModifier(caster, self:GetAbility(), "iron_claw_iron_hide_resting_modifier", {duration = self.rest_time})

	end

	self.last_loc = caster:GetAbsOrigin()
end

function iron_claw_iron_hide_checker_modifier:DeclareFunctions()
	local funcs = {
	}

	return funcs
end

function iron_claw_iron_hide_checker_modifier:GetAttributes()
	return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE
end

function iron_claw_iron_hide_checker_modifier:IsHidden()
    return true
end

function iron_claw_iron_hide_checker_modifier:IsPurgable()
	return false
end

function iron_claw_iron_hide_checker_modifier:IsPurgeException()
	return false
end

function iron_claw_iron_hide_checker_modifier:IsStunDebuff()
	return false
end

function iron_claw_iron_hide_checker_modifier:IsDebuff()
	return false
end