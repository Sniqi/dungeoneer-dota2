the_curse_of_agony_banish = class({})

LinkLuaModifier( 'the_curse_of_agony_the_curse_modifier', 'encounters/the_curse_of_agony/the_curse_of_agony_the_curse_modifier', LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( 'the_curse_of_agony_banished_modifier', 'encounters/the_curse_of_agony/the_curse_of_agony_banished_modifier', LUA_MODIFIER_MOTION_NONE )

function the_curse_of_agony_banish:OnSpellStart()

	--- Get Caster, Victim, Player, Point ---
	local caster		= self:GetCaster()
	local caster_loc	= caster:GetAbsOrigin()
	local playerID		= caster:GetPlayerOwnerID()
	local player		= PlayerResource:GetPlayer(playerID)
	local team			= caster:GetTeamNumber()
	
	--- Get Special Values ---
	local AoERadius                   = self:GetSpecialValueFor("AoERadius")
	local duration                    = self:GetSpecialValueFor("duration")
	local delay                       = self:GetSpecialValueFor("delay")
	local interval                    = self:GetSpecialValueFor("interval")

	local unit

	-- Modifier --
	caster:AddNewModifier(caster, self, "the_curse_of_agony_the_curse_modifier", {})

	if self.unit == nil then

		local unit_loc = GetSpecificBorderPoint("point_bottom") + Vector(0,400,0)
		unit = CreateUnitByName("the_purger", unit_loc, true, nil, nil, DOTA_TEAM_GOODGUYS)
		PersistentUnit_Add(unit)

		self.unit = unit

		unit:AddNewModifier(unit, nil, "modifier_invulnerable", {})
		unit:AddNewModifier(unit, nil, "modifier_phased", {})
		
		-- Animation --
		unit:StartGestureWithPlaybackRate( ACT_DOTA_DISABLED, 0.75 )

		TurnToLoc(unit, unit_loc+Vector(0,10,0), 1)

		local timer1 = Timers:CreateTimer(interval, function()

			EncounterUnitWarning(unit, delay, true, "green") --nil=yellow, "red", "orange", "green"

			local timer = Timers:CreateTimer(0, function()
				unit:RemoveGesture( ACT_DOTA_DISABLED )
				TurnToLoc(unit, caster:GetAbsOrigin(), 1)

				-- Sound --
				local sound = {"dazzle_dazz_attack_02", "dazzle_dazz_attack_04",
								"dazzle_dazz_attack_12"}
				EmitAnnouncerSound( sound[RandomInt(1, #sound)] )
			end)
			PersistentTimer_Add(timer)

			local timer = Timers:CreateTimer(delay-0.8, function()
				StartAnimation(unit, {duration=2, activity=ACT_DOTA_ATTACK, rate=1.0})
				TurnToLoc(unit, caster:GetAbsOrigin(), 0.75)
			end)
			PersistentTimer_Add(timer)

			local timer = Timers:CreateTimer(delay, function()

				TurnToLoc(unit, caster:GetAbsOrigin(), 1)

				-- Sound --
				unit:EmitSound("DOTA_Item.EtherealBlade.Activate")
				
				local info = 
				{
					Target = caster,
					Source = unit,
					Ability = self,
					EffectName = "particles/items_fx/ethereal_blade.vpcf",
					iMoveSpeed = 1100,
					vSourceLoc = unit:GetAbsOrigin() + Vector(0,0,50),
					bDrawsOnMinimap = false,                          -- Optional
					bDodgeable = false,                               -- Optional
					bIsAttack = false,                                 -- Optional
					bVisibleToEnemies = true,                         -- Optional
					bReplaceExisting = false,                         -- Optional
					flExpireTime = GameRules:GetGameTime() + 10,      -- Optional but recommended
					bProvidesVision = false,                          -- Optional
					--iVisionRadius = 0,                                -- Optional
					--iVisionTeamNumber = caster:GetTeamNumber()        -- Optional
				}

				ProjectileManager:CreateTrackingProjectile(info)
			end)
			PersistentTimer_Add(timer)

			local timer = Timers:CreateTimer(delay+0.5, function()
				-- Animation --
				unit:StartGestureWithPlaybackRate( ACT_DOTA_DISABLED, 0.75 )
				TurnToLoc(unit, unit_loc+Vector(0,10,0), 1)
			end)
			PersistentTimer_Add(timer)

			return interval
		end)
		PersistentTimer_Add(timer1)

	end
end

function the_curse_of_agony_banish:OnProjectileHit( hTarget, vLocation )

	--- Get Caster, Victim, Player, Point ---
	local caster		= self:GetCaster()
	local caster_loc	= caster:GetAbsOrigin()
	local playerID		= caster:GetPlayerOwnerID()
	local player		= PlayerResource:GetPlayer(playerID)
	local team			= caster:GetTeamNumber()
	
	--- Get Special Values ---
	local AoERadius                   = self:GetSpecialValueFor("AoERadius")
	local duration                    = self:GetSpecialValueFor("duration")
	local delay                       = self:GetSpecialValueFor("delay")
	local interval                    = self:GetSpecialValueFor("interval")

	-- Sound --
	local sound = {"bane_bane_death_01", "bane_bane_death_03",
					"bane_bane_death_04", "bane_bane_death_06",
					"bane_bane_death_09"}
	EmitAnnouncerSound( sound[RandomInt(1, #sound)] )

	-- Modifier --
	caster:RemoveModifierByName("the_curse_of_agony_the_curse_modifier")
	caster:AddNewModifier(caster, self, "the_curse_of_agony_banished_modifier", {duration=duration})
	caster:AddNewModifier(caster, self, "casting_rooted_modifier", {duration=duration})

	DisableMotionControllers(caster, duration)

	-- Sound --
	caster:EmitSound("DOTA_Item.EtherealBlade.Target")

	-- Animation --
	caster:StartGestureWithPlaybackRate( ACT_DOTA_FLAIL, 0.5 )


	local timer = Timers:CreateTimer(duration, function()

		-- Sound --
		local sound = {"bane_bane_respawn_03", "bane_bane_respawn_06",
						"bane_bane_respawn_07", "bane_bane_respawn_09",
						"bane_bane_respawn_11"}
		EmitAnnouncerSound( sound[RandomInt(1, #sound)] )

		caster:RemoveGesture( ACT_DOTA_FLAIL )

		-- Modifier --
		caster:AddNewModifier(caster, self, "the_curse_of_agony_the_curse_modifier", {})

	end)
	PersistentTimer_Add(timer)
	
end

function the_curse_of_agony_banish:OnAbilityPhaseStart()
	local caster			= self:GetCaster()
	local playerID			= caster:GetPlayerOwnerID()
	local player			= PlayerResource:GetPlayer(playerID)

	return true
end

function the_curse_of_agony_banish:GetManaCost(abilitylevel)
	return self.BaseClass.GetManaCost(self, abilitylevel)
end

function the_curse_of_agony_banish:GetCooldown(abilitylevel)
	return self.BaseClass.GetCooldown(self, abilitylevel)
end