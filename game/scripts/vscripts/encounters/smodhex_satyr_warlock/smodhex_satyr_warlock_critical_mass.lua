smodhex_satyr_warlock_critical_mass = class({})

LinkLuaModifier( 'smodhex_satyr_warlock_critical_mass_modifier', 'encounters/smodhex_satyr_warlock/smodhex_satyr_warlock_critical_mass_modifier', LUA_MODIFIER_MOTION_NONE )

function smodhex_satyr_warlock_critical_mass:OnSpellStart()

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
	local AoERadius                   = self:GetSpecialValueFor("AoERadius")
	local damage                      = self:GetSpecialValueFor("damage")
	local delay                       = self:GetSpecialValueFor("delay")
	local stun                        = self:GetSpecialValueFor("stun")
	local phase_two_percentage        = self:GetSpecialValueFor("phase_two_percentage")
	local phase_two_damage_percentage = self:GetSpecialValueFor("phase_two_damage_percentage")
	local phase_two_damage_duration   = self:GetSpecialValueFor("phase_two_damage_duration")
	local phase_two_damage_interval   = self:GetSpecialValueFor("phase_two_damage_interval")
	local phase_two_aoe               = self:GetSpecialValueFor("phase_two_aoe")
	local phase_two_interval          = self:GetSpecialValueFor("phase_two_interval")

	caster:AddNewModifier(caster, self, "casting_rooted_modifier", {duration=1.5})
	DisableMotionControllers(caster, 1.5)
	
	TurnToLoc(caster, victim_loc, 1.5)

	EncounterGroundAOEWarningStickyOnUnit(victim, AoERadius, delay)

	-- Sound --
	local sound = {"leshrac_lesh_level_04", "leshrac_lesh_level_06",
					"leshrac_lesh_purch_02", "leshrac_lesh_ability_failure_01"}
	EmitAnnouncerSound( sound[RandomInt(1, #sound)] )

	-- Animation --
	StartAnimation(caster, {duration=2, activity=ACT_DOTA_CAST_ABILITY_1, rate=0.85})

	-- Particle --
	local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_stormspirit/stormspirit_electric_vortex.vpcf", PATTACH_ABSORIGIN_FOLLOW, victim)
	ParticleManager:SetParticleControl( particle, 0, caster_loc )
	ParticleManager:SetParticleControlEnt( particle, 1, victim, PATTACH_POINT_FOLLOW, "attach_hitloc", victim:GetAttachmentOrigin(victim:ScriptLookupAttachment("attach_hitloc")), true)
	PersistentParticle_Add(particle)

	-- Sound --
	victim:EmitSound("Hero_Invoker.EMP.Cast")

	-- Modifier --
	victim:AddNewModifier(caster, self, "smodhex_satyr_warlock_critical_mass_modifier", {duration = delay})

	local timer0 = Timers:CreateTimer(delay, function()

		local victim_loc = victim:GetAbsOrigin()

		-- Particle --
		ParticleManager:DestroyParticle( particle, false )
		ParticleManager:ReleaseParticleIndex( particle )
		particle = nil

		-- DOTA_UNIT_TARGET_TEAM_FRIENDLY; DOTA_UNIT_TARGET_TEAM_ENEMY; DOTA_UNIT_TARGET_TEAM_BOTH
		local units	= FindUnitsInRadius(team, victim_loc, nil, AoERadius, DOTA_UNIT_TARGET_TEAM_BOTH, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
		if units[2] ~= nil then

			-- Particle --
			local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_invoker/invoker_emp_explode.vpcf", PATTACH_ABSORIGIN, victim)
			ParticleManager:SetParticleControl( particle, 0, victim:GetAbsOrigin() )
			ParticleManager:ReleaseParticleIndex( particle )
			particle = nil

			-- Sound --
			victim:EmitSound("Hero_Invoker.EMP.Discharge")

			for _,victim in pairs(units) do
				if victim:GetTeamNumber() == DOTA_TEAM_GOODGUYS then
			
					-- Modifier --
					local modifier = victim:AddNewModifier(caster, self, "modifier_stunned", {duration=stun})
					PersistentModifier_Add(modifier)

					-- Apply Damage --
					EncounterApplyDamage(victim, caster, self, damage, DAMAGE_TYPE_MAGICAL, DOTA_DAMAGE_FLAG_NONE)

				end
			end

		else

		end


		-- PHASE 2 --
		if caster:GetHealthPercent() < phase_two_percentage then

			for i=1,3 do

				local location
				local timer1
				local particle

				local timer2 = Timers:CreateTimer(i*phase_two_interval, function()

					location = victim:GetAbsOrigin()

					EncounterGroundAOEWarningSticky(location, phase_two_aoe, phase_two_interval+1)

				end)
				PersistentTimer_Add(timer2)

				local timer3 = Timers:CreateTimer(i*(phase_two_interval+1), function()

					-- Particle --
					particle = ParticleManager:CreateParticle("particles/units/heroes/hero_enigma/enigma_blackhole_n.vpcf", PATTACH_CUSTOMORIGIN, nil)
					ParticleManager:SetParticleControl( particle, 0, location )
					ParticleManager:SetParticleControl( particle, 1, location )
					PersistentParticle_Add(particle)

					timer1 = Timers:CreateTimer(0, function()

						-- DOTA_UNIT_TARGET_TEAM_FRIENDLY; DOTA_UNIT_TARGET_TEAM_ENEMY; DOTA_UNIT_TARGET_TEAM_BOTH
						local units	= FindUnitsInRadius(team, location, nil, phase_two_aoe, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
						for _,victim in pairs(units) do

							local modifier = victim:FindModifierByName("smodhex_satyr_warlock_resisted_shadows_modifier")

							if modifier ~= nil then
								-- Particle --
								ParticleManager:DestroyParticle( particle, false )
								ParticleManager:ReleaseParticleIndex( particle )
								particle = nil

								Timers:RemoveTimer(timer1)
								timer1 = nil
							else
								-- Apply Damage --
								EncounterApplyDamage(victim, caster, self, phase_two_damage_percentage*phase_two_damage_interval, DAMAGE_TYPE_MAGICAL, DOTA_DAMAGE_FLAG_NONE)
							end

						end

						return phase_two_damage_interval
					end)
					PersistentTimer_Add(timer1)

				end)
				PersistentTimer_Add(timer3)

				local timer4 = Timers:CreateTimer( (i*phase_two_interval) + phase_two_damage_duration, function()
					-- Particle --
					ParticleManager:DestroyParticle( particle, false )
					ParticleManager:ReleaseParticleIndex( particle )
					particle = nil

					Timers:RemoveTimer(timer1)
					timer1 = nil
				end)
				PersistentTimer_Add(timer4)

			end
		end


	end)
	PersistentTimer_Add(timer0)

end

function smodhex_satyr_warlock_critical_mass:OnAbilityPhaseStart()
	local caster			= self:GetCaster()
	local playerID			= caster:GetPlayerOwnerID()
	local player			= PlayerResource:GetPlayer(playerID)

	return true
end

function smodhex_satyr_warlock_critical_mass:GetManaCost(abilitylevel)
	return self.BaseClass.GetManaCost(self, abilitylevel)
end

function smodhex_satyr_warlock_critical_mass:GetCooldown(abilitylevel)
	return self.BaseClass.GetCooldown(self, abilitylevel)
end