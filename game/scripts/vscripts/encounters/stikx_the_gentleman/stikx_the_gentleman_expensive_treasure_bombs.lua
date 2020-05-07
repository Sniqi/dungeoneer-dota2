stikx_the_gentleman_expensive_treasure_bombs = class({})

function stikx_the_gentleman_expensive_treasure_bombs:OnSpellStart()

	--- Get Caster, Victim, Player, Point ---
	local caster		= self:GetCaster()
	local caster_loc	= caster:GetAbsOrigin()
	local playerID		= caster:GetPlayerOwnerID()
	local player		= PlayerResource:GetPlayer(playerID)
	local team			= caster:GetTeamNumber()
	local victim		= caster
	local victim_loc	= victim:GetAbsOrigin()
	
	--- Get Special Values ---
	local AoERadius                   = self:GetSpecialValueFor("AoERadius")
	local duration                    = self:GetSpecialValueFor("duration")
	local damage                      = self:GetSpecialValueFor("damage")
	local delay_min                   = self:GetSpecialValueFor("delay_min")
	local delay_max                   = self:GetSpecialValueFor("delay_max")
	local minion_move_speed           = self:GetSpecialValueFor("minion_move_speed")
	local minion_count                = self:GetSpecialValueFor("minion_count")
	local delay_explosion             = self:GetSpecialValueFor("delay_explosion")

	caster:AddNewModifier(caster, self, "casting_rooted_modifier", {duration=duration/3})
	DisableMotionControllers(caster, duration/3)

	-- Sound and Animation --
	local sound = {"monkey_king_monkey_bottle_07", "monkey_king_monkey_bottle_08",
					"monkey_king_monkey_bottle_09", "monkey_king_monkey_ability2_04"}
	EmitAnnouncerSound( sound[RandomInt(1, #sound)] )
	
	StartAnimation(caster, {duration=duration, activity=ACT_DOTA_SPAWN, rate=0.5})

	for i=1,minion_count do

		local loc_start = GetRandomBorderPoint()
		local loc_end = GetRandomBorderPointCounterpart(loc_start)

		loc_start = loc_start + Vector(i*25,i*25,0)

		local delay = RandomFloat(delay_min, delay_max)

		-- Sound --
		StartSoundEventFromPositionReliable("Hero_Chen.TeleportOut", loc_start)

		-- Particle --
		local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_brewmaster/brewmaster_primal_split_explosion_swirl_b.vpcf", PATTACH_CUSTOMORIGIN, nil)
		ParticleManager:SetParticleControl( particle, 0, loc_start )
		ParticleManager:ReleaseParticleIndex( particle )
		particle = nil

		local unit = CreateUnitByName("expensive_treasure_bombs", loc_start, true, nil, nil, DOTA_TEAM_BADGUYS)
		PersistentUnit_Add(unit)

		unit:AddNewModifier(unit, nil, "modifier_dummy", {})
		unit:AddNewModifier(unit, nil, "modifier_phased", {})

		unit:Stop()

		local timer = Timers:CreateTimer(0.1, function()
			unit:MoveToPosition(loc_end)
		end)
		PersistentTimer_Add(timer)

		local timer1 = Timers:CreateTimer(delay, function()

			unit:Stop()

			local loc = unit:GetAbsOrigin()

			EncounterGroundAOEWarningSticky(loc, AoERadius, delay_explosion+0.1)

			local timer2 = Timers:CreateTimer(delay_explosion, function()

				unit:RemoveSelf()

				-- Sound --
				StartSoundEventFromPositionReliable("Hero_ElderTitan.EchoStomp", loc)

				-- Particle --
				local particle = ParticleManager:CreateParticle("particles/encounter/stikx_the_gentleman/stikx_the_gentleman_expensive_treasure_bombs.vpcf", PATTACH_CUSTOMORIGIN, nil)
				ParticleManager:SetParticleControl( particle, 0, loc )
				ParticleManager:SetParticleControl( particle, 1, loc )
				ParticleManager:SetParticleControl( particle, 3, loc )
				ParticleManager:ReleaseParticleIndex( particle )
				particle = nil

				-- DOTA_UNIT_TARGET_TEAM_FRIENDLY; DOTA_UNIT_TARGET_TEAM_ENEMY; DOTA_UNIT_TARGET_TEAM_BOTH
				local units	= FindUnitsInRadius(team, loc, nil, AoERadius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
				for _,victim in pairs(units) do

					-- Apply Damage --
					EncounterApplyDamage(victim, caster, self, damage, DAMAGE_TYPE_MAGICAL, DOTA_DAMAGE_FLAG_NONE)

				end

			end)
			PersistentTimer_Add(timer2)

		end)
		PersistentTimer_Add(timer1)

	end
	
end

function stikx_the_gentleman_expensive_treasure_bombs:OnAbilityPhaseStart()
	local caster			= self:GetCaster()
	local playerID			= caster:GetPlayerOwnerID()
	local player			= PlayerResource:GetPlayer(playerID)

	return true
end

function stikx_the_gentleman_expensive_treasure_bombs:GetManaCost(abilitylevel)
	return self.BaseClass.GetManaCost(self, abilitylevel)
end

function stikx_the_gentleman_expensive_treasure_bombs:GetCooldown(abilitylevel)
	return self.BaseClass.GetCooldown(self, abilitylevel)
end