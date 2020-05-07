treasure_on_a_tree_green_mines = class({})

LinkLuaModifier( 'treasure_on_a_tree_green_mines_modifier', 'encounters/treasure_on_a_tree/treasure_on_a_tree_green_mines_modifier', LUA_MODIFIER_MOTION_NONE )

function treasure_on_a_tree_green_mines:OnSpellStart()

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
	local range                       = self:GetSpecialValueFor("range")
	local debuff_duration             = self:GetSpecialValueFor("debuff_duration")
	local move_speed_percentage       = self:GetSpecialValueFor("move_speed_percentage")

	local count = math.floor( ( ( range / AoERadius ) / 3 ) + 0.5 )

	local loc = caster:GetAbsOrigin() + Vector( RandomInt(-100, 100), RandomInt(-100, 100), 0 )  --RandomLocationMinDistance( GetSpecificBorderPoint("point_center"), 100)

	caster:AddNewModifier(caster, self, "casting_rooted_modifier", {duration=delay})
	
	StartAnimation(caster, {duration=delay, activity=ACT_DOTA_RUN, rate=0.40})

	TurnToLoc(caster, loc, delay)

	local locs = {}
	local timer = Timers:CreateTimer(0.5, function()
		for i=1,count do

			local location = caster:GetAbsOrigin() + ( caster:GetForwardVector() * AoERadius * 3 * i ) 
			location = RandomLocationMinDistance( location, AoERadius*RandomFloat(0.0, 0.5))

			table.insert(locs, location)

			EncounterGroundAOEWarningSticky(location, AoERadius, delay+2)
		end
	end)
	PersistentTimer_Add(timer)

	local particles = {}
	local timers = {}
	local timer1 = Timers:CreateTimer(delay-0.5, function()

		-- Sound and Animation --
		local sound = {"treant_treant_pain_01", "treant_treant_pain_02",
						"treant_treant_pain_03", "treant_treant_pain_13"}
		EmitAnnouncerSound( sound[RandomInt(1, #sound)] )
		
		StartAnimation(caster, {duration=delay, activity=ACT_DOTA_SPAWN, rate=1.75})

		for _,location in pairs(locs) do

			local timer2 = Timers:CreateTimer(_*0.1+RandomFloat(0.00, 1.00), function()

				local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_grimstroke/grimstroke_soulchain_ground_chains_detail_glow.vpcf", PATTACH_CUSTOMORIGIN, nil)
				ParticleManager:SetParticleControl( particle, 2, location )
				PersistentParticle_Add(particle)
				table.insert(particles, particle)

				-- Sound --
				StartSoundEventFromPositionReliable("Hero_VenomancerWard.ProjectileImpact", location)

				local timer3 = Timers:CreateTimer(0, function()

					-- DOTA_UNIT_TARGET_TEAM_FRIENDLY; DOTA_UNIT_TARGET_TEAM_ENEMY; DOTA_UNIT_TARGET_TEAM_BOTH
					local units	= FindUnitsInRadius(team, location, nil, AoERadius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
					for _,victim in pairs(units) do

						-- Sound --
						StartSoundEventReliable("Hero_VenomancerWard.ProjectileImpact", victim)
						
						victim:AddNewModifier(caster, self, "treasure_on_a_tree_green_mines_modifier", {duration = debuff_duration})

						-- Apply Damage --
						EncounterApplyDamage(victim, caster, self, damage, DAMAGE_TYPE_MAGICAL, DOTA_DAMAGE_FLAG_NONE)

					end

					if units[1] ~= nil then
						ParticleManager:DestroyParticle( particle, false )
						ParticleManager:ReleaseParticleIndex( particle )
						particle = nil
						return
					else
						return 0.1
					end
				end)
				PersistentTimer_Add(timer3)
				table.insert(timers, timer3)

			end)
			PersistentTimer_Add(timer2)

			local timer4 = Timers:CreateTimer(duration, function()

				for _,timer in pairs(timers) do
					Timers:RemoveTimer(timer)
					timer = nil
				end

				for _,particle in pairs(particles) do
					if particle ~= nil then
						ParticleManager:DestroyParticle( particle, false )
						ParticleManager:ReleaseParticleIndex( particle )
						particle = nil
					end
				end

			end)
			PersistentTimer_Add(timer4)

		end

	end)
	PersistentTimer_Add(timer1)

end

function treasure_on_a_tree_green_mines:OnAbilityPhaseStart()
	local caster			= self:GetCaster()
	local playerID			= caster:GetPlayerOwnerID()
	local player			= PlayerResource:GetPlayer(playerID)

	return true
end

function treasure_on_a_tree_green_mines:GetManaCost(abilitylevel)
	return self.BaseClass.GetManaCost(self, abilitylevel)
end

function treasure_on_a_tree_green_mines:GetCooldown(abilitylevel)
	return self.BaseClass.GetCooldown(self, abilitylevel)
end