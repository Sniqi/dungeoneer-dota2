lunar_horse_eclipse = class({})

LinkLuaModifier( 'lunar_horse_sun_orb_move_range_counter_modifier', 'encounters/lunar_horse/lunar_horse_sun_orb_move_range_counter_modifier', LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( 'lunar_horse_sun_orb_countdown_modifier', 'encounters/lunar_horse/lunar_horse_sun_orb_countdown_modifier', LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( 'lunar_horse_sun_orb_modifier', 'encounters/lunar_horse/lunar_horse_sun_orb_modifier', LUA_MODIFIER_MOTION_NONE )

function lunar_horse_eclipse:OnSpellStart()
	self.abilityUsed = true

	--- Get Caster, Victim, Player, Point ---
	local caster		= self:GetCaster()
	local caster_loc	= caster:GetAbsOrigin()
	local playerID		= caster:GetPlayerOwnerID()
	local player		= PlayerResource:GetPlayer(playerID)
	local team			= caster:GetTeamNumber()
	
	--- Get Special Values ---
	local duration                    = self:GetSpecialValueFor("duration")
	local first_orb_percentage        = self:GetSpecialValueFor("first_orb_percentage")
	local second_orb_percentage       = self:GetSpecialValueFor("second_orb_percentage")
	local move_distance_min           = self:GetSpecialValueFor("move_distance_min")
	local move_distance_max           = self:GetSpecialValueFor("move_distance_max")
	local move_time                   = self:GetSpecialValueFor("move_time")
	local hero_move_speed_percentage  = self:GetSpecialValueFor("hero_move_speed_percentage")
	local incoming_damage_percentage  = self:GetSpecialValueFor("incoming_damage_percentage")
	local boss_move_speed_percentage  = self:GetSpecialValueFor("boss_move_speed_percentage")

	local first_orb_triggered = false
	local second_orb_triggered = false

	local timer = Timers:CreateTimer(function()

		if caster:GetHealthPercent() <= first_orb_percentage and not first_orb_triggered then
			first_orb_triggered = true
			lunar_horse_eclipse:SpawnOrb(self)
		end

		if caster:GetHealthPercent() <= second_orb_percentage and not second_orb_triggered then
			second_orb_triggered = true
			lunar_horse_eclipse:SpawnOrb(self)
		end

		GameRules:BeginTemporaryNight(1.1)

		return 1.0
	end)
	PersistentTimer_Add(timer)

end

function lunar_horse_eclipse:SpawnOrb(ability)
	self = ability

	--- Get Caster, Victim, Player, Point ---
	local caster		= self:GetCaster()
	local caster_loc	= caster:GetAbsOrigin()
	local playerID		= caster:GetPlayerOwnerID()
	local player		= PlayerResource:GetPlayer(playerID)
	local team			= caster:GetTeamNumber()

	--- Get Special Values ---
	local duration                    = self:GetSpecialValueFor("duration")
	local first_orb_percentage        = self:GetSpecialValueFor("first_orb_percentage")
	local second_orb_percentage       = self:GetSpecialValueFor("second_orb_percentage")
	local move_distance_min           = self:GetSpecialValueFor("move_distance_min")
	local move_distance_max           = self:GetSpecialValueFor("move_distance_max")
	local move_time                   = self:GetSpecialValueFor("move_time")
	local hero_move_speed_percentage  = self:GetSpecialValueFor("hero_move_speed_percentage")
	local incoming_damage_percentage  = self:GetSpecialValueFor("incoming_damage_percentage")
	local boss_move_speed_percentage  = self:GetSpecialValueFor("boss_move_speed_percentage")

	local AoERadius = 80

	local loc = GetRandomPointWithinArena(1200)

	local warningParticle = EncounterGroundAOEWarningSticky(loc, AoERadius, nil, Vector(0,255,0))

	-- Particle -- PATTACH_ABSORIGIN-PATTACH_ABSORIGIN_FOLLOW-PATTACH_CUSTOMORIGIN
	local particle = ParticleManager:CreateParticle("particles/encounter/lunar_horse/lunar_horse_eclipse.vpcf", PATTACH_CUSTOMORIGIN, nil)
	ParticleManager:SetParticleControl( particle, 0, loc )		
	PersistentParticle_Add(particle)

	local timer = Timers:CreateTimer(function()

		-- DOTA_UNIT_TARGET_TEAM_FRIENDLY; DOTA_UNIT_TARGET_TEAM_ENEMY; DOTA_UNIT_TARGET_TEAM_BOTH
		local units	= FindUnitsInRadius(team, loc, nil, AoERadius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
		local victim = units[1]
		if victim ~= nil and victim:FindModifierByName("lunar_horse_sun_orb_move_range_counter_modifier") == nil then

			ParticleManager:DestroyParticle( particle, false )
			ParticleManager:ReleaseParticleIndex( particle )
			particle = nil

			ParticleManager:DestroyParticle( warningParticle, false )
			ParticleManager:ReleaseParticleIndex( warningParticle )
			warningParticle = nil

			EncounterUnitWarning(victim, nil, true, "green")

			-- Modifier --
			victim:AddNewModifier(caster, self, "lunar_horse_sun_orb_move_range_counter_modifier", {duration = move_time*1.1})
			-- Modifier --
			victim:AddNewModifier(caster, self, "lunar_horse_sun_orb_countdown_modifier", {duration = move_time*1.1})

			return
		end

		return 0.1
	end)
	PersistentTimer_Add(timer)
end


function lunar_horse_eclipse:OnAbilityPhaseStart()
	local caster			= self:GetCaster()
	local playerID			= caster:GetPlayerOwnerID()
	local player			= PlayerResource:GetPlayer(playerID)

	if self.abilityUsed then return false end

	return true
end

function lunar_horse_eclipse:GetManaCost(abilitylevel)
	return self.BaseClass.GetManaCost(self, abilitylevel)
end

function lunar_horse_eclipse:GetCooldown(abilitylevel)
	return self.BaseClass.GetCooldown(self, abilitylevel)
end