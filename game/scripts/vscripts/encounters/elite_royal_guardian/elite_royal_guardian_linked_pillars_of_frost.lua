elite_royal_guardian_linked_pillars_of_frost = class({})

function elite_royal_guardian_linked_pillars_of_frost:OnSpellStart()

	--- Get Caster, Victim, Player, loc ---
	local caster		= self:GetCaster()
	local caster_loc	= caster:GetAbsOrigin()
	local playerID		= caster:GetPlayerOwnerID()
	local player		= PlayerResource:GetPlayer(playerID)
	local team			= caster:GetTeamNumber()
	
	--- Get Special Values ---
	local AoERadius                   = self:GetSpecialValueFor("AoERadius")
	local duration                    = self:GetSpecialValueFor("duration")
	local delay                       = self:GetSpecialValueFor("delay")
	local count                       = self:GetSpecialValueFor("count")
	local interval_max_hp             = self:GetSpecialValueFor("interval_max_hp")
	local interval_min_hp             = self:GetSpecialValueFor("interval_min_hp")
	local damage_max_hp_percentage    = self:GetSpecialValueFor("damage_max_hp_percentage")
	local damage_min_hp_percentage    = self:GetSpecialValueFor("damage_min_hp_percentage")
	local projectile_speed_max_hp     = self:GetSpecialValueFor("projectile_speed_max_hp")
	local projectile_speed_min_hp     = self:GetSpecialValueFor("projectile_speed_min_hp")

	local interval_range = interval_max_hp - interval_min_hp
	local interval = interval_min_hp + ( interval_range * ( caster:GetHealthPercent() / 100 ) )

	local damage_range = damage_max_hp_percentage - damage_min_hp_percentage
	local damage = damage_min_hp_percentage + ( damage_range * ( caster:GetHealthPercent() / 100 ) )
	self.damage = math.floor(damage)

	local projectile_speed_range = projectile_speed_max_hp - projectile_speed_min_hp
	local projectile_speed = projectile_speed_min_hp + ( projectile_speed_range * ( caster:GetHealthPercent() / 100 ) )
	projectile_speed = math.floor(projectile_speed)

	caster:AddNewModifier(caster, self, "casting_rooted_modifier", {duration=delay})
	DisableMotionControllers(caster, delay)

	-- Sound and Animation --
	local sound = {"sven_sven_attack_04", "sven_sven_attack_07",
					"sven_sven_attack_12", "sven_sven_attack_02"}
	EmitAnnouncerSound( sound[RandomInt(1, #sound)] )
	
	StartAnimation(caster, {duration=delay, activity=ACT_DOTA_GENERIC_CHANNEL_1, rate=1.00})

	local locs = {}

	for i=1,count do

		local loc = GetRandomPointWithinArena(50)
		loc = loc * Vector(1,1,0)
		loc = loc + ( GetGroundPosition(loc, caster) * Vector(0,0,1) )

		table.insert(locs, loc)

	end

	for i,loc in ipairs(locs) do

		local timer1 = Timers:CreateTimer( (i-1) * 0.25, function()

			EncounterGroundAOEWarningSticky(loc, 60, delay+0.1)

			local timer2 = Timers:CreateTimer(delay, function()

				-- Particle -- PATTACH_ABSORIGIN-PATTACH_ABSORIGIN_FOLLOW-PATTACH_CUSTOMORIGIN
				local particle = ParticleManager:CreateParticle("particles/econ/items/effigies/status_fx_effigies/frosty_base_statue_destruction_dire.vpcf", PATTACH_CUSTOMORIGIN, nil)
				ParticleManager:SetParticleControl( particle, 0, loc )
				ParticleManager:ReleaseParticleIndex( particle )
				particle = nil

				-- Sound --
				StartSoundEventFromPositionReliable("Ability.SandKing_BurrowStrike", loc)

				local unit = CreateUnitByName("elite_royal_guardian_linked_pillars_of_frost", loc, true, nil, nil, DOTA_TEAM_BADGUYS)
				PersistentUnit_Add(unit)

				unit:AddNewModifier(caster, self, "modifier_invulnerable", {})
				unit:AddNewModifier(caster, self, "modifier_unselectable", {})
				--unit:AddNewModifier(caster, self, "modifier_phased", {})

				unit:Stop()

				unit:SetAbsOrigin( unit:GetAbsOrigin() + Vector(0,0,-600) )

				local timer3 = Timers:CreateTimer(function()

					if unit:GetAbsOrigin().z < GetGroundPosition( unit:GetAbsOrigin(), caster ).z - 100 then
						unit:SetAbsOrigin( unit:GetAbsOrigin() + Vector(0,0,100) )
					else
						return
					end

					return 0.03
				end)
				PersistentTimer_Add(timer3)

				local timer4 = Timers:CreateTimer(0.15, function()

					local loc1 = locs[i]
					local loc2 = locs[i+1]
					if loc2 == nil then
						loc2 = locs[1]
					end

					-- Projectile --
					local projectile = {
						EffectName = "particles/encounter/elite_royal_guardian/elite_royal_guardian_linked_pillars_of_frost.vpcf",
						vSpawnOrigin = loc1 + Vector(0,0,175),--{unit=hero, attach="attach_attack1", offset=Vector(0,0,0)},
						fDistance = ( loc2 - loc1 ):Length2D(),
						fStartRadius = AoERadius,
						fEndRadius = AoERadius,
						Source = caster,
						fExpireTime = 60.0,
						vVelocity = ( loc2 - loc1 ):Normalized() * projectile_speed,
						UnitBehavior = PROJECTILES_DESTROY,
						bMultipleHits = false,
						bIgnoreSource = true,
						TreeBehavior = PROJECTILES_NOTHING,
						bCutTrees = false,
						bTreeFullCollision = false,
						WallBehavior = PROJECTILES_NOTHING,
						GroundBehavior = PROJECTILES_NOTHING,
						fGroundOffset = 64,
						nChangeMax = 50,
						bRecreateOnChange = true,
						bZCheck = false,
						bGroundLock = false,
						bProvidesVision = false,
						bDestroyImmediate = false,
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

						UnitTest = function(self, victim) return victim:GetTeamNumber() ~= caster:GetTeamNumber() end,
						OnUnitHit = function(self, victim)
							--print ('HIT UNIT: ' .. caster:GetUnitName())

							local caster = self.Source
							local ability = caster:FindAbilityByName("elite_royal_guardian_linked_pillars_of_frost")
							local damage = ability.damage

							-- Sound --
							victim:EmitSound("Hero_ChaosKnight.ChaosBolt.Impact")

							-- Apply Damage --
							EncounterApplyDamage(victim, caster, ability, damage, DAMAGE_TYPE_MAGICAL, DOTA_DAMAGE_FLAG_NONE)

						end,

						--OnTreeHit = function(self, tree) ... end,
						--OnWallHit = function(self, gnvPos) ... end,
						--OnGroundHit = function(self, groundPos) ... end,
						OnFinish = function(self, pos)
							--[[
							-- Sound --
							StartSoundEventFromPosition("Hero_Phoenix.FireSpirits.ProjectileHit", pos)

							-- Particle --
							local particle = ParticleManager:CreateParticle("particles/econ/items/templar_assassin/templar_assassin_focal/templar_assassin_meld_focal_start_dust_hit.vpcf", PATTACH_CUSTOMORIGIN, nil)
							ParticleManager:SetParticleControl( particle, 0, pos )
							ParticleManager:ReleaseParticleIndex( particle )
							particle = nil
							]]
						end,
					}

					local advanced_projectile = Projectiles:CreateProjectile(projectile)
					PersistentAdvancedProjectile_Add(advanced_projectile)

					StartSoundEventFromPositionReliable("Creep_Good_Range.Attack", loc)

					return interval
				end)
				PersistentTimer_Add(timer4)

				local timer5 = Timers:CreateTimer(duration, function()

					Timers:RemoveTimer(timer4)
					timer4 = nil

					-- Particle -- PATTACH_ABSORIGIN-PATTACH_ABSORIGIN_FOLLOW-PATTACH_CUSTOMORIGIN
					local particle = ParticleManager:CreateParticle("particles/econ/items/effigies/status_fx_effigies/frosty_base_statue_destruction_dire.vpcf", PATTACH_CUSTOMORIGIN, nil)
					ParticleManager:SetParticleControl( particle, 0, loc )
					ParticleManager:ReleaseParticleIndex( particle )
					particle = nil

					StartSoundEventFromPositionReliable("Building_Generic.PartialDestruction", loc)

					local timer6 = Timers:CreateTimer(function()

						if unit:GetAbsOrigin().z >= unit:GetAbsOrigin().z - 500 then
							unit:SetAbsOrigin( unit:GetAbsOrigin() - Vector(0,0,100) )
						end

						return 0.03
					end)
					PersistentTimer_Add(timer6)

					local timer7 = Timers:CreateTimer(0.15, function()
						Timers:RemoveTimer(timer6)
						timer6 = nil

						unit:RemoveSelf()
					end)
					PersistentTimer_Add(timer7)

				end)
				PersistentTimer_Add(timer5)

			end)
			PersistentTimer_Add(timer2)

		end)
		PersistentTimer_Add(timer1)

	end

end

function elite_royal_guardian_linked_pillars_of_frost:OnAbilityPhaseStart()
	local caster			= self:GetCaster()
	local playerID			= caster:GetPlayerOwnerID()
	local player			= PlayerResource:GetPlayer(playerID)

	return true
end

function elite_royal_guardian_linked_pillars_of_frost:GetManaCost(abilitylevel)
	return self.BaseClass.GetManaCost(self, abilitylevel)
end

function elite_royal_guardian_linked_pillars_of_frost:GetCooldown(abilitylevel)
	return self.BaseClass.GetCooldown(self, abilitylevel)
end