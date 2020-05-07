smodhex_satyr_warlock_shadow_fountain = class({})

LinkLuaModifier( 'smodhex_satyr_warlock_resisted_shadows_modifier', 'encounters/smodhex_satyr_warlock/smodhex_satyr_warlock_resisted_shadows_modifier', LUA_MODIFIER_MOTION_NONE )

function smodhex_satyr_warlock_shadow_fountain:OnSpellStart()

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
	local damage_instances            = self:GetSpecialValueFor("damage_instances")
	local delay                       = self:GetSpecialValueFor("delay")
	local location_damage             = self:GetSpecialValueFor("location_damage")
	local location_aoe                = self:GetSpecialValueFor("location_aoe")
	local phase_two_percentage        = self:GetSpecialValueFor("phase_two_percentage")
	local phase_two_buff_duration     = self:GetSpecialValueFor("phase_two_buff_duration")

	caster:AddNewModifier(caster, self, "casting_rooted_modifier", {duration=delay})
	DisableMotionControllers(caster, delay)

	local location = GetSpecificBorderPoint("point_center")

	TurnToLoc(caster, location, delay)

	-- Sound --
	local sound = {"leshrac_lesh_ability_edict_01", "leshrac_lesh_ability_edict_02",
					"leshrac_lesh_ability_edict_05", "leshrac_lesh_ability_storm_01",
					"leshrac_lesh_ability_nova_02"}
	EmitAnnouncerSound( sound[RandomInt(1, #sound)] )

	EncounterGroundAOEWarningSticky(location, location_aoe, delay+3.0, Vector(0,255,0))

	-- Particle --
	local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_shadow_demon/shadow_demon_soul_catcher_spiral03.vpcf", PATTACH_CUSTOMORIGIN, nil)
	ParticleManager:SetParticleControl( particle, 0, location )
	ParticleManager:SetParticleControl( particle, 1, location )
	PersistentParticle_Add(particle)
	local particle1 = particle

	-- Particle --
	local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_shadow_demon/shadow_demon_disruption_center.vpcf", PATTACH_CUSTOMORIGIN, nil)
	ParticleManager:SetParticleControl( particle, 0, location )
	ParticleManager:SetParticleControl( particle, 1, Vector(1,0,0) )
	PersistentParticle_Add(particle)
	local particle2 = particle

	local timer = Timers:CreateTimer(delay-1.00, function()

		-- Animation --
		StartAnimation(caster, {duration=2, activity=ACT_DOTA_ATTACK, rate=1.0, translate="tidebringer"})

		-- Sound --
		EmitAnnouncerSound("leshrac_lesh_anger_05")

	end)
	PersistentTimer_Add(timer)

	local timer = Timers:CreateTimer(delay-0.25, function()

		local ground_pos = GetGroundPosition(location, caster) * Vector(0,0,1)

		-- Sound --
		caster:EmitSound("Hero_SkywrathMage.ConcussiveShot.Cast")

		-- Projectile --
		local projectile = {
			EffectName = "particles/encounter/scroll_collector/scroll_collector_triple_shadow_bolt.vpcf",
			vSpawnOrigin = {unit=caster, attach="attach_weapon", offset=Vector(0,0,0)},
			fDistance = (caster_loc - location):Length2D(),
			fStartRadius = 0,
			fEndRadius = 0,
			Source = caster,
			fExpireTime = 10.0,
			vVelocity = caster:GetForwardVector() * 1600,
			UnitBehavior = PROJECTILES_NOTHING,
			bMultipleHits = false,
			bIgnoreSource = true,
			TreeBehavior = PROJECTILES_NOTHING,
			bCutTrees = false,
			bTreeFullCollision = false,
			WallBehavior = PROJECTILES_NOTHING,
			GroundBehavior = PROJECTILES_NOTHING,
			fGroundOffset = 0,
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

				local caster                  = self.Source
				local team                    = caster:GetTeamNumber()
				local ability                 = caster:FindAbilityByName("smodhex_satyr_warlock_shadow_fountain")
				local phase_two_percentage    = ability:GetSpecialValueFor("phase_two_percentage")
				local phase_two_buff_duration = ability:GetSpecialValueFor("phase_two_buff_duration")

				pos = ( pos * Vector(1,1,0) ) + ground_pos + Vector(0,0,25)

				-- Sound --
				StartSoundEventFromPositionReliable("Hero_SkywrathMage.ConcussiveShot.Target", pos)

				-- Particle --
				ParticleManager:DestroyParticle( particle1, false )
				ParticleManager:ReleaseParticleIndex( particle1 )
				particle1 = nil
				ParticleManager:DestroyParticle( particle2, false )
				ParticleManager:ReleaseParticleIndex( particle2 )
				particle2 = nil

				-- DOTA_UNIT_TARGET_TEAM_FRIENDLY; DOTA_UNIT_TARGET_TEAM_ENEMY; DOTA_UNIT_TARGET_TEAM_BOTH
				local units	= FindUnitsInRadius(team, location, nil, location_aoe, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
				if units[1] ~= nil then

					-- DOTA_UNIT_TARGET_TEAM_FRIENDLY; DOTA_UNIT_TARGET_TEAM_ENEMY; DOTA_UNIT_TARGET_TEAM_BOTH
					local units	= FindUnitsInRadius(team, location, nil, location_aoe, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
					local particle = {}
					for _,victim in pairs(units) do
						-- Apply Damage --
						EncounterApplyDamage(victim, caster, ability, location_damage, DAMAGE_TYPE_MAGICAL, DOTA_DAMAGE_FLAG_NONE)

						-- PHASE 2 --
						if caster:GetHealthPercent() < phase_two_percentage then
							if _ == 1 then
								-- Modifier --
								local modifier = victim:AddNewModifier(caster, ability, "smodhex_satyr_warlock_resisted_shadows_modifier", { duration=phase_two_buff_duration })
								PersistentModifier_Add(modifier)
							end
						end

					end

				else

					-- Particle --
					local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_shadow_demon/shadow_demon_disruption.vpcf", PATTACH_CUSTOMORIGIN, nil)
					ParticleManager:SetParticleControl( particle, 0, location )
					ParticleManager:SetParticleControl( particle, 1, location )
					PersistentParticle_Add(particle)

					local timer1 = Timers:CreateTimer(0, function()

						local victim		= GetRandomHeroEntities(1)
						if not victim then return end
						victim				= victim[1]
						local victim_loc	= victim:GetAbsOrigin()

						local point = nil
						if RollPercentage(50) then
							if RollPercentage(75) then
								if RollPercentage(65) then
									point = victim_loc + RandomVector(50)
								else
									point = victim_loc + RandomVector(250)
								end
							else
								point = victim_loc + RandomVector(500)
							end
						else
							if RollPercentage(75) then
								if RollPercentage(65) then
									point = victim_loc - RandomVector(50)
								else
									point = victim_loc - RandomVector(250)
								end
							else
								point = victim_loc - RandomVector(500)
							end
						end

						local ability = caster:FindAbilityByName("smodhex_satyr_warlock_shadow_fountain")
						local AoERadius = ability:GetSpecialValueFor("AoERadius")

						--EncounterGroundAOEWarning(point, AoERadius)
						EncounterGroundAOEWarningSticky(point, AoERadius, 1.5)

						-- Projectile --
						local projectile = {
							EffectName = "particles/encounter/scroll_collector/scroll_collector_triple_shadow_bolt.vpcf",
							vSpawnOrigin = location + Vector(0,0,25),--{unit=hero, attach="attach_attack1", offset=Vector(0,0,0)},
							fDistance = (location - point):Length2D(),
							fStartRadius = 0,
							fEndRadius = 0,
							Source = caster,
							fExpireTime = 10.0,
							vVelocity = ( point - location ):Normalized() * 1250,
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
								local ability = caster:FindAbilityByName("smodhex_satyr_warlock_shadow_fountain")
								local damage = ability:GetSpecialValueFor("damage")
								local AoERadius = ability:GetSpecialValueFor("AoERadius")

								-- Sound --
								StartSoundEventFromPositionReliable("Hero_ChaosKnight.ChaosBolt.Impact", point)

								-- Particle --
								local particle = ParticleManager:CreateParticle("particles/neutral_fx/centaur_khan_stomp_dust.vpcf", PATTACH_CUSTOMORIGIN, nil)
								ParticleManager:SetParticleControl( particle, 0, point )
								ParticleManager:ReleaseParticleIndex( particle )
								particle = nil

								-- DOTA_UNIT_TARGET_TEAM_FRIENDLY; DOTA_UNIT_TARGET_TEAM_ENEMY; DOTA_UNIT_TARGET_TEAM_BOTH
								local units	= FindUnitsInRadius(team, point, nil, AoERadius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
								for _,victim in pairs(units) do
									-- Apply Damage --
									EncounterApplyDamage(victim, caster, ability, damage, DAMAGE_TYPE_MAGICAL, DOTA_DAMAGE_FLAG_NONE)
								end

							end,
							}

						local advanced_projectile = Projectiles:CreateProjectile(projectile)
						PersistentAdvancedProjectile_Add(advanced_projectile)

						return damage_interval
					end)
					PersistentTimer_Add(timer1)

					local timer2 = Timers:CreateTimer(duration, function()

						Timers:RemoveTimer(timer1)
						timer1 = nil

						-- Particle --
						ParticleManager:DestroyParticle( particle, false )
						ParticleManager:ReleaseParticleIndex( particle )
						particle = nil
						
					end)
					PersistentTimer_Add(timer2)

				end

			end,
			}

		local advanced_projectile = Projectiles:CreateProjectile(projectile)
		PersistentAdvancedProjectile_Add(advanced_projectile)

	end)
	PersistentTimer_Add(timer)

end

function smodhex_satyr_warlock_shadow_fountain:OnAbilityPhaseStart()
	local caster			= self:GetCaster()
	local playerID			= caster:GetPlayerOwnerID()
	local player			= PlayerResource:GetPlayer(playerID)

	return true
end

function smodhex_satyr_warlock_shadow_fountain:GetManaCost(abilitylevel)
	return self.BaseClass.GetManaCost(self, abilitylevel)
end

function smodhex_satyr_warlock_shadow_fountain:GetCooldown(abilitylevel)
	return self.BaseClass.GetCooldown(self, abilitylevel)
end