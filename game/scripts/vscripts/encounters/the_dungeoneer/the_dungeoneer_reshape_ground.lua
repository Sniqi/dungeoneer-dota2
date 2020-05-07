the_dungeoneer_reshape_ground = class({})

LinkLuaModifier( 'the_dungeoneer_reshaped_ground_poison_modifier', 'encounters/the_dungeoneer/the_dungeoneer_reshaped_ground_poison_modifier', LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( 'the_dungeoneer_reshaped_ground_ice_modifier', 'encounters/the_dungeoneer/the_dungeoneer_reshaped_ground_ice_modifier', LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( 'the_dungeoneer_reshaped_ground_earth_modifier', 'encounters/the_dungeoneer/the_dungeoneer_reshaped_ground_earth_modifier', LUA_MODIFIER_MOTION_NONE )

function the_dungeoneer_reshape_ground:OnSpellStart()

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
	local AoERadius                   = self:GetSpecialValueFor("AoERadius")
	local duration                    = self:GetSpecialValueFor("duration")
	local damage                      = self:GetSpecialValueFor("damage")
	local damage_interval             = self:GetSpecialValueFor("damage_interval")
	local delay                       = self:GetSpecialValueFor("delay")
	local ice_move_speed_percentage   = self:GetSpecialValueFor("ice_move_speed_percentage")
	local earth_stun_interval         = self:GetSpecialValueFor("earth_stun_interval")
	local earth_stun_duration         = self:GetSpecialValueFor("earth_stun_duration")

	caster:AddNewModifier(caster, self, "casting_rooted_modifier", {duration=delay})
	DisableMotionControllers(caster, delay)

	caster:Stop()

	local timer1 = Timers:CreateTimer(0, function()
		victim_loc = victim:GetAbsOrigin()
		caster:FaceTowards(victim_loc)

		return 0.03
	end)
	PersistentTimer_Add(timer1)

	-- Sound and Animation --
	local sound = {"grimstroke_grimstroke_spawn_11", "grimstroke_grimstroke_spawn_13",
					"grimstroke_grimstroke_spawn_06", "grimstroke_grimstroke_battlebegins_02"}
	EmitAnnouncerSound( sound[RandomInt(1, #sound)] )

	StartAnimation(caster, {duration=delay, activity=ACT_DOTA_RUN, translate="haste", rate=1.0})


	local timer2 = Timers:CreateTimer(delay, function()

		Timers:RemoveTimer(timer1)
		timer1 = nil

		StartAnimation(caster, {duration=1.0, activity=ACT_DOTA_CAST_ABILITY_1, translate=nil, rate=1.00})

		local random = RandomInt(1, 3)

		local rad = 25

		local projectile_start = -2
		local projectile_end = 2

		for i=projectile_start,projectile_end do

			local direction

			direction = RotateVector2D(caster:GetForwardVector(),math.rad(i*rad))

			EncounterGroundConeWarning(caster, AoERadius/3, AoERadius, caster_loc, direction, AbilityCastRange, delay+duration)

			if i == 0 then
				-- Sound --
				caster:EmitSound("Hero_Chen.TestOfFaith.Cast")
			end

			-- Particle --
			local data = {}
			data["0"] = "LOCATION"
			data["1"] = "LOCATION"
			EncounterGroundConeParticle(caster, AoERadius/3, AoERadius, caster_loc, direction, AbilityCastRange, delay, "particles/units/heroes/hero_enigma/enigma_ambient_body.vpcf", data)

			local timer = Timers:CreateTimer(delay, function()

				if i == 0 then
					-- Sound --
					caster:EmitSound("Hero_Chen.HolyPersuasionCast")
				end

				-- Particle --
				local data = {}
				data["0"] = "LOCATION"
				data["1"] = "LOCATION"
				data["2"] = "LOCATION"
				EncounterGroundConeParticle(caster, AoERadius/3, AoERadius, caster_loc, direction, AbilityCastRange, 2.0, "particles/econ/items/zeus/arcana_chariot/zeus_arcana_kill_explosion.vpcf", data)

				local timer3

				if random == 1 then

					-- Particle --
					local data = {}
					data["0"] = "LOCATION"
					local particle_path = "particles/econ/items/viper/viper_ti7_immortal/viper_poison_debuff_ti7.vpcf"
					EncounterGroundConeParticle(caster, AoERadius/3, AoERadius, caster_loc, direction, AbilityCastRange, duration, particle_path, data)

					timer3 = Timers:CreateTimer(0, function()

						-- DOTA_UNIT_TARGET_TEAM_FRIENDLY; DOTA_UNIT_TARGET_TEAM_ENEMY; DOTA_UNIT_TARGET_TEAM_BOTH
						local units	= EncounterGroundConeFindUnits(caster, AoERadius/3, AoERadius, caster_loc, direction, AbilityCastRange, team, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE)
						for _,victim in pairs(units) do
							-- Modifier --
							victim:AddNewModifier(caster, self, "the_dungeoneer_reshaped_ground_poison_modifier", {duration = damage_interval-0.1})

							-- Apply Damage --
							EncounterApplyDamage(victim, caster, self, damage*damage_interval, DAMAGE_TYPE_MAGICAL, DOTA_DAMAGE_FLAG_NONE)
						end

						return damage_interval
					end)
					PersistentTimer_Add(timer3)

				elseif random == 2 then

					-- Particle --
					local data = {}
					data["0"] = "LOCATION"
					local particle_path = "particles/econ/items/pudge/pudge_arcana/ice/pudge_arcana_dismember_ground_ice.vpcf"
					EncounterGroundConeParticle(caster, AoERadius/3, AoERadius, caster_loc, direction, AbilityCastRange, duration, particle_path, data)

					timer3 = Timers:CreateTimer(0, function()

						-- DOTA_UNIT_TARGET_TEAM_FRIENDLY; DOTA_UNIT_TARGET_TEAM_ENEMY; DOTA_UNIT_TARGET_TEAM_BOTH
						local units	= EncounterGroundConeFindUnits(caster, AoERadius/3, AoERadius, caster_loc, direction, AbilityCastRange, team, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE)
						for _,victim in pairs(units) do
							-- Modifier --
							victim:AddNewModifier(caster, self, "the_dungeoneer_reshaped_ground_ice_modifier", {duration = damage_interval-0.1})

							-- Apply Damage --
							EncounterApplyDamage(victim, caster, self, damage*damage_interval, DAMAGE_TYPE_MAGICAL, DOTA_DAMAGE_FLAG_NONE)
						end

						return damage_interval
					end)
					PersistentTimer_Add(timer3)

				elseif random == 3 then

					-- Particle --
					local data = {}
					data["0"] = "LOCATION"
					data["1"] = "LOCATION"
					local particle_path = "particles/econ/items/earthshaker/earthshaker_gravelmaw/earthshaker_fissure_beam_gravelmaw.vpcf"
					EncounterGroundConeParticle(caster, AoERadius/3, AoERadius, caster_loc, direction, AbilityCastRange, duration, particle_path, data)

					local count = 0
					timer3 = Timers:CreateTimer(0, function()

						if count % (earth_stun_interval*10) == 0 then
							-- Particle --
							local data = {}
							data["0"] = "LOCATION"
							local particle_path = "particles/econ/items/earthshaker/earthshaker_totem_ti6/earthshaker_totem_ti6_leap_impact.vpcf"
							EncounterGroundConeParticle(caster, AoERadius/3, AoERadius, caster_loc, direction, AbilityCastRange, duration, particle_path, data)
						end

						-- DOTA_UNIT_TARGET_TEAM_FRIENDLY; DOTA_UNIT_TARGET_TEAM_ENEMY; DOTA_UNIT_TARGET_TEAM_BOTH
						local units	= EncounterGroundConeFindUnits(caster, AoERadius/3, AoERadius, caster_loc, direction, AbilityCastRange, team, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE)
						for _,victim in pairs(units) do
							-- Modifier --
							victim:AddNewModifier(caster, self, "the_dungeoneer_reshaped_ground_earth_modifier", {duration = damage_interval-0.1})

							-- Apply Damage --
							EncounterApplyDamage(victim, caster, self, damage*damage_interval, DAMAGE_TYPE_MAGICAL, DOTA_DAMAGE_FLAG_NONE)

							if count % (earth_stun_interval*10) == 0 then
								victim:AddNewModifier(caster, self, "modifier_stunned", {duration = earth_stun_duration})
							end
						end

						count = count + (damage_interval*10)
						return damage_interval
					end)
					PersistentTimer_Add(timer3)

				end

				local timer4 = Timers:CreateTimer(duration+0.05, function()

					Timers:RemoveTimer(timer3)
					timer3 = nil

				end)

			end)
			PersistentTimer_Add(timer)

		end

	end)
	PersistentTimer_Add(timer2)

end

function the_dungeoneer_reshape_ground:OnAbilityPhaseStart()
	local caster			= self:GetCaster()
	local playerID			= caster:GetPlayerOwnerID()
	local player			= PlayerResource:GetPlayer(playerID)

	return true
end

function the_dungeoneer_reshape_ground:GetManaCost(abilitylevel)
	return self.BaseClass.GetManaCost(self, abilitylevel)
end

function the_dungeoneer_reshape_ground:GetCooldown(abilitylevel)
	return self.BaseClass.GetCooldown(self, abilitylevel)
end