iron_claw_absorbing_skin_modifier = class({})

function iron_claw_absorbing_skin_modifier:OnCreated( kv )
	self.damage_to_attack_damage_percentage = self:GetAbility():GetSpecialValueFor("damage_to_attack_damage_percentage")
	self.damage_to_move_speed_percentage = self:GetAbility():GetSpecialValueFor("damage_to_move_speed_percentage")
	self.duration = self:GetAbility():GetSpecialValueFor("duration")

	if not IsServer() then return end
	self.interval = 0.5
	self.time = 0
	self.last_health = self:GetParent():GetHealthPercent()
	self:StartIntervalThink(self.interval)

end

function iron_claw_absorbing_skin_modifier:OnIntervalThink()
	if not IsServer() then return end

	local caster = self:GetParent()
	local duration = self.duration

	local current_health = caster:GetHealthPercent()
	local deficit = self.last_health - current_health

	local modifier = caster:FindModifierByName("iron_claw_iron_hide_resting_modifier")

	if deficit > 0 and modifier == nil then

		deficit = deficit * 100

		local damage_to_attack_damage_percentage = deficit * (self.damage_to_attack_damage_percentage/100) * 1000
		local damage_to_move_speed_percentage = deficit * (self.damage_to_move_speed_percentage/100) * 1000

		local modifier = caster:FindModifierByName("iron_claw_absorbing_skin_attack_damage_modifier")
		modifier:SetStackCount( modifier:GetStackCount() + damage_to_attack_damage_percentage )

		local modifier = caster:FindModifierByName("iron_claw_absorbing_skin_move_speed_modifier")
		modifier:SetStackCount( modifier:GetStackCount() + damage_to_move_speed_percentage )

		local timer = Timers:CreateTimer(self.duration, function()

			local modifier = caster:FindModifierByName("iron_claw_absorbing_skin_attack_damage_modifier")
			modifier:SetStackCount( modifier:GetStackCount() - damage_to_attack_damage_percentage )

			local modifier = caster:FindModifierByName("iron_claw_absorbing_skin_move_speed_modifier")
			modifier:SetStackCount( modifier:GetStackCount() - damage_to_move_speed_percentage )

		end)
		PersistentTimer_Add(timer)

	end


	self.last_health = caster:GetHealthPercent()
	self.time = self.time + self.interval
end

function iron_claw_absorbing_skin_modifier:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_TOOLTIP,
		MODIFIER_PROPERTY_TOOLTIP2,
	}

	return funcs
end

function iron_claw_absorbing_skin_modifier:OnTooltip( params )
	return self.damage_to_attack_damage_percentage
end

function iron_claw_absorbing_skin_modifier:OnTooltip2( params )
	return self.damage_to_move_speed_percentage
end

function iron_claw_absorbing_skin_modifier:GetAttributes()
	return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE
end

function iron_claw_absorbing_skin_modifier:IsHidden()
    return false
end

function iron_claw_absorbing_skin_modifier:IsPurgable()
	return false
end

function iron_claw_absorbing_skin_modifier:IsPurgeException()
	return false
end

function iron_claw_absorbing_skin_modifier:IsStunDebuff()
	return false
end

function iron_claw_absorbing_skin_modifier:IsDebuff()
	return false
end