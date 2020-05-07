deathspeaker_xunra_tentacle_sweep_modifier = class({})

function deathspeaker_xunra_tentacle_sweep_modifier:OnCreated( kv )
	self.stun                         = self:GetAbility():GetSpecialValueFor("stun")
end

function deathspeaker_xunra_tentacle_sweep_modifier:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_TOOLTIP,
	}

	return funcs
end


function deathspeaker_xunra_tentacle_sweep_modifier:OnTooltip( params )
	return self.stun
end


function deathspeaker_xunra_tentacle_sweep_modifier:GetAttributes()
	return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE
end

function deathspeaker_xunra_tentacle_sweep_modifier:IsHidden()
    return false
end

function deathspeaker_xunra_tentacle_sweep_modifier:IsPurgable()
	return false
end

function deathspeaker_xunra_tentacle_sweep_modifier:IsPurgeException()
	return false
end

function deathspeaker_xunra_tentacle_sweep_modifier:IsStunDebuff()
	return false
end

function deathspeaker_xunra_tentacle_sweep_modifier:IsDebuff()
	return true
end