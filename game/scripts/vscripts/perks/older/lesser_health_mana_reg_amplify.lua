lesser_health_mana_reg_amplify = class({})

function lesser_health_mana_reg_amplify:OnCreated( data )
	-- ### VALUES START ### --
	self.health_regen_amp              = 30
	self.mana_regen_amp                = 50
	-- ### VALUES END ### --
end

function lesser_health_mana_reg_amplify:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_HP_REGEN_AMPLIFY_PERCENTAGE,
		MODIFIER_PROPERTY_MP_REGEN_AMPLIFY_PERCENTAGE
	}

	return funcs
end

function lesser_health_mana_reg_amplify:GetModifierHPRegenAmplify_Percentage( params )
	return self.health_regen_amp
end

function lesser_health_mana_reg_amplify:GetModifierMPRegenAmplify_Percentage( params )
	return self.mana_regen_amp
end

function lesser_health_mana_reg_amplify:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE + MODIFIER_ATTRIBUTE_MULTIPLE
end

function lesser_health_mana_reg_amplify:IsHidden()
    return true
end

function lesser_health_mana_reg_amplify:IsPurgable()
	return false
end

function lesser_health_mana_reg_amplify:IsPurgeException()
	return false
end

function lesser_health_mana_reg_amplify:IsStunDebuff()
	return false
end

function lesser_health_mana_reg_amplify:IsDebuff()
	return false
end
















































































































































































