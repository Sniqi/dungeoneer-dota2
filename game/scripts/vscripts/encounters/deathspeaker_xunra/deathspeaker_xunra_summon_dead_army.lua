deathspeaker_xunra_summon_dead_army = class({})

function deathspeaker_xunra_summon_dead_army:OnSpellStart()

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
	local victim		= caster
	local victim_loc	= victim:GetAbsOrigin()
	
	--- Get Special Values ---
	local delay                       = self:GetSpecialValueFor("delay")
	local phase_two_percentage        = self:GetSpecialValueFor("phase_two_percentage")
	local phase_three_percentage      = self:GetSpecialValueFor("phase_three_percentage")

	local factorHealth = 0.67

	caster:AddNewModifier(caster, self, "casting_rooted_modifier", {duration=1.0})
	DisableMotionControllers(caster, 1.0)

	-- Sound and Animation --
	local sound = {"necrolyte_necr_level_01", "necrolyte_necr_level_05",
					"necrolyte_necr_level_07", "necrolyte_necr_level_03"}
	EmitAnnouncerSound( sound[RandomInt(1, #sound)] )
	
	StartAnimation(caster, {duration=1.0, activity=ACT_DOTA_CAST_ABILITY_1, rate=0.75})

	local number_warriors = 1
	local number_archers = 1
	local number_warlocks = 1

	-- PHASE 2 --
	if caster:GetHealthPercent() < phase_two_percentage then
		number_warriors = 2
	end

	-- PHASE 3 --
	if caster:GetHealthPercent() < phase_two_percentage then
		number_archers = 2
	end

	for i=1,number_warriors do

		local loc = RandomLocationMinDistance( caster:GetAbsOrigin(), 500*RandomFloat(0.5, 1.0) )

		local unit = CreateUnitByName("structures_of_xunra_obelisk_summon_unholy_warrior", loc, true, nil, nil, DOTA_TEAM_BADGUYS)
		PersistentUnit_Add(unit)

		EncounterCreate_AttackDamage(unit)
		EncounterCreate_Health(unit, factorHealth)

		unit:Stop()

		local ability = unit:FindAbilityByName("structures_of_xunra_unholy_warrior_cleave")

		ability:SetLevel( 3 )--self:GetLevel() )

		local timer = Timers:CreateTimer( RandomFloat(2.5, 5.0), function()

			if unit == nil then return end
			if unit:IsNull() then return end
			if not unit:IsAlive() then return end

			for i=0,10 do
				local ability = unit:GetAbilityByIndex(i)

				if ability ~= nil then
					if ability:IsCooldownReady() then

						local order = {
							UnitIndex = unit:entindex(),
							AbilityIndex = ability:entindex(),
							OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
							Queue = false
						}
						ExecuteOrderFromTable(order)
						
					end
				end
			end

			return 1.0
		end)
		PersistentTimer_Add(timer)

	end

	--

	for i=1,number_archers do

		local loc = RandomLocationMinDistance( caster:GetAbsOrigin(), 500*RandomFloat(0.5, 1.0) )

		local unit = CreateUnitByName("structures_of_xunra_obelisk_summon_unholy_archer", loc, true, nil, nil, DOTA_TEAM_BADGUYS)
		PersistentUnit_Add(unit)

		EncounterCreate_AttackDamage(unit)
		EncounterCreate_Health(unit, factorHealth)

		unit:Stop()

		local ability = unit:FindAbilityByName("structures_of_xunra_unholy_archer_concentrated_arrow")

		ability:SetLevel( 3 )--self:GetLevel() )

		local timer = Timers:CreateTimer( i-1 * RandomFloat(0.5, 1.5), function()

			if unit == nil then return end
			if unit:IsNull() then return end
			if not unit:IsAlive() then return end

			for i=0,10 do
				local ability = unit:GetAbilityByIndex(i)

				if ability ~= nil then
					if ability:IsCooldownReady() then

						local order = {
							UnitIndex = unit:entindex(),
							AbilityIndex = ability:entindex(),
							OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
							Queue = false
						}
						ExecuteOrderFromTable(order)
						
					end
				end
			end

			return 1.0
		end)
		PersistentTimer_Add(timer)

	end

	--

	for i=1,number_warlocks do

		local loc = RandomLocationMinDistance( caster:GetAbsOrigin(), 500*RandomFloat(0.5, 1.0) )

		local unit = CreateUnitByName("structures_of_xunra_obelisk_summon_unholy_warlock", loc, true, nil, nil, DOTA_TEAM_BADGUYS)
		PersistentUnit_Add(unit)

		EncounterCreate_AttackDamage(unit)
		EncounterCreate_Health(unit, factorHealth)

		unit:Stop()

		local ability = unit:FindAbilityByName("structures_of_xunra_unholy_warlock_transfer_energy")

		ability:SetLevel( 3 )--self:GetLevel() )

		local timer = Timers:CreateTimer( i-1 * RandomFloat(0.5, 1.5), function()

			if unit == nil then return end
			if unit:IsNull() then return end
			if not unit:IsAlive() then return end

			for i=0,10 do
				local ability = unit:GetAbilityByIndex(i)

				if ability ~= nil then
					if ability:IsCooldownReady() then

						local order = {
							UnitIndex = unit:entindex(),
							AbilityIndex = ability:entindex(),
							OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
							Queue = false
						}
						ExecuteOrderFromTable(order)
						
					end
				end
			end

			return 1.0
		end)
		PersistentTimer_Add(timer)

	end

end

function deathspeaker_xunra_summon_dead_army:OnAbilityPhaseStart()
	local caster			= self:GetCaster()
	local playerID			= caster:GetPlayerOwnerID()
	local player			= PlayerResource:GetPlayer(playerID)

	return true
end

function deathspeaker_xunra_summon_dead_army:GetManaCost(abilitylevel)
	return self.BaseClass.GetManaCost(self, abilitylevel)
end

function deathspeaker_xunra_summon_dead_army:GetCooldown(abilitylevel)
	return self.BaseClass.GetCooldown(self, abilitylevel)
end