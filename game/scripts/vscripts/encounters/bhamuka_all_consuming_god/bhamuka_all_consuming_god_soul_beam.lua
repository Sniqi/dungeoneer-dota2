bhamuka_all_consuming_god_soul_beam = class({})

LinkLuaModifier( 'bhamuka_all_consuming_god_soul_beam_turn_rate_modifier', 'encounters/bhamuka_all_consuming_god/bhamuka_all_consuming_god_soul_beam_turn_rate_modifier', LUA_MODIFIER_MOTION_NONE )

function bhamuka_all_consuming_god_soul_beam:OnSpellStart()

	--- Get Caster, Victim, Player, Point ---
	local caster		= self:GetCaster()
	local caster_loc	= caster:GetAbsOrigin()
	local playerID		= caster:GetPlayerOwnerID()
	local player		= PlayerResource:GetPlayer(playerID)
	local team			= caster:GetTeamNumber()
	local victim		= caster
	local victim_loc	= victim:GetAbsOrigin()
	
	--- Get Special Values ---
	local AbilityCastRange            = self:GetSpecialValueFor("AbilityCastRange")
	local AoERadius                   = self:GetSpecialValueFor("AoERadius")
	local duration                    = self:GetSpecialValueFor("duration")
	local damage                      = self:GetSpecialValueFor("damage")
	local damage_interval             = self:GetSpecialValueFor("damage_interval")
	local delay                       = self:GetSpecialValueFor("delay")
	local projectile_speed            = self:GetSpecialValueFor("projectile_speed")

	local damage_instances = duration / damage_interval

	caster:AddNewModifier(caster, self, "casting_rooted_modifier", {duration=duration+delay})
	DisableMotionControllers(caster, duration+delay)
	
	-- Sound --
	local sound = {"outworld_destroyer_odest_attack_01", "outworld_destroyer_odest_attack_08"}
	EmitAnnouncerSound( sound[RandomInt(1, #sound)] )

	local start
	if RollPercentage(50) then
		start = "point_top_left"
	else
		start = "point_top_right"
	end

	caster:Stop()

	local timer = Timers:CreateTimer(0, function()
		caster:FaceTowards( GetSpecificBorderPoint(start) )

		return 0.03
	end)
	PersistentTimer_Add(timer)

	local timer = Timers:CreateTimer(delay/2, function()
		Timers:RemoveTimer(timer)
		timer = nil
	end)
	PersistentTimer_Add(timer)

	local timer1 = Timers:CreateTimer(delay, function()

		caster:AddNewModifier(caster, self, "bhamuka_all_consuming_god_soul_beam_turn_rate_modifier", {duration = duration+1})

		caster:FaceTowards( GetSpecificBorderPoint("point_bottom") )

		-- Animation
		StartAnimation(caster, {duration=duration, activity=ACT_DOTA_RUN, rate=1.0})

		for i=0,damage_instances-1 do

			local timer2 = Timers:CreateTimer(damage_interval*i, function()

				local count = 0
				local timer3 = Timers:CreateTimer(0, function()
					EncounterGroundLineWarning(caster, AoERadius/2, AoERadius, caster_loc, caster:GetForwardVector(), AbilityCastRange, delay)
				end)
				PersistentTimer_Add(timer3)

				local timer4 = Timers:CreateTimer(damage_interval, function()

					-- Sound --
					caster:EmitSound("Hero_ObsidianDestroyer.ArcaneOrb")--Hero_ObsidianDestroyer.AstralImprisonment.Cast

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

							local caster = self.Source
							local ability = caster:FindAbilityByName("bhamuka_all_consuming_god_soul_beam")
							local damage = ability:GetSpecialValueFor("damage")
							local damage_interval = ability:GetSpecialValueFor("damage_interval")

							-- Sound --
							victim:EmitSound("Hero_ObsidianDestroyer.ArcaneOrb.Impact")

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
				PersistentTimer_Add(timer4)

			end)
			PersistentTimer_Add(timer2)
		end

	end)
	PersistentTimer_Add(timer1)

end

function bhamuka_all_consuming_god_soul_beam:OnAbilityPhaseStart()
	local caster			= self:GetCaster()
	local playerID			= caster:GetPlayerOwnerID()
	local player			= PlayerResource:GetPlayer(playerID)

	return true
end

function bhamuka_all_consuming_god_soul_beam:GetManaCost(abilitylevel)
	return self.BaseClass.GetManaCost(self, abilitylevel)
end

function bhamuka_all_consuming_god_soul_beam:GetCooldown(abilitylevel)
	return self.BaseClass.GetCooldown(self, abilitylevel)
end