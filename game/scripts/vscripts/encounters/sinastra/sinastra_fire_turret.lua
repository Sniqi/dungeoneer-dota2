sinastra_fire_turret = class({})

function sinastra_fire_turret:OnSpellStart()

	local victim		= GetCurrentEncounterEntity()
	local victim_loc	= victim:GetAbsOrigin()

	--- Get Caster, Victim, Player, Point ---
	local caster		= self:GetCaster()
	local caster_loc	= caster:GetAbsOrigin()
	local playerID		= caster:GetPlayerOwnerID()
	local player		= PlayerResource:GetPlayer(playerID)
	local team			= caster:GetTeamNumber()
	
	--- Get Special Values ---
	local delay                       = self:GetSpecialValueFor("delay")
	local damage                      = self:GetSpecialValueFor("damage")
	local turret_damage_percentage    = self:GetSpecialValueFor("turret_damage_percentage")
	local turret_range                = self:GetSpecialValueFor("turret_range")
	local turret_aoe_radius           = self:GetSpecialValueFor("turret_aoe_radius")

	-- Particle -- PATTACH_ABSORIGIN-PATTACH_ABSORIGIN_FOLLOW-PATTACH_CUSTOMORIGIN
	local particle = ParticleManager:CreateParticle("particles/econ/items/storm_spirit/storm_spirit_orchid_hat/stormspirit_orchid_ball_lightning.vpcf", PATTACH_CUSTOMORIGIN, nil)
	ParticleManager:SetParticleControl( particle, 0, caster_loc )
	ParticleManager:SetParticleControl( particle, 1, caster_loc )

	local direction = caster:GetForwardVector()

	EncounterGroundLineWarning(caster, turret_aoe_radius, turret_aoe_radius, caster_loc, direction, turret_range, delay+0.1)

	-- Sound --
	caster:EmitSound("Hero_Invoker.EMP.Cast")
	caster:EmitSound("Hero_Invoker.EMP.Charge")

	local timer = Timers:CreateTimer(delay, function()

		ParticleManager:DestroyParticle( particle, false )
		ParticleManager:ReleaseParticleIndex( particle )
		particle = nil

		-- Particle -- PATTACH_ABSORIGIN-PATTACH_ABSORIGIN_FOLLOW-PATTACH_CUSTOMORIGIN
		local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_zuus/zuus_arc_lightning.vpcf", PATTACH_ABSORIGIN, caster)
		ParticleManager:SetParticleControl( particle, 0, caster:GetAbsOrigin() + Vector(0,0,75) )
		ParticleManager:SetParticleControl( particle, 1, caster:GetAbsOrigin() + ( direction * turret_range ) + Vector(0,0,75) )
		ParticleManager:SetParticleControl( particle, 62, Vector(2,0,500) )

		local timer1 = Timers:CreateTimer(1.0, function()
			ParticleManager:DestroyParticle( particle, false )
			ParticleManager:ReleaseParticleIndex( particle )
			particle = nil
		end)
		PersistentTimer_Add(timer1)
	
		-- Sound --
		caster:EmitSound("Hero_Zuus.LightningBolt")

		StartAnimation(caster, {duration=1.0, activity=ACT_DOTA_ATTACK, rate=2.0})

		local projectile = {
			EffectName = "",
			vSpawnOrigin = caster_loc + Vector(0,0,50),--{unit=hero, attach="attach_attack1", offset=Vector(0,0,0)},
			fDistance = turret_range,
			fStartRadius = turret_aoe_radius,
			fEndRadius = turret_aoe_radius,
			Source = caster,
			fExpireTime = 10.0,
			vVelocity = direction * 10000,
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

			UnitTest = function(self, victim) return true end,
			OnUnitHit = function(self, victim)

				local caster = GetCurrentEncounterEntity()--self.Source
				local ability = caster:FindAbilityByName("sinastra_fire_turret")
				local damage = ability:GetSpecialValueFor("damage")
				local turret_damage_percentage = ability:GetSpecialValueFor("turret_damage_percentage")

				if victim:GetUnitName() == "npc_dota_hero_sinastra" then
					victim:SetHealth( victim:GetHealth() - ( victim:GetMaxHealth() * ( turret_damage_percentage / 100 ) ) )

					local timer = Timers:CreateTimer(0.5, function()

						-- Sound and Animation --
						local sound = {"winter_wyvern_winwyv_pain_01", "winter_wyvern_winwyv_pain_02",
										"winter_wyvern_winwyv_pain_07", "winter_wyvern_winwyv_pain_08"}
						EmitAnnouncerSound( sound[RandomInt(1, #sound)] )

					end)
					PersistentTimer_Add(timer)

					local timer = Timers:CreateTimer(1.5, function()

						if victim:GetHealthPercent() <= 100 and victim:GetHealthPercent() > 80 then
							-- Sound and Animation --
							local sound = {"winter_wyvern_winwyv_notyet_01", "winter_wyvern_winwyv_notyet_04",
											"winter_wyvern_winwyv_notyet_07"}
							EmitAnnouncerSound( sound[RandomInt(1, #sound)] )
						end

						if victim:GetHealthPercent() <= 80 and victim:GetHealthPercent() > 60 then
							-- Sound and Animation --
							local sound = {"winter_wyvern_winwyv_notyet_03", "winter_wyvern_winwyv_notyet_05",
											"winter_wyvern_winwyv_notyet_08"}
							EmitAnnouncerSound( sound[RandomInt(1, #sound)] )
						end

						if victim:GetHealthPercent() <= 60 and victim:GetHealthPercent() > 51 then
							-- Sound and Animation --
							local sound = {"winter_wyvern_winwyv_notyet_02", "winter_wyvern_winwyv_notyet_06",
											"winter_wyvern_winwyv_notyet_09"}
							EmitAnnouncerSound( sound[RandomInt(1, #sound)] )
						end

					end)
					PersistentTimer_Add(timer)

				else
					-- Apply Damage --
					EncounterApplyDamage(victim, caster, self, damage, DAMAGE_TYPE_PHYSICAL, DOTA_DAMAGE_FLAG_NONE)
				end

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

function sinastra_fire_turret:OnAbilityPhaseStart()
	local caster			= self:GetCaster()
	local playerID			= caster:GetPlayerOwnerID()
	local player			= PlayerResource:GetPlayer(playerID)

	return true
end

function sinastra_fire_turret:GetManaCost(abilitylevel)
	return self.BaseClass.GetManaCost(self, abilitylevel)
end

function sinastra_fire_turret:GetCooldown(abilitylevel)
	return self.BaseClass.GetCooldown(self, abilitylevel)
end