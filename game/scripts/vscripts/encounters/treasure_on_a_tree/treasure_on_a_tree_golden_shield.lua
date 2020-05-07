treasure_on_a_tree_golden_shield = class({})

function treasure_on_a_tree_golden_shield:OnSpellStart()

	--- Get Caster, Victim, Player, Point ---
	local caster		= self:GetCaster()
	local caster_loc	= caster:GetAbsOrigin()
	local playerID		= caster:GetPlayerOwnerID()
	local player		= PlayerResource:GetPlayer(playerID)
	local team			= caster:GetTeamNumber()
	local victim		= caster
	local victim_loc	= victim:GetAbsOrigin()
	
	--- Get Special Values ---
	local duration                    = self:GetSpecialValueFor("duration")
	local delay                       = self:GetSpecialValueFor("delay")
	local damage_reduction_percentage = self:GetSpecialValueFor("damage_reduction_percentage")

	caster:AddNewModifier(caster, self, "casting_rooted_modifier", {duration=delay})

	local loc = RandomLocationMinDistance( caster:GetAbsOrigin(), 100)

	StartAnimation(caster, {duration=delay, activity=ACT_DOTA_RUN, rate=0.40})

	TurnToLoc(caster, loc, delay)

	local timer = Timers:CreateTimer(delay, function()

		loc = caster:GetAbsOrigin() + ( caster:GetForwardVector() * 150 )

		caster.golden_shield_hero_angle = caster:GetAnglesAsVector().y

		-- Sound and Animation --
		local sound = {"treant_treant_laugh_01", "treant_treant_laugh_02",
						"treant_treant_laugh_03", "treant_treant_laugh_13"}
		EmitAnnouncerSound( sound[RandomInt(1, #sound)] )

		StartAnimation(caster, {duration=delay, activity=ACT_DOTA_SPAWN, rate=0.75})

		StartSoundEventFromPositionReliable("Hero_Lich.FrostArmor", loc)

		-- Particle -- PATTACH_ABSORIGIN-PATTACH_ABSORIGIN_FOLLOW-PATTACH_CUSTOMORIGIN
		local particle = ParticleManager:CreateParticle("particles/encounter/treasure_on_a_tree/treasure_on_a_tree_golden_shield.vpcf", PATTACH_CUSTOMORIGIN, nil)
		ParticleManager:SetParticleControl( particle, 2, loc )
		ParticleManager:SetParticleControlOrientation( particle, 2, caster:GetForwardVector(), caster:GetForwardVector(), Vector(0,0,0) )
		PersistentParticle_Add(particle)

		local timer1 = Timers:CreateTimer(duration, function()

			caster.golden_shield_hero_angle = nil

			ParticleManager:DestroyParticle( particle, false )
			ParticleManager:ReleaseParticleIndex( particle )
			particle = nil

		end)
		PersistentTimer_Add(timer1)

	end)
	PersistentTimer_Add(timer)

end

function treasure_on_a_tree_golden_shield:OnAbilityPhaseStart()
	local caster			= self:GetCaster()
	local playerID			= caster:GetPlayerOwnerID()
	local player			= PlayerResource:GetPlayer(playerID)

	return true
end

function treasure_on_a_tree_golden_shield:GetManaCost(abilitylevel)
	return self.BaseClass.GetManaCost(self, abilitylevel)
end

function treasure_on_a_tree_golden_shield:GetCooldown(abilitylevel)
	return self.BaseClass.GetCooldown(self, abilitylevel)
end