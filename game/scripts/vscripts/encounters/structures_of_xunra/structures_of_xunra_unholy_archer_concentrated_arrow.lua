structures_of_xunra_unholy_archer_concentrated_arrow = class({})

function structures_of_xunra_unholy_archer_concentrated_arrow:OnSpellStart()

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
	local range                       = self:GetSpecialValueFor("range")
	local projectile_speed            = self:GetSpecialValueFor("projectile_speed")

	caster:AddNewModifier(caster, self, "casting_rooted_modifier", {duration=delay})
	DisableMotionControllers(caster, delay)

	caster:Stop()

	caster:AddNewModifier(caster, self, "turn_rate_modifier", {duration=delay})
	local timer1 = Timers:CreateTimer(0, function()
		victim_loc = victim:GetAbsOrigin()
		caster:FaceTowards(victim_loc)

		return 0.03
	end)
	PersistentTimer_Add(timer1)

	StartAnimation(caster, {duration=delay, activity=ACT_DOTA_DISABLED, rate=0.5})

	local direction

	local timer = Timers:CreateTimer(0.5, function()
		
		direction = caster:GetForwardVector()

		EncounterGroundLineWarning(caster, AoERadius, AoERadius, caster_loc, direction, range, delay/1.25)
	end)

	local timer = Timers:CreateTimer(delay, function()

		Timers:RemoveTimer(timer1)
		timer1 = nil

		if caster == nil then return end
		if caster:IsNull() then return end
		if not caster:IsAlive() then return end

		-- Sound --
		caster:EmitSound("Ability.Powershot")

		StartAnimation(caster, {duration=1.0, activity=ACT_DOTA_ATTACK, rate=2.0})

		local projectile = {
			EffectName = "particles/econ/items/windrunner/windrunner_ti6/windrunner_spell_powershot_ti6.vpcf",
			vSpawnOrigin = caster_loc + Vector(0,0,50),--{unit=hero, attach="attach_attack1", offset=Vector(0,0,0)},
			fDistance = range,
			fStartRadius = AoERadius,
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
			fGroundOffset = 50,
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
				local ability = caster:FindAbilityByName("structures_of_xunra_unholy_archer_concentrated_arrow")
				local duration = ability:GetSpecialValueFor("duration")
				local damage = ability:GetSpecialValueFor("damage")

				-- Sound --
				victim:EmitSound("Hero_ChaosKnight.ChaosBolt.Impact")

				-- Apply Damage --
				EncounterApplyDamage(victim, caster, self, damage, DAMAGE_TYPE_PHYSICAL, DOTA_DAMAGE_FLAG_NONE)

				-- Modifier --
				victim:AddNewModifier(caster, self, "modifier_stunned", {duration=duration})


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

function structures_of_xunra_unholy_archer_concentrated_arrow:OnAbilityPhaseStart()
	local caster			= self:GetCaster()
	local playerID			= caster:GetPlayerOwnerID()
	local player			= PlayerResource:GetPlayer(playerID)

	return true
end

function structures_of_xunra_unholy_archer_concentrated_arrow:GetManaCost(abilitylevel)
	return self.BaseClass.GetManaCost(self, abilitylevel)
end

function structures_of_xunra_unholy_archer_concentrated_arrow:GetCooldown(abilitylevel)
	return self.BaseClass.GetCooldown(self, abilitylevel)
end