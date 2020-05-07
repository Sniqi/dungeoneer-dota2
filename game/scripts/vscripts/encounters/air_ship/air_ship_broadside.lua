air_ship_broadside = class({})

function air_ship_broadside:OnSpellStart()

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
	local shots_max_hp                = self:GetSpecialValueFor("shots_max_hp")
	local shots_min_hp                = self:GetSpecialValueFor("shots_min_hp")
	local delay_max_hp                = self:GetSpecialValueFor("delay_max_hp")
	local delay_min_hp                = self:GetSpecialValueFor("delay_min_hp")
	local delay_shot_max_hp           = self:GetSpecialValueFor("delay_shot_max_hp")
	local delay_shot_min_hp           = self:GetSpecialValueFor("delay_shot_min_hp")
	local stun                        = self:GetSpecialValueFor("stun")
	local projectile_speed            = self:GetSpecialValueFor("projectile_speed")

	local shots_range = shots_max_hp - shots_min_hp
	local shots = shots_min_hp + ( shots_range * ( caster:GetHealthPercent() / 100 ) )
	shots = math.floor(shots)

	local delay_range = delay_max_hp - delay_min_hp
	local delay = delay_min_hp + ( delay_range * ( caster:GetHealthPercent() / 100 ) )

	local delay_shot_range = delay_shot_max_hp - delay_shot_min_hp
	local delay_shot = delay_shot_min_hp + ( delay_shot_range * ( caster:GetHealthPercent() / 100 ) )

	caster:AddNewModifier(caster, self, "casting_rooted_modifier", {duration=delay+(delay_shot*shots)})
	DisableMotionControllers(caster, delay+(delay_shot*shots))

	caster:Stop()

	EncounterUnitWarning(caster, 1.0, true, nil) --nil=yellow, "red", "orange", "green"

	for i=1,shots do

		local direction = {}
		local loc = {}

		local count = 0
		local timer = Timers:CreateTimer((delay_shot*i), function()

			-- Sound --
			caster:EmitSound("Ability.AssassinateLoad")

			direction[i] = RotateVector2D(Vector(0,-1,0),math.rad(RandomInt(-55,55)))
			loc[i] = caster_loc+(Vector(RandomInt(-70,70),100,0))

			EncounterGroundLineWarning(caster, AoERadius/2, AoERadius, loc[i], direction[i], AbilityCastRange, delay)
		end)
		PersistentTimer_Add(timer)

		local timer = Timers:CreateTimer(delay + (delay_shot*i), function()

			-- Sound --
			caster:EmitSound("Hero_Sniper.attack")

			local projectile = {
				EffectName = "particles/encounter/ancient_siege_engine/ancient_siege_engine_multishot.vpcf",
				vSpawnOrigin = loc[i] + Vector(0,0,100),--{unit=hero, attach="attach_attack1", offset=Vector(0,0,0)},
				fDistance = AbilityCastRange,
				fStartRadius = AoERadius/2,
				fEndRadius = AoERadius,
				Source = caster,
				fExpireTime = 10.0,
				vVelocity = direction[i] * projectile_speed,
				UnitBehavior = PROJECTILES_NOTHING,
				bMultipleHits = false,
				bIgnoreSource = true,
				TreeBehavior = PROJECTILES_NOTHING,
				bCutTrees = false,
				bTreeFullCollision = false,
				WallBehavior = PROJECTILES_NOTHING,
				GroundBehavior = PROJECTILES_NOTHING,
				fGroundOffset = 100,
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
					local ability = caster:FindAbilityByName("air_ship_broadside")
					local damage = ability:GetSpecialValueFor("damage")

					-- Sound --
					victim:EmitSound("Hero_Sniper.AssassinateDamage")

					-- Apply Damage --
					EncounterApplyDamage(victim, caster, ability, damage, DAMAGE_TYPE_PHYSICAL, DOTA_DAMAGE_FLAG_NONE)

					-- Modifier --
					victim:AddNewModifier(caster, ability, "modifier_stunned", {duration = stun})

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

function air_ship_broadside:OnAbilityPhaseStart()
	local caster			= self:GetCaster()
	local playerID			= caster:GetPlayerOwnerID()
	local player			= PlayerResource:GetPlayer(playerID)

	return true
end

function air_ship_broadside:GetManaCost(abilitylevel)
	return self.BaseClass.GetManaCost(self, abilitylevel)
end

function air_ship_broadside:GetCooldown(abilitylevel)
	return self.BaseClass.GetCooldown(self, abilitylevel)
end