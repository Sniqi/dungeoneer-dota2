scroll_collector_dark_orb = class({})

function scroll_collector_dark_orb:OnSpellStart()

	--- Get Caster, Victim, Player, Point ---
	local caster		= self:GetCaster()
	local caster_loc	= caster:GetAbsOrigin()
	local playerID		= caster:GetPlayerOwnerID()
	local player		= PlayerResource:GetPlayer(playerID)
	local team			= caster:GetTeamNumber()
	
	--- Get Special Values ---
	local AoERadius                   = self:GetSpecialValueFor("AoERadius")
	local duration                    = self:GetSpecialValueFor("duration")
	local damage                      = self:GetSpecialValueFor("damage")
	local damage_interval             = self:GetSpecialValueFor("damage_interval")
	local delay                       = self:GetSpecialValueFor("delay")
	local projectile_speed            = self:GetSpecialValueFor("projectile_speed")

	caster:AddNewModifier(caster, self, "casting_rooted_modifier", {duration=delay})
	DisableMotionControllers(caster, delay)

	EncounterUnitWarning(caster, delay, true, nil) --nil=yellow, "red", "orange", "green"

	-- Sound and Animation --
	local sound = {"dark_seer_dkseer_level_01", "dark_seer_dkseer_cast_01"}
	EmitAnnouncerSound( sound[RandomInt(1, #sound)] )

	StartAnimation(caster, {duration=delay, activity=ACT_DOTA_RUN, translate="haste", rate=1.0})

	local timer = Timers:CreateTimer(delay, function()

		local projectile = {
			EffectName = "particles/encounter/scroll_collector/scroll_collector_dark_orb.vpcf",
			vSpawnOrigin = caster_loc + Vector(0,0,80),--{unit=hero, attach="attach_attack1", offset=Vector(0,0,0)},
			fDistance = 999999,
			fStartRadius = AoERadius,
			fEndRadius = AoERadius,
			Source = caster,
			fExpireTime = duration,
			vVelocity = caster:GetForwardVector() * projectile_speed,-- RandomVector(1000),
			UnitBehavior = PROJECTILES_NOTHING,
			bMultipleHits = true,
			bIgnoreSource = true,
			TreeBehavior = PROJECTILES_NOTHING,
			bCutTrees = false,
			bTreeFullCollision = false,
			WallBehavior = PROJECTILES_NOTHING,
			GroundBehavior = PROJECTILES_NOTHING,
			fGroundOffset = 80,
			nChangeMax = 999999,
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
			fRehitDelay = damage_interval,
			fChangeDelay = 0.1,
			--fRadiusStep = 10,
			--bUseFindUnitsInRadius = false,

			UnitTest = function(self, victim) return victim:GetTeamNumber() ~= caster:GetTeamNumber() end,
			OnUnitHit = function(self, victim)

				local caster = self.Source
				local ability = caster:FindAbilityByName("scroll_collector_dark_orb")
				local damage = ability:GetSpecialValueFor("damage")

				--print ('HIT UNIT: ' .. caster:GetUnitName())

				if victim == nil then return true end
				if victim:IsNull() then return true end
				if not IsValidEntity(victim) or not victim:IsAlive() then return true end

				-- Sound --
				victim:EmitSound("Hero_Luna.Eclipse.Target")

				-- Particle --
				local particle = ParticleManager:CreateParticle("particles/econ/items/luna/luna_lucent_ti5/luna_eclipse_impact_notarget_moonfall.vpcf", PATTACH_ABSORIGIN_FOLLOW, victim)
				ParticleManager:SetParticleControl( particle, 0, victim:GetAbsOrigin() )
				ParticleManager:SetParticleControl( particle, 1, victim:GetAbsOrigin() )
				ParticleManager:SetParticleControl( particle, 2, victim:GetAbsOrigin() )
				ParticleManager:SetParticleControl( particle, 5, victim:GetAbsOrigin() )
				ParticleManager:ReleaseParticleIndex( particle )

				-- Apply Damage --
				EncounterApplyDamage(victim, caster, ability, damage, DAMAGE_TYPE_MAGICAL, DOTA_DAMAGE_FLAG_NONE)

				Timers:CreateTimer(0.5, function()
					local sound = {"dark_seer_dkseer_laugh_08", "dark_seer_dkseer_laugh_12"}
					EmitAnnouncerSound( sound[RandomInt(1, #sound)] )
				end)

			end,
			--OnTreeHit = function(self, tree) ... end,
			--OnWallHit = function(self, gnvPos) ... end,
			--OnGroundHit = function(self, groundPos) ... end,
		}

		local advanced_projectile = Projectiles:CreateProjectile(projectile)
		PersistentAdvancedProjectile_Add(advanced_projectile)

		local timer1 = Timers:CreateTimer(0, function()

			local loc = projectile:GetPosition()

			local min_x = GetSpecificBorderPoint("point_top_left").x
			if GetSpecificBorderPoint("point_left").x < min_x then min_x = GetSpecificBorderPoint("point_left").x end
			if GetSpecificBorderPoint("point_bottom_left").x < min_x then min_x = GetSpecificBorderPoint("point_bottom_left").x end

			local min_y = GetSpecificBorderPoint("point_bottom_left").y
			if GetSpecificBorderPoint("point_bottom").y < min_y then min_y = GetSpecificBorderPoint("point_bottom").y end
			if GetSpecificBorderPoint("point_bottom_right").y < min_y then min_y = GetSpecificBorderPoint("point_bottom_right").y end

			local max_x = GetSpecificBorderPoint("point_top_right").x
			if GetSpecificBorderPoint("point_right").x > max_x then max_x = GetSpecificBorderPoint("point_right").x end
			if GetSpecificBorderPoint("point_bottom_right").x > max_x then max_x = GetSpecificBorderPoint("point_bottom_right").x end

			local max_y = GetSpecificBorderPoint("point_top_left").y
			if GetSpecificBorderPoint("point_top").y > max_y then max_y = GetSpecificBorderPoint("point_top").y end
			if GetSpecificBorderPoint("point_top_right").y > max_y then max_y = GetSpecificBorderPoint("point_top_right").y end

			if loc.z < -10000 or
				loc.x < min_x or loc.y < min_y or
				loc.x > max_x or loc.y > max_y then

				projectile:SetVelocity( -projectile:GetVelocity() )

			end

			return 0.1
		end)
		PersistentTimer_Add(timer1)

	end)
	PersistentTimer_Add(timer)

end

function scroll_collector_dark_orb:OnAbilityPhaseStart()
	local caster			= self:GetCaster()
	local playerID			= caster:GetPlayerOwnerID()
	local player			= PlayerResource:GetPlayer(playerID)

	return true
end

function scroll_collector_dark_orb:GetManaCost(abilitylevel)
	return self.BaseClass.GetManaCost(self, abilitylevel)
end

function scroll_collector_dark_orb:GetCooldown(abilitylevel)
	return self.BaseClass.GetCooldown(self, abilitylevel)
end