lunar_horse_sun_orb_modifier = class({})

function lunar_horse_sun_orb_modifier:OnCreated( kv )
	self.move_speed_percentage        = self:GetAbility():GetSpecialValueFor("move_speed_percentage")
	self.incoming_damage_percentage   = self:GetAbility():GetSpecialValueFor("incoming_damage_percentage")
	self.boss_move_speed_percentage   = self:GetAbility():GetSpecialValueFor("boss_move_speed_percentage")
end

function lunar_horse_sun_orb_modifier:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
	}

	return funcs
end


function lunar_horse_sun_orb_modifier:GetModifierMoveSpeedBonus_Percentage( params )
	return self.move_speed_percentage
end

function lunar_horse_sun_orb_modifier:GetModifierIncomingDamage_Percentage( params )
	return self.incoming_damage_percentage
end

function lunar_horse_sun_orb_modifier:OnTooltip( params )
	return self.boss_move_speed_percentage
end


function lunar_horse_sun_orb_modifier:GetAttributes()
	return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE
end

function lunar_horse_sun_orb_modifier:IsHidden()
    return false
end

function lunar_horse_sun_orb_modifier:IsPurgable()
	return false
end

function lunar_horse_sun_orb_modifier:IsPurgeException()
	return false
end

function lunar_horse_sun_orb_modifier:IsStunDebuff()
	return false
end

function lunar_horse_sun_orb_modifier:IsDebuff()
	return true
end