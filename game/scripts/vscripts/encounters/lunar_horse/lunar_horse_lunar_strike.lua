lunar_horse_lunar_strike = class({})

LinkLuaModifier( 'lunar_horse_lunar_strike_modifier', 'encounters/lunar_horse/lunar_horse_lunar_strike_modifier', LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( 'lunar_horse_lunar_strike_movespeedtwo_modifier', 'encounters/lunar_horse/lunar_horse_lunar_strike_movespeedtwo_modifier', LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( 'lunar_horse_lunar_strike_movespeedthree_modifier', 'encounters/lunar_horse/lunar_horse_lunar_strike_movespeedthree_modifier', LUA_MODIFIER_MOTION_NONE )

function lunar_horse_lunar_strike:OnSpellStart()

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
	
	--- Get Special Values ---
	local AoERadius                   = self:GetSpecialValueFor("AoERadius")
	local duration                    = self:GetSpecialValueFor("duration")
	local damage                      = self:GetSpecialValueFor("damage")
	local damage_interval             = self:GetSpecialValueFor("damage_interval")
	local delay                       = self:GetSpecialValueFor("delay")
	local stun                        = self:GetSpecialValueFor("stun")
	local phase_two_percentage        = self:GetSpecialValueFor("phase_two_percentage")
	local phase_two_move_step         = self:GetSpecialValueFor("phase_two_move_step")
	local phase_three_percentage      = self:GetSpecialValueFor("phase_three_percentage")
	local phase_three_move_step       = self:GetSpecialValueFor("phase_three_move_step")

	EncounterGroundAOEWarningStickyOnUnit(victim, AoERadius, delay)

	victim:AddNewModifier(caster, self, "lunar_horse_lunar_strike_modifier", {duration = delay})

	local timer = Timers:CreateTimer(delay, function()

		local unit = CreateUnitByName("dummy", victim:GetAbsOrigin(), true, nil, nil, DOTA_TEAM_BADGUYS)
		PersistentUnit_Add(unit)

		unit:AddNewModifier(caster, self, "modifier_invulnerable", {})
		unit:AddNewModifier(caster, self, "modifier_unselectable", {})
		unit:AddNewModifier(caster, self, "modifier_phased", {})

		unit:Stop()

		-- Particle -- PATTACH_ABSORIGIN-PATTACH_ABSORIGIN_FOLLOW-PATTACH_CUSTOMORIGIN
		local particle_ground = ParticleManager:CreateParticle("particles/encounter/lunar_horse/lunar_horse_lunar_strike_ground.vpcf", PATTACH_ABSORIGIN_FOLLOW, unit)
		ParticleManager:SetParticleControl( particle_ground, 0, unit:GetAbsOrigin() )
		ParticleManager:SetParticleControl( particle_ground, 1, Vector(AoERadius,duration,0) )
		PersistentParticle_Add(particle_ground)

		-- PHASE --
		if caster:GetHealthPercent() < phase_two_percentage then

			local victim		= GetRandomHeroEntities(1)
			if not victim then return end
			victim				= victim[1]

			-- PHASE 3 --
			if caster:GetHealthPercent() < phase_three_percentage then
				unit:AddNewModifier(unit, self, "lunar_horse_lunar_strike_movespeedthree_modifier", {})
			-- PHASE 2 --
			else
				unit:AddNewModifier(unit, self, "lunar_horse_lunar_strike_movespeedtwo_modifier", {})
			end

			local timer = Timers:CreateTimer(0.1, function()
				unit:MoveToNPC(victim)
			end)

		end

		local timer1 = Timers:CreateTimer(delay/2, function()

			-- DOTA_UNIT_TARGET_TEAM_FRIENDLY; DOTA_UNIT_TARGET_TEAM_ENEMY; DOTA_UNIT_TARGET_TEAM_BOTH
			local units	= FindUnitsInRadius(team, unit:GetAbsOrigin(), nil, AoERadius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
			for _,victim in pairs(units) do

				-- Sound --
				StartSoundEventReliable("Hero_Mirana.Starstorm.Impact", victim)

				-- Particle -- PATTACH_ABSORIGIN-PATTACH_ABSORIGIN_FOLLOW-PATTACH_CUSTOMORIGIN
				local particle = ParticleManager:CreateParticle("particles/econ/items/mirana/mirana_starstorm_bow/mirana_starstorm_starfall_attack.vpcf", PATTACH_ABSORIGIN, victim)
				ParticleManager:SetParticleControl( particle, 0, victim:GetAbsOrigin() )
				ParticleManager:ReleaseParticleIndex( particle )
				particle = nil

				-- Modifier --
				victim:AddNewModifier(caster, self, "modifier_stunned", {duration = stun})
	
				-- Apply Damage --
				EncounterApplyDamage(victim, caster, self, damage, DAMAGE_TYPE_MAGICAL, DOTA_DAMAGE_FLAG_NONE)

			end

			return damage_interval
		end)
		PersistentTimer_Add(timer1)

		local timer2 = Timers:CreateTimer(duration, function()

			Timers:RemoveTimer(timer1)
			timer1 = nil

			--ParticleManager:DestroyParticle( particle_ground, false )
			--ParticleManager:ReleaseParticleIndex( particle_ground )
			--particle_ground = nil

			unit:RemoveSelf()
			unit = nil

		end)
		PersistentTimer_Add(timer2)
	end)
	PersistentTimer_Add(timer)
	
end

function lunar_horse_lunar_strike:OnAbilityPhaseStart()
	local caster			= self:GetCaster()
	local playerID			= caster:GetPlayerOwnerID()
	local player			= PlayerResource:GetPlayer(playerID)

	return true
end

function lunar_horse_lunar_strike:GetManaCost(abilitylevel)
	return self.BaseClass.GetManaCost(self, abilitylevel)
end

function lunar_horse_lunar_strike:GetCooldown(abilitylevel)
	return self.BaseClass.GetCooldown(self, abilitylevel)
end