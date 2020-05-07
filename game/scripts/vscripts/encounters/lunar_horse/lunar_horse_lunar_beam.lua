lunar_horse_lunar_beam = class({})

LinkLuaModifier( 'lunar_horse_lunar_beam_modifier', 'encounters/lunar_horse/lunar_horse_lunar_beam_modifier', LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( 'lunar_horse_lunar_beam_turning_modifier', 'encounters/lunar_horse/lunar_horse_lunar_beam_turning_modifier', LUA_MODIFIER_MOTION_NONE )

function lunar_horse_lunar_beam:OnSpellStart()

	--- Get Caster, Victim, Player, Point ---
	local caster		= self:GetCaster()
	local caster_loc	= caster:GetAbsOrigin()
	local playerID		= caster:GetPlayerOwnerID()
	local player		= PlayerResource:GetPlayer(playerID)
	local team			= caster:GetTeamNumber()

	--- Get Special Values ---
	local AoERadius                   = self:GetSpecialValueFor("AoERadius")
	local duration                    = self:GetSpecialValueFor("duration")
	local damage                      = self:GetSpecialValueFor("damage")
	local damage_interval             = self:GetSpecialValueFor("damage_interval")
	local delay                       = self:GetSpecialValueFor("delay")
	local range                       = self:GetSpecialValueFor("range")
	local turn_speed_max_hp           = self:GetSpecialValueFor("turn_speed_max_hp")
	local turn_speed_min_hp           = self:GetSpecialValueFor("turn_speed_min_hp")
	local move_speed_absolute         = self:GetSpecialValueFor("move_speed_absolute")

	local turn_speed_range = turn_speed_max_hp - turn_speed_min_hp
	local turn_speed = turn_speed_min_hp + ( turn_speed_range * ( caster:GetHealthPercent() / 100 ) )
	if RollPercentage(50) then
		turn_speed = turn_speed * -1
	end

	local casting_modifier = caster:AddNewModifier(caster, self, "casting_modifier", {})
	local movement_modifier = caster:AddNewModifier(caster, self, "lunar_horse_lunar_beam_modifier", {})

	local loc = GetRandomBorderPoint()
	local loc_end

	caster:MoveToPosition(loc)

	local timer1 = Timers:CreateTimer(function()

		if (caster:GetAbsOrigin() - loc):Length2D() < 100 then

			caster_loc = caster:GetAbsOrigin()

			casting_modifier:Destroy()
			movement_modifier:Destroy()

			caster:AddNewModifier(caster, self, "casting_rooted_modifier", {duration=delay+duration})
			--DisableMotionControllers(caster, delay+duration)

			caster:Stop()

			local timer1 = Timers:CreateTimer(0.1, function()
				caster:FaceTowards( GetSpecificBorderPoint("point_center") )

				loc_end = caster:GetAbsOrigin() + ( caster:GetForwardVector() * Vector(range,range,1) ) + Vector(0,0,128)

				local timer = Timers:CreateTimer(delay/3, function()
					EncounterGroundLineWarning(caster, AoERadius, AoERadius, caster:GetAbsOrigin(), caster:GetForwardVector(), range, delay)
					caster:AddNewModifier(caster, self, "lunar_horse_lunar_beam_turning_modifier", {duration=duration})
				end)
				PersistentTimer_Add(timer)
			end)
			PersistentTimer_Add(timer1)

			local timer2 = Timers:CreateTimer(delay, function()

				-- Particle --
				local particle = ParticleManager:CreateParticle( "particles/econ/items/phoenix/phoenix_solar_forge/phoenix_sunray_solar_forge.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster )
				ParticleManager:SetParticleControlEnt( particle, 0, caster, PATTACH_POINT_FOLLOW, "attach_hitloc", caster:GetAbsOrigin(), true )
				ParticleManager:SetParticleControl( particle, 1, loc_end )
				ParticleManager:SetParticleControlEnt( particle, 9, caster, PATTACH_POINT_FOLLOW, "attach_hitloc", caster:GetAbsOrigin(), true )
				PersistentParticle_Add(particle)

				-- Sound --
				local sound = "Hero_Phoenix.SunRay.Beam"
				StartSoundEvent( sound, caster )

				local count = 0

				-- The Beam --
				local timer3 = Timers:CreateTimer(function()

					local direction = RotateVector2D( caster:GetForwardVector(),math.rad( turn_speed / 2 ) )
					caster:FaceTowards( caster:GetAbsOrigin() + direction )

					loc_end = caster:GetAbsOrigin() + ( caster:GetForwardVector() * Vector(range,range,1) ) + Vector(0,0,128)
					ParticleManager:SetParticleControl( particle, 1, loc_end )

					-- DOTA_UNIT_TARGET_TEAM_FRIENDLY; DOTA_UNIT_TARGET_TEAM_ENEMY; DOTA_UNIT_TARGET_TEAM_BOTH
					local units	= FindUnitsInLine(team, caster:GetAbsOrigin(), loc_end, nil, AoERadius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE)
					for _,victim in pairs(units) do

						-- Apply Damage --
						EncounterApplyDamage(victim, caster, self, damage*damage_interval, DAMAGE_TYPE_MAGICAL, DOTA_DAMAGE_FLAG_NONE)

					end

					count = count + 1
					return damage_interval
				end)
				PersistentTimer_Add(timer3)

				-- After Duration --
				local timer4 = Timers:CreateTimer(duration, function()
					Timers:RemoveTimer(timer3)
					timer3 = nil

					ParticleManager:DestroyParticle( particle , false )
					ParticleManager:ReleaseParticleIndex( particle )
					particle = nil

					StopSoundEvent( sound, caster )
				end)
				PersistentTimer_Add(timer4)

			end)
			PersistentTimer_Add(timer2)

			return
		end

		return 0.25
	end)
	PersistentTimer_Add(timer1)

end

function lunar_horse_lunar_beam:OnAbilityPhaseStart()
	local caster			= self:GetCaster()
	local playerID			= caster:GetPlayerOwnerID()
	local player			= PlayerResource:GetPlayer(playerID)

	return true
end

function lunar_horse_lunar_beam:GetManaCost(abilitylevel)
	return self.BaseClass.GetManaCost(self, abilitylevel)
end

function lunar_horse_lunar_beam:GetCooldown(abilitylevel)
	return self.BaseClass.GetCooldown(self, abilitylevel)
end