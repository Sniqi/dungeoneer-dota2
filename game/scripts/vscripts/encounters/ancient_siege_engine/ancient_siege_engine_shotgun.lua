ancient_siege_engine_shotgun = class({})

function ancient_siege_engine_shotgun:OnSpellStart()

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
	local bullets_count               = self:GetSpecialValueFor("bullets_count")
	local projectile_speed            = self:GetSpecialValueFor("projectile_speed")

	local turn_delay = 0.7

	-- ChallengerMode 1 --
	if GameMode_Active == "Challenger" and ChallengerMode_Active == 1 then AbilityCastRange = AbilityCastRange * 2 end

	caster:AddNewModifier(caster, self, "casting_rooted_modifier", {duration=turn_delay+delay})
	DisableMotionControllers(caster, turn_delay+delay)

	caster:Stop()
	caster:FaceTowards(victim_loc)

	EncounterUnitWarning(caster, 1.0, true, nil) --nil=yellow, "red", "orange", "green"

	-- Sound and Animation --
	local timer = Timers:CreateTimer(turn_delay + delay - 0.3, function()
		StartAnimation(caster, {duration=1.0, activity=ACT_DOTA_ATTACK, rate=4.0})
	end)
	PersistentTimer_Add(timer)

	local rad = 10

	for i=-3,3 do

		local direction

		local count = 0
		local timer = Timers:CreateTimer(turn_delay, function()

			direction = RotateVector2D(caster:GetForwardVector(),math.rad(i*rad))

			EncounterGroundLineWarning(caster, AoERadius/2, AoERadius, caster_loc, direction, AbilityCastRange, delay)
		end)
		PersistentTimer_Add(timer)

		local timer = Timers:CreateTimer(turn_delay + delay, function()

			if i == 0 then
				-- Sound --
				caster:EmitSound("Hero_Tiny.TossThrow")
				caster:EmitSound("Hero_Tiny.Toss.Target")
			end

			local projectile = {
				EffectName = "particles/encounter/ancient_siege_engine/ancient_siege_engine_multishot.vpcf",
				vSpawnOrigin = caster_loc + Vector(0,0,160),--{unit=hero, attach="attach_attack1", offset=Vector(0,0,0)},
				fDistance = AbilityCastRange,
				fStartRadius = AoERadius/2,
				fEndRadius = AoERadius,
				Source = caster,
				fExpireTime = 20,
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
					local ability = caster:FindAbilityByName("ancient_siege_engine_shotgun")
					local damage = ability:GetSpecialValueFor("damage")

					-- Sound --
					victim:EmitSound("Hero_ChaosKnight.ChaosBolt.Impact")

					-- Apply Damage --
					EncounterApplyDamage(victim, caster, ability, damage, DAMAGE_TYPE_PHYSICAL, DOTA_DAMAGE_FLAG_NONE)

				end,

				--OnTreeHit = function(self, tree) ... end,
				--OnWallHit = function(self, gnvPos) ... end,
				--OnGroundHit = function(self, groundPos) ... end,
				OnFinish = function(self, pos)

					-- Sound --
					StartSoundEventFromPosition("Ability.TossImpact", pos)

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
		PersistentTimer_Add(timer)

	end
	
end

function ancient_siege_engine_shotgun:OnAbilityPhaseStart()
	local caster			= self:GetCaster()
	local playerID			= caster:GetPlayerOwnerID()
	local player			= PlayerResource:GetPlayer(playerID)

	return true
end

function ancient_siege_engine_shotgun:GetManaCost(abilitylevel)
	return self.BaseClass.GetManaCost(self, abilitylevel)
end

function ancient_siege_engine_shotgun:GetCooldown(abilitylevel)
	return self.BaseClass.GetCooldown(self, abilitylevel)
end