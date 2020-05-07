scroll_collector_triple_shadow_bolt = class({})

function scroll_collector_triple_shadow_bolt:OnSpellStart()

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
	local damage                      = self:GetSpecialValueFor("damage")
	local delay                       = self:GetSpecialValueFor("delay")
	local projectile_speed            = self:GetSpecialValueFor("projectile_speed")
	local phase_two                   = self:GetSpecialValueFor("phase_two")
	local phase_two_additional_projectiles= self:GetSpecialValueFor("phase_two_additional_projectiles")

	local turn_delay = 0.5

	caster:AddNewModifier(caster, self, "casting_rooted_modifier", {duration=turn_delay+delay})
	DisableMotionControllers(caster, turn_delay+delay)

	caster:Stop()
	caster:FaceTowards(victim_loc)

	-- Sound and Animation --
	local sound = {"dark_seer_dkseer_attack_01", "dark_seer_dkseer_attack_02",
					"dark_seer_dkseer_attack_04", "dark_seer_dkseer_attack_07"}
	EmitAnnouncerSound( sound[RandomInt(1, #sound)] )
	StartAnimation(caster, {duration=turn_delay+delay, activity=ACT_DOTA_RUN, translate="haste", rate=1.0})

	local rad = 35

	local projectile_start = -1
	local projectile_end = 1

	-- PHASE 2 --
	if caster:GetHealthPercent() < phase_two then
		if RandomInt(0,100) < 50 then
			projectile_end = projectile_end + phase_two_additional_projectiles
		else
			projectile_start = projectile_start - phase_two_additional_projectiles
		end
	end

	for i=projectile_start,projectile_end do

		local direction

		local count = 0
		local timer = Timers:CreateTimer(turn_delay, function()

			-- PHASE 2 --
			if caster:GetHealthPercent() < phase_two then
				rad = rad + RandomInt(-10, 10)
			end

			direction = RotateVector2D(caster:GetForwardVector(),math.rad(i*rad))

			EncounterGroundLineWarning(caster, AoERadius/2, AoERadius, caster_loc, direction, AbilityCastRange, delay)
		end)
		PersistentTimer_Add(timer)

		local timer = Timers:CreateTimer(turn_delay + delay, function()

			if i == 0 then
				-- Sound --
				caster:EmitSound("Hero_Necrolyte.DeathPulse")
			end

			local projectile = {
				EffectName = "particles/encounter/scroll_collector/scroll_collector_triple_shadow_bolt.vpcf",
				vSpawnOrigin = caster_loc + Vector(0,0,160),--{unit=hero, attach="attach_attack1", offset=Vector(0,0,0)},
				fDistance = AbilityCastRange,
				fStartRadius = AoERadius/2,
				fEndRadius = AoERadius,
				Source = caster,
				fExpireTime = 10.0,
				vVelocity = direction * projectile_speed,
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

		end)
		PersistentTimer_Add(timer)

	end

end

function scroll_collector_triple_shadow_bolt:OnAbilityPhaseStart()
	local caster			= self:GetCaster()
	local playerID			= caster:GetPlayerOwnerID()
	local player			= PlayerResource:GetPlayer(playerID)

	return true
end

function scroll_collector_triple_shadow_bolt:GetManaCost(abilitylevel)
	return self.BaseClass.GetManaCost(self, abilitylevel)
end

function scroll_collector_triple_shadow_bolt:GetCooldown(abilitylevel)
	return self.BaseClass.GetCooldown(self, abilitylevel)
end