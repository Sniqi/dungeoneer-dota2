deathspeaker_xunra_deathly_scythe_modifier = class({})

function deathspeaker_xunra_deathly_scythe_modifier:OnCreated( kv )
	self.move_speed_percentage        = self:GetAbility():GetSpecialValueFor("move_speed_percentage")
	self.magic_resist_percentage      = self:GetAbility():GetSpecialValueFor("magic_resist_percentage")
end

function deathspeaker_xunra_deathly_scythe_modifier:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,
	}

	return funcs
end


function deathspeaker_xunra_deathly_scythe_modifier:GetModifierMoveSpeedBonus_Percentage( params )
	return self.move_speed_percentage
end

function deathspeaker_xunra_deathly_scythe_modifier:GetModifierMagicalResistanceBonus( params )
	return self.magic_resist_percentage
end


function deathspeaker_xunra_deathly_scythe_modifier:GetAttributes()
	return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE
end

function deathspeaker_xunra_deathly_scythe_modifier:IsHidden()
    return false
end

function deathspeaker_xunra_deathly_scythe_modifier:IsPurgable()
	return false
end

function deathspeaker_xunra_deathly_scythe_modifier:IsPurgeException()
	return false
end

function deathspeaker_xunra_deathly_scythe_modifier:IsStunDebuff()
	return false
end

function deathspeaker_xunra_deathly_scythe_modifier:IsDebuff()
	return true
end