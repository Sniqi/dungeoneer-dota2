a_mighty_boar_falling_rocks = class({})

LinkLuaModifier( 'a_mighty_boar_falling_rocks_modifier', 'encounters/a_mighty_boar/a_mighty_boar_falling_rocks_modifier', LUA_MODIFIER_MOTION_NONE )

function a_mighty_boar_falling_rocks:OnSpellStart()

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
	local damage_duration             = self:GetSpecialValueFor("damage_duration")
	local damage_interval             = self:GetSpecialValueFor("damage_interval")
	local damage_instances            = self:GetSpecialValueFor("damage_instances")
	local delay_min                   = self:GetSpecialValueFor("delay_min")
	local delay_max                   = self:GetSpecialValueFor("delay_max")
	local stun                        = self:GetSpecialValueFor("stun")

	local delay = RandomFloat(delay_min, delay_max)

	caster:AddNewModifier(caster, self, "casting_rooted_modifier", {duration=delay})
	DisableMotionControllers(caster, delay)

	TurnToLoc(caster, victim_loc, nil)

	EncounterGroundAOEWarningStickyOnUnit(victim, AoERadius, delay)
	EncounterUnitWarning(victim, 2.0, true, nil) --nil=yellow, "red", "orange", "green"

	local timer1 = Timers:CreateTimer(delay, function()

		local victim_loc = victim:GetAbsOrigin()

		EncounterGroundAOEWarningSticky(victim_loc, AoERadius, duration)

		-- Create Particle --
		local particle = ParticleManager:CreateParticle("particles/dire_fx/dire_lava_falling_rocks.vpcf", PATTACH_CUSTOMORIGIN, nil)
		ParticleManager:SetParticleControl( particle, 0, victim_loc )
		ParticleManager:SetParticleControl( particle, 1, Vector(0, 0, 0) )
		PersistentParticle_Add(particle)
	
		local timer2 = Timers:CreateTimer(2.0, function()
			for i=0,damage_instances-1 do
				local timer = Timers:CreateTimer(damage_interval * i, function()

					-- Sound --
					StartSoundEventFromPositionReliable("Roshan.Slam", victim_loc)

					-- DOTA_UNIT_TARGET_TEAM_FRIENDLY; DOTA_UNIT_TARGET_TEAM_ENEMY; DOTA_UNIT_TARGET_TEAM_BOTH
					local units	= FindUnitsInRadius(team, victim_loc, nil, AoERadius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
					for _,victim in pairs(units) do

						-- Modifier --
						victim:AddNewModifier(caster, self, "a_mighty_boar_falling_rocks_modifier", {duration = stun})

						-- Apply Damage --
						EncounterApplyDamage(victim, caster, self, damage/damage_instances, DAMAGE_TYPE_PHYSICAL, DOTA_DAMAGE_FLAG_NONE)
					
					end

				end)
				PersistentTimer_Add(timer)
			end
		end)
		PersistentTimer_Add(timer2)

		-- Cleanup --
		Timers:CreateTimer(5.0, function()
			ParticleManager:DestroyParticle( particle, false )
			ParticleManager:ReleaseParticleIndex( particle )
		end)

	end)
	PersistentTimer_Add(timer1)

end

function a_mighty_boar_falling_rocks:OnAbilityPhaseStart()
	local caster			= self:GetCaster()
	local playerID			= caster:GetPlayerOwnerID()
	local player			= PlayerResource:GetPlayer(playerID)

	return true
end

function a_mighty_boar_falling_rocks:GetManaCost(abilitylevel)
	return self.BaseClass.GetManaCost(self, abilitylevel)
end

function a_mighty_boar_falling_rocks:GetCooldown(abilitylevel)
	return self.BaseClass.GetCooldown(self, abilitylevel)
end