lunar_horse_sun_orb_countdown_modifier = class({})

function lunar_horse_sun_orb_countdown_modifier:OnCreated( kv )
	self.duration            = self:GetAbility():GetSpecialValueFor("duration")
	self.move_distance_min   = self:GetAbility():GetSpecialValueFor("move_distance_min")
	self.move_distance_max   = self:GetAbility():GetSpecialValueFor("move_distance_max")
	self.move_time           = self:GetAbility():GetSpecialValueFor("move_time")

	if not IsServer() then return end
	self:SetStackCount( self.move_time - 1 )
	self:StartIntervalThink(1)
end

function lunar_horse_sun_orb_countdown_modifier:DeclareFunctions()
	local funcs = {
	}

	return funcs
end

function lunar_horse_sun_orb_countdown_modifier:OnIntervalThink()
	if not IsServer() then return end

	if self:GetStackCount() == 0 then

		local caster = GetCurrentEncounterEntity()
		local victim = self:GetParent()
		local moveCheck = victim:FindModifierByName("lunar_horse_sun_orb_move_range_counter_modifier"):GetStackCount()

		if moveCheck > 1 and moveCheck < 80 then

			-- Modifier --
			caster:AddNewModifier(caster, self:GetAbility(), "lunar_horse_sun_orb_modifier", {duration = self.duration})

		end

	else
		self:DecrementStackCount()
	end
end

function lunar_horse_sun_orb_countdown_modifier:GetAttributes()
	return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE
end

function lunar_horse_sun_orb_countdown_modifier:IsHidden()
    return false
end

function lunar_horse_sun_orb_countdown_modifier:IsPurgable()
	return false
end

function lunar_horse_sun_orb_countdown_modifier:IsPurgeException()
	return false
end

function lunar_horse_sun_orb_countdown_modifier:IsStunDebuff()
	return false
end

function lunar_horse_sun_orb_countdown_modifier:IsDebuff()
	return true
end