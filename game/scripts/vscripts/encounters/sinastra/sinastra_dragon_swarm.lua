sinastra_dragon_swarm = class({})

LinkLuaModifier( 'sinastra_dragon_swarm_modifier', 'encounters/sinastra/sinastra_dragon_swarm_modifier', LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( 'sinastra_dragon_swarm_speed_modifier', 'encounters/sinastra/sinastra_dragon_swarm_speed_modifier', LUA_MODIFIER_MOTION_NONE )

function sinastra_dragon_swarm:OnSpellStart()

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
	local delay                       = self:GetSpecialValueFor("delay")
	local move_speed_percentage       = self:GetSpecialValueFor("move_speed_percentage")
	local debuff_duration             = self:GetSpecialValueFor("debuff_duration")
	local delay_between_attacks_min   = self:GetSpecialValueFor("delay_between_attacks_min")
	local delay_between_attacks_max   = self:GetSpecialValueFor("delay_between_attacks_max")

	-- Sound and Animation --
	local sound = {"winter_wyvern_winwyv_spawn_03", "winter_wyvern_winwyv_move_10",
					"winter_wyvern_winwyv_attack_02", "winter_wyvern_winwyv_attack_01"}
	EmitAnnouncerSound( sound[RandomInt(1, #sound)] )

	local loc = GetRandomPointWithinArena()

	local unit = CreateUnitByName("sinastra_dragon_swarm", loc, true, nil, nil, DOTA_TEAM_BADGUYS)
	PersistentUnit_Add(unit)

	unit:AddNewModifier(unit, self, "sinastra_dragon_swarm_speed_modifier", {})
	unit:AddNewModifier(unit, nil, "modifier_dummy", {})
	unit:AddNewModifier(unit, nil, "modifier_phased", {})
	unit:AddNewModifier(unit, nil, "modifier_flying", {})
	
	unit:Stop()

	-- Particle -- PATTACH_ABSORIGIN-PATTACH_ABSORIGIN_FOLLOW-PATTACH_CUSTOMORIGIN
	local particle = ParticleManager:CreateParticle("particles/econ/items/effigies/status_fx_effigies/frosty_effigy_ambient_foot.vpcf", PATTACH_ABSORIGIN_FOLLOW, unit)
	ParticleManager:SetParticleControl( particle, 0, unit:GetAbsOrigin() )
	ParticleManager:SetParticleControl( particle, 4, unit:GetAbsOrigin() )
	PersistentParticle_Add(particle)

	local ground_warning = EncounterGroundAOEWarningStickyOnUnit(unit, AoERadius, nil)

	-- Damage interval
	local timer0 = Timers:CreateTimer(0.1, function()

		-- DOTA_UNIT_TARGET_TEAM_FRIENDLY; DOTA_UNIT_TARGET_TEAM_ENEMY; DOTA_UNIT_TARGET_TEAM_BOTH
		local units	= FindUnitsInRadius(team, unit:GetAbsOrigin(), nil, AoERadius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
		for _,victim in pairs(units) do
			-- Modifier --
			local modifier = victim:AddNewModifier(unit, self, "sinastra_dragon_swarm_modifier", {duration = debuff_duration})
			PersistentModifier_Add(modifier)

			-- Apply Damage --
			EncounterApplyDamage(victim, caster, self, damage*0.1, DAMAGE_TYPE_MAGICAL, DOTA_DAMAGE_FLAG_NONE)
		end

		return 0.1
	end)
	PersistentTimer_Add(timer0)

	-- Logic
	local timer1 = Timers:CreateTimer(RandomFloat(delay_between_attacks_min, delay_between_attacks_max), function()
		
		local loc = GetRandomPointWithinArena()

		local timer2 = Timers:CreateTimer(0, function()
			unit:FaceTowards( loc )

			return 0.1
		end)
		PersistentTimer_Add(timer2)

		local timer3 = Timers:CreateTimer(delay*0.3, function()
			Timers:RemoveTimer(timer2)
			timer = nil

			EncounterGroundLineWarning(unit, AoERadius, AoERadius, unit:GetAbsOrigin(), unit:GetForwardVector(), (loc-unit:GetAbsOrigin()):Length2D(), delay)
		end)
		PersistentTimer_Add(timer3)

		local timer4 = Timers:CreateTimer(delay, function()

			unit:MoveToPosition(loc)

		end)
		PersistentTimer_Add(timer4)


		return RandomFloat(delay_between_attacks_min, delay_between_attacks_max)
	end)
	PersistentTimer_Add(timer1)


	-- After Duration
	local timer = Timers:CreateTimer(duration, function()
			Timers:RemoveTimer(timer0)
			timer0 = nil

			Timers:RemoveTimer(timer1)
			timer1 = nil

			ParticleManager:DestroyParticle( ground_warning, false )
			ParticleManager:ReleaseParticleIndex( ground_warning )
			ground_warning = nil

			UTIL_Remove(unit)
	end)
	PersistentTimer_Add(timer)

end

function sinastra_dragon_swarm:OnAbilityPhaseStart()
	local caster			= self:GetCaster()
	local playerID			= caster:GetPlayerOwnerID()
	local player			= PlayerResource:GetPlayer(playerID)

	return true
end

function sinastra_dragon_swarm:GetManaCost(abilitylevel)
	return self.BaseClass.GetManaCost(self, abilitylevel)
end

function sinastra_dragon_swarm:GetCooldown(abilitylevel)
	return self.BaseClass.GetCooldown(self, abilitylevel)
end