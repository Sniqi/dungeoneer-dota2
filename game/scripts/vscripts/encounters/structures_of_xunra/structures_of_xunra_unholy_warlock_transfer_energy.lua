structures_of_xunra_unholy_warlock_transfer_energy = class({})

function structures_of_xunra_unholy_warlock_transfer_energy:OnSpellStart()

	local victim		= GetRandomHeroEntities(1)
	if not victim then return end
	victim				= victim[1]
	local victim_loc	= victim:GetAbsOrigin()

	--- Get Caster, Victim, Player, Point ---
	local caster		= self:GetCaster()
	local caster_loc	= caster:GetAbsOrigin()
	local playerID		= caster:GetPlayerOwnerID()
	local player		= PlayerResource:GetPlayer(playerID)
	local team			= caster:GetTeamNumber()

	--- Get Special Values ---
	local AbilityCastRange            = self:GetSpecialValueFor("AbilityCastRange")
	local duration                    = self:GetSpecialValueFor("duration")
	local damage                      = self:GetSpecialValueFor("damage")
	local delay                       = self:GetSpecialValueFor("delay")
	local heal_percentage             = self:GetSpecialValueFor("heal_percentage")
	local heal_amp_mulitplicator      = self:GetSpecialValueFor("heal_amp_mulitplicator")
	local hp_loss_to_cancel_percentage= self:GetSpecialValueFor("hp_loss_to_cancel_percentage")

	if (victim_loc - caster_loc):Length2D() >= AbilityCastRange then
		self:EndCooldown()
		return
	end

	local friend = nil

	-- DOTA_UNIT_TARGET_TEAM_FRIENDLY; DOTA_UNIT_TARGET_TEAM_ENEMY; DOTA_UNIT_TARGET_TEAM_BOTH
	local units	= FindUnitsInRadius(team, caster_loc, nil, AbilityCastRange*1.5, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
	for _,victim in pairs(units) do
	
		if victim:GetUnitName() ~= "structures_of_xunra_obelisk_summon_unholy_warlock" then
			if victim:GetHealthPercent() < 100 then

				if friend == nil then
					friend = victim
				elseif victim:GetHealthPercent() < friend:GetHealthPercent() then
					friend = victim
				end

			end
		end

	end

	if friend == nil then
		self:EndCooldown()
		return
	end

	if friend:GetUnitName() == "structures_of_xunra_obelisk_summon_unholy_warrior" or
		friend:GetUnitName() == "structures_of_xunra_obelisk_summon_unholy_archer" or
		friend:GetUnitName() == "structures_of_xunra_obelisk_summon_unholy_warlock" then

			heal_percentage = heal_percentage * ( heal_amp_mulitplicator / 100 )
	end

	StartAnimation(caster, {duration=delay, activity=ACT_DOTA_DISABLED, rate=0.5})

	EncounterUnitWarning(victim, delay, true, nil) --nil=yellow, "red", "orange", "green"
	EncounterUnitWarning(friend, delay, true, "green") --nil=yellow, "red", "orange", "green"
	--EncounterGroundAOEWarningStickyOnUnit(victim, 80, delay)
	--EncounterGroundAOEWarningStickyOnUnit(friend, 80, delay)

	local interval = 0.1

	local timer = Timers:CreateTimer(delay, function()

		-- Create Particle --
		local particle = ParticleManager:CreateParticle("particles/encounter/structures_of_xunra/structures_of_xunra_linked_obelisks_beam_1.vpcf", PATTACH_POINT_FOLLOW, friend)
		ParticleManager:SetParticleControlEnt( particle, 0, friend, PATTACH_POINT_FOLLOW, "attach_hitloc", friend:GetAttachmentOrigin(friend:ScriptLookupAttachment("attach_hitloc")), true)
		ParticleManager:SetParticleControlEnt( particle, 1, victim, PATTACH_POINT_FOLLOW, "attach_hitloc", victim:GetAttachmentOrigin(victim:ScriptLookupAttachment("attach_attack1")), true)
		ParticleManager:SetParticleControl( particle, 10, Vector(1,0,0) )
		ParticleManager:SetParticleControl( particle, 11, Vector(1,0,0) )
		PersistentParticle_Add(particle)

		local caster_health = caster:GetHealthPercent()

		local timer1 = Timers:CreateTimer(0, function()

			local abort = false

			if caster == nil then abort = true end
			if friend == nil then abort = true end
			if caster:IsNull() then abort = true end
			if friend:IsNull() then abort = true end
			if not caster:IsAlive() then abort = true end
			if not friend:IsAlive() then abort = true end

			if abort or caster_health - caster:GetHealthPercent() >= hp_loss_to_cancel_percentage then

				ParticleManager:DestroyParticle( particle, false )
				ParticleManager:ReleaseParticleIndex( particle )
				particle = nil

				return
			end

			-- Apply Damage --
			EncounterApplyDamage(victim, caster, self, (damage/duration)*interval, DAMAGE_TYPE_MAGICAL, DOTA_DAMAGE_FLAG_HPLOSS)

			-- Apply Heal --
			friend:Heal( friend:GetMaxHealth() * ( (heal_percentage/duration) / 100 ) * interval, self)

			return interval
		end)
		PersistentTimer_Add(timer1)

		local timer2 = Timers:CreateTimer(duration, function()

				if particle ~= nil then
					ParticleManager:DestroyParticle( particle, false )
					ParticleManager:ReleaseParticleIndex( particle )
					particle = nil
				end

				if timer1 ~= nil then
					Timers:RemoveTimer(timer1)
					timer1 = nil
				end

		end)
		PersistentTimer_Add(timer2)


	end)
	PersistentTimer_Add(timer)

end

function structures_of_xunra_unholy_warlock_transfer_energy:OnAbilityPhaseStart()
	local caster			= self:GetCaster()
	local playerID			= caster:GetPlayerOwnerID()
	local player			= PlayerResource:GetPlayer(playerID)

	return true
end

function structures_of_xunra_unholy_warlock_transfer_energy:GetManaCost(abilitylevel)
	return self.BaseClass.GetManaCost(self, abilitylevel)
end

function structures_of_xunra_unholy_warlock_transfer_energy:GetCooldown(abilitylevel)
	return self.BaseClass.GetCooldown(self, abilitylevel)
end