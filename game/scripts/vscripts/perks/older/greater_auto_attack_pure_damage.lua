greater_auto_attack_pure_damage = class({})

function greater_auto_attack_pure_damage:OnCreated( data )
	-- ### VALUES START ### --
	self.auto_attack_pure_damage       = 30
	-- ### VALUES END ### --
end

function greater_auto_attack_pure_damage:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_ATTACK_LANDED
	}

	return funcs
end

function greater_auto_attack_pure_damage:OnAttackLanded( params )
	if not IsServer() then return end
	if self:GetParent() ~= params.attacker then return end

	local caster = self:GetParent()
	local victim = params.target

	local damage = params.original_damage * ( self.auto_attack_pure_damage / 100 )

	local damageTable_normal = {
		victim = victim,
		attacker = caster,
		damage = damage,
		damage_type = DAMAGE_TYPE_PURE,
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

function greater_auto_attack_pure_damage:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE + MODIFIER_ATTRIBUTE_MULTIPLE
end

function greater_auto_attack_pure_damage:IsHidden()
    return true
end

function greater_auto_attack_pure_damage:IsPurgable()
	return false
end

function greater_auto_attack_pure_damage:IsPurgeException()
	return false
end

function greater_auto_attack_pure_damage:IsStunDebuff()
	return false
end

function greater_auto_attack_pure_damage:IsDebuff()
	return false
end















































































































































































































































