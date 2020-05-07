function ChallengerMode_CastAnyBossSpell(ability, boss_readable, boss, abilityindex, duration, hidden)

	--- Get Caster, Victim, Player, Point ---
	local caster		= ability:GetCaster()
	local caster_loc	= caster:GetAbsOrigin()
	local playerID		= caster:GetPlayerOwnerID()
	local player		= PlayerResource:GetPlayer(playerID)
	local team			= caster:GetTeamNumber()

	local delay = 0.0

	local location = RandomLocationMinDistance( GetSpecificBorderPoint("point_center"), 600)

	-- Sound and Animation --
	local sound = {"grimstroke_grimstroke_spawn_12", "grimstroke_grimstroke_ability1_01",
					"grimstroke_grimstroke_ability1_02", "grimstroke_grimstroke_ability2_07"}
	--EmitAnnouncerSound( sound[RandomInt(1, #sound)] )

	-- Sound --
	if not hidden then 
		local unit_loc = location
		local dummy_unit_sound = CreateUnitByName("dummy", unit_loc, true, nil, nil, DOTA_TEAM_BADGUYS)
		PersistentUnit_Add(dummy_unit_sound)
		--dummy_unit_sound:AddNewModifier(dummy_unit_sound, nil, "modifier_invulnerable", {})
		--dummy_unit_sound:AddNewModifier(dummy_unit_sound, nil, "modifier_unselectable", {})
		dummy_unit_sound:AddNewModifier(dummy_unit_sound, nil, "modifier_dummy", {})
		dummy_unit_sound:AddNewModifier(dummy_unit_sound, nil, "modifier_phased", {})

		StartSoundEventReliable("Hero_Enigma.Midnight_Pulse", dummy_unit_sound )
	end

	-- Particle --
	if not hidden then 
		local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_rubick/rubick_blackhole_l.vpcf", PATTACH_CUSTOMORIGIN, nil)
		ParticleManager:SetParticleControl( particle, 0, location )
		ParticleManager:SetParticleControl( particle, 1, location )
		PersistentParticle_Add(particle)
	end

	local timer = Timers:CreateTimer(delay, function()

		-- Particle --
		if not hidden then 
			ParticleManager:DestroyParticle( particle, false )
			ParticleManager:ReleaseParticleIndex( particle )
			particle = nil
		end

		local sound = {"grimstroke_grimstroke_laugh_03", "grimstroke_grimstroke_laugh_04",
						"grimstroke_grimstroke_laugh_05", "grimstroke_grimstroke_laugh_06"}
		--EmitAnnouncerSound( sound[RandomInt(1, #sound)] )

		if not hidden then 
			StartAnimation(caster, {duration=1.25, activity=ACT_DOTA_TELEPORT_END, rate=0.8})
		end

		-- Sound --
		if not hidden then 
			StopSoundEvent("Hero_Enigma.Midnight_Pulse", dummy_unit_sound )
		end
		--StartSoundEventReliable("Hero_Enigma.Black_Hole", dummy_unit_sound )

		-- Particle --
		if not hidden then 
			local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_rubick/rubick_blackhole.vpcf", PATTACH_CUSTOMORIGIN, nil)
			ParticleManager:SetParticleControl( particle, 0, location )
			PersistentParticle_Add(particle)
		end

		-- logic
		local unit_loc = location
		local unit = CreateUnitByName(boss, unit_loc, true, nil, nil, DOTA_TEAM_BADGUYS)
		PersistentUnit_Add(unit)
		EncounterCreate_AttackDamage(unit)
		EncounterCreate_Health(unit)

		unit.the_dungeoneer_time_warp = true

		unit:AddNewModifier(unit, nil, "modifier_invulnerable", {})
		unit:AddNewModifier(unit, nil, "modifier_unselectable", {})
		unit:AddNewModifier(unit, nil, "modifier_flying_for_pathing", {})
		if hidden then unit:AddNewModifier(unit, nil, "modifier_special_invis", {}) end

		unit:AddExperience(10000, 0, false, true)
		EncounterCreate_AbilitiesLvlUp(unit, 1)

		local chosen_ability = unit:GetAbilityByIndex( abilityindex )
		--[[
		local chosen_ability_duration = chosen_ability:GetSpecialValueFor("duration")
		local chosen_ability_delay = chosen_ability:GetSpecialValueFor("delay")

		if chosen_ability:GetAbilityName() == "ancient_siege_engine_earthen_spike" or
			chosen_ability:GetAbilityName() == "stikx_the_gentleman_swath_of_destruction" or
			chosen_ability:GetAbilityName() == "treasure_on_a_tree_green_mines" or
			chosen_ability:GetAbilityName() == "treasure_on_a_tree_golden_shield" or
			chosen_ability:GetAbilityName() == "treasure_on_a_tree_cursed_gold"

			then chosen_ability_duration = 2.0 end

		local duration = tonumber(chosen_ability_duration) + tonumber(chosen_ability_delay)
		if duration == 0 then duration = 2 end
		duration = duration + 2
		]]

		local order = {
			UnitIndex = unit:entindex(),
			AbilityIndex = chosen_ability:entindex(),
			OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
			Queue = false
		}
		ExecuteOrderFromTable(order)

		--caster:AddNewModifier(caster, ability, "casting_rooted_modifier", {duration=duration})

		-- Create Particle --
		if not hidden then
			local particle_beam = ParticleManager:CreateParticle("particles/units/heroes/hero_pugna/pugna_life_drain.vpcf", PATTACH_POINT_FOLLOW, dummy_unit_sound)
			ParticleManager:SetParticleControlEnt( particle_beam, 0, dummy_unit_sound, PATTACH_POINT_FOLLOW, "attach_hitloc", dummy_unit_sound:GetAttachmentOrigin(dummy_unit_sound:ScriptLookupAttachment("attach_hitloc")), true)
			ParticleManager:SetParticleControlEnt( particle_beam, 1, unit, PATTACH_POINT_FOLLOW, "attach_hitloc", unit:GetAttachmentOrigin(unit:ScriptLookupAttachment("attach_hitloc")), true)
			ParticleManager:SetParticleControl( particle_beam, 11, Vector(1,0,0) )
			ParticleManager:SetParticleControl( particle_beam, 60, Vector(26,74,28) )
			ParticleManager:SetParticleControl( particle_beam, 61, Vector(255,0,0) )
		end

		-- after duration
		local timer1 = Timers:CreateTimer(duration, function()

			if not hidden then 
				-- Sound --
				--StopSoundEvent("Hero_Enigma.Black_Hole", dummy_unit_sound )
				--StartSoundEventReliable("Hero_Enigma.Black_Hole.Stop", caster)

				-- Particle --
				ParticleManager:DestroyParticle( particle, false )
				ParticleManager:ReleaseParticleIndex( particle )
				particle = nil

				-- Particle --
				ParticleManager:DestroyParticle( particle_beam, false )
				ParticleManager:ReleaseParticleIndex( particle_beam )
				particle_beam = nil
			end

			unit:AddNewModifier(unit, ability, "modifier_out_of_world", {})

			local timer2 = Timers:CreateTimer(0.75, function()
				unit:RemoveSelf()
				if not hidden then 
					dummy_unit_sound:RemoveSelf()
				end
			end)
			PersistentTimer_Add(timer2)

		end)
		PersistentTimer_Add(timer1)

	end)
	PersistentTimer_Add(timer)

end
