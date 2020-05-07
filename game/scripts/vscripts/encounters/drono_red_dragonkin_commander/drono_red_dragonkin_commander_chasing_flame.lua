drono_red_dragonkin_commander_chasing_flame = class({})

function drono_red_dragonkin_commander_chasing_flame:OnSpellStart()

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
	local delay                       = self:GetSpecialValueFor("delay")

	caster:AddNewModifier(caster, self, "casting_rooted_modifier", {duration=delay})
	DisableMotionControllers(caster, delay)

	-- Sound --
	local sound = {"troll_warlord_troll_spawn_06"}
	EmitAnnouncerSound( sound[RandomInt(1, #sound)] )

	-- Animation --
	StartAnimation(caster, {duration=delay, activity=ACT_DOTA_FLAIL, rate=0.5})

	local timer1 = Timers:CreateTimer(delay, function()
		for _,victim in pairs( GetHeroesAliveEntities() ) do

			local timer2 = Timers:CreateTimer(0, function()

				local victim_loc = victim:GetAbsOrigin()
				local location

				if victim.chasing_flame_last == nil then
					location = caster_loc
				else
					location = victim.chasing_flame_last
				end

				location = location + ( (victim_loc - location):Normalized() * (AoERadius*1.5) )
				location = GetGroundPosition(location, caster) + Vector(0,0,25)

				victim.chasing_flame_last = location

				EncounterGroundAOEWarningSticky(location, AoERadius, damage_duration)

				-- Sound --
				StartSoundEventFromPositionReliable("Hero_Jakiro.LiquidFire", location)

				-- Particle --
				local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_phoenix/phoenix_supernova_egg_lava.vpcf", PATTACH_CUSTOMORIGIN, nil)
				ParticleManager:SetParticleControl( particle, 0, location )
				ParticleManager:SetParticleControl( particle, 3, location )
				PersistentParticle_Add(particle)

				local timer3 = Timers:CreateTimer(0, function()

					local units	= FindUnitsInRadius(team, location, nil, AoERadius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
					for _,victim in pairs(units) do
						-- Apply Damage --
						EncounterApplyDamage(victim, caster, self, damage*damage_interval, DAMAGE_TYPE_MAGICAL, DOTA_DAMAGE_FLAG_NONE)
					end

					return damage_interval
				end)
				PersistentTimer_Add(timer3)

				local timer4 = Timers:CreateTimer(damage_duration-0.03, function()

					Timers:RemoveTimer(timer3)
					timer3 = nil

					-- Particle --
					ParticleManager:DestroyParticle( particle, false )
					ParticleManager:ReleaseParticleIndex( particle )
					particle = nil
				end)
				PersistentTimer_Add(timer4)

				return 0.7
			end)
			PersistentTimer_Add(timer2)

			local timer5 = Timers:CreateTimer(duration-0.03, function()

				Timers:RemoveTimer(timer2)
				timer2 = nil

				victim.chasing_flame_last = nil

			end)
			PersistentTimer_Add(timer5)

		end
	end)
	PersistentTimer_Add(timer1)

end

function drono_red_dragonkin_commander_chasing_flame:OnAbilityPhaseStart()
	local caster			= self:GetCaster()
	local playerID			= caster:GetPlayerOwnerID()
	local player			= PlayerResource:GetPlayer(playerID)

	return true
end

function drono_red_dragonkin_commander_chasing_flame:GetManaCost(abilitylevel)
	return self.BaseClass.GetManaCost(self, abilitylevel)
end

function drono_red_dragonkin_commander_chasing_flame:GetCooldown(abilitylevel)
	return self.BaseClass.GetCooldown(self, abilitylevel)
end