samurai_of_chaos_chaos_field = class({})

function samurai_of_chaos_chaos_field:OnSpellStart()

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
	local count                       = self:GetSpecialValueFor("count")
	local stun                        = self:GetSpecialValueFor("stun")

	caster:AddNewModifier(caster, self, "casting_rooted_modifier", {duration=delay})
	DisableMotionControllers(caster, delay)

	-- Sound and Animation --
	local sound = {"juggernaut_jugsc_arc_attack_10", "juggernaut_jugsc_arc_attack_03",
					"juggernaut_jugsc_arc_lasthit_10", "juggernaut_jugsc_arc_kill_05"}
	EmitAnnouncerSound( sound[RandomInt(1, #sound)] )
	
	StartAnimation(caster, {duration=delay, activity=ACT_DOTA_CAST_ABILITY_2, rate=0.1})

	local points = {}

	local pattern = { ["start"] = GetSpecificBorderPoint("point_top_left"), ["end"] = GetSpecificBorderPoint("point_bottom_left") }

	local loc_start = pattern["start"] + Vector(0,AoERadius,0)
	local loc_end = pattern["end"] - Vector(0,AoERadius,0)
	local loc_forward_vec = (loc_end - loc_start):Normalized()

	local loc_start_cross = loc_start:Cross(loc_forward_vec)
	local loc_end_cross = loc_end:Cross(loc_forward_vec)

	local initial_distance = (loc_end - loc_start):Length2D()
	local line_steps = AoERadius * 1.5
	local line_count = math.floor(initial_distance / AoERadius)

	local loc_start = GetSpecificBorderPoint("point_top_left") - Vector(AoERadius,0,0)
	local loc_end = GetSpecificBorderPoint("point_top_right") + Vector(AoERadius,0,0)
	local initial_distance = (GetSpecificBorderPoint("point_top_left") - GetSpecificBorderPoint("point_top_right")):Length2D()
	local column_count = math.floor(initial_distance / AoERadius)

	for i=1,line_count do
		points[i] = {}

		for j=1,column_count do

			local loc = loc_start + ( loc_start_cross * j )

			local point = loc + ( (loc_forward_vec * line_steps) * (i-1) )
			point = point * Vector(1,1,0)
			point = point + ( GetGroundPosition(point, caster) * Vector(0,0,1) )

			table.insert(points[i], point)
		end
	end

	local safeSpot_line = RandomInt(2, #points-3)
	local safeSpot_column = RandomInt(2, #points[safeSpot_line]-3)

	for i,line in ipairs(points) do
		for j,point in ipairs(line) do

			local timer1 = Timers:CreateTimer(0, function()

				if ( i == safeSpot_line and j == safeSpot_column ) or
					( i+1 == safeSpot_line and j == safeSpot_column ) or
					( i-1 == safeSpot_line and j == safeSpot_column ) or
					( i == safeSpot_line and j+1 == safeSpot_column ) or
					( i == safeSpot_line and j-1 == safeSpot_column ) or
					( i+1 == safeSpot_line and j+1 == safeSpot_column ) or
					( i+1 == safeSpot_line and j-1 == safeSpot_column ) or
					( i-1 == safeSpot_line and j+1 == safeSpot_column ) or
					( i-1 == safeSpot_line and j-1 == safeSpot_column ) then

						local timer = Timers:CreateTimer(0, function()
							EncounterGroundAOEWarningSticky(point, AoERadius, delay, Vector(0,255,0))
						end)
						PersistentTimer_Add(timer)

				else
					--EncounterGroundAOEWarningSticky(point, AoERadius, delay/2)

					local particle

					local timer2 = Timers:CreateTimer(delay-1.0, function()

						-- Particle --
						particle = ParticleManager:CreateParticle("particles/encounter/the_dungeoneer/the_dungeoneer_death_and_decay.vpcf", PATTACH_CUSTOMORIGIN, nil)
						ParticleManager:SetParticleControl( particle, 0, point )
						PersistentParticle_Add(particle)

					end)
					PersistentTimer_Add(timer2)

					local timer3 = Timers:CreateTimer(delay, function()

						ParticleManager:DestroyParticle( particle, false )
						ParticleManager:ReleaseParticleIndex( particle )
						particle = nil

						-- DOTA_UNIT_TARGET_TEAM_FRIENDLY; DOTA_UNIT_TARGET_TEAM_ENEMY; DOTA_UNIT_TARGET_TEAM_BOTH
						local units	= FindUnitsInRadius(team, point, nil, AoERadius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
						for _,victim in pairs(units) do

							if victim:FindModifierByNameAndCaster("modifier_stunned", caster) == nil then

								victim:AddNewModifier(caster, self, "modifier_stunned", {duration = stun})

								-- Apply Damage --
								EncounterApplyDamage(victim, caster, self, damage, DAMAGE_TYPE_MAGICAL, DOTA_DAMAGE_FLAG_NONE)
							end

						end

					end)
					PersistentTimer_Add(timer3)
				end

			end)
			PersistentTimer_Add(timer1)

		end

	end






--[[


	local timer = Timers:CreateTimer(0.1, function()

	end)
	PersistentTimer_Add(timer)
	
	EncounterGroundAOEWarningSticky(loc, AoERadius, delay+0.1)
	
	-- Particle -- PATTACH_ABSORIGIN-PATTACH_ABSORIGIN_FOLLOW-PATTACH_CUSTOMORIGIN
	local particle = ParticleManager:CreateParticle("xxx", PATTACH_ABSORIGIN, caster)
	local particle = ParticleManager:CreateParticle("xxx", PATTACH_CUSTOMORIGIN, nil)
	ParticleManager:SetParticleControl( particle, 0, loc )
	
	ParticleManager:SetParticleControlEnt( particle, 3, caster, PATTACH_POINT_FOLLOW, "attach_hitloc", caster:GetAttachmentOrigin(caster:ScriptLookupAttachment("attach_hitloc")), true)
	
	PersistentParticle_Add(particle)
	
	ParticleManager:ReleaseParticleIndex( particle )
	particle = nil

	local timer = Timers:CreateTimer(duration, function()
			ParticleManager:DestroyParticle( particle, false )
			ParticleManager:ReleaseParticleIndex( particle )
			particle = nil
	end)
	PersistentTimer_Add(timer)
	
	local unit = CreateUnitByName("xxx", loc, true, nil, nil, DOTA_TEAM_BADGUYS)
	PersistentUnit_Add(unit)

	unit:AddNewModifier(caster, self, "modifier_invulnerable", {})
	unit:AddNewModifier(caster, self, "modifier_unselectable", {})
	unit:AddNewModifier(caster, self, "modifier_phased", {})

	unit:Stop()
	unit:MoveToPosition(loc)
	
	-- Sound --
	StartSoundEventReliable("xxx", victim)
	StartSoundEventFromPositionReliable("xxx", loc)
	
	-- DOTA_UNIT_TARGET_TEAM_FRIENDLY; DOTA_UNIT_TARGET_TEAM_ENEMY; DOTA_UNIT_TARGET_TEAM_BOTH
	local units	= FindUnitsInRadius(team, loc, nil, AoERadius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
	for _,victim in pairs(units) do
	
	end
	
	TurnToLoc(caster, victim_loc, 1.5)
	RandomLocationMinDistance( GetSpecificBorderPoint("point_center"), 750*RandomFloat(0.25, 1.0))
	
	
	


	]]
	
	
end

function samurai_of_chaos_chaos_field:OnAbilityPhaseStart()
	local caster			= self:GetCaster()
	local playerID			= caster:GetPlayerOwnerID()
	local player			= PlayerResource:GetPlayer(playerID)

	return true
end

function samurai_of_chaos_chaos_field:GetManaCost(abilitylevel)
	return self.BaseClass.GetManaCost(self, abilitylevel)
end

function samurai_of_chaos_chaos_field:GetCooldown(abilitylevel)
	return self.BaseClass.GetCooldown(self, abilitylevel)
end