deathspeaker_xunra_rune_of_solitude_modifier = class({})

function deathspeaker_xunra_rune_of_solitude_modifier:OnCreated( kv )
	self.solitude_damage            = self:GetAbility():GetSpecialValueFor("solitude_damage")
	self.solitude_aoe               = self:GetAbility():GetSpecialValueFor("solitude_aoe")

	if not IsServer() then return end

	self:StartIntervalThink(0.1)
end

function deathspeaker_xunra_rune_of_solitude_modifier:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_TOOLTIP,
	}

	return funcs
end

function deathspeaker_xunra_rune_of_solitude_modifier:OnIntervalThink()
	if not IsServer() then return end

	local caster = self:GetCaster()
	local victim = self:GetParent()

	if victim:HasModifier("deathspeaker_xunra_runic_penalty_modifier") then return end

	-- DOTA_UNIT_TARGET_TEAM_FRIENDLY; DOTA_UNIT_TARGET_TEAM_ENEMY; DOTA_UNIT_TARGET_TEAM_BOTH
	local units	= FindUnitsInRadius(caster:GetTeamNumber(), victim:GetAbsOrigin(), nil, self.solitude_aoe, DOTA_UNIT_TARGET_TEAM_BOTH, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_INVULNERABLE, FIND_CLOSEST, false)

	if units[2] ~= nil then
		if units[2]:GetUnitName() ~= "npc_dota_hero_deathspeaker_xunra" and units[2] ~= victim then

			self:Destroy()

			-- Sound and Animation --
			local sound = {"necrolyte_necr_move_15", "necrolyte_necr_move_02",
							"necrolyte_necr_cast_01", "necrolyte_necr_laugh_07",
							"necrolyte_necr_laugh_06", "necrolyte_necr_laugh_05"}
			EmitAnnouncerSound( sound[RandomInt(1, #sound)] )

			StartSoundEventFromPositionReliable("Hero_Pugna.NetherWard", victim:GetAbsOrigin())

			local particle = ParticleManager:CreateParticle("particles/econ/items/pugna/pugna_ward_ti5/pugna_ward_attack_medium_ti_5.vpcf", PATTACH_CUSTOMORIGIN, nil)
			ParticleManager:SetParticleControlEnt( particle, 0, caster, PATTACH_POINT_FOLLOW, "attach_attack2", caster:GetAttachmentOrigin(caster:ScriptLookupAttachment("attach_attack2")), true)
			ParticleManager:SetParticleControlEnt( particle, 1, victim, PATTACH_POINT_FOLLOW, "attach_hitloc", victim:GetAttachmentOrigin(victim:ScriptLookupAttachment("attach_hitloc")), true)
			ParticleManager:ReleaseParticleIndex( particle )
			particle = nil

			-- Apply Damage --
			EncounterApplyDamage(victim, caster, self:GetAbility(), self.solitude_damage, DAMAGE_TYPE_MAGICAL, DOTA_DAMAGE_FLAG_NONE)

		end
	end

end

function deathspeaker_xunra_rune_of_solitude_modifier:OnTooltip( params )
	return self.roots_duration
end

function deathspeaker_xunra_rune_of_solitude_modifier:GetAttributes()
	return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE
end

function deathspeaker_xunra_rune_of_solitude_modifier:IsHidden()
    return false
end

function deathspeaker_xunra_rune_of_solitude_modifier:IsPurgable()
	return false
end

function deathspeaker_xunra_rune_of_solitude_modifier:IsPurgeException()
	return false
end

function deathspeaker_xunra_rune_of_solitude_modifier:IsStunDebuff()
	return false
end

function deathspeaker_xunra_rune_of_solitude_modifier:IsDebuff()
	return true
end