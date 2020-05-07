samurai_of_chaos_slowest_death_kitty = class({})

LinkLuaModifier( 'samurai_of_chaos_slowest_death_kitty_modifier', 'encounters/samurai_of_chaos/samurai_of_chaos_slowest_death_kitty_modifier', LUA_MODIFIER_MOTION_NONE )

function samurai_of_chaos_slowest_death_kitty:OnSpellStart()

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
	local move_speed_absolute         = self:GetSpecialValueFor("move_speed_absolute")
	local delay                       = self:GetSpecialValueFor("delay")

	local AoERadius_Trigger = 100

	-- Sound and Animation --
	local sound = {"juggernaut_jugsc_arc_attack_02", "juggernaut_jugsc_arc_attack_05",
					"juggernaut_jugsc_arc_attack_06", "juggernaut_jugsc_arc_attack_09"}
	EmitAnnouncerSound( sound[RandomInt(1, #sound)] )

	StartAnimation(caster, {duration=0.9, activity=ACT_DOTA_CAST_ABILITY_2, rate=1.00})

	local unit = CreateUnitByName("samurai_of_chaos_slowest_death_kitty", victim:GetAbsOrigin(), true, nil, nil, DOTA_TEAM_BADGUYS)
	PersistentUnit_Add(unit)

	unit:AddNewModifier(caster, self, "modifier_invulnerable", {})
	unit:AddNewModifier(caster, self, "modifier_unselectable", {})
	unit:AddNewModifier(caster, self, "modifier_phased", {})

	-- Modifier --
	unit:AddNewModifier(caster, self, "samurai_of_chaos_slowest_death_kitty_modifier", {})

	unit:Stop()

	EncounterGroundAOEWarningStickyOnUnit(unit, AoERadius_Trigger, nil, nil)

	-- Sound --
	StartSoundEventFromPositionReliable("Hero_Juggernaut.HealingWard.Cast", unit:GetAbsOrigin())

	local triggered = false

	local timer = Timers:CreateTimer(delay, function()
		unit:MoveToNPC(victim)

		local timer1 = Timers:CreateTimer(function()

			-- DOTA_UNIT_TARGET_TEAM_FRIENDLY; DOTA_UNIT_TARGET_TEAM_ENEMY; DOTA_UNIT_TARGET_TEAM_BOTH
			local units	= FindUnitsInRadius(team, unit:GetAbsOrigin(), nil, AoERadius_Trigger, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
			if units[1] ~= nil and not triggered then
				triggered = true

				unit:Stop()

				-- Sound --
				StartSoundEventFromPositionReliable("Hero_Phoenix.SuperNova.Death", unit:GetAbsOrigin())

				-- Particle -- PATTACH_ABSORIGIN-PATTACH_ABSORIGIN_FOLLOW-PATTACH_CUSTOMORIGIN
				local particle = ParticleManager:CreateParticle("particles/encounter/samurai_of_chaos/samurai_of_chaos_slowest_death_kitty_shine.vpcf", PATTACH_CUSTOMORIGIN, nil)
				ParticleManager:SetParticleControl( particle, 1, unit:GetAbsOrigin() )
				ParticleManager:ReleaseParticleIndex( particle )
				particle = nil


				local timer = Timers:CreateTimer(0.5, function()

					-- Sound --
					StartSoundEventFromPositionReliable("Hero_Phoenix.SuperNova.Explode", unit:GetAbsOrigin())

					-- Particle -- PATTACH_ABSORIGIN-PATTACH_ABSORIGIN_FOLLOW-PATTACH_CUSTOMORIGIN
					local particle = ParticleManager:CreateParticle("particles/encounter/samurai_of_chaos/samurai_of_chaos_slowest_death_kitty_smoke.vpcf", PATTACH_CUSTOMORIGIN, nil)
					ParticleManager:SetParticleControl( particle, 3, unit:GetAbsOrigin() )
					ParticleManager:ReleaseParticleIndex( particle )
					particle = nil

					-- Particle -- PATTACH_ABSORIGIN-PATTACH_ABSORIGIN_FOLLOW-PATTACH_CUSTOMORIGIN
					local particle = ParticleManager:CreateParticle("particles/encounter/samurai_of_chaos/samurai_of_chaos_slowest_death_kitty_particle.vpcf", PATTACH_CUSTOMORIGIN, nil)
					ParticleManager:SetParticleControl( particle, 3, unit:GetAbsOrigin() )
					ParticleManager:ReleaseParticleIndex( particle )
					particle = nil

					-- Particle -- PATTACH_ABSORIGIN-PATTACH_ABSORIGIN_FOLLOW-PATTACH_CUSTOMORIGIN
					local particle = ParticleManager:CreateParticle("particles/encounter/samurai_of_chaos/samurai_of_chaos_slowest_death_kitty_explosion.vpcf", PATTACH_CUSTOMORIGIN, nil)
					ParticleManager:SetParticleControl( particle, 1, unit:GetAbsOrigin() )
					ParticleManager:ReleaseParticleIndex( particle )
					particle = nil

					-- DOTA_UNIT_TARGET_TEAM_FRIENDLY; DOTA_UNIT_TARGET_TEAM_ENEMY; DOTA_UNIT_TARGET_TEAM_BOTH
					local units	= FindUnitsInRadius(team, unit:GetAbsOrigin(), nil, AoERadius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
					for _,victim in pairs(units) do
						-- Apply Damage --
						EncounterApplyDamage(victim, caster, self, damage, DAMAGE_TYPE_MAGICAL, DOTA_DAMAGE_FLAG_NONE)
					end

					unit:ForceKill(false)

					local timer = Timers:CreateTimer(2.0, function()
						unit:RemoveSelf()
					end)

				end)

			end

			if triggered then return end

			return 0.1
		end)
		PersistentTimer_Add(timer1)

	end)
	PersistentTimer_Add(timer)

end

function samurai_of_chaos_slowest_death_kitty:OnAbilityPhaseStart()
	local caster			= self:GetCaster()
	local playerID			= caster:GetPlayerOwnerID()
	local player			= PlayerResource:GetPlayer(playerID)

	return true
end

function samurai_of_chaos_slowest_death_kitty:GetManaCost(abilitylevel)
	return self.BaseClass.GetManaCost(self, abilitylevel)
end

function samurai_of_chaos_slowest_death_kitty:GetCooldown(abilitylevel)
	return self.BaseClass.GetCooldown(self, abilitylevel)
end