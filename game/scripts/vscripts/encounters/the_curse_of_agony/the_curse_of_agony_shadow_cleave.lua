the_curse_of_agony_shadow_cleave = class({})

function the_curse_of_agony_shadow_cleave:OnSpellStart()

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
	local damage                      = self:GetSpecialValueFor("damage")
	local delay                       = self:GetSpecialValueFor("delay")
	local projectile_speed            = self:GetSpecialValueFor("projectile_speed")

	caster:AddNewModifier(caster, self, "casting_rooted_modifier", {duration=delay})
	DisableMotionControllers(caster, delay)

	caster:Stop()

	-- Sound --
	local sound = {"bane_bane_cast_01", "bane_bane_cast_02",
					"bane_bane_cast_03"}
	EmitAnnouncerSound( sound[RandomInt(1, #sound)] )

	-- Animation --
	StartAnimation(caster, {duration=delay, activity=ACT_DOTA_DISABLED, rate=0.75})

	for x=0,3 do

		local dir

		if x == 0 then
			dir = RotateVector2D( caster:GetForwardVector(), math.rad( RandomInt(-20, 20) ) )
		end
		if x == 1 then
			dir = RotateVector2D( caster:GetForwardVector(), math.rad( RandomInt(70, 110) ) )
		end
		if x == 2 then
			dir = RotateVector2D( caster:GetForwardVector(), math.rad( RandomInt(160, 200) ) )
		end
		if x == 3 then
			dir = RotateVector2D( caster:GetForwardVector(), math.rad( RandomInt(250, 290) ) )
		end

		local timer1 = Timers:CreateTimer(0.2*x, function()

			local count = 0
			local rad = 8

			for i=-3,3 do

				local direction = RotateVector2D( dir, math.rad(i*rad) )

				EncounterGroundLineWarning(caster, AoERadius/2, AoERadius, caster_loc, direction, AbilityCastRange, delay)

				local timer2 = Timers:CreateTimer(delay + (count*0.03), function()

					local modifier = caster:FindModifierByName("the_curse_of_agony_banished_modifier")

					if modifier == nil then

						-- Animation --
						StartAnimation(caster, {duration=1.0, activity=ACT_DOTA_ATTACK, rate=1.75})

						TurnToLoc(caster, direction, 0.1)

						if i == -3 or i == 3 then
							-- Sound --
							caster:EmitSound("Hero_Oracle.FortunesEnd.Attack")
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
								local ability = caster:FindAbilityByName("the_curse_of_agony_shadow_cleave")
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

				count = count + 1
			end

		end)
		PersistentTimer_Add(timer1)
	end

end

function the_curse_of_agony_shadow_cleave:OnAbilityPhaseStart()
	local caster			= self:GetCaster()
	local playerID			= caster:GetPlayerOwnerID()
	local player			= PlayerResource:GetPlayer(playerID)

	return true
end

function the_curse_of_agony_shadow_cleave:GetManaCost(abilitylevel)
	return self.BaseClass.GetManaCost(self, abilitylevel)
end

function the_curse_of_agony_shadow_cleave:GetCooldown(abilitylevel)
	return self.BaseClass.GetCooldown(self, abilitylevel)
end