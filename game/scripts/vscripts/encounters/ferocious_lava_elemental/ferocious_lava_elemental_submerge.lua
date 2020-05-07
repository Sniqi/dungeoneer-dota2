ferocious_lava_elemental_submerge = class({})

function ferocious_lava_elemental_submerge:OnSpellStart()

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
	local phase_two_percentage        = self:GetSpecialValueFor("phase_two_percentage")
	local phase_two_damage_percentage = self:GetSpecialValueFor("phase_two_damage_percentage")
	local phase_two_aoe               = self:GetSpecialValueFor("phase_two_aoe")
	local phase_two_delay             = self:GetSpecialValueFor("phase_two_delay")

	local phase_three_percentage      = self:GetSpecialValueFor("phase_three_percentage")

	local animation_duration = 2.25

		-- PHASE 2 --
	local phase2_delay = 0
	if caster:GetHealthPercent() < phase_two_percentage then
		phase2_delay = phase_two_delay
	end

	caster:AddNewModifier(caster, self, "casting_rooted_modifier", {duration=animation_duration+delay+duration+phase2_delay})
	DisableMotionControllers(caster, animation_duration+delay+duration+phase2_delay)

	-- Sound and Animation --
	local sound = {"nevermore_nev_arc_death_13", "nevermore_nev_arc_move_03",
					"nevermore_nev_arc_kill_13"}
	EmitAnnouncerSound( sound[RandomInt(1, #sound)] )
	StartAnimation(caster, {duration=animation_duration, activity=ACT_DOTA_DIE, rate=0.75})

	-- Particle --
	local particle = ParticleManager:CreateParticle("particles/encounter/ferocious_lava_elemental/ferocious_lava_elemental_submerge.vpcf", PATTACH_CUSTOMORIGIN, nil)
	ParticleManager:SetParticleControl( particle, 0, caster_loc )
	PersistentParticle_Add(particle)

	local timer = Timers:CreateTimer(animation_duration, function()
		caster:AddNewModifier(caster, self, "modifier_out_of_world", {duration = delay+duration+phase2_delay})
	end)
	PersistentTimer_Add(timer)

	local timer = Timers:CreateTimer(animation_duration+2.0, function()
		ParticleManager:DestroyParticle( particle, false )
		ParticleManager:ReleaseParticleIndex( particle )
		particle = nil
	end)
	PersistentTimer_Add(timer)

	local instances = 20
	for i=0,instances do
		local timer1 = Timers:CreateTimer(animation_duration+delay + (duration / instances * i), function()

			local victim		= GetRandomHeroEntities(1)
			if not victim then return end
			victim				= victim[1]
			local victim_loc	= victim:GetAbsOrigin()

			local point = nil
			if RollPercentage(50) then
				if RollPercentage(50) then
					if RollPercentage(50) then
						point = victim_loc + RandomVector(50)
					else
						point = victim_loc + RandomVector(250)
					end
				else
					point = victim_loc + RandomVector(500)
				end
			else
				if RollPercentage(50) then
					if RollPercentage(50) then
						point = victim_loc - RandomVector(50)
					else
						point = victim_loc - RandomVector(250)
					end
				else
					point = victim_loc - RandomVector(500)
				end
			end

			EncounterGroundAOEWarningSticky(point, AoERadius, delay+0.25)

			local timer2 = Timers:CreateTimer(delay, function()

				-- Sound --
				StartSoundEventFromPosition("Hero_Phoenix.FireSpirits.Target", point)

				-- Particle --
				local particle = ParticleManager:CreateParticle("particles/econ/items/alchemist/alchemist_smooth_criminal/alchemist_smooth_criminal_unstable_concoction_explosion.vpcf", PATTACH_CUSTOMORIGIN, nil)
				ParticleManager:SetParticleControl( particle, 0, point )
				ParticleManager:ReleaseParticleIndex( particle )
				particle = nil

				-- DOTA_UNIT_TARGET_TEAM_FRIENDLY; DOTA_UNIT_TARGET_TEAM_ENEMY; DOTA_UNIT_TARGET_TEAM_BOTH
				local units	= FindUnitsInRadius(team, point, nil, AoERadius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
				for _,victim in pairs(units) do
					-- Apply Damage --
					EncounterApplyDamage(victim, caster, self, damage, DAMAGE_TYPE_MAGICAL, DOTA_DAMAGE_FLAG_NONE)
				end

			end)
			PersistentTimer_Add(timer2)

		end)
		PersistentTimer_Add(timer1)
	end

	-- PHASE 2 --
	local phase2_delay = 0
	if caster:GetHealthPercent() < phase_two_percentage then

		phase2_delay = phase_two_delay

		local timer = Timers:CreateTimer(animation_duration+delay+duration, function()
			EncounterGroundAOEWarningSticky(caster_loc, phase_two_aoe, phase2_delay+0.25)
		end)
		PersistentTimer_Add(timer)

		local timer = Timers:CreateTimer(animation_duration+delay+duration+phase2_delay, function()

			-- Sound --
			StartSoundEventFromPosition("Hero_Warlock.RainOfChaos_buildup", caster_loc)
			StartSoundEventFromPosition("Hero_Warlock.RainOfChaos", caster_loc)

			-- Particle --
			local particle = ParticleManager:CreateParticle("particles/dire_fx/bad_ancient002_pit_lava_blast.vpcf", PATTACH_CUSTOMORIGIN, nil)
			ParticleManager:SetParticleControl( particle, 0, caster_loc )
			ParticleManager:ReleaseParticleIndex( particle )
			particle = nil

			-- DOTA_UNIT_TARGET_TEAM_FRIENDLY; DOTA_UNIT_TARGET_TEAM_ENEMY; DOTA_UNIT_TARGET_TEAM_BOTH
			local units	= FindUnitsInRadius(team, caster_loc, nil, phase_two_aoe, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
			for _,victim in pairs(units) do
				-- Apply Damage --
				EncounterApplyDamage(victim, caster, self, phase_two_damage_percentage, DAMAGE_TYPE_MAGICAL, DOTA_DAMAGE_FLAG_NONE)
			end

		end)
		PersistentTimer_Add(timer)

	end


	local timer = Timers:CreateTimer(animation_duration+delay+duration+phase2_delay, function()

		-- Sound and Animation --
		local sound = {"nevermore_nev_arc_ability_presence_01", "nevermore_nev_arc_ability_presence_02",
						"nevermore_nev_arc_ability_presence_03"}
		EmitAnnouncerSound( sound[RandomInt(1, #sound)] )
		StartAnimation(caster, {duration=animation_duration, activity=ACT_DOTA_SPAWN, rate=1.0})

		-- Particle --
		local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_gyrocopter/gyro_calldown_explosion_flash_c.vpcf", PATTACH_CUSTOMORIGIN, nil)
		ParticleManager:SetParticleControl( particle, 0, caster_loc )
		ParticleManager:SetParticleControl( particle, 3, caster_loc )
		ParticleManager:ReleaseParticleIndex( particle )
		particle = nil

		-- PHASE 3 --
		if caster:GetHealthPercent() < phase_three_percentage then
			for i=1,GetPlayerCount()*2 do
				local unit = CreateUnitByName("lesser_lava_elemental", caster_loc, true, nil, nil, DOTA_TEAM_BADGUYS)
				PersistentUnit_Add(unit)
				EncounterCreate_AttackDamage(unit)
				EncounterCreate_Health(unit)
			end
		end

	end)
	PersistentTimer_Add(timer)
	
end

function ferocious_lava_elemental_submerge:OnAbilityPhaseStart()
	local caster			= self:GetCaster()
	local playerID			= caster:GetPlayerOwnerID()
	local player			= PlayerResource:GetPlayer(playerID)

	return true
end

function ferocious_lava_elemental_submerge:GetManaCost(abilitylevel)
	return self.BaseClass.GetManaCost(self, abilitylevel)
end

function ferocious_lava_elemental_submerge:GetCooldown(abilitylevel)
	return self.BaseClass.GetCooldown(self, abilitylevel)
end