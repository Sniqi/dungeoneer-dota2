elite_royal_guardian_freezing_tempest = class({})

LinkLuaModifier( 'elite_royal_guardian_freezing_tempest_modifier', 'encounters/elite_royal_guardian/elite_royal_guardian_freezing_tempest_modifier', LUA_MODIFIER_MOTION_NONE )

function elite_royal_guardian_freezing_tempest:OnSpellStart()

	local victim		= GetRandomHeroEntities(1)
	if not victim then return end
	victim				= victim[1]
	local victim_loc    = victim:GetAbsOrigin()

	--- Get Caster, Victim, Player, Point ---
	local caster		= self:GetCaster()
	local caster_loc	= caster:GetAbsOrigin()
	local playerID		= caster:GetPlayerOwnerID()
	local player		= PlayerResource:GetPlayer(playerID)
	local team			= caster:GetTeamNumber()

	if caster.elite_royal_guardian_eternal_ice_chosenPoint == nil then return end

	--- Get Special Values ---
	local AoERadius                   = self:GetSpecialValueFor("AoERadius")
	local duration                    = self:GetSpecialValueFor("duration")
	local damage                      = self:GetSpecialValueFor("damage")
	local delay                       = self:GetSpecialValueFor("delay")
	local move_speed_percentage       = self:GetSpecialValueFor("move_speed_percentage")
	local move_speed_absolute         = self:GetSpecialValueFor("move_speed_absolute")

	local castingModifier = caster:AddNewModifier(caster, self, "casting_modifier", {})

	-- Particle --
	local particle = ParticleManager:CreateParticle("particles/econ/items/tinker/boots_of_travel/teleport_end_bots_ground_flash.vpcf", PATTACH_ABSORIGIN, caster)
	ParticleManager:SetParticleControl( particle, 0, caster:GetAbsOrigin() )
	ParticleManager:SetParticleControl( particle, 2, Vector(255,255,255) )
	PersistentParticle_Add(particle)

	-- Sound --
	StartSoundEventReliable("Hero_QueenOfPain.Blink_out", caster)

	local timer = Timers:CreateTimer(2.0, function()
		ParticleManager:DestroyParticle( particle, false )
		ParticleManager:ReleaseParticleIndex( particle )
		particle = nil
	end)
	PersistentTimer_Add(timer)

	local loc = caster.elite_royal_guardian_eternal_ice_chosenPoint
	FindClearSpaceForUnit(caster, loc, false)

	-- Sound and Animation --
	local sound = {"sven_sven_attack_06"}
	EmitAnnouncerSound( sound[RandomInt(1, #sound)] )

	TurnToLoc(caster, victim_loc, 0.3)

	StartAnimation(caster, {duration=1.7, activity=ACT_DOTA_OVERRIDE_ABILITY_1, rate=1.00})

	local timer = Timers:CreateTimer(0.5, function()
		FreezeAnimation(caster, 100.0)

		EncounterGroundLineWarning(caster, AoERadius, AoERadius, caster:GetAbsOrigin(), caster:GetForwardVector(), 5000, 2.0)
	end)
	PersistentTimer_Add(timer)

	StartSoundEventReliable("hero_Crystal.freezingField.wind", caster)

	local timer2 = Timers:CreateTimer(0.5, function()

		local loc = caster:GetAbsOrigin() + (caster:GetForwardVector() * ( -AoERadius / 2) )

		-- Particle -- PATTACH_ABSORIGIN-PATTACH_ABSORIGIN_FOLLOW-PATTACH_CUSTOMORIGIN
		local particle = ParticleManager:CreateParticle("particles/encounter/elite_royal_guardian/elite_royal_guardian_eternal_ice.vpcf", PATTACH_CUSTOMORIGIN, nil)
		ParticleManager:SetParticleControl( particle, 0, loc )
		ParticleManager:SetParticleControl( particle, 1, Vector(AoERadius,1.0,0) )

		return 0.1
	end)
	PersistentTimer_Add(timer2)

	local direction
	local loc_end
	local count = 1

	local timer = Timers:CreateTimer(0.1, function()
		direction = ( victim_loc - caster:GetAbsOrigin() ):Normalized()
		loc_end = caster:GetAbsOrigin() + ( direction * 5000 )
	end)
	PersistentTimer_Add(timer)

	local timer = Timers:CreateTimer(0.5, function()

		if ( loc_end - caster:GetAbsOrigin() ):Length2D() > 200 then

			local loc = caster:GetAbsOrigin() + (caster:GetForwardVector() * ( -AoERadius / 2) )

			caster:SetAbsOrigin(caster:GetAbsOrigin() + direction * ( 1 + (0.1 * count) ) )

			-- DOTA_UNIT_TARGET_TEAM_FRIENDLY; DOTA_UNIT_TARGET_TEAM_ENEMY; DOTA_UNIT_TARGET_TEAM_BOTH
			local units	= FindUnitsInRadius(team, loc, nil, AoERadius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
			for _,victim in pairs(units) do
				-- Apply Damage --
				EncounterApplyDamage(victim, caster, self, damage * 0.03, DAMAGE_TYPE_MAGICAL, DOTA_DAMAGE_FLAG_NONE)
			end
		else
			caster:InterruptMotionControllers(true)
			caster:SetAbsOrigin(GetGroundPosition(caster:GetAbsOrigin(), caster))
			UnfreezeAnimation(caster)

			Timers:RemoveTimer(timer2)
			timer2 = nil

			local loc = GetSpecificBorderPoint("point_center")
			FindClearSpaceForUnit(caster, loc, false)

			-- Sound --
			StartSoundEventFromPositionReliable("Hero_QueenOfPain.Blink_out", loc)

			castingModifier:Destroy()

			return
		end

		count = count + 1
		return 0.03
	end)
	PersistentTimer_Add(timer)

	local timer3 = Timers:CreateTimer(delay, function()

		-- DOTA_UNIT_TARGET_TEAM_FRIENDLY; DOTA_UNIT_TARGET_TEAM_ENEMY; DOTA_UNIT_TARGET_TEAM_BOTH
		local units	= FindUnitsInRadius(team, loc, nil, 9999, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
		for _,victim in pairs(units) do
			-- Modifier --
			victim:AddNewModifier(caster, self, "elite_royal_guardian_freezing_tempest_modifier", {duration = duration})
		end

	end)
	PersistentTimer_Add(timer3)

end

function elite_royal_guardian_freezing_tempest:OnAbilityPhaseStart()
	local caster			= self:GetCaster()
	local playerID			= caster:GetPlayerOwnerID()
	local player			= PlayerResource:GetPlayer(playerID)

	return true
end

function elite_royal_guardian_freezing_tempest:GetManaCost(abilitylevel)
	return self.BaseClass.GetManaCost(self, abilitylevel)
end

function elite_royal_guardian_freezing_tempest:GetCooldown(abilitylevel)
	return self.BaseClass.GetCooldown(self, abilitylevel)
end
