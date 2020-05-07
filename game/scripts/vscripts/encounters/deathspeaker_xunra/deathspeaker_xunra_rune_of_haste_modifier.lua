deathspeaker_xunra_rune_of_haste_modifier = class({})

function deathspeaker_xunra_rune_of_haste_modifier:OnCreated( kv )
	self.haste_damage                 = self:GetAbility():GetSpecialValueFor("haste_damage")
	self.haste_knockback              = self:GetAbility():GetSpecialValueFor("haste_knockback")

	if not IsServer() then return end

	local victim = self:GetParent()
	self.oldPos = victim:GetAbsOrigin()

	self:StartIntervalThink(0.1)
end

function deathspeaker_xunra_rune_of_haste_modifier:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_TOOLTIP,
	}

	return funcs
end

function deathspeaker_xunra_rune_of_haste_modifier:OnIntervalThink()
	if not IsServer() then return end

	local caster = self:GetCaster()
	local victim = self:GetParent()

	local distance = ( self.oldPos - victim:GetAbsOrigin() ):Length2D()
	if distance == 0  and not victim:HasModifier("deathspeaker_xunra_runic_penalty_modifier") then

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
		EncounterApplyDamage(victim, caster, self:GetAbility(), self.haste_damage, DAMAGE_TYPE_MAGICAL, DOTA_DAMAGE_FLAG_NONE)

		victim:SetRebounceFrames(12)
		victim:SetPhysicsVelocityMax(self.haste_knockback)
		victim:AddPhysicsVelocity(-victim:GetForwardVector() * self.haste_knockback)
		--victim:OnBounce(function(victim, normal)
			--EncounterApplyDamage(victim, caster, ability, push_damage, DAMAGE_TYPE_PHYSICAL, DOTA_DAMAGE_FLAG_NONE)
		--end)

	end

	self.oldPos = victim:GetAbsOrigin()
end

function deathspeaker_xunra_rune_of_haste_modifier:GetAttributes()
	return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE
end

function deathspeaker_xunra_rune_of_haste_modifier:IsHidden()
    return false
end

function deathspeaker_xunra_rune_of_haste_modifier:IsPurgable()
	return false
end

function deathspeaker_xunra_rune_of_haste_modifier:IsPurgeException()
	return false
end

function deathspeaker_xunra_rune_of_haste_modifier:IsStunDebuff()
	return false
end

function deathspeaker_xunra_rune_of_haste_modifier:IsDebuff()
	return true
end