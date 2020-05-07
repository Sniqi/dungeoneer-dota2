lunar_horse_sun_orb_move_range_counter_modifier = class({})

function lunar_horse_sun_orb_move_range_counter_modifier:OnCreated( kv )
	self.move_distance_min   = self:GetAbility():GetSpecialValueFor("move_distance_min")
	self.move_distance_max   = self:GetAbility():GetSpecialValueFor("move_distance_max")
	self.hero_move_speed_percentage        = self:GetAbility():GetSpecialValueFor("hero_move_speed_percentage")

	if not IsServer() then return end
	self:SetStackCount( RandomInt( self.move_distance_min, self.move_distance_max ) )

	local victim = self:GetParent()
	self.oldPos = victim:GetAbsOrigin()

	self:StartIntervalThink(0.1)
end

function lunar_horse_sun_orb_move_range_counter_modifier:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
	}

	return funcs
end

function lunar_horse_sun_orb_move_range_counter_modifier:OnIntervalThink()
	if not IsServer() then return end

	local victim = self:GetParent()

	local distance = ( self.oldPos - victim:GetAbsOrigin() ):Length2D()
	if distance > 0 then
		self:SetStackCount( self:GetStackCount() - distance )
	end

	self.oldPos = victim:GetAbsOrigin()

end

function lunar_horse_sun_orb_move_range_counter_modifier:GetModifierMoveSpeedBonus_Percentage( params )
	return self.hero_move_speed_percentage
end


function lunar_horse_sun_orb_move_range_counter_modifier:GetAttributes()
	return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE
end

function lunar_horse_sun_orb_move_range_counter_modifier:IsHidden()
    return false
end

function lunar_horse_sun_orb_move_range_counter_modifier:IsPurgable()
	return false
end

function lunar_horse_sun_orb_move_range_counter_modifier:IsPurgeException()
	return false
end

function lunar_horse_sun_orb_move_range_counter_modifier:IsStunDebuff()
	return false
end

function lunar_horse_sun_orb_move_range_counter_modifier:IsDebuff()
	return true
end