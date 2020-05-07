samurai_of_chaos_great_slash = class({})

LinkLuaModifier( 'samurai_of_chaos_great_slash_movement_modifier', 'encounters/samurai_of_chaos/samurai_of_chaos_great_slash_movement_modifier', LUA_MODIFIER_MOTION_NONE )

function samurai_of_chaos_great_slash:OnSpellStart()

	--- Get Caster, Victim, Player, Point ---
	local caster		= self:GetCaster()
	local caster_loc	= caster:GetAbsOrigin()
	local playerID		= caster:GetPlayerOwnerID()
	local player		= PlayerResource:GetPlayer(playerID)
	local team			= caster:GetTeamNumber()
	
	--- Get Special Values ---
	local AbilityCastRange            = self:GetSpecialValueFor("AbilityCastRange")
	local AoERadius                   = self:GetSpecialValueFor("AoERadius")
	local damage                      = self:GetSpecialValueFor("damage")
	local delay                       = self:GetSpecialValueFor("delay")

	-- Sound and Animation --
	local sound = {"juggernaut_jugsc_arc_attack_08", "juggernaut_jugsc_arc_rare_02",
					"juggernaut_jugsc_arc_attack_01", "juggernaut_jugsc_arc_attack_13"}
	EmitAnnouncerSound( sound[RandomInt(1, #sound)] )
	
	StartAnimation(caster, {duration=delay, activity=ACT_DOTA_FLAIL, rate=0.7 , translate="forcestaff_friendly"})
	local timer = Timers:CreateTimer(0.6, function()
		FreezeAnimation(caster, 10)
	end)
	PersistentTimer_Add(timer)

	local casting_modifier = caster:AddNewModifier(caster, self, "casting_modifier", {})
	local movement_modifier = caster:AddNewModifier(caster, self, "samurai_of_chaos_great_slash_movement_modifier", {})

	local loc = GetRandomBorderPoint()
	local loc_end

	caster:MoveToPosition(loc)

	local delayTimeline = delay

	local timer1 = Timers:CreateTimer(function()

		if (caster:GetAbsOrigin() - loc):Length2D() < 100 then

			caster_loc = caster:GetAbsOrigin()

			casting_modifier:Destroy()
			movement_modifier:Destroy()

			caster:AddNewModifier(caster, self, "casting_rooted_modifier", {duration=delay})
			--DisableMotionControllers(caster, delay)

			caster:Stop()

			UnfreezeAnimation(caster)
			EndAnimation(caster)

			local timer2 = Timers:CreateTimer(0.1, function()

				caster:FaceTowards( GetRandomBorderPointCounterpart(loc) )

				local timer3 = Timers:CreateTimer(delay/3, function()
					delayTimeline = delayTimeline - ( delay/3 )

					loc_end = caster:GetAbsOrigin() + ( caster:GetForwardVector() * Vector(AbilityCastRange,AbilityCastRange,1) )
					
					local rad = 10

					for i=-4,4 do

						local direction

						local timer4 = Timers:CreateTimer(function()

							direction = RotateVector2D(caster:GetForwardVector(),math.rad(i*rad))

							EncounterGroundLineWarning(caster, AoERadius, AoERadius*2, caster:GetAbsOrigin(), direction, AbilityCastRange, delayTimeline )
						
						end)
						PersistentTimer_Add(timer4)

						if i == 0 then
							local timer5 = Timers:CreateTimer(delayTimeline - 0.4, function()

								-- Sound and Animation --
								local sound = {"juggernaut_jugsc_arc_pain_01", "juggernaut_jugsc_arc_pain_02",
												"juggernaut_jugsc_arc_pain_06", "juggernaut_jugsc_arc_pain_10"}
								EmitAnnouncerSound( sound[RandomInt(1, #sound)] )
								
								StartAnimation(caster, {duration=1.05, activity=ACT_DOTA_ATTACK_EVENT, rate=0.8, translate="ti8"})
								
								-- Particle --
								local particle = ParticleManager:CreateParticle("particles/econ/items/juggernaut/jugg_ti8_sword/juggernaut_crimson_ti8_sword_crit_overtheshoulder.vpcf", PATTACH_ABSORIGIN, caster)
								ParticleManager:SetParticleControl( particle, 0, caster:GetAbsOrigin() )
								ParticleManager:SetParticleControl( particle, 1, caster:GetForwardVector() )
								ParticleManager:ReleaseParticleIndex( particle )
								particle = nil
								
							
							end)
							PersistentTimer_Add(timer5)
						end

						local timer6 = Timers:CreateTimer(delayTimeline, function()

							if i == 0 then
								-- Sound --
								caster:EmitSound("Hero_Tiny.TossThrow")
								caster:EmitSound("Hero_Tiny.Toss.Target")
							end

							local projectile = {
								EffectName = "particles/encounter/samurai_of_chaos/samurai_of_chaos_great_slash.vpcf",
								vSpawnOrigin = caster_loc + Vector(0,0,160),--{unit=hero, attach="attach_attack1", offset=Vector(0,0,0)},
								fDistance = AbilityCastRange,
								fStartRadius = AoERadius,
								fEndRadius = AoERadius*2,
								Source = caster,
								fExpireTime = 10.0,
								vVelocity = direction * 2000,
								UnitBehavior = PROJECTILES_NOTHING,
								bMultipleHits = false,
								bIgnoreSource = true,
								TreeBehavior = PROJECTILES_NOTHING,
								bCutTrees = false,
								bTreeFullCollision = false,
								WallBehavior = PROJECTILES_NOTHING,
								GroundBehavior = PROJECTILES_NOTHING,
								fGroundOffset = 80,
								nChangeMax = 50,
								bRecreateOnChange = true,
								bZCheck = false,
								bGroundLock = false,
								bProvidesVision = false,
								--iVisionRadius = 0,
								--iVisionTeamNumber = unit:GetTeam(),
								--bFlyingVision = false,
								--fVisionTickTime = .1,
								--fVisionLingerDuration = 1,
								draw = false,
								--draw = {alpha=1, color=Vector(200,0,0)},
								--iPositionCP = 0,
								--iVelocityCP = 1,
								--ControlPoints = {[5]=Vector(100,0,0), [10]=Vector(0,0,1)},
								--ControlPointForwards = {[4]=hero:GetForwardVector() * -1},
								--ControlPointOrientations = {[1]={hero:GetForwardVector() * -1, hero:GetForwardVector() * -1, hero:GetForwardVector() * -1}},
								--[[ControlPointEntityAttaches = {[0]={
								unit = hero,
								pattach = PATTACH_ABSORIGIN_FOLLOW,
								attachPoint = "attach_attack1", -- nil
								origin = Vector(0,0,0)
								}},]]
								--fRehitDelay = 0.2,
								fChangeDelay = 0.1,
								--fRadiusStep = 10,
								--bUseFindUnitsInRadius = false,

								UnitTest = function(self, victim) return victim:GetTeamNumber() ~= caster:GetTeamNumber() end,
								OnUnitHit = function(self, victim)
									--print ('HIT UNIT: ' .. caster:GetUnitName())

									local caster = self.Source
									local ability = caster:FindAbilityByName("samurai_of_chaos_great_slash")
									local damage = ability:GetSpecialValueFor("damage")

									-- Sound --
									victim:EmitSound("Hero_ChaosKnight.ChaosBolt.Impact")

									-- Apply Damage --
									EncounterApplyDamage(victim, caster, ability, damage, DAMAGE_TYPE_MAGICAL, DOTA_DAMAGE_FLAG_NONE)

								end,

								--OnTreeHit = function(self, tree) ... end,
								--OnWallHit = function(self, gnvPos) ... end,
								--OnGroundHit = function(self, groundPos) ... end,
								OnFinish = function(self, pos)

									-- Sound --
									StartSoundEventFromPosition("Hero_Phoenix.FireSpirits.ProjectileHit", pos)

									-- Particle --
									local particle = ParticleManager:CreateParticle("particles/econ/items/templar_assassin/templar_assassin_focal/templar_assassin_meld_focal_start_dust_hit.vpcf", PATTACH_CUSTOMORIGIN, nil)
									ParticleManager:SetParticleControl( particle, 0, pos )
									ParticleManager:ReleaseParticleIndex( particle )
									particle = nil
								end,
								}

								local advanced_projectile = Projectiles:CreateProjectile(projectile)
								PersistentAdvancedProjectile_Add(advanced_projectile)
						
						end)
						PersistentTimer_Add(timer6)

					end
				
				end)
				PersistentTimer_Add(timer3)
			end)
			PersistentTimer_Add(timer2)

		end

		return 0.25
	end)
	PersistentTimer_Add(timer1)

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
	
	
	

		-- Apply Damage --
		EncounterApplyDamage(victim, caster, self, damage, DAMAGE_TYPE_MAGICAL, DOTA_DAMAGE_FLAG_NONE)
	]]
	
	
end

function samurai_of_chaos_great_slash:OnAbilityPhaseStart()
	local caster			= self:GetCaster()
	local playerID			= caster:GetPlayerOwnerID()
	local player			= PlayerResource:GetPlayer(playerID)

	return true
end

function samurai_of_chaos_great_slash:GetManaCost(abilitylevel)
	return self.BaseClass.GetManaCost(self, abilitylevel)
end

function samurai_of_chaos_great_slash:GetCooldown(abilitylevel)
	return self.BaseClass.GetCooldown(self, abilitylevel)
end