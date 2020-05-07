air_ship_napalm_air_strike = class({})

LinkLuaModifier( 'air_ship_napalm_air_strike_modifier', 'encounters/air_ship/air_ship_napalm_air_strike_modifier', LUA_MODIFIER_MOTION_NONE )

function air_ship_napalm_air_strike:OnSpellStart()

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
	local burn_damage                 = self:GetSpecialValueFor("burn_damage")
	local burn_damage_interval        = self:GetSpecialValueFor("burn_damage_interval")
	local delay                       = self:GetSpecialValueFor("delay")
	local initial_damage              = self:GetSpecialValueFor("initial_damage")
	local initial_stun                = self:GetSpecialValueFor("initial_stun")
	local burn_slow_percentage        = self:GetSpecialValueFor("burn_slow_percentage")


	caster:AddNewModifier(caster, self, "casting_rooted_modifier", {duration=1.0})
	DisableMotionControllers(caster, delay)

	caster:Stop()

	EncounterUnitWarning(caster, 1.0, true, "orange") --nil=yellow, "red", "orange", "green"

	-- Sound --
	StartSoundEventFromPositionReliable("Hero_Sniper.ShrapnelShoot", caster_loc)

	-- Particle -- PATTACH_ABSORIGIN-PATTACH_ABSORIGIN_FOLLOW-PATTACH_CUSTOMORIGIN
	local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_sniper/sniper_shrapnel_launch.vpcf", PATTACH_ABSORIGIN, caster)
	ParticleManager:SetParticleControl( particle, 0, caster_loc )
	ParticleManager:SetParticleControl( particle, 1, Vector(0,120,600) )
	ParticleManager:ReleaseParticleIndex( particle )
	particle = nil

	local column_count = 3

	local points = {}

	local pattern = { ["start"] = GetSpecificBorderPoint("point_top"), ["end"] = GetSpecificBorderPoint("point_bottom") }

	local loc_start = pattern["start"]
	local loc_end = pattern["end"]
	local loc_forward_vec = (loc_end - loc_start):Normalized()

	local loc_start_cross = loc_start:Cross(loc_forward_vec)
	local loc_end_cross = loc_end:Cross(loc_forward_vec)

	local initial_distance = (loc_end - loc_start):Length2D()
	local line_steps = AoERadius * RandomFloat(1.5, 2.0)
	local line_count = math.floor(initial_distance / line_steps)

	for i=1,line_count do
		points[i] = {}

		for j=1,column_count do

			local loc = loc_start + ( loc_start_cross + Vector(RandomFloat(-2000.0, 2000.0),0,0) )

			local point = loc + ( (loc_forward_vec * line_steps) * (i-1) )
			point = point * Vector(1,1,0)
			point = point + ( GetGroundPosition(point, caster) * Vector(0,0,1) )

			table.insert(points[i], point)
		end
	end

	for i,line in ipairs(points) do
		for j,point in ipairs(line) do

			local timer1 = Timers:CreateTimer(RandomFloat(0.67, 1.33) * i-1, function()

				EncounterGroundAOEWarningSticky(point, AoERadius, delay+duration)

				local timer2 = Timers:CreateTimer(delay, function()

					--IMPACT

					-- Sound --
					StartSoundEventFromPosition("Hero_Batrider.Flamebreak.Impact", point)

					-- Particle --
					local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_batrider/batrider_flamebreak_explosion.vpcf", PATTACH_CUSTOMORIGIN, nil)
					ParticleManager:SetParticleControl( particle, 3, point )
					ParticleManager:ReleaseParticleIndex( particle )
					particle = nil

					-- DOTA_UNIT_TARGET_TEAM_FRIENDLY; DOTA_UNIT_TARGET_TEAM_ENEMY; DOTA_UNIT_TARGET_TEAM_BOTH
					local units	= FindUnitsInRadius(team, point, nil, AoERadius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
					for _,victim in pairs(units) do
						-- Apply Damage --
						EncounterApplyDamage(victim, caster, self, initial_damage, DAMAGE_TYPE_MAGICAL, DOTA_DAMAGE_FLAG_NONE)

						-- Modifier --
						victim:AddNewModifier(caster, self, "modifier_stunned", {duration = initial_stun})
					end

					--BURN

					-- Particle --
					local particle = ParticleManager:CreateParticle("particles/encounter/air_ship/air_ship_napalm_air_strike.vpcf", PATTACH_CUSTOMORIGIN, nil)
					ParticleManager:SetParticleControl( particle, 0, point )
					ParticleManager:SetParticleControl( particle, 1, Vector(duration,0,0) )
					PersistentParticle_Add(particle)

					local timer3 = Timers:CreateTimer(function()

						-- DOTA_UNIT_TARGET_TEAM_FRIENDLY; DOTA_UNIT_TARGET_TEAM_ENEMY; DOTA_UNIT_TARGET_TEAM_BOTH
						local units	= FindUnitsInRadius(team, point, nil, AoERadius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
						for _,victim in pairs(units) do
							-- Apply Damage --
							EncounterApplyDamage(victim, caster, self, burn_damage*burn_damage_interval, DAMAGE_TYPE_MAGICAL, DOTA_DAMAGE_FLAG_NONE)

							-- Modifier --
							victim:AddNewModifier(caster, self, "air_ship_napalm_air_strike_modifier", {duration = 3.0})
						end


						return burn_damage_interval
					end)
					PersistentTimer_Add(timer3)

					local timer4 = Timers:CreateTimer(duration, function()
						Timers:RemoveTimer(timer3)
						timer3 = nil

						ParticleManager:DestroyParticle( particle, false )
						ParticleManager:ReleaseParticleIndex( particle )
						particle = nil
					end)
					PersistentTimer_Add(timer4)

				end)
				PersistentTimer_Add(timer2)

			end)
			PersistentTimer_Add(timer1)

		end
	end

end

function air_ship_napalm_air_strike:OnAbilityPhaseStart()
	local caster			= self:GetCaster()
	local playerID			= caster:GetPlayerOwnerID()
	local player			= PlayerResource:GetPlayer(playerID)

	return true
end

function air_ship_napalm_air_strike:GetManaCost(abilitylevel)
	return self.BaseClass.GetManaCost(self, abilitylevel)
end

function air_ship_napalm_air_strike:GetCooldown(abilitylevel)
	return self.BaseClass.GetCooldown(self, abilitylevel)
end