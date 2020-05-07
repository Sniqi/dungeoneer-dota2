ferocious_lava_elemental_fireball = class({})

function ferocious_lava_elemental_fireball:OnSpellStart()

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

	caster:AddNewModifier(caster, self, "casting_rooted_modifier", {duration=delay})
	DisableMotionControllers(caster, delay)

	-- Sound and Animation --
	local sound = {"nevermore_nev_arc_attack_04", "nevermore_nev_arc_attack_06",
					"nevermore_nev_arc_attack_07"}
	EmitAnnouncerSound( sound[RandomInt(1, #sound)] )
	
	StartAnimation(caster, {duration=delay, activity=ACT_DOTA_FLAIL, rate=0.5})
	local timer = Timers:CreateTimer(delay-0.23, function()
		StartAnimation(caster, {duration=2.0, activity=ACT_DOTA_ATTACK, rate=1.0})
	end)
	PersistentTimer_Add(timer)

	for _,victim in pairs(GetHeroesAliveEntities()) do
		EncounterGroundAOEWarningSticky(victim:GetAbsOrigin(), AoERadius, delay+1.0)

		local direction = (victim:GetAbsOrigin() - caster_loc):Normalized()
		local distance = (victim:GetAbsOrigin() - caster_loc):Length2D()

		local timer = Timers:CreateTimer(delay, function()

			local projectile = {
				EffectName = "particles/encounter/ferocious_lava_elemental/ferocious_lava_elemental_fireball.vpcf",
				vSpawnOrigin = {unit=caster, attach="attach_attack1", offset=Vector(0,0,0)},--caster_loc + Vector(0,0,200),--
				fDistance = distance,
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

					local caster = self.Source
					local ability = caster:FindAbilityByName("ferocious_lava_elemental_fireball")
					local AoERadius = ability:GetSpecialValueFor("AoERadius")
					local damage = ability:GetSpecialValueFor("damage")
					local phase_two_percentage = ability:GetSpecialValueFor("phase_two_percentage")
					
					StartSoundEventFromPosition("Hero_Jakiro.LiquidFire", pos)

					-- Particle --
					local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_phoenix/phoenix_fire_spirit_ground.vpcf", PATTACH_CUSTOMORIGIN, nil)
					ParticleManager:SetParticleControl( particle, 0, pos )
					ParticleManager:SetParticleControl( particle, 3, pos )
					ParticleManager:ReleaseParticleIndex( particle )
					particle = nil

					-- DOTA_UNIT_TARGET_TEAM_FRIENDLY; DOTA_UNIT_TARGET_TEAM_ENEMY; DOTA_UNIT_TARGET_TEAM_BOTH
					local units	= FindUnitsInRadius(team, pos, nil, AoERadius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
					for _,victim in pairs(units) do
						-- Apply Damage --
						EncounterApplyDamage(victim, caster, ability, damage, DAMAGE_TYPE_MAGICAL, DOTA_DAMAGE_FLAG_NONE)
					end

					-- PHASE 2 --
					if caster:GetHealthPercent() < phase_two_percentage then
						local unit = CreateUnitByName("lesser_lava_elemental", pos, true, nil, nil, DOTA_TEAM_BADGUYS)
						PersistentUnit_Add(unit)
						EncounterCreate_AttackDamage(unit)
						EncounterCreate_Health(unit)
					end

				end,
			}

			local advanced_projectile = Projectiles:CreateProjectile(projectile)
			PersistentAdvancedProjectile_Add(advanced_projectile)
			
		end)
		PersistentTimer_Add(timer)
	end
end

function ferocious_lava_elemental_fireball:OnAbilityPhaseStart()
	local caster			= self:GetCaster()
	local playerID			= caster:GetPlayerOwnerID()
	local player			= PlayerResource:GetPlayer(playerID)

	return true
end

function ferocious_lava_elemental_fireball:GetManaCost(abilitylevel)
	return self.BaseClass.GetManaCost(self, abilitylevel)
end

function ferocious_lava_elemental_fireball:GetCooldown(abilitylevel)
	return self.BaseClass.GetCooldown(self, abilitylevel)
end