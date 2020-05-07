demonic_warrior_deep_cutting_axe_modifier = class({})

function demonic_warrior_deep_cutting_axe_modifier:OnCreated( kv )
end

function demonic_warrior_deep_cutting_axe_modifier:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_ATTACK_LANDED
	}

	return funcs
end

function demonic_warrior_deep_cutting_axe_modifier:OnAttackLanded( params )
	if not IsServer() then return end
	if self:GetParent() ~= params.attacker then return end

	local caster = self:GetParent()
	local victim = params.target

	-- DOTA_UNIT_TARGET_TEAM_FRIENDLY; DOTA_UNIT_TARGET_TEAM_ENEMY; DOTA_UNIT_TARGET_TEAM_BOTH
	for _,victim_hero in pairs( GetHeroesAliveEntities() ) do
		-- Modifier --
		local debuff = victim_hero:FindModifierByNameAndCaster("demonic_warrior_deep_cutting_axe_wound_modifier", caster)

		if debuff == nil then	
			debuff = victim_hero:AddNewModifier(caster, self:GetAbility(), "demonic_warrior_deep_cutting_axe_wound_modifier", {})
			PersistentModifier_Add(debuff)		
		end

		debuff:IncrementStackCount()
		
		-- ChallengerMode 1 --
		if GameMode_Active == "Challenger" and ChallengerMode_Active == 1 then
			debuff:IncrementStackCount()
		end
	end

end

function demonic_warrior_deep_cutting_axe_modifier:GetAttributes()
	--return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE
end

function demonic_warrior_deep_cutting_axe_modifier:IsHidden()
    return false
end

function demonic_warrior_deep_cutting_axe_modifier:IsPurgable()
	return false
end

function demonic_warrior_deep_cutting_axe_modifier:IsPurgeException()
	return false
end

function demonic_warrior_deep_cutting_axe_modifier:IsStunDebuff()
	return false
end

function demonic_warrior_deep_cutting_axe_modifier:IsDebuff()
	return false
end