scroll_collector_reverse_jail = class({})

LinkLuaModifier( 'scroll_collector_reverse_jail_safe_zone_modifier', 'encounters/scroll_collector/scroll_collector_reverse_jail_safe_zone_modifier', LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( 'scroll_collector_reverse_jail_damage_modifier', 'encounters/scroll_collector/scroll_collector_reverse_jail_damage_modifier', LUA_MODIFIER_MOTION_NONE )

function scroll_collector_reverse_jail:OnSpellStart()

	if not CheckHeroesAlive() then return end

	local victims = GetHeroesAliveEntities()

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
	local phase_two                   = self:GetSpecialValueFor("phase_two")
	local phase_two_additional_duration= self:GetSpecialValueFor("phase_two_additional_duration")

	local iterations = 1

	local old_duration = duration

	-- PHASE 2 --
	if caster:GetHealthPercent() < phase_two then
		iterations = RandomInt(5, 11)
		duration = (duration + phase_two_additional_duration) / iterations
	end

	caster:AddNewModifier(caster, self, "casting_rooted_modifier", {duration=old_duration+delay})

	-- Sound and Animation --
	local sound = {"dark_seer_dkseer_attack_05", "dark_seer_dkseer_attack_10",
					"dark_seer_dkseer_cast_02", "dark_seer_dkseer_cast_03"}
	EmitAnnouncerSound( sound[RandomInt(1, #sound)] )
	StartAnimation(caster, {duration=old_duration, activity=ACT_DOTA_RUN, translate="haste", rate=1.0})

	for i=0,iterations-1 do

		local timer1 = Timers:CreateTimer(i*duration, function()

			for _,victim in pairs(victims) do
				local victim_loc = victim:GetAbsOrigin()

				-- PHASE 2 --
				if caster:GetHealthPercent() < phase_two then
					victim_loc = RandomLocationMinDistance(victim_loc, AoERadius*0.8)
				end

				EncounterGroundAOEWarningSticky(victim_loc, AoERadius, delay+duration, Vector(0,255,0))
				EncounterUnitWarning(caster, delay, true, nil) --nil=yellow, "red", "orange", "green"

				if iterations > 1 then delay = 0 end
				local timer2 = Timers:CreateTimer(delay, function()

					local units	= FindUnitsInRadius(team, victim_loc, nil, AoERadius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
					for _,victim in pairs(units) do

						local timer3 = Timers:CreateTimer(0, function()
							victim:AddNewModifier(caster, self, "scroll_collector_reverse_jail_safe_zone_modifier", {duration = 0.12})
						end)
						PersistentTimer_Add(timer3)

					end

					local modifier = victim:FindModifierByName("scroll_collector_reverse_jail_safe_zone_modifier")

					if modifier == nil then	
						victim:AddNewModifier(caster, self, "scroll_collector_reverse_jail_damage_modifier", {duration = 0.12})
					end

					return 0.1
				end)
				PersistentTimer_Add(timer2)

				local timer4 = Timers:CreateTimer(delay+duration, function()
					Timers:RemoveTimer(timer2)
					timer2 = nil
				end)
				PersistentTimer_Add(timer4)

			end

		end)
		PersistentTimer_Add(timer1)

	end
		
end

function scroll_collector_reverse_jail:OnAbilityPhaseStart()
	local caster			= self:GetCaster()
	local playerID			= caster:GetPlayerOwnerID()
	local player			= PlayerResource:GetPlayer(playerID)

	return true
end

function scroll_collector_reverse_jail:GetManaCost(abilitylevel)
	return self.BaseClass.GetManaCost(self, abilitylevel)
end

function scroll_collector_reverse_jail:GetCooldown(abilitylevel)
	return self.BaseClass.GetCooldown(self, abilitylevel)
end