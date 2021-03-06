deathspeaker_xunra_rune_of_roots_modifier = class({})

function deathspeaker_xunra_rune_of_roots_modifier:OnCreated( kv )
	self.move_speed_percentage        = self:GetAbility():GetSpecialValueFor("move_speed_percentage")
	self.roots_duration               = self:GetAbility():GetSpecialValueFor("roots_duration")
end

function deathspeaker_xunra_rune_of_roots_modifier:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_PROPERTY_TOOLTIP,
	}

	return funcs
end


function deathspeaker_xunra_rune_of_roots_modifier:GetModifierMoveSpeedBonus_Percentage( params )
	return self.move_speed_percentage
end

function deathspeaker_xunra_rune_of_roots_modifier:OnTooltip( params )
	return self.roots_duration
end


function deathspeaker_xunra_rune_of_roots_modifier:GetAttributes()
	return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE
end

function deathspeaker_xunra_rune_of_roots_modifier:IsHidden()
    return false
end

function deathspeaker_xunra_rune_of_roots_modifier:IsPurgable()
	return false
end

function deathspeaker_xunra_rune_of_roots_modifier:IsPurgeException()
	return false
end

function deathspeaker_xunra_rune_of_roots_modifier:IsStunDebuff()
	return false
end

function deathspeaker_xunra_rune_of_roots_modifier:IsDebuff()
	return true
end