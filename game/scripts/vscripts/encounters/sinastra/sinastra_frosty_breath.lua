sinastra_frosty_breath = class({})

LinkLuaModifier( 'sinastra_frosty_breath_modifier', 'encounters/sinastra/sinastra_frosty_breath_modifier', LUA_MODIFIER_MOTION_NONE )

function sinastra_frosty_breath:OnSpellStart()

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
	local AbilityCastRange            = self:GetSpecialValueFor("AbilityCastRange")
	local AoERadius                   = self:GetSpecialValueFor("AoERadius")
	local duration                    = self:GetSpecialValueFor("duration")
	local damage                      = self:GetSpecialValueFor("damage")
	local delay                       = self:GetSpecialValueFor("delay")
	local move_speed_percentage       = self:GetSpecialValueFor("move_speed_percentage")

	local loc

	caster:AddNewModifier(caster, self, "casting_rooted_modifier", {duration=delay})
	DisableMotionControllers(caster, delay)

	caster:Stop()

	caster:FaceTowards(victim_loc)

	StartAnimation(caster, {duration=delay, activity=ACT_DOTA_DISABLED, rate=0.8})

	local timer = Timers:CreateTimer(delay*0.6, function()
		loc = victim_loc + ( -caster:GetForwardVector() * ( AbilityCastRange / 3 ) )
		loc = GetGroundPosition(loc, caster)

		EncounterGroundAOEWarningSticky(loc, AoERadius, delay+1.5)
	end)
	PersistentTimer_Add(timer)

	local timer = Timers:CreateTimer(delay*0.85, function()
		StartAnimation(caster, {duration=1.5, activity=ACT_DOTA_ATTACK, rate=1.25})
	end)
	PersistentTimer_Add(timer)

	local timer = Timers:CreateTimer(delay, function()

		-- Sound --
		caster:EmitSound("Hero_Winter_Wyvern.ArcticBurn.Cast")

		local projectile = {
			EffectName = "particles/encounter/sinastra/sinastra_orb.vpcf",
			vSpawnOrigin = caster:GetAbsOrigin(),
			fDistance = (loc - caster:GetAbsOrigin()):Length2D(),
			fStartRadius = 0,
			fEndRadius = 0,
			Source = caster,
			fExpireTime = 20,
			vVelocity = caster:GetForwardVector() * 500,
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

			--UnitTest = function(self, victim) return victim:GetTeamNumber() ~= caster:GetTeamNumber() end,
			--OnUnitHit = function(self, victim) ... end,
			--OnTreeHit = function(self, tree) ... end,
			--OnWallHit = function(self, gnvPos) ... end,
			--OnGroundHit = function(self, groundPos) ... end,
			OnFinish = function(self, loc)

				local caster		= self.Source
				local caster_loc	= caster:GetAbsOrigin()
				local playerID		= caster:GetPlayerOwnerID()
				local player		= PlayerResource:GetPlayer(playerID)
				local team			= caster:GetTeamNumber()

				local ability       = caster:FindAbilityByName("sinastra_frosty_breath")

				--- Get Special Values ---
				local AbilityCastRange            = ability:GetSpecialValueFor("AbilityCastRange")
				local AoERadius                   = ability:GetSpecialValueFor("AoERadius")
				local duration                    = ability:GetSpecialValueFor("duration")
				local damage                      = ability:GetSpecialValueFor("damage")
				local delay                       = ability:GetSpecialValueFor("delay")
				local move_speed_percentage       = ability:GetSpecialValueFor("move_speed_percentage")

				loc = GetGroundPosition(loc, caster)

				StartSoundEventFromPosition("Hero_Winter_Wyvern.SplinterBlast.Splinter", loc)

				-- Particle --
				local particle = ParticleManager:CreateParticle("particles/econ/items/lich/frozen_chains_ti6/lich_frozenchains_frostnova_g2.vpcf", PATTACH_CUSTOMORIGIN, nil)
				ParticleManager:SetParticleControl( particle, 0, loc )
				ParticleManager:ReleaseParticleIndex( particle )
				particle = nil

				local rad = 25

				local projectile_start = -2
				local projectile_end = 2

				for i=projectile_start,projectile_end do

					local direction

					direction = RotateVector2D(caster:GetForwardVector(),math.rad(i*rad))

					EncounterGroundConeWarning(caster, AoERadius/3, AoERadius, loc, direction, AbilityCastRange, 0.5+0.25)

					local timer1 = Timers:CreateTimer(0.5, function()

						if caster == nil then return end
						if caster:IsNull() then return end
						if not caster:IsAlive() then return end

						if i == 0 then
							-- Sound --
							caster:EmitSound("Hero_Winter_Wyvern.SplinterBlast.Splinter")
						end

						-- Particle --
						local data = {}
						data["0"] = "LOCATION"
						data["1"] = "LOCATION"
						data["2"] = "LOCATION"
						EncounterGroundConeParticle(caster, AoERadius/3, AoERadius, loc, direction, AbilityCastRange, 2.0, "particles/econ/items/lich/frozen_chains_ti6/lich_frozenchains_frostnova_g2.vpcf", data)

						-- Particle --
						local data = {}
						data["0"] = "LOCATION"

						-- DOTA_UNIT_TARGET_TEAM_FRIENDLY; DOTA_UNIT_TARGET_TEAM_ENEMY; DOTA_UNIT_TARGET_TEAM_BOTH
						local units	= EncounterGroundConeFindUnits(caster, AoERadius/3, AoERadius, loc, direction, AbilityCastRange, team, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE)
						for _,victim in pairs(units) do
							-- Modifier --
							local modifier = victim:AddNewModifier(caster, ability, "sinastra_frosty_breath_modifier", {duration = duration})
							PersistentModifier_Add(modifier)

							-- Apply Damage --
							EncounterApplyDamage(victim, caster, ability, damage, DAMAGE_TYPE_MAGICAL, DOTA_DAMAGE_FLAG_NONE)
						end

					end)
					PersistentTimer_Add(timer1)

				end

			end,
			}

			local advanced_projectile = Projectiles:CreateProjectile(projectile)
			PersistentAdvancedProjectile_Add(advanced_projectile)

	end)
	PersistentTimer_Add(timer)

end

function sinastra_frosty_breath:OnAbilityPhaseStart()
	local caster			= self:GetCaster()
	local playerID			= caster:GetPlayerOwnerID()
	local player			= PlayerResource:GetPlayer(playerID)

	return true
end

function sinastra_frosty_breath:GetManaCost(abilitylevel)
	return self.BaseClass.GetManaCost(self, abilitylevel)
end

function sinastra_frosty_breath:GetCooldown(abilitylevel)
	return self.BaseClass.GetCooldown(self, abilitylevel)
end