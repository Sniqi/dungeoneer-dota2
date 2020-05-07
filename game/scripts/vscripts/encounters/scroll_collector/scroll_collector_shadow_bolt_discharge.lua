scroll_collector_shadow_bolt_discharge = class({})

function scroll_collector_shadow_bolt_discharge:OnSpellStart()

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
	local projectile_speed            = self:GetSpecialValueFor("projectile_speed")
	local phase_two                   = self:GetSpecialValueFor("phase_two")
	local teleport_chance             = self:GetSpecialValueFor("teleport_chance")

	local damage_instances = duration / damage_interval

	caster:AddNewModifier(caster, self, "casting_rooted_modifier", {duration=duration+delay})
	caster:AddNewModifier(caster, self, "turn_rate_modifier", {duration=duration+delay})
	DisableMotionControllers(caster, delay/2)
	
	-- Sound and Animation --
	local sound = {"dark_seer_dkseer_attack_06", "dark_seer_dkseer_attack_11",
					"dark_seer_dkseer_ability_vacuum_05", "dark_seer_dkseer_cast_01"}
	EmitAnnouncerSound( sound[RandomInt(1, #sound)] )
	StartAnimation(caster, {duration=duration, activity=ACT_DOTA_RUN, translate="haste", rate=1.0})

	caster:Stop()

	local timer = Timers:CreateTimer(0, function()
		victim_loc = victim:GetAbsOrigin()
		caster:FaceTowards(victim_loc)

		return 0.03
	end)
	PersistentTimer_Add(timer)

	local timer1 = Timers:CreateTimer(duration+delay, function()
		Timers:RemoveTimer(timer)
		timer = nil
	end)
	PersistentTimer_Add(timer1)

	local timer1 = Timers:CreateTimer(delay, function()

		for i=0,damage_instances-1 do

			local timer2 = Timers:CreateTimer(damage_interval*i, function()

				caster_loc = caster:GetAbsOrigin()
				
				EncounterGroundLineWarning(caster, AoERadius/2, AoERadius, caster_loc, caster:GetForwardVector(), AbilityCastRange, delay)

				local timer4 = Timers:CreateTimer(damage_interval, function()

					-- Sound --
					caster:EmitSound("Hero_Necrolyte.DeathPulse")

					local projectile = {
						EffectName = "particles/encounter/scroll_collector/scroll_collector_triple_shadow_bolt.vpcf",
						vSpawnOrigin = caster_loc + Vector(0,0,160),--{unit=hero, attach="attach_attack1", offset=Vector(0,0,0)},
						fDistance = AbilityCastRange,
						fStartRadius = AoERadius/2,
						fEndRadius = AoERadius,
						Source = caster,
						fExpireTime = 10.0,
						vVelocity = caster:GetForwardVector() * projectile_speed,
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
							local ability = caster:FindAbilityByName("scroll_collector_triple_shadow_bolt")
							local damage = ability:GetSpecialValueFor("damage")

							-- Sound --
							victim:EmitSound("Hero_ChaosKnight.ChaosBolt.Impact")

							-- Apply Damage --
							EncounterApplyDamage(victim, caster, ability, damage, DAMAGE_TYPE_MAGICAL, DOTA_DAMAGE_FLAG_NONE)

						end,

						--OnTreeHit = function(self, tree) ... end,
						--OnWallHit = function(self, gnvPos) ... end,
						--OnGroundHit = function(self, groundPos) ... end,
						--OnFinish = function(self, pos) ... end,
						}

						local advanced_projectile = Projectiles:CreateProjectile(projectile)
						PersistentAdvancedProjectile_Add(advanced_projectile)

						-- PHASE 2 --
						if caster:GetHealthPercent() < phase_two then
							if RandomInt(0,100) < teleport_chance then

								local victim_loc = victim:GetAbsOrigin()
								local new_loc = RandomLocationMinDistance(victim_loc, 800)

								caster:SetAbsOrigin(new_loc)
								FindClearSpaceForUnit(caster, new_loc, false)

								-- Particle --
								local particle = ParticleManager:CreateParticle("particles/econ/events/ti6/teleport_end_ti6_ground_flash.vpcf", PATTACH_ABSORIGIN, caster)
								ParticleManager:SetParticleControl( particle, 0, caster:GetAbsOrigin() )
								PersistentParticle_Add(particle)

								local timer5 = Timers:CreateTimer(2.0, function()
									ParticleManager:DestroyParticle( particle, false )
									ParticleManager:ReleaseParticleIndex( particle )
									particle = nil
								end)
								PersistentTimer_Add(timer5)

							end
						end
				end)
				PersistentTimer_Add(timer4)

			end)
			PersistentTimer_Add(timer2)
		end

	end)
	PersistentTimer_Add(timer1)
end

function scroll_collector_shadow_bolt_discharge:OnAbilityPhaseStart()
	local caster			= self:GetCaster()
	local playerID			= caster:GetPlayerOwnerID()
	local player			= PlayerResource:GetPlayer(playerID)

	return true
end

function scroll_collector_shadow_bolt_discharge:GetManaCost(abilitylevel)
	return self.BaseClass.GetManaCost(self, abilitylevel)
end

function scroll_collector_shadow_bolt_discharge:GetCooldown(abilitylevel)
	return self.BaseClass.GetCooldown(self, abilitylevel)
end