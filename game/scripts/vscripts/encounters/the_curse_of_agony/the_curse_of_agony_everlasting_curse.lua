the_curse_of_agony_everlasting_curse = class({})

LinkLuaModifier( 'the_curse_of_agony_everlasting_curse_modifier', 'encounters/the_curse_of_agony/the_curse_of_agony_everlasting_curse_modifier', LUA_MODIFIER_MOTION_NONE )

function the_curse_of_agony_everlasting_curse:OnSpellStart()

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
	local delay                       = self:GetSpecialValueFor("delay")
	local curse_interval              = self:GetSpecialValueFor("curse_interval")

	-- Sound --
	local sound = {"bane_bane_kill_05", "bane_bane_kill_06",
					"bane_bane_kill_07", "bane_bane_kill_08"}
	EmitAnnouncerSound( sound[RandomInt(1, #sound)] )

	-- Modifier --
	local modifier = victim:AddNewModifier(caster, self, "the_curse_of_agony_everlasting_curse_modifier", {duration = (duration/3) - delay})
	PersistentModifier_Add(modifier)

	-- Modifier --
	local modifier = victim:AddNewModifier(caster, self, "the_curse_of_agony_everlasting_curse_modifier", {duration = (duration/2) - delay})
	PersistentModifier_Add(modifier)

	-- Modifier --
	local modifier = victim:AddNewModifier(caster, self, "the_curse_of_agony_everlasting_curse_modifier", {duration = (duration/1) - delay})
	PersistentModifier_Add(modifier)

	for i=1,duration/curse_interval do

		local location

		local timer2 = Timers:CreateTimer( (i*curse_interval) - delay, function()

			local modifier = caster:FindModifierByName("the_curse_of_agony_banished_modifier")
			if modifier == nil then

				location = victim:GetAbsOrigin()

				-- Sound --
				local sound = {"bane_bane_laugh_02", "bane_bane_laugh_03",
								"bane_bane_laugh_04", "bane_bane_laugh_05"}
				EmitAnnouncerSound( sound[RandomInt(1, #sound)] )

				EncounterGroundAOEWarningSticky(location, AoERadius, delay+duration)

			end

		end)
		PersistentTimer_Add(timer2)

		local timer3 = Timers:CreateTimer( i*curse_interval, function()

			local modifier = caster:FindModifierByName("the_curse_of_agony_banished_modifier")
			if modifier == nil then

				-- Particle --
				local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_enigma/enigma_blackhole_n.vpcf", PATTACH_CUSTOMORIGIN, nil)
				ParticleManager:SetParticleControl( particle, 0, location )
				ParticleManager:SetParticleControl( particle, 1, location )
				PersistentParticle_Add(particle)

				local timer1 = Timers:CreateTimer(0, function()

					-- DOTA_UNIT_TARGET_TEAM_FRIENDLY; DOTA_UNIT_TARGET_TEAM_ENEMY; DOTA_UNIT_TARGET_TEAM_BOTH
					local units	= FindUnitsInRadius(team, location, nil, AoERadius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
					for _,victim in pairs(units) do
						-- Apply Damage --
						EncounterApplyDamage(victim, caster, self, damage*damage_interval, DAMAGE_TYPE_MAGICAL, DOTA_DAMAGE_FLAG_NONE)
					end

					return damage_interval
				end)
				PersistentTimer_Add(timer1)

				local timer4 = Timers:CreateTimer(damage_duration, function()
					ParticleManager:DestroyParticle( particle, false )
					ParticleManager:ReleaseParticleIndex( particle )
					particle = nil

					Timers:RemoveTimer(timer1)
					timer1 = nil
				end)
				PersistentTimer_Add(timer4)

			end

		end)
		PersistentTimer_Add(timer3)

	end
	
end

function the_curse_of_agony_everlasting_curse:OnAbilityPhaseStart()
	local caster			= self:GetCaster()
	local playerID			= caster:GetPlayerOwnerID()
	local player			= PlayerResource:GetPlayer(playerID)

	return true
end

function the_curse_of_agony_everlasting_curse:GetManaCost(abilitylevel)
	return self.BaseClass.GetManaCost(self, abilitylevel)
end

function the_curse_of_agony_everlasting_curse:GetCooldown(abilitylevel)
	return self.BaseClass.GetCooldown(self, abilitylevel)
end