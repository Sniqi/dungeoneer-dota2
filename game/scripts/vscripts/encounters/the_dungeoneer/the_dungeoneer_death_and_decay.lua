the_dungeoneer_death_and_decay = class({})

LinkLuaModifier( 'the_dungeoneer_death_and_decay_modifier', 'encounters/the_dungeoneer/the_dungeoneer_death_and_decay_modifier', LUA_MODIFIER_MOTION_NONE )

function the_dungeoneer_death_and_decay:OnSpellStart()

	--- Get Caster, Victim, Player, Point ---
	local caster		= self:GetCaster()
	local caster_loc	= caster:GetAbsOrigin()
	local playerID		= caster:GetPlayerOwnerID()
	local player		= PlayerResource:GetPlayer(playerID)
	local team			= caster:GetTeamNumber()
	
	--- Get Special Values ---
	local duration                    = self:GetSpecialValueFor("duration")
	local damage                      = self:GetSpecialValueFor("damage")
	local damage_interval             = self:GetSpecialValueFor("damage_interval")
	local delay                       = self:GetSpecialValueFor("delay")
	local move_speed_max              = self:GetSpecialValueFor("move_speed_max")

	local AoERadius = 250
	local AbilityCastRange = 4200

	caster:AddNewModifier(caster, self, "casting_rooted_modifier", {duration=delay+duration})

	caster:Stop()

	caster:FaceTowards( caster_loc + Vector(25, 0, 0) )

	-- Sound and Animation --
	local sound = {"grimstroke_grimstroke_spawn_14", "grimstroke_grimstroke_spawn_03_02",
					"grimstroke_grimstroke_spawn_04", "grimstroke_grimstroke_spawn_08"}
	EmitAnnouncerSound( sound[RandomInt(1, #sound)] )

	StartAnimation(caster, {duration=delay, activity=ACT_DOTA_STUN_STATUE, rate=0.8})

	-- Port Players to top, silenece/mute/disarm, slow
	for _,victim in pairs( GetHeroesAliveEntities() ) do
		local real_duration = duration + (0.75*(duration/0.75) )

		-- Particle --
		local particle = ParticleManager:CreateParticle("particles/econ/events/ti6/teleport_end_ti6_ground_flash.vpcf", PATTACH_ABSORIGIN, victim)
		ParticleManager:SetParticleControl( particle, 0, victim:GetAbsOrigin() )
		PersistentParticle_Add(particle)

		-- Sound --
		victim:EmitSound("Hero_QueenOfPain.Blink_out")

		local timer = Timers:CreateTimer(2.0, function()
			ParticleManager:DestroyParticle( particle, false )
			ParticleManager:ReleaseParticleIndex( particle )
			particle = nil
		end)
		PersistentTimer_Add(timer)

		-- Modifier --
		victim:AddNewModifier(caster, self, "the_dungeoneer_death_and_decay_modifier", {duration = real_duration })
		victim:AddNewModifier(caster, self, "modifier_silence", {duration = real_duration })
		victim:AddNewModifier(caster, self, "modifier_muted", {duration = real_duration })
		victim:AddNewModifier(caster, self, "modifier_disarmed", {duration = real_duration })
		victim:AddNewModifier(caster, self, "modifier_phased", {duration = real_duration })

		local location = GetSpecificBorderPoint("point_top")
		FindClearSpaceForUnit(victim, location, false)

		-- Camera --
		PlayerResource:SetCameraTarget(victim:GetPlayerOwnerID(), victim)
		Timers:CreateTimer(0.10, function()
			PlayerResource:SetCameraTarget(victim:GetPlayerOwnerID(), nil)
		end)

	end

	-- Port to top left, facing right, disable turning
	local location = GetSpecificBorderPoint("point_top_left") + Vector(-250, 250, 0)
	FindClearSpaceForUnit(caster, location, false)

	local timer = Timers:CreateTimer(0.1, function()
		caster:FaceTowards( caster:GetAbsOrigin() + Vector(25, 0, 0) )
		caster:AddNewModifier(caster, self, "casting_no_turning_modifier", {duration=delay+duration-0.1})
	end)
	PersistentTimer_Add(timer)

	local numOfLines = math.floor(CalcDistanceToLineSegment2D( GetSpecificBorderPoint("point_top"), GetSpecificBorderPoint("point_bottom"), GetSpecificBorderPoint("point_bottom")) / AoERadius) + 1

	-- Delay
	local timer1 = Timers:CreateTimer(delay, function()

		local safe_zone
		local old_safe_zone = nil

		-- Main Loop, line by line, every 0.75s
		local count_line = 0
		local timer2 = Timers:CreateTimer(0, function()

			caster:AddNewModifier(caster, self, "casting_rooted_modifier", {duration=duration*2})

			location = caster:GetAbsOrigin() + Vector(0, -AoERadius, 0)
			FindClearSpaceForUnit(caster, location, false)
			caster:FaceTowards( caster:GetAbsOrigin() + Vector(25, 0, 0) )

			-- Sound --
			caster:EmitSound("Hero_QueenOfPain.Blink_out")

			StartAnimation(caster, {duration=delay, activity=ACT_DOTA_CAST_ABILITY_3, translate=nil, rate=0.8})

			-- Particle --
			local particle = ParticleManager:CreateParticle("particles/econ/events/ti6/teleport_end_ti6_ground_flash.vpcf", PATTACH_ABSORIGIN, caster)
			ParticleManager:SetParticleControl( particle, 0, caster:GetAbsOrigin() )
			PersistentParticle_Add(particle)

			local timer = Timers:CreateTimer(2.0, function()
				ParticleManager:DestroyParticle( particle, false )
				ParticleManager:ReleaseParticleIndex( particle )
				particle = nil
			end)
			PersistentTimer_Add(timer)



			local warnings_steps = AoERadius
			local warnings_count = AbilityCastRange / warnings_steps

			if old_safe_zone ~= nil then
				local random
				if RandomInt(0, 1) == 0 then
					random = 1
				else
					random = -1
				end
				safe_zone = safe_zone + random
			else
				safe_zone = math.floor(warnings_count/2)
			end

			old_safe_zone = safe_zone

			-- Fill the board, every 0.03s
			local count = 0
			local timer = Timers:CreateTimer(0, function()

				local loc = location + ( (caster:GetForwardVector() * warnings_steps) * count )
				loc = loc * Vector(1,1,0)
				loc = loc + ( GetGroundPosition(loc, caster) * Vector(0,0,1) )

				-- Damage Zone
				if count ~= safe_zone and count ~= safe_zone+1 and count ~= safe_zone-1 then
					EncounterGroundAOEWarningSticky( loc, AoERadius, 1.0)--duration + (0.75 * count) )

					-- 1s delay for Particle & Damage
					local timer1 = Timers:CreateTimer(1.0, function()

						-- Particle --
						local particle = ParticleManager:CreateParticle("particles/encounter/the_dungeoneer/the_dungeoneer_death_and_decay.vpcf", PATTACH_CUSTOMORIGIN, nil)
						ParticleManager:SetParticleControl( particle, 0, loc )
						PersistentParticle_Add(particle)

						-- Damage loop
						local timer2 = Timers:CreateTimer(0, function()

							local units	= FindUnitsInRadius(team, loc, nil, AoERadius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
							for _,victim in pairs(units) do
								-- Apply Damage --
								EncounterApplyDamage(victim, caster, self, damage*damage_interval, DAMAGE_TYPE_MAGICAL, DOTA_DAMAGE_FLAG_NONE)
							end

							return damage_interval
						end)
						PersistentTimer_Add(timer2)

						-- Garbage collection
						local timer3 = Timers:CreateTimer( duration + (0.75 * ( duration/0.75 ) ) - 1.0, function()
							ParticleManager:DestroyParticle( particle, false )
							ParticleManager:ReleaseParticleIndex( particle )
							particle = nil

							Timers:RemoveTimer(timer2)
							timer2 = nil
						end)
						PersistentTimer_Add(timer3)

					end)
					PersistentTimer_Add(timer1)


				else

					-- Skip last damage zone
					if count_line ~= numOfLines and count_line ~= numOfLines-1 and count_line ~= numOfLines-2 then

						-- Safe zone
						local timer3 = Timers:CreateTimer(delay, function()

							-- Particle --
							local particle = ParticleManager:CreateParticle("particles/encounter/the_dungeoneer/the_dungeoneer_death_and_decay.vpcf", PATTACH_CUSTOMORIGIN, nil)
							ParticleManager:SetParticleControl( particle, 0, loc )
							PersistentParticle_Add(particle)

							-- Damage loop
							local timer2 = Timers:CreateTimer(0, function()

								local units	= FindUnitsInRadius(team, loc, nil, AoERadius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
								for _,victim in pairs(units) do
									-- Apply Damage --
									EncounterApplyDamage(victim, caster, self, damage*damage_interval, DAMAGE_TYPE_MAGICAL, DOTA_DAMAGE_FLAG_NONE)
								end

								return damage_interval
							end)
							PersistentTimer_Add(timer2)

							-- Garbage collection
							local timer3 = Timers:CreateTimer( duration + (0.75 * ( duration/0.75) ) - delay, function()
								ParticleManager:DestroyParticle( particle, false )
								ParticleManager:ReleaseParticleIndex( particle )
								particle = nil

								Timers:RemoveTimer(timer2)
								timer2 = nil
							end)
							PersistentTimer_Add(timer3)

						end)
						PersistentTimer_Add(timer3)

					end

				end

				count = count + 1
				if count >= warnings_count then
					return
				else
					return 0.03
				end
			end)
			PersistentTimer_Add(timer)

			local timer4 = Timers:CreateTimer(duration*1.25, function()
				Timers:RemoveTimer(timer)
				timer = nil
			end)
			PersistentTimer_Add(timer4)




			count_line = count_line + 1
			return 0.75
		end)
		PersistentTimer_Add(timer2)

		local timer = Timers:CreateTimer(0.75 * numOfLines, function()
			Timers:RemoveTimer(timer2)
			timer2 = nil

			local location = GetSpecificBorderPoint("point_top")
			FindClearSpaceForUnit(caster, location, false)
		end)
		PersistentTimer_Add(timer)

	end)
	PersistentTimer_Add(timer1)	
	
end

function the_dungeoneer_death_and_decay:OnAbilityPhaseStart()
	local caster			= self:GetCaster()
	local playerID			= caster:GetPlayerOwnerID()
	local player			= PlayerResource:GetPlayer(playerID)

	return true
end

function the_dungeoneer_death_and_decay:GetManaCost(abilitylevel)
	return self.BaseClass.GetManaCost(self, abilitylevel)
end

function the_dungeoneer_death_and_decay:GetCooldown(abilitylevel)
	return self.BaseClass.GetCooldown(self, abilitylevel)
end