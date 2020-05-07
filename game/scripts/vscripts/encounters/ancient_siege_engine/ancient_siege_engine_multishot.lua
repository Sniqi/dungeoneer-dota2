ancient_siege_engine_multishot = class({})

function ancient_siege_engine_multishot:OnSpellStart()

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
	local AoERadius                   = self:GetSpecialValueFor("AoERadius")
	local damage                      = self:GetSpecialValueFor("damage")
	local delay                       = self:GetSpecialValueFor("delay")
	local projectile_speed            = self:GetSpecialValueFor("projectile_speed")
	local phase_two                   = self:GetSpecialValueFor("phase_two")
	local burning_ground_damage       = self:GetSpecialValueFor("burning_ground_damage")
	local burning_ground_damage_duration= self:GetSpecialValueFor("burning_ground_damage_duration")
	local burning_ground_damage_interval= self:GetSpecialValueFor("burning_ground_damage_interval")
	local burning_ground_aoe          = self:GetSpecialValueFor("burning_ground_aoe")

	local turn_delay = 0.7
	delay = delay - turn_delay

	caster:AddNewModifier(caster, self, "casting_rooted_modifier", {duration=turn_delay+delay})
	DisableMotionControllers(caster, turn_delay+delay)

	caster:Stop()
	caster:FaceTowards(victim_loc)

	EncounterUnitWarning(caster, 1.0, true, nil) --nil=yellow, "red", "orange", "green"

	-- Sound and Animation --
	local timer = Timers:CreateTimer(turn_delay + delay - 0.65, function()
		StartAnimation(caster, {duration=2.0, activity=ACT_DOTA_ATTACK, rate=1.0})
	end)
	PersistentTimer_Add(timer)

	local projectile_count = 5

	-- ChallengerMode 1 --
	if GameMode_Active == "Challenger" and ChallengerMode_Active == 1 then projectile_count = projectile_count * 3 end

	for i=1,projectile_count do

		local rad = RandomInt(-4, 4)

		local range = (victim_loc - caster_loc):Length2D() + RandomInt(-200, 200)

		local direction
		local final_location

		local count = 0
		local timer = Timers:CreateTimer(turn_delay, function()

			direction = RotateVector2D(caster:GetForwardVector(),math.rad(i*rad))

			final_location = caster_loc + (direction * range)

			EncounterGroundAOEWarningSticky(final_location, AoERadius, turn_delay+delay)
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
				fDistance = range,
				fStartRadius = 0,
				fEndRadius = 0,
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

				--UnitTest = function(self, victim) return victim:GetTeamNumber() ~= caster:GetTeamNumber() end,
				--OnUnitHit = function(self, victim) ... end,
				--OnTreeHit = function(self, tree) ... end,
				--OnWallHit = function(self, gnvPos) ... end,
				--OnGroundHit = function(self, groundPos) ... end,
				OnFinish = function(self, pos)

					pos = pos - Vector(0,0,80)

					--print ('HIT UNIT: ' .. caster:GetUnitName())

					local caster		= self.Source
					local caster_loc	= caster:GetAbsOrigin()
					local playerID		= caster:GetPlayerOwnerID()
					local player		= PlayerResource:GetPlayer(playerID)
					local team			= caster:GetTeamNumber()

					local ability       = caster:FindAbilityByName("ancient_siege_engine_multishot")

					local AoERadius                   = ability:GetSpecialValueFor("AoERadius")
					local damage                      = ability:GetSpecialValueFor("damage")
					local phase_two                   = ability:GetSpecialValueFor("phase_two")
					local burning_ground_damage       = ability:GetSpecialValueFor("burning_ground_damage")
					local burning_ground_damage_duration= ability:GetSpecialValueFor("burning_ground_damage_duration")
					local burning_ground_damage_interval= ability:GetSpecialValueFor("burning_ground_damage_interval")
					local burning_ground_aoe          = ability:GetSpecialValueFor("burning_ground_aoe")

					StartSoundEventFromPosition("Ability.TossImpact", pos)

					-- Particle --
					local particle = ParticleManager:CreateParticle("particles/econ/items/templar_assassin/templar_assassin_focal/templar_assassin_meld_focal_start_dust_hit.vpcf", PATTACH_CUSTOMORIGIN, nil)
					ParticleManager:SetParticleControl( particle, 0, pos )
					ParticleManager:ReleaseParticleIndex( particle )
					particle = nil

					-- DOTA_UNIT_TARGET_TEAM_FRIENDLY; DOTA_UNIT_TARGET_TEAM_ENEMY; DOTA_UNIT_TARGET_TEAM_BOTH
					local units	= FindUnitsInRadius(team, pos, nil, AoERadius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
					local particle = {}
					for _,victim in pairs(units) do
						-- Apply Damage --
						EncounterApplyDamage(victim, caster, ability, damage, DAMAGE_TYPE_PHYSICAL, DOTA_DAMAGE_FLAG_NONE)
					end

					-- PHASE 2 --
					if caster:GetHealthPercent() < phase_two then

						-- Particle --
						local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_batrider/batrider_firefly.vpcf", PATTACH_CUSTOMORIGIN, nil)
						ParticleManager:SetParticleControl( particle, 0, pos )
						PersistentParticle_Add(particle)

						EncounterGroundAOEWarningSticky(pos, burning_ground_aoe, burning_ground_damage_duration)

						local timer2 = Timers:CreateTimer(0, function()

							-- DOTA_UNIT_TARGET_TEAM_FRIENDLY; DOTA_UNIT_TARGET_TEAM_ENEMY; DOTA_UNIT_TARGET_TEAM_BOTH
							local units	= FindUnitsInRadius(team, pos, nil, burning_ground_aoe, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
							local particle = {}
							for _,victim in pairs(units) do
							
								-- Sound --
								victim:EmitSound("Hero_Batrider.Firefly.Cast")

								-- Apply Damage --
								EncounterApplyDamage(victim, caster, self, burning_ground_damage*burning_ground_damage_interval, DAMAGE_TYPE_MAGICAL, DOTA_DAMAGE_FLAG_NONE)
							end

							return burning_ground_damage_interval
						end)
						PersistentTimer_Add(timer2)

						local timer3 = Timers:CreateTimer(burning_ground_damage_duration, function()

							Timers:RemoveTimer(timer2)
							timer2 = nil

							ParticleManager:DestroyParticle( particle, false )
							ParticleManager:ReleaseParticleIndex( particle )
							particle = nil

						end)
						PersistentTimer_Add(timer3)

					end
					-- PHASE 2 END --

				end,
				}

				local advanced_projectile = Projectiles:CreateProjectile(projectile)
				PersistentAdvancedProjectile_Add(advanced_projectile)


		end)
		PersistentTimer_Add(timer)

	end

end

function ancient_siege_engine_multishot:OnAbilityPhaseStart()
	local caster			= self:GetCaster()
	local playerID			= caster:GetPlayerOwnerID()
	local player			= PlayerResource:GetPlayer(playerID)

	return true
end

function ancient_siege_engine_multishot:GetManaCost(abilitylevel)
	return self.BaseClass.GetManaCost(self, abilitylevel)
end

function ancient_siege_engine_multishot:GetCooldown(abilitylevel)
	return self.BaseClass.GetCooldown(self, abilitylevel)
end