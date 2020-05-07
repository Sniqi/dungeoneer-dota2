lesser_status_resistance = class({})

function lesser_status_resistance:OnCreated( data )
	-- ### VALUES START ### --
	self.status_resistance             = 25
	-- ### VALUES END ### --
	
	if not IsServer() then return end
	self:StartIntervalThink(0.06)
end

function lesser_status_resistance:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_ATTACK_LANDED,
		MODIFIER_EVENT_ON_ABILITY_FULLY_CAST,
	}

	return funcs
end

function lesser_status_resistance:OnIntervalThink()
end

function lesser_status_resistance:OnAttackLanded( params )
	if not IsServer() then return end
	if self:GetParent() ~= params.attacker then return end

	local caster = self:GetParent()
	local victim = params.target
end

function lesser_status_resistance:OnAbilityFullyCast( params )
	if not IsServer() then return end
	if params.ability:GetCaster() ~= self:GetParent() then return end

	local heroEntity = self:GetParent()
end

function lesser_status_resistance:GetModifierPhysicalArmorBonus( params )
	return self.armor
end

function lesser_status_resistance:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE + MODIFIER_ATTRIBUTE_MULTIPLE
end

function lesser_status_resistance:IsHidden()
    return true
end

function lesser_status_resistance:IsPurgable()
	return false
end

function lesser_status_resistance:IsPurgeException()
	return false
end

function lesser_status_resistance:IsStunDebuff()
	return false
end

function lesser_status_resistance:IsDebuff()
	return false
end








































































