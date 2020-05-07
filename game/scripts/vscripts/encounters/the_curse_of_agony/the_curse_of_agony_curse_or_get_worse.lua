the_curse_of_agony_curse_or_get_worse = class({})

LinkLuaModifier( 'the_curse_of_agony_curse_or_get_worse_buff_modifier', 'encounters/the_curse_of_agony/the_curse_of_agony_curse_or_get_worse_buff_modifier', LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( 'the_curse_of_agony_curse_or_get_worse_debuff_modifier', 'encounters/the_curse_of_agony/the_curse_of_agony_curse_or_get_worse_debuff_modifier', LUA_MODIFIER_MOTION_NONE )

function the_curse_of_agony_curse_or_get_worse:OnSpellStart()

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
	local delay                       = self:GetSpecialValueFor("delay")
	local curse_duration              = self:GetSpecialValueFor("curse_duration")
	local buff_attack_damage_percentage= self:GetSpecialValueFor("buff_attack_damage_percentage")
	local buff_spell_amplify_percentage= self:GetSpecialValueFor("buff_spell_amplify_percentage")
	local buff_base_attack_time_constant= self:GetSpecialValueFor("buff_base_attack_time_constant")
	local buff_move_speed_constant    = self:GetSpecialValueFor("buff_move_speed_constant")
	local buff_incoming_damage_percentage= self:GetSpecialValueFor("buff_incoming_damage_percentage")
	local debuff_attack_damage_percentage= self:GetSpecialValueFor("debuff_attack_damage_percentage")
	local debuff_spell_amplify_percentage= self:GetSpecialValueFor("debuff_spell_amplify_percentage")
	local debuff_incoming_damage_percentage= self:GetSpecialValueFor("debuff_incoming_damage_percentage")

	self.picked_up = false

	local location = GetRandomPointWithinArena(750)

	-- Sound --
	local sound = {"bane_bane_lasthit_04", "bane_bane_lasthit_06",
					"bane_bane_lasthit_09", "bane_bane_lasthit_11"}
	EmitAnnouncerSound( sound[RandomInt(1, #sound)] )

	EncounterGroundAOEWarningSticky(location, AoERadius, delay+1, Vector(0,255,0))

	-- Particle --
	local particle = ParticleManager:CreateParticle("particles/econ/items/broodmother/bm_lycosidaes/bm_lycosidaes_spiderlings_debuff.vpcf", PATTACH_CUSTOMORIGIN, nil)
	ParticleManager:SetParticleControl( particle, 0, location )
	PersistentParticle_Add(particle)

	-- check for pick up
	local timer1 = Timers:CreateTimer(delay, function()

		-- DOTA_UNIT_TARGET_TEAM_FRIENDLY; DOTA_UNIT_TARGET_TEAM_ENEMY; DOTA_UNIT_TARGET_TEAM_BOTH
		local units	= FindUnitsInRadius(team, location, nil, AoERadius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
		if units[1] ~= nil then
			self.picked_up = true

			for _,victim in pairs( GetHeroesAliveEntities() ) do
				-- Modifier --
				local modifier = victim:AddNewModifier(caster, self, "the_curse_of_agony_curse_or_get_worse_buff_modifier", {duration = curse_duration})
				PersistentModifier_Add(modifier)
			end

			-- Particle --
			ParticleManager:DestroyParticle( particle, false )
			ParticleManager:ReleaseParticleIndex( particle )
			particle = nil

			return
		end

		return 0.1
	end)
	PersistentTimer_Add(timer1)

	-- not picked up --
	local timer2 = Timers:CreateTimer(duration, function()

		if not self.picked_up then

			Timers:RemoveTimer(timer1)
			timer1 = nil

			-- Particle --
			ParticleManager:DestroyParticle( particle, false )
			ParticleManager:ReleaseParticleIndex( particle )
			particle = nil

			for _,victim in pairs( GetHeroesAliveEntities() ) do
				-- Modifier --
				local modifier = victim:AddNewModifier(caster, self, "the_curse_of_agony_curse_or_get_worse_debuff_modifier", {duration = curse_duration})
				PersistentModifier_Add(modifier)
			end

		end
	end)
	PersistentTimer_Add(timer2)

end

function the_curse_of_agony_curse_or_get_worse:OnAbilityPhaseStart()
	local caster			= self:GetCaster()
	local playerID			= caster:GetPlayerOwnerID()
	local player			= PlayerResource:GetPlayer(playerID)

	return true
end

function the_curse_of_agony_curse_or_get_worse:GetManaCost(abilitylevel)
	return self.BaseClass.GetManaCost(self, abilitylevel)
end

function the_curse_of_agony_curse_or_get_worse:GetCooldown(abilitylevel)
	return self.BaseClass.GetCooldown(self, abilitylevel)
end