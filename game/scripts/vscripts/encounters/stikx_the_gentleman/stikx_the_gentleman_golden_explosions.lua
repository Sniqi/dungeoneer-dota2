stikx_the_gentleman_golden_explosions = class({})

function stikx_the_gentleman_golden_explosions:OnSpellStart()

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
	local damage                      = self:GetSpecialValueFor("damage")
	local delay_min                   = self:GetSpecialValueFor("delay_min")
	local delay_max                   = self:GetSpecialValueFor("delay_max")
	local count_min                   = self:GetSpecialValueFor("count_min")
	local count_max                   = self:GetSpecialValueFor("count_max")

	local count = RandomInt(count_min, count_max)
	local duration = 0
	local data = {}

	for _,hero in pairs( GetHeroesAliveEntities() ) do

		data[_] = {}
		data[_]["heroEntity"] = hero
		data[_]["delays"] = {}

		for i=1,count do

			local randomDelay = RandomFloat(delay_min, delay_max)
			table.insert(data[_]["delays"], randomDelay)

			if randomDelay > duration then
				duration = randomDelay
			end
		end

	end

	caster:AddNewModifier(caster, self, "casting_rooted_modifier", {duration=duration})
	DisableMotionControllers(caster, duration)

	-- Sound and Animation --
	local sound = {"monkey_king_monkey_ability1_07", "monkey_king_monkey_ability3_01",
					"monkey_king_monkey_ability3_05"}
	EmitAnnouncerSound( sound[RandomInt(1, #sound)] )
	
	StartAnimation(caster, {duration=duration, activity=ACT_DOTA_SPAWN, rate=0.5})


	for _,heroData in ipairs( data ) do

		local hero = heroData["heroEntity"]

		for i,delay in pairs( heroData["delays"] ) do

			local loc

			local timer = Timers:CreateTimer(delay-1.5, function()

				loc = RandomLocationMinDistance(hero:GetAbsOrigin(), AoERadius*RandomFloat(0.5, 1.0))

				EncounterGroundAOEWarningSticky(loc, AoERadius, delay-1.5+0.1)

			end)
			PersistentTimer_Add(timer)

			local timer = Timers:CreateTimer(delay, function()

				-- Sound --
				StartSoundEventFromPositionReliable("Hero_SkywrathMage.ArcaneBolt.Impact", loc)

				-- Particle --
				local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_brewmaster/brewmaster_primal_split_explosion_swirl_b.vpcf", PATTACH_CUSTOMORIGIN, nil)
				ParticleManager:SetParticleControl( particle, 0, loc )
				ParticleManager:ReleaseParticleIndex( particle )
				particle = nil

				-- DOTA_UNIT_TARGET_TEAM_FRIENDLY; DOTA_UNIT_TARGET_TEAM_ENEMY; DOTA_UNIT_TARGET_TEAM_BOTH
				local units	= FindUnitsInRadius(team, loc, nil, AoERadius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
				for _,victim in pairs(units) do

					-- Apply Damage --
					EncounterApplyDamage(victim, caster, self, damage, DAMAGE_TYPE_MAGICAL, DOTA_DAMAGE_FLAG_NONE)

				end

			end)
			PersistentTimer_Add(timer)

		end

	end

end

function stikx_the_gentleman_golden_explosions:OnAbilityPhaseStart()
	local caster			= self:GetCaster()
	local playerID			= caster:GetPlayerOwnerID()
	local player			= PlayerResource:GetPlayer(playerID)

	return true
end

function stikx_the_gentleman_golden_explosions:GetManaCost(abilitylevel)
	return self.BaseClass.GetManaCost(self, abilitylevel)
end

function stikx_the_gentleman_golden_explosions:GetCooldown(abilitylevel)
	return self.BaseClass.GetCooldown(self, abilitylevel)
end