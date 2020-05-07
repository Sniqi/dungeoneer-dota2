deathspeaker_xunra_rune_of_roots_penalty_modifier = class({})

function deathspeaker_xunra_rune_of_roots_penalty_modifier:OnCreated( kv )
	self.roots_move_speed_percentage  = self:GetAbility():GetSpecialValueFor("roots_move_speed_percentage")
	self.roots_damage                 = self:GetAbility():GetSpecialValueFor("roots_damage")
	self.roots_duration               = self:GetAbility():GetSpecialValueFor("roots_duration")

	if not IsServer() then return end

	local victim = self:GetParent()
	self.oldPos = victim:GetAbsOrigin()

	self.interval = 0.5
	self:StartIntervalThink( self.interval )
end

function deathspeaker_xunra_rune_of_roots_penalty_modifier:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_PROPERTY_TOOLTIP,
	}

	return funcs
end

function deathspeaker_xunra_rune_of_roots_penalty_modifier:OnIntervalThink()
	if not IsServer() then return end

	local caster = self:GetCaster()
	local victim = self:GetParent()

	local damage = ( self.roots_damage / self.roots_duration ) * self.interval

	-- Apply Damage --
	EncounterApplyDamage(victim, caster, self:GetAbility(), damage, DAMAGE_TYPE_MAGICAL, DOTA_DAMAGE_FLAG_NONE)
end

function deathspeaker_xunra_rune_of_roots_penalty_modifier:GetModifierMoveSpeedBonus_Percentage( params )
	return self.roots_move_speed_percentage
end

function deathspeaker_xunra_rune_of_roots_penalty_modifier:OnTooltip( params )
	return self.roots_duration
end

function deathspeaker_xunra_rune_of_roots_penalty_modifier:GetAttributes()
	return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE
end

function deathspeaker_xunra_rune_of_roots_penalty_modifier:IsHidden()
    return false
end

function deathspeaker_xunra_rune_of_roots_penalty_modifier:IsPurgable()
	return false
end

function deathspeaker_xunra_rune_of_roots_penalty_modifier:IsPurgeException()
	return false
end

function deathspeaker_xunra_rune_of_roots_penalty_modifier:IsStunDebuff()
	return false
end

function deathspeaker_xunra_rune_of_roots_penalty_modifier:IsDebuff()
	return true
end