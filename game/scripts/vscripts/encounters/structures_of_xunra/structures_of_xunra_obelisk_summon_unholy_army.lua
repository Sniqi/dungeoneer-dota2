structures_of_xunra_obelisk_summon_unholy_army = class({})

function structures_of_xunra_obelisk_summon_unholy_army:OnSpellStart()

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

	local potential_units = {}

	for _,obelisk in pairs(caster:FindAbilityByName("structures_of_xunra_linked_obelisks").units) do
		if obelisk ~= nil then
		if not obelisk:IsNull() then
		if obelisk:IsAlive() then

			table.insert(potential_units, obelisk)

		end
		end
		end
	end

	if self.initial_cast_done == true then
		local potential_unit = potential_units[ RandomInt(1, #potential_units) ]
		potential_units = {}
		potential_units[1] = potential_unit
	end

	for _,obelisk in pairs( potential_units ) do
		if obelisk ~= nil then
		if not obelisk:IsNull() then
		if obelisk:IsAlive() then

			local number_warriors = 1

			-- ChallengerMode 1 --
			if GameMode_Active == "Challenger" and ChallengerMode_Active == 1 then number_warriors = 0 end

			for i=1,number_warriors do

				local loc = RandomLocationMinDistance( obelisk:GetAbsOrigin(), 500*RandomFloat(0.5, 1.0) )

				local unit = CreateUnitByName("structures_of_xunra_obelisk_summon_unholy_warrior", loc, true, nil, nil, DOTA_TEAM_BADGUYS)
				PersistentUnit_Add(unit)

				EncounterCreate_AttackDamage(unit)
				EncounterCreate_Health(unit)

				unit:Stop()

				local ability = unit:FindAbilityByName("structures_of_xunra_unholy_warrior_cleave")

				ability:SetLevel( self:GetLevel() )

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

			local number_archers = 1

			-- ChallengerMode 1 --
			if GameMode_Active == "Challenger" and ChallengerMode_Active == 1 then number_archers = 3 end

			for i=1,number_archers do

				local loc = RandomLocationMinDistance( obelisk:GetAbsOrigin(), 500*RandomFloat(0.5, 1.0) )

				local unit = CreateUnitByName("structures_of_xunra_obelisk_summon_unholy_archer", loc, true, nil, nil, DOTA_TEAM_BADGUYS)
				PersistentUnit_Add(unit)

				EncounterCreate_AttackDamage(unit)
				EncounterCreate_Health(unit)

				unit:Stop()

				local ability = unit:FindAbilityByName("structures_of_xunra_unholy_archer_concentrated_arrow")

				ability:SetLevel( self:GetLevel() )

				local timer = Timers:CreateTimer( ( (_-1) * 5 ) + (i-1 * RandomFloat(0.5, 1.5)), function()

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

			local number_warlocks = 1

			-- ChallengerMode 1 --
			if GameMode_Active == "Challenger" and ChallengerMode_Active == 1 then number_warlocks = 0 end

			for i=1,number_warlocks do

				local loc = RandomLocationMinDistance( obelisk:GetAbsOrigin(), 500*RandomFloat(0.5, 1.0) )

				local unit = CreateUnitByName("structures_of_xunra_obelisk_summon_unholy_warlock", loc, true, nil, nil, DOTA_TEAM_BADGUYS)
				PersistentUnit_Add(unit)

				EncounterCreate_AttackDamage(unit)
				EncounterCreate_Health(unit)

				unit:Stop()

				local ability = unit:FindAbilityByName("structures_of_xunra_unholy_warlock_transfer_energy")

				ability:SetLevel( self:GetLevel() )

				local timer = Timers:CreateTimer( ( (_-1) * 5 ) + (i-1 * RandomFloat(0.5, 1.5)), function()

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
		end
		end
	end

	self.initial_cast_done = true

end

function structures_of_xunra_obelisk_summon_unholy_army:OnAbilityPhaseStart()
	local caster			= self:GetCaster()
	local playerID			= caster:GetPlayerOwnerID()
	local player			= PlayerResource:GetPlayer(playerID)

	return true
end

function structures_of_xunra_obelisk_summon_unholy_army:GetManaCost(abilitylevel)
	return self.BaseClass.GetManaCost(self, abilitylevel)
end

function structures_of_xunra_obelisk_summon_unholy_army:GetCooldown(abilitylevel)
	return self.BaseClass.GetCooldown(self, abilitylevel)
end