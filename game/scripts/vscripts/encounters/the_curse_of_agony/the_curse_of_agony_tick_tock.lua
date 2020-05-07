the_curse_of_agony_tick_tock = class({})

function the_curse_of_agony_tick_tock:OnSpellStart()

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
	local damage_instances            = self:GetSpecialValueFor("damage_instances")
	local delay                       = self:GetSpecialValueFor("delay")
	local projectile_speed            = self:GetSpecialValueFor("projectile_speed")
	
	local location = GetSpecificBorderPoint("point_center")

	-- Sound --
	local sound = {"bane_bane_laugh_02", "bane_bane_laugh_03",
					"bane_bane_laugh_04", "bane_bane_laugh_05"}
	EmitAnnouncerSound( sound[RandomInt(1, #sound)] )

	-- Animation --
	StartAnimation(caster, {duration=delay, activity=ACT_DOTA_DISABLED, rate=0.75})

	-- Particle --
	local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_dark_willow/dark_willow_bramble.vpcf", PATTACH_CUSTOMORIGIN, nil)
	ParticleManager:SetParticleControl( particle, 0, location )
	ParticleManager:SetParticleControl( particle, 3, location )
	PersistentParticle_Add(particle)

	local timer1 = Timers:CreateTimer(delay, function()

		for i=0,damage_instances do

			local rad = ( ( 360 / duration ) * damage_interval ) + RandomFloat(-0.5, 0.5)
			local dir = ( GetSpecificBorderPoint("point_top") - GetSpecificBorderPoint("point_center") ):Normalized()
			local direction = RotateVector2D( dir, math.rad( i * rad * -1) )

			direction.x = direction.x + RandomFloat(-0.15, 0.15)
			direction.y = direction.y + RandomFloat(-0.15, 0.15)

			local timer2 = Timers:CreateTimer(i*damage_interval, function()

				local modifier = caster:FindModifierByName("the_curse_of_agony_banished_modifier")

				if modifier == nil then

					-- Sound --
					StartSoundEventFromPositionReliable("Hero_SkywrathMage.Attack", location)

					EncounterGroundLineWarning(caster, AoERadius/2, AoERadius, location, direction, AbilityCastRange, 1)

					local projectile = {
						EffectName = "particles/encounter/scroll_collector/scroll_collector_triple_shadow_bolt.vpcf",
						vSpawnOrigin = location + Vector(0,0,160),--{unit=hero, attach="attach_attack1", offset=Vector(0,0,0)},
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
							local ability = caster:FindAbilityByName("the_curse_of_agony_tick_tock")
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

							local ground_pos = GetGroundPosition(pos, caster) * Vector(0,0,1)
							pos = ( pos * Vector(1,1,0) ) + ground_pos + Vector(0,0,25)

							-- Particle --
							local particle = ParticleManager:CreateParticle("particles/neutral_fx/centaur_khan_stomp_dust.vpcf", PATTACH_CUSTOMORIGIN, nil)
							ParticleManager:SetParticleControl( particle, 0, pos )
							ParticleManager:ReleaseParticleIndex( particle )
							particle = nil
						end,
						}

					local advanced_projectile = Projectiles:CreateProjectile(projectile)
					PersistentAdvancedProjectile_Add(advanced_projectile)

				end

			end)
			PersistentTimer_Add(timer2)

		end

	end)
	PersistentTimer_Add(timer1)

	local timer = Timers:CreateTimer(delay+duration+1, function()
		-- Particle --
		ParticleManager:DestroyParticle( particle, false )
		ParticleManager:ReleaseParticleIndex( particle )
		particle = nil
	end)
	PersistentTimer_Add(timer)

	-- ChallengerMode 1 --
	if GameMode_Active == "Challenger" and ChallengerMode_Active == 1 then
		local boss_readable = "Nether Drake"
		local boss = "npc_dota_hero_nether_drake"
		local abilityindex = 4
		local duration = 15
		local hidden = true

		ChallengerMode_CastAnyBossSpell(self, boss_readable, boss, abilityindex, duration, hidden)
	end

end

function the_curse_of_agony_tick_tock:OnAbilityPhaseStart()
	local caster			= self:GetCaster()
	local playerID			= caster:GetPlayerOwnerID()
	local player			= PlayerResource:GetPlayer(playerID)

	return true
end

function the_curse_of_agony_tick_tock:GetManaCost(abilitylevel)
	return self.BaseClass.GetManaCost(self, abilitylevel)
end

function the_curse_of_agony_tick_tock:GetCooldown(abilitylevel)
	return self.BaseClass.GetCooldown(self, abilitylevel)
end
