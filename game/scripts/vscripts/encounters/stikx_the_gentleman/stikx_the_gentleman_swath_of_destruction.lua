stikx_the_gentleman_swath_of_destruction = class({})

function stikx_the_gentleman_swath_of_destruction:OnSpellStart()

	--- Get Caster, Victim, Player, Point ---
	local caster		= self:GetCaster()
	local caster_loc	= caster:GetAbsOrigin()
	local playerID		= caster:GetPlayerOwnerID()
	local player		= PlayerResource:GetPlayer(playerID)
	local team			= caster:GetTeamNumber()
	local victim		= caster
	local victim_loc	= victim:GetAbsOrigin()
	
	--- Get Special Values ---
	local AoERadius                   = self:GetSpecialValueFor("AoERadius")
	local duration                    = self:GetSpecialValueFor("duration")
	local damage                      = self:GetSpecialValueFor("damage")
	local damage_duration             = self:GetSpecialValueFor("damage_duration")
	local damage_interval             = self:GetSpecialValueFor("damage_interval")
	local delay                       = self:GetSpecialValueFor("delay")
	local source_move_speed           = self:GetSpecialValueFor("source_move_speed")
	local source_damage_percentage    = self:GetSpecialValueFor("source_damage_percentage")
	local source_damage_interval      = self:GetSpecialValueFor("source_damage_interval")

	local loc_start = RandomLocationMinDistance( GetSpecificBorderPoint("point_center"), 1000*RandomFloat(0.1, 1.0))
	local loc_end = GetRandomBorderPoint()

	caster:AddNewModifier(caster, self, "casting_rooted_modifier", {duration=delay})
	DisableMotionControllers(caster, delay)

	-- Sound and Animation --
	local sound = {"monkey_king_monkey_doubledam_02", "monkey_king_monkey_arcane_02",
					"monkey_king_monkey_haste_01", "monkey_king_monkey_illus_01"}
	EmitAnnouncerSound( sound[RandomInt(1, #sound)] )
	
	StartAnimation(caster, {duration=delay, activity=ACT_DOTA_SPAWN, rate=0.75})

	local unit = CreateUnitByName("swath_of_destruction", loc_start, true, nil, nil, DOTA_TEAM_BADGUYS)
	PersistentUnit_Add(unit)

	unit:AddNewModifier(caster, self, "modifier_invulnerable", {})
	unit:AddNewModifier(caster, self, "modifier_attack_immune", {})
	unit:AddNewModifier(caster, self, "modifier_unselectable", {})
	unit:AddNewModifier(caster, self, "modifier_phased", {})
	
	EncounterGroundAOEWarningSticky(loc_start, AoERadius, delay+0.1)

	local timer1 = Timers:CreateTimer(delay, function()

		local loc = unit:GetAbsOrigin()

		unit:Stop()
		unit:MoveToPosition(loc_end)

		-- Particle --
		local particle_source = ParticleManager:CreateParticle("particles/econ/items/dazzle/dazzle_dark_light_weapon/dazzle_dark_shallow_grave_ground.vpcf", PATTACH_ABSORIGIN_FOLLOW, unit)
		ParticleManager:SetParticleControlEnt( particle_source, 3, unit, PATTACH_POINT_FOLLOW, "attach_hitloc", unit:GetAttachmentOrigin(unit:ScriptLookupAttachment("attach_hitloc")), true)
		PersistentParticle_Add(particle_source)

		local timer_source = Timers:CreateTimer(0, function()

				local loc = unit:GetAbsOrigin()

				EncounterGroundAOEWarningSticky(loc, AoERadius, source_damage_interval)

				-- DOTA_UNIT_TARGET_TEAM_FRIENDLY; DOTA_UNIT_TARGET_TEAM_ENEMY; DOTA_UNIT_TARGET_TEAM_BOTH
				local units	= FindUnitsInRadius(team, loc, nil, AoERadius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
				for _,victim in pairs(units) do

					-- Apply Damage --
					EncounterApplyDamage(victim, caster, self, source_damage_percentage*source_damage_interval, DAMAGE_TYPE_MAGICAL, DOTA_DAMAGE_FLAG_NONE)

				end

			return source_damage_interval
		end)
		PersistentTimer_Add(timer_source)

		-- Source Sound --
		local timer_source_snd = Timers:CreateTimer(0, function()

			local loc = unit:GetAbsOrigin()

			StartSoundEventFromPositionReliable("Hero_Mirana.Starstorm.Impact", loc)

			return 0.8
		end)
		PersistentTimer_Add(timer_source_snd)

		-- Source Movement --
		local timer_source_move = Timers:CreateTimer(6.0, function()

			loc_end = GetRandomBorderPointCounterpart(loc_end)

			unit:MoveToPosition( GetRandomBorderPointCounterpart(loc_end) )

			return 6.0
		end)
		PersistentTimer_Add(timer_source_move)

		local particle_ground = {}
		local timers_ground = {}
		-- Burning Ground --
		local timer_ground = Timers:CreateTimer(0, function()

			local loc = unit:GetAbsOrigin()

			-- Particle --
			local particle = ParticleManager:CreateParticle("particles/econ/items/earthshaker/earthshaker_gravelmaw/earthshaker_fissure_beam_gravelmaw.vpcf", PATTACH_CUSTOMORIGIN, nil)
			ParticleManager:SetParticleControl( particle, 0, loc - (unit:GetForwardVector()*(AoERadius/2)) )
			ParticleManager:SetParticleControl( particle, 1, loc + (unit:GetForwardVector()*(AoERadius/2)) )
			PersistentParticle_Add(particle)
			table.insert(particle_ground, particle)

			local timer = Timers:CreateTimer(0, function()

				EncounterGroundAOEWarning(loc, AoERadius)

				-- DOTA_UNIT_TARGET_TEAM_FRIENDLY; DOTA_UNIT_TARGET_TEAM_ENEMY; DOTA_UNIT_TARGET_TEAM_BOTH
				local units	= FindUnitsInRadius(team, loc, nil, AoERadius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
				for _,victim in pairs(units) do

					-- Apply Damage --
					EncounterApplyDamage(victim, caster, self, damage*damage_interval, DAMAGE_TYPE_MAGICAL, DOTA_DAMAGE_FLAG_NONE)

				end

				return damage_interval
			end)
			PersistentTimer_Add(timer)
			table.insert(timers_ground, timer)

			return AoERadius / unit:GetBaseMoveSpeed()
		end)
		PersistentTimer_Add(timer_ground)
		
		-- Clean up after duration --
		local timer2 = Timers:CreateTimer(duration, function()

			Timers:RemoveTimer(timer_source)
			timer_source = nil

			Timers:RemoveTimer(timer_source_snd)
			timer_source_snd = nil

			Timers:RemoveTimer(timer_source_move)
			timer_source_move = nil

			Timers:RemoveTimer(timer_ground)
			timer_ground = nil

			for _,particle in pairs(particle_ground) do
				ParticleManager:DestroyParticle( particle, false )
				ParticleManager:ReleaseParticleIndex( particle )
				particle = nil
			end

			for _,timer in pairs(timers_ground) do
				Timers:RemoveTimer(timer)
				timer = nil
			end

			ParticleManager:DestroyParticle( particle_source, false )
			ParticleManager:ReleaseParticleIndex( particle_source )
			particle_source = nil

			unit:RemoveSelf()

		end)
		PersistentTimer_Add(timer2)

		
	end)
	PersistentTimer_Add(timer1)

end

function stikx_the_gentleman_swath_of_destruction:OnAbilityPhaseStart()
	local caster			= self:GetCaster()
	local playerID			= caster:GetPlayerOwnerID()
	local player			= PlayerResource:GetPlayer(playerID)

	return true
end

function stikx_the_gentleman_swath_of_destruction:GetManaCost(abilitylevel)
	return self.BaseClass.GetManaCost(self, abilitylevel)
end

function stikx_the_gentleman_swath_of_destruction:GetCooldown(abilitylevel)
	return self.BaseClass.GetCooldown(self, abilitylevel)
end