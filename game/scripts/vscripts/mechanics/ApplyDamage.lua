function EncounterApplyDamage(victim, caster, ability, damage, damagetype, damageflags)
	damage = victim:GetMaxHealth() * ( damage / 100 )

	local damage_normal = damage * 0.65
	local damage_pure = damage * 0.35

	local damageTable_normal = {
		victim = victim,
		attacker = caster,
		damage = damage_normal,
		damage_type = damagetype,
		damage_flags = damageflags,
		ability = ability,
	}

	local damageTable_pure = {
		victim = victim,
		attacker = caster,
		damage = damage_pure,
		damage_type = DAMAGE_TYPE_PURE,
		damage_flags = damageflags,
		ability = ability,
	}

	if not IsValidEntity(GetCurrentEncounterEntity()) then return end
	if GetCurrentEncounterEntity() == nil then return end
	if GetCurrentEncounterEntity():IsNull() then return end
	if not GetCurrentEncounterEntity():IsAlive() then return end

	if not IsValidEntity(victim) then return end
	if victim == nil then return end
	if victim:IsNull() then return end
	if not victim:IsAlive() then return end

	ApplyDamage(damageTable_normal)

	local timer = Timers:CreateTimer(0.01, function()
		if not IsValidEntity(victim) then return end
		if victim == nil then return end
		if victim:IsNull() then return end
		if not victim:IsAlive() then return end

		ApplyDamage(damageTable_pure)
	end)
	PersistentTimer_Add(timer)
end
