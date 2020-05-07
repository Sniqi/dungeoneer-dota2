lesser_attack_damage = class({})

function lesser_attack_damage:OnCreated( data )
	-- ### VALUES START ### --
	self.attack_damage                 = 25
	-- ### VALUES END ### --
end

function lesser_attack_damage:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_BASEDAMAGEOUTGOING_PERCENTAGE
	}

	return funcs
end

function lesser_attack_damage:GetModifierBaseDamageOutgoing_Percentage( params )
	return self.attack_damage
end

function lesser_attack_damage:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE + MODIFIER_ATTRIBUTE_MULTIPLE
end

function lesser_attack_damage:IsHidden()
    return true
end

function lesser_attack_damage:IsPurgable()
	return false
end

function lesser_attack_damage:IsPurgeException()
	return false
end

function lesser_attack_damage:IsStunDebuff()
	return false
end

function lesser_attack_damage:IsDebuff()
	return false
end















































































































































































































































