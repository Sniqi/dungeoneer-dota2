drono_red_dragonkin_commander_commanding_shout = class({})

LinkLuaModifier( 'drono_red_dragonkin_commander_commanding_shout_modifier', 'encounters/drono_red_dragonkin_commander/drono_red_dragonkin_commander_commanding_shout_modifier', LUA_MODIFIER_MOTION_NONE )

function drono_red_dragonkin_commander_commanding_shout:OnSpellStart()

	--- Get Caster, Victim, Player, Point ---
	local caster		= self:GetCaster()
	local caster_loc	= caster:GetAbsOrigin()
	local playerID		= caster:GetPlayerOwnerID()
	local player		= PlayerResource:GetPlayer(playerID)
	local team			= caster:GetTeamNumber()
	
	--- Get Special Values ---
	local duration                    = self:GetSpecialValueFor("duration")
	local delay                       = self:GetSpecialValueFor("delay")
	local move_speed_percentage       = self:GetSpecialValueFor("move_speed_percentage")
	local armor                       = self:GetSpecialValueFor("armor")
	local magic_resist_percentage     = self:GetSpecialValueFor("magic_resist_percentage")
	local disable_healing             = self:GetSpecialValueFor("disable_healing")
	
	caster:AddNewModifier(caster, self, "casting_rooted_modifier", {duration=delay})
	DisableMotionControllers(caster, delay)

	EncounterUnitWarning(caster, delay, true, nil) --nil=yellow, "red", "orange", "green"

	-- Sound --
	local sound = {"troll_warlord_troll_beserker_01", "troll_warlord_troll_beserker_02",
					"troll_warlord_troll_beserker_04", "troll_warlord_troll_battletrance_05"}
	EmitAnnouncerSound( sound[RandomInt(1, #sound)] )

	-- Animation --
	StartAnimation(caster, {duration=delay, activity=ACT_DOTA_DISABLED, rate=1.0})

	local timer1 = Timers:CreateTimer(delay, function()

		-- Animation --
		StartAnimation(caster, {duration=0.3, activity=ACT_DOTA_FLAIL, rate=1.0})

		-- Sound --
		caster:EmitSound("Hero_Beastmaster.Primal_Roar")

		-- DOTA_UNIT_TARGET_TEAM_FRIENDLY; DOTA_UNIT_TARGET_TEAM_ENEMY; DOTA_UNIT_TARGET_TEAM_BOTH
		local units	= FindUnitsInRadius(team, caster_loc, nil, 5000, DOTA_UNIT_TARGET_TEAM_BOTH, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
		for _,victim in pairs(units) do

			if victim ~= caster then

				local current_loc = victim:GetAbsOrigin()

				local timer2 = Timers:CreateTimer(0.03, function()

					local new_loc = victim:GetAbsOrigin()

					if current_loc.x ~= new_loc.x or current_loc.y ~= new_loc.y then

						-- Particle --
						local particle = ParticleManager:CreateParticle("particles/econ/items/weaver/weaver_golden_immortal_ti7/weaver_golden_swarm_infected_debuff_ti7.vpcf", PATTACH_ABSORIGIN_FOLLOW, victim)
						ParticleManager:SetParticleControl( particle, 0, victim:GetAbsOrigin() )
						PersistentParticle_Add(particle)

						local timer3 = Timers:CreateTimer(duration, function()
							-- Particle --
							ParticleManager:DestroyParticle( particle, false )
							ParticleManager:ReleaseParticleIndex( particle )
							particle = nil
						end)
						PersistentTimer_Add(timer3)

						-- Modifier --
						local modifier = victim:AddNewModifier(caster, self, "drono_red_dragonkin_commander_commanding_shout_modifier", {duration = duration})
						PersistentModifier_Add(modifier)

					end

				end)
				PersistentTimer_Add(timer2)

			end

		end

	end)
	PersistentTimer_Add(timer1)

end

function drono_red_dragonkin_commander_commanding_shout:OnAbilityPhaseStart()
	local caster			= self:GetCaster()
	local playerID			= caster:GetPlayerOwnerID()
	local player			= PlayerResource:GetPlayer(playerID)

	return true
end

function drono_red_dragonkin_commander_commanding_shout:GetManaCost(abilitylevel)
	return self.BaseClass.GetManaCost(self, abilitylevel)
end

function drono_red_dragonkin_commander_commanding_shout:GetCooldown(abilitylevel)
	return self.BaseClass.GetCooldown(self, abilitylevel)
end