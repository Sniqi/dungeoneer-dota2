the_dungeoneer_three_shell_game = class({})

function the_dungeoneer_three_shell_game:OnSpellStart()

	--- Get Caster, Victim, Player, Point ---
	local caster		= self:GetCaster()
	local caster_loc	= caster:GetAbsOrigin()
	local playerID		= caster:GetPlayerOwnerID()
	local player		= PlayerResource:GetPlayer(playerID)
	local team			= caster:GetTeamNumber()
	
	--- Get Special Values ---
	local duration                    = self:GetSpecialValueFor("duration")
	local delay                       = self:GetSpecialValueFor("delay")
	local demonic_warrior_health_percentage= self:GetSpecialValueFor("demonic_warrior_health_percentage")

	DelayAbilityCooldown(caster, "the_dungeoneer_death_and_decay", 3.0+2.0+5.0+duration, 2.0)
	DelayAbilityCooldown(caster, "the_dungeoneer_seed_of_corruption", 3.0+2.0+5.0+duration, 2.0)

	caster:AddNewModifier(caster, self, "casting_rooted_modifier", {duration=delay})

	-- Sound and Animation --
	local sound = {"grimstroke_grimstroke_lasthit_11", "grimstroke_grimstroke_deny_13",
					"grimstroke_grimstroke_purch_02", "grimstroke_grimstroke_purch_04"}
	EmitAnnouncerSound( sound[RandomInt(1, #sound)] )

	local timer = Timers:CreateTimer(3.5, function()
		local sound = {"grimstroke_grimstroke_laugh_03", "grimstroke_grimstroke_laugh_04",
						"grimstroke_grimstroke_laugh_05", "grimstroke_grimstroke_laugh_06"}
		EmitAnnouncerSound( sound[RandomInt(1, #sound)] )
	end)
	PersistentTimer_Add(timer)

	StartAnimation(caster, {duration=delay, activity=ACT_DOTA_STUN_STATUE, rate=0.8})

	local units = {}

	for i=-1,1 do

		local unit_loc = GetSpecificBorderPoint("point_center") + Vector(i*333,0,0)
		local unit = CreateUnitByName("three_shell_game", unit_loc, true, nil, nil, DOTA_TEAM_BADGUYS)
		PersistentUnit_Add(unit)
		table.insert(units, unit)

		unit:AddNewModifier(caster, self, "modifier_invulnerable", {})
		unit:AddNewModifier(caster, self, "modifier_attack_immune", {})
		unit:AddNewModifier(caster, self, "modifier_unselectable", {})
		unit:AddNewModifier(caster, self, "modifier_phased", {})

		unit:SetOriginalModel("models/props_gameplay/treasure_chest_gold.vmdl")
		unit:SetModel("models/props_gameplay/treasure_chest_gold.vmdl")
		unit:ManageModelChanges()

		-- Add Physics --
		if not IsPhysicsUnit(unit) then
			--Physics:GenerateAngleGrid()
			Physics:Unit(unit)
			--unit:AdaptiveNavGridLookahead(true)
			unit:SetNavCollisionType(PHYSICS_NAV_BOUNCE)
			unit:SetGroundBehavior(PHYSICS_GROUND_LOCK)
			unit:SetBounceMultiplier(1.5)
		end

	end

	self.units = units

	local chosen_unit = units[ RandomInt(1, #units) ]

	local timer = Timers:CreateTimer(2.0, function()

		--EncounterGroundAOEWarningSticky(chosen_unit:GetAbsOrigin(), 80, 2.0, Vector(0,255,0))
		EncounterUnitWarning(chosen_unit, 2.0, true, "green") --nil=yellow, "red", "orange", "green"

	end)
	PersistentTimer_Add(timer)

	local timer = Timers:CreateTimer(3.0+2.0, function()

		for _,unit in pairs(units) do

			-- Particle --
			local particle = ParticleManager:CreateParticle("particles/econ/items/wisp/wisp_guardian_explosion_ti7.vpcf", PATTACH_ABSORIGIN, unit)
			ParticleManager:SetParticleControl( particle, 0, unit:GetAbsOrigin() )
			ParticleManager:ReleaseParticleIndex( particle )
			particle = nil

			-- Sound --
			unit:EmitSound("Hero_OgreMagi.Fireblast.x3")

			unit:SetPhysicsFriction(0.015)
			unit:SetRebounceFrames(12)
			unit:AddPhysicsVelocity( RotateVector2D(unit:GetForwardVector(),math.rad(RandomInt(0, 360))) * RandomInt(2000, 2500) )
			unit:OnPhysicsFrame(function(unit)
				-- Particle --
				local particle = ParticleManager:CreateParticle("particles/econ/courier/courier_flopjaw_gold/flopjaw_death_coins_gold.vpcf", PATTACH_ABSORIGIN, unit)
				ParticleManager:SetParticleControl( particle, 0, unit:GetAbsOrigin() )
				ParticleManager:ReleaseParticleIndex( particle )
				particle = nil
			end)

		end

	end)
	PersistentTimer_Add(timer)

	local timer = Timers:CreateTimer(3.0+2.0+5.0, function()

		for _,unit in pairs(units) do
			unit:SetPhysicsFriction(0.20)
			unit:FindModifierByName("modifier_attack_immune"):Destroy()
			unit:FindModifierByName("modifier_invulnerable"):Destroy()
			unit:FindModifierByName("modifier_unselectable"):Destroy()
		end

	end)
	PersistentTimer_Add(timer)

	local timer = Timers:CreateTimer(3.0+2.0+5.0, function()

		for _,unit in pairs(units) do
			if not unit:IsAlive() then
				if unit ~= chosen_unit then
					self:FalseUnit()
					return
				else
					self:CorrectUnit()
					return
				end
			end
		end

		return 0.01
	end)
	PersistentTimer_Add(timer)

	local timer1 = Timers:CreateTimer(3.0+2.0+5.0+duration, function()

		Timers:RemoveTimer(timer)
		timer = nil

		local units_alive = 0
		for _,unit in pairs(units) do
			if unit ~= nil then
				if not unit:IsNull() then
					if unit:IsAlive() then
						units_alive = units_alive + 1
					end
				end
			end
		end

		if units_alive == 3 then
			self:FalseUnit()
		end

	end)
	PersistentTimer_Add(timer1)

end

function the_dungeoneer_three_shell_game:FalseUnit()
	--- Get Caster, Victim, Player, Point ---
	local caster		= self:GetCaster()
	local caster_loc	= caster:GetAbsOrigin()
	local playerID		= caster:GetPlayerOwnerID()
	local player		= PlayerResource:GetPlayer(playerID)
	local team			= caster:GetTeamNumber()
	
	--- Get Special Values ---
	local duration                    = self:GetSpecialValueFor("duration")
	local delay                       = self:GetSpecialValueFor("delay")
	local demonic_warrior_health_percentage= self:GetSpecialValueFor("demonic_warrior_health_percentage")

	-- Sound and Animation --
	local sound = {"grimstroke_grimstroke_deny_15", "grimstroke_grimstroke_deny_08",
					"grimstroke_grimstroke_deny_05", "grimstroke_grimstroke_lasthit_18"}
	EmitAnnouncerSound( sound[RandomInt(1, #sound)] )

	local timer = Timers:CreateTimer(2.75, function()
		local sound = {"grimstroke_grimstroke_laugh_14", "grimstroke_grimstroke_laugh_10",
						"grimstroke_grimstroke_laugh_12", "grimstroke_grimstroke_laugh_13"}
		EmitAnnouncerSound( sound[RandomInt(1, #sound)] )
	end)
	PersistentTimer_Add(timer)

	local unit_loc = GetRandomPointWithinArena()--GetSpecificBorderPoint("point_center")
	local unit = CreateUnitByName("npc_dota_hero_demonic_warrior", unit_loc, true, nil, nil, DOTA_TEAM_BADGUYS)
	PersistentUnit_Add(unit)
	EncounterCreate_AttackDamage(unit)
	EncounterCreate_Health(unit)

	unit:SetHealth( unit:GetMaxHealth() * ( demonic_warrior_health_percentage / 100 ) )

	unit:AddExperience(10000, 0, false, true)
	EncounterCreate_AbilitiesLvlUp(unit, 2)

	local timer = Timers:CreateTimer(0.1, function()
		for i=0,2 do
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

	for _,unit in pairs(self.units) do
		if unit ~= nil then
			if not unit:IsNull() then
				unit:RemoveSelf()
			end
		end
	end

end

function the_dungeoneer_three_shell_game:CorrectUnit()
	--- Get Caster, Victim, Player, Point ---
	local caster		= self:GetCaster()
	local caster_loc	= caster:GetAbsOrigin()
	local playerID		= caster:GetPlayerOwnerID()
	local player		= PlayerResource:GetPlayer(playerID)
	local team			= caster:GetTeamNumber()
	
	--- Get Special Values ---
	local duration                    = self:GetSpecialValueFor("duration")
	local delay                       = self:GetSpecialValueFor("delay")
	local demonic_warrior_health_percentage= self:GetSpecialValueFor("demonic_warrior_health_percentage")

	-- Sound and Animation --
	local sound = {"grimstroke_grimstroke_anger_06", "grimstroke_grimstroke_anger_07",
					"grimstroke_grimstroke_crumwiz_01", "grimstroke_grimstroke_shitwiz_01"}
	EmitAnnouncerSound( sound[RandomInt(1, #sound)] )

	for _,unit in pairs(self.units) do
		if unit ~= nil then
			if not unit:IsNull() then
				unit:RemoveSelf()
			end
		end
	end

end

function the_dungeoneer_three_shell_game:OnAbilityPhaseStart()
	local caster			= self:GetCaster()
	local playerID			= caster:GetPlayerOwnerID()
	local player			= PlayerResource:GetPlayer(playerID)

	return true
end

function the_dungeoneer_three_shell_game:GetManaCost(abilitylevel)
	return self.BaseClass.GetManaCost(self, abilitylevel)
end

function the_dungeoneer_three_shell_game:GetCooldown(abilitylevel)
	return self.BaseClass.GetCooldown(self, abilitylevel)
end