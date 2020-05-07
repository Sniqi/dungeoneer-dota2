samurai_of_chaos_chaotic_bladestorm = class({})

function samurai_of_chaos_chaotic_bladestorm:OnSpellStart()

	--- Get Caster, Victim, Player, Point ---
	local caster		= self:GetCaster()
	local caster_loc	= caster:GetAbsOrigin()
	local playerID		= caster:GetPlayerOwnerID()
	local player		= PlayerResource:GetPlayer(playerID)
	local team			= caster:GetTeamNumber()

	EndAnimation(caster)
	
	--- Get Special Values ---
	local AoERadius                   = self:GetSpecialValueFor("AoERadius")
	local delay_min                   = self:GetSpecialValueFor("delay_min")
	local delay_max                   = self:GetSpecialValueFor("delay_max")
	local count_max_hp                = self:GetSpecialValueFor("count_max_hp")
	local count_min_hp                = self:GetSpecialValueFor("count_min_hp")
	local damage_max_hp_percentage    = self:GetSpecialValueFor("damage_max_hp_percentage")
	local damage_min_hp_percentage    = self:GetSpecialValueFor("damage_min_hp_percentage")

	local count_range = count_max_hp - count_min_hp
	local count = count_min_hp + ( count_range * ( caster:GetHealthPercent() / 100 ) )
	count = math.floor(count)

	local damage_range = damage_max_hp_percentage - damage_min_hp_percentage
	local damage = damage_min_hp_percentage + ( damage_range * ( caster:GetHealthPercent() / 100 ) )
	self.damage = math.floor(damage)

	local cast_time = 0.65

	caster:AddNewModifier(caster, self, "casting_rooted_modifier", {duration=cast_time})
	DisableMotionControllers(caster, cast_time)

	-- Sound and Animation --
	local sound = {"juggernaut_jugsc_arc_ability_bladefury_12", "juggernaut_jugsc_arc_ability_bladefury_09",
					"juggernaut_jugsc_arc_ability_bladefury_02", "juggernaut_jugsc_arc_ability_bladefury_16"}
	EmitAnnouncerSound( sound[RandomInt(1, #sound)] )

	-- Sound --
	StartSoundEventFromPositionReliable("Hero_Juggernaut.BladeFury.Impact", caster_loc)
	
	StartAnimation(caster, {duration=cast_time, activity=ACT_DOTA_OVERRIDE_ABILITY_1, rate=1.00})

	-- Particle -- PATTACH_ABSORIGIN-PATTACH_ABSORIGIN_FOLLOW-PATTACH_CUSTOMORIGIN
	local particle = ParticleManager:CreateParticle("particles/econ/items/juggernaut/jugg_ti8_sword/juggernaut_blade_fury_abyssal.vpcf", PATTACH_ABSORIGIN, caster)
	ParticleManager:SetParticleControl( particle, 0, caster_loc + Vector(0,0,120) )
	ParticleManager:SetParticleControl( particle, 5, Vector(500,0,0) )	
	PersistentParticle_Add(particle)

	local timer = Timers:CreateTimer(cast_time, function()
			ParticleManager:DestroyParticle( particle, false )
			ParticleManager:ReleaseParticleIndex( particle )
			particle = nil
	end)
	PersistentTimer_Add(timer)

	local points_start = {}
	local points = {}

	for i=1,count do

		local rad = 360 / count
		local direction = RotateVector2D(caster:GetForwardVector(),math.rad(i*rad))
		local point = caster_loc + (direction * 150)
		point.z = point.z + 300

		table.insert(points_start, point)

		local point = GetRandomPointWithinArena(350)
		point = point * Vector(1,1,0)
		point = point + ( GetGroundPosition(point, caster) * Vector(0,0,1) )

		table.insert(points, point)

	end

	for i,point in ipairs(points_start) do

		local delay = RandomFloat(delay_min, delay_max)

		local timer1 = Timers:CreateTimer(RandomFloat(0.1, 0.1) * i-1, function()

			local caster_loc = caster:GetAbsOrigin()

			local particleWarning = EncounterGroundAOEWarningSticky(points[i], AoERadius, nil)

			-- Projectile --
			local projectile = {
				EffectName = "particles/encounter/samurai_of_chaos/samurai_of_chaos_chaotic_bladestorm.vpcf",
				vSpawnOrigin = caster_loc + Vector(0,0,64),--{unit=hero, attach="attach_attack1", offset=Vector(0,0,0)},
				fDistance = 9999,
				fStartRadius = 0,
				fEndRadius = 0,
				Source = caster,
				fExpireTime = 15.0,
				vVelocity = ( points_start[i] - caster_loc ):Normalized() * 1200,
				UnitBehavior = PROJECTILES_NOTHING,
				bMultipleHits = false,
				bIgnoreSource = true,
				TreeBehavior = PROJECTILES_NOTHING,
				bCutTrees = false,
				bTreeFullCollision = false,
				WallBehavior = PROJECTILES_NOTHING,
				GroundBehavior = PROJECTILES_NOTHING,
				fGroundOffset = 64,
				nChangeMax = 1000,
				bRecreateOnChange = true,
				bZCheck = false,
				bGroundLock = false,
				bProvidesVision = false,
				bDestroyImmediate = true,
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
				fChangeDelay = 0.01,
				--fRadiusStep = 10,
				--bUseFindUnitsInRadius = false,

				--UnitTest = function(self, victim) return victim:GetTeamNumber() ~= caster:GetTeamNumber() end,
				--OnUnitHit = function(self, victim) ... end,

				--OnTreeHit = function(self, tree) ... end,
				--OnWallHit = function(self, gnvPos) ... end,
				--OnGroundHit = function(self, groundPos) ... end,
				OnFinish = function(self, pos)

								local caster = self.Source
								local team = caster:GetTeamNumber()
								local ability = caster:FindAbilityByName("samurai_of_chaos_chaotic_bladestorm")
								local AoERadius = ability:GetSpecialValueFor("AoERadius")

								local damage = ability.damage

								-- Sound --
								StartSoundEventFromPositionReliable("Hero_ChaosKnight.ChaosBolt.Impact", pos)

								-- Particle --
								local particle = ParticleManager:CreateParticle("particles/encounter/samurai_of_chaos/samurai_of_chaos_chaotic_bladestorm_endcap.vpcf", PATTACH_CUSTOMORIGIN, nil)
								ParticleManager:SetParticleControl( particle, 0, pos )
								ParticleManager:ReleaseParticleIndex( particle )
								particle = nil

								-- DOTA_UNIT_TARGET_TEAM_FRIENDLY; DOTA_UNIT_TARGET_TEAM_ENEMY; DOTA_UNIT_TARGET_TEAM_BOTH
								local units	= FindUnitsInRadius(team, pos, nil, AoERadius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
								for _,victim in pairs(units) do
									-- Apply Damage --
									EncounterApplyDamage(victim, caster, ability, damage, DAMAGE_TYPE_MAGICAL, DOTA_DAMAGE_FLAG_NONE)
								end

							end,
			}

			local advanced_projectile = Projectiles:CreateProjectile(projectile)
			PersistentAdvancedProjectile_Add(advanced_projectile)

			local time = 0
			local interval = 0.03
			local timer2 = Timers:CreateTimer(function()

				--advanced_projectile:SetVelocity( ( points_start[i] - caster_loc ):Normalized() * ( 900 - ( time * 22 ) ), nil) 
				advanced_projectile:SetVelocity( advanced_projectile:GetVelocity() * 0.92, nil)

				if time >= 0.75 then
					advanced_projectile:SetVelocity( Vector(0,0,0), nil) 

					return
				end
				
				time = time + interval
				return interval
			end)
			PersistentTimer_Add(timer2)

			local timer3 = Timers:CreateTimer(delay + ( RandomFloat(0.1, 0.2) * i-1 ), function()

				local projectileSpeed = 500
				local projectileDistance = ( points[i] - points_start[i] ):Length2D()
				local finishTime = projectileDistance / projectileSpeed

				advanced_projectile.bDestroyImmediate = false
				advanced_projectile.fDistance = advanced_projectile:GetDistanceTraveled() + projectileDistance
				advanced_projectile:SetVelocity( ( points[i] - points_start[i] ):Normalized() * projectileSpeed, nil) 

				local timer4 = Timers:CreateTimer(finishTime, function()
					-- Particle --
					ParticleManager:DestroyParticle( particleWarning, false )
					ParticleManager:ReleaseParticleIndex( particleWarning )
					particleWarning = nil
				end)
				PersistentTimer_Add(timer4)

			end)
			PersistentTimer_Add(timer3)

		end)
		PersistentTimer_Add(timer1)

	end

end

function samurai_of_chaos_chaotic_bladestorm:OnAbilityPhaseStart()
	local caster			= self:GetCaster()
	local playerID			= caster:GetPlayerOwnerID()
	local player			= PlayerResource:GetPlayer(playerID)

	return true
end

function samurai_of_chaos_chaotic_bladestorm:GetManaCost(abilitylevel)
	return self.BaseClass.GetManaCost(self, abilitylevel)
end

function samurai_of_chaos_chaotic_bladestorm:GetCooldown(abilitylevel)
	return self.BaseClass.GetCooldown(self, abilitylevel)
end