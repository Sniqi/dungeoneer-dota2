smodhex_satyr_warlock_shadow_bolt_volley = class({})

function smodhex_satyr_warlock_shadow_bolt_volley:OnSpellStart()

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

	local projectile_speed = 700

	caster:AddNewModifier(caster, self, "casting_rooted_modifier", {duration=delay})
	DisableMotionControllers(caster, delay)

	-- Sound --
	local sound = {"leshrac_lesh_attack_01", "leshrac_lesh_attack_02",
					"leshrac_lesh_attack_04", "leshrac_lesh_attack_12"}
	EmitAnnouncerSound( sound[RandomInt(1, #sound)] )

	local timer = Timers:CreateTimer(delay - 1.1, function()
		-- Animation --
		StartAnimation(caster, {duration=3, activity=ACT_DOTA_ATTACK, rate=0.75, translate="tidebringer"})
	end)
	PersistentTimer_Add(timer)

	for _,victim in pairs( GetHeroesAliveEntities() ) do

		local victim_loc = victim:GetAbsOrigin()

		EncounterGroundAOEWarningSticky(victim_loc, AoERadius, delay + ( ( caster_loc - victim_loc ):Length2D() / projectile_speed ) )

		-- Projectile --
		local projectile = {
			EffectName = "particles/encounter/scroll_collector/scroll_collector_triple_shadow_bolt.vpcf",
			vSpawnOrigin = {unit=caster, attach="attach_weapon", offset=Vector(0,0,0)},
			fDistance = ( caster_loc - victim_loc ):Length2D(),
			fStartRadius = 0,
			fEndRadius = 0,
			Source = caster,
			fExpireTime = 10.0,
			vVelocity = ( victim_loc - caster_loc ):Normalized() * projectile_speed,
			UnitBehavior = PROJECTILES_NOTHING,
			bMultipleHits = false,
			bIgnoreSource = true,
			TreeBehavior = PROJECTILES_NOTHING,
			bCutTrees = false,
			bTreeFullCollision = false,
			WallBehavior = PROJECTILES_NOTHING,
			GroundBehavior = PROJECTILES_NOTHING,
			fGroundOffset = 25,
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

				local caster = self.Source
				local team = caster:GetTeamNumber()
				local ability = caster:FindAbilityByName("smodhex_satyr_warlock_shadow_bolt_volley")
				local AoERadius = ability:GetSpecialValueFor("AoERadius")
				local damage = ability:GetSpecialValueFor("damage")

				-- Sound --
				victim:EmitSound("Hero_ChaosKnight.ChaosBolt.Impact")

				-- Particle --
				local particle = ParticleManager:CreateParticle("particles/encounter/smodhex_satyr_warlock/smodhex_satyr_warlock_shadow_bolt_volley_ground_dust.vpcf", PATTACH_CUSTOMORIGIN, nil)
				ParticleManager:SetParticleControl( particle, 0, victim_loc )
				ParticleManager:ReleaseParticleIndex( particle )
				particle = nil

				-- DOTA_UNIT_TARGET_TEAM_FRIENDLY; DOTA_UNIT_TARGET_TEAM_ENEMY; DOTA_UNIT_TARGET_TEAM_BOTH
				local units	= FindUnitsInRadius(team, victim_loc, nil, AoERadius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
				DeepPrintTable(units)
				for _,victim in pairs(units) do
					-- Apply Damage --
					EncounterApplyDamage(victim, caster, ability, damage, DAMAGE_TYPE_MAGICAL, DOTA_DAMAGE_FLAG_NONE)
				end

			end,
			}

		local timer = Timers:CreateTimer(delay + (0.1*_), function()

			-- Sound --
			caster:EmitSound("Hero_SkywrathMage.ConcussiveShot.Cast")

			local advanced_projectile = Projectiles:CreateProjectile(projectile)
			PersistentAdvancedProjectile_Add(advanced_projectile)

		end)
		PersistentTimer_Add(timer)

	end
end

function smodhex_satyr_warlock_shadow_bolt_volley:OnAbilityPhaseStart()
	local caster			= self:GetCaster()
	local playerID			= caster:GetPlayerOwnerID()
	local player			= PlayerResource:GetPlayer(playerID)

	return true
end

function smodhex_satyr_warlock_shadow_bolt_volley:GetManaCost(abilitylevel)
	return self.BaseClass.GetManaCost(self, abilitylevel)
end

function smodhex_satyr_warlock_shadow_bolt_volley:GetCooldown(abilitylevel)
	return self.BaseClass.GetCooldown(self, abilitylevel)
end