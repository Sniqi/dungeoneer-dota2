deathspeaker_xunra_soulcatcher_checker_modifier = class({})

function deathspeaker_xunra_soulcatcher_checker_modifier:OnCreated( kv )
	self.link_break_range             = self:GetAbility():GetSpecialValueFor("link_break_range")
end

function deathspeaker_xunra_soulcatcher_checker_modifier:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_TOOLTIP,
	}

	return funcs
end


function deathspeaker_xunra_soulcatcher_checker_modifier:OnTooltip( params )
	return self.link_break_range
end


function deathspeaker_xunra_soulcatcher_checker_modifier:GetAttributes()
	return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE
end

function deathspeaker_xunra_soulcatcher_checker_modifier:IsHidden()
    return false
end

function deathspeaker_xunra_soulcatcher_checker_modifier:IsPurgable()
	return false
end

function deathspeaker_xunra_soulcatcher_checker_modifier:IsPurgeException()
	return false
end

function deathspeaker_xunra_soulcatcher_checker_modifier:IsStunDebuff()
	return false
end

function deathspeaker_xunra_soulcatcher_checker_modifier:IsDebuff()
	return true
end