lesser_auto_attack_magic_damage = class({})

function lesser_auto_attack_magic_damage:OnCreated( data )
	-- ### VALUES START ### --
	self.auto_attack_magic_damage      = 20
	-- ### VALUES END ### --
end

function lesser_auto_attack_magic_damage:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_ATTACK_LANDED
	}

	return funcs
end

function lesser_auto_attack_magic_damage:OnAttackLanded( params )
	if not IsServer() then return end
	if self:GetParent() ~= params.attacker then return end

	local caster = self:GetParent()
	local victim = params.target

	local damage = params.original_damage * ( self.auto_attack_magic_damage / 100 )

	local damageTable_normal = {
		victim = victim,
		attacker = caster,
		damage = damage,
		damage_type = DAMAGE_TYPE_MAGICAL,
		damage_flags = DOTA_DAMAGE_FLAG_NONE,
	}

	Timers:CreateTimer(0.25, function()
		if not IsValidEntity(victim) then return end
		if victim == nil then return end
		if victim:IsNull() then return end
		if not victim:IsAlive() then return end

		ApplyDamage(damageTable_normal)
	end)
end

function lesser_auto_attack_magic_damage:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE + MODIFIER_ATTRIBUTE_MULTIPLE
end

function lesser_auto_attack_magic_damage:IsHidden()
    return true
end

function lesser_auto_attack_magic_damage:IsPurgable()
	return false
end

function lesser_auto_attack_magic_damage:IsPurgeException()
	return false
end

function lesser_auto_attack_magic_damage:IsStunDebuff()
	return false
end

function lesser_auto_attack_magic_damage:IsDebuff()
	return false
end















































































































































































































































