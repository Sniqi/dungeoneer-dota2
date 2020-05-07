percentage_based_auto_attack_damage = class({})

function percentage_based_auto_attack_damage:OnCreated( kv )
	if not IsServer() then return end

	self:StartIntervalThink(0.1)
end

function percentage_based_auto_attack_damage:OnIntervalThink()
	if not IsServer() then return end

	local caster = self:GetParent()
	local attack_damage = caster:GetAttackDamage()

	if attack_damage < 0 then attack_damage = 0 end

	self:SetStackCount( attack_damage )
end

function percentage_based_auto_attack_damage:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_ATTACK_LANDED,
		MODIFIER_PROPERTY_TOOLTIP
	}

	return funcs
end

function percentage_based_auto_attack_damage:OnAttackLanded( params )
	if not IsServer() then return end
	if self:GetParent() ~= params.attacker then return end

	local caster = self:GetParent()
	local victim = params.target
	local damage = self:GetStackCount()

	EncounterApplyDamage(victim, caster, nil, damage, DAMAGE_TYPE_PHYSICAL, DOTA_DAMAGE_FLAG_NONE)
end

function percentage_based_auto_attack_damage:OnTooltip()
	return self:GetStackCount()
end

function percentage_based_auto_attack_damage:GetAttributes()
	return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE + MODIFIER_ATTRIBUTE_PERMANENT
end

function percentage_based_auto_attack_damage:IsHidden()
    return false
end

function percentage_based_auto_attack_damage:IsPurgable()
	return false
end

function percentage_based_auto_attack_damage:IsPurgeException()
	return false
end

function percentage_based_auto_attack_damage:IsStunDebuff()
	return false
end

function percentage_based_auto_attack_damage:IsDebuff()
	return false
end

function percentage_based_auto_attack_damage:GetTexture()
	return "juggernaut_blade_dance"
end