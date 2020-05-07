sinastra_ice_shard_barrage = class({})

LinkLuaModifier( 'sinastra_ice_shard_barrage_modifier', 'encounters/sinastra/sinastra_ice_shard_barrage_modifier', LUA_MODIFIER_MOTION_NONE )

function sinastra_ice_shard_barrage:OnSpellStart()

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
	local delay                       = self:GetSpecialValueFor("delay")
	local interval                    = self:GetSpecialValueFor("interval")
	local root_duration               = self:GetSpecialValueFor("root_duration")
	local projectile_speed            = self:GetSpecialValueFor("projectile_speed")

	local casting_modifier = caster:AddNewModifier(caster, self, "casting_modifier", {})
	local movement_modifier = caster:AddNewModifier(caster, self, "sinastra_ice_shard_barrage_modifier", {})

--[[
	local border = {}
	table.insert(border, GetSpecificBorderPoint("point_top_left"))
	table.insert(border, GetSpecificBorderPoint("point_top_right"))
	table.insert(border, GetSpecificBorderPoint("point_bottom_right"))
	table.insert(border, GetSpecificBorderPoint("point_bottom_left"))

	local loc = nil

	for _,border in pairs( border ) do

		if loc == nil then
			loc = border
		elseif (caster_loc - border):Length2D() < (caster_loc - loc):Length2D() then
			loc = border
		end

	end
]]
	local loc = GetRandomBorderPoint()

	caster:MoveToPosition(loc)

	local timer = Timers:CreateTimer(0.25, function()
	if (caster:GetAbsOrigin() - loc):Length2D() < 50 then

		caster_loc = caster:GetAbsOrigin()

		local turn_delay = 0.5

		casting_modifier:Destroy()
		movement_modifier:Destroy()

		caster:AddNewModifier(caster, self, "casting_rooted_modifier", {duration=turn_delay+delay+duration})
		DisableMotionControllers(caster, turn_delay+delay+duration)

		caster:Stop()

		local timer1 = Timers:CreateTimer(0, function()
			caster:FaceTowards( GetSpecificBorderPoint("point_center") )

			return 0.1
		end)
		PersistentTimer_Add(timer1)

		local timer2 = Timers:CreateTimer(turn_delay+delay+duration, function()
			Timers:RemoveTimer(timer1)
			timer = nil
		end)
		PersistentTimer_Add(timer2)

		-- Sound and Animation --
		local sound = {"winter_wyvern_winwyv_attack_07", "winter_wyvern_winwyv_attack_09",
						"winter_wyvern_winwyv_cast_03", "winter_wyvern_winwyv_respawn_02"}
		EmitAnnouncerSound( sound[RandomInt(1, #sound)] )

		StartAnimation(caster, {duration=turn_delay+delay+duration, activity=ACT_DOTA_TELEPORT, rate=1.0})

		local count = -2
		local timer = Timers:CreateTimer(turn_delay, function()

			if count >= duration/2 then return end

			local projectile_start = -2
			local projectile_end = 2

			local rad = 15 + (math.abs(count) * 7.5)

			for i=projectile_start,projectile_end do

				local direction = RotateVector2D(caster:GetForwardVector(),math.rad(i*rad))

				EncounterGroundLineWarning(caster, AoERadius/4, AoERadius, caster_loc, direction, AbilityCastRange, 0.67)

				local timer = Timers:CreateTimer(1.0, function()

					if i == 0 then
						-- Sound --
						caster:EmitSound("Hero_Winter_Wyvern.ArcticBurn.Cast")
					end

					local projectile = {
						EffectName = "particles/encounter/sinastra/sinastra_orb.vpcf",
						vSpawnOrigin = caster_loc + Vector(0,0,160),--{unit=hero, attach="attach_attack1", offset=Vector(0,0,0)},
						fDistance = AbilityCastRange,
						fStartRadius = AoERadius/4,
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
							local ability = caster:FindAbilityByName("sinastra_ice_shard_barrage")
							local damage = ability:GetSpecialValueFor("damage")
							local root_duration = ability:GetSpecialValueFor("root_duration")

							-- Sound --
							victim:EmitSound("Hero_ChaosKnight.ChaosBolt.Impact")

							-- Modifier --
							local modifier = victim:AddNewModifier(caster, ability, "modifier_rooted", {duration=root_duration})
							PersistentModifier_Add(modifier)

							-- Apply Damage --
							EncounterApplyDamage(victim, caster, ability, damage, DAMAGE_TYPE_MAGICAL, DOTA_DAMAGE_FLAG_NONE)

						end,

						--OnTreeHit = function(self, tree) ... end,
						--OnWallHit = function(self, gnvPos) ... end,
						--OnGroundHit = function(self, groundPos) ... end,
						--OnFinish = function(self, pos) ... end,
						}

						Projectiles:CreateProjectile(projectile)


				end)
				PersistentTimer_Add(timer)

			end

			count = count + 1

			return interval
		end)
		PersistentTimer_Add(timer)

		return
	end

	return 0.25
	end)
	PersistentTimer_Add(timer)
	
end

function sinastra_ice_shard_barrage:OnAbilityPhaseStart()
	local caster			= self:GetCaster()
	local playerID			= caster:GetPlayerOwnerID()
	local player			= PlayerResource:GetPlayer(playerID)

	return true
end

function sinastra_ice_shard_barrage:GetManaCost(abilitylevel)
	return self.BaseClass.GetManaCost(self, abilitylevel)
end

function sinastra_ice_shard_barrage:GetCooldown(abilitylevel)
	return self.BaseClass.GetCooldown(self, abilitylevel)
end