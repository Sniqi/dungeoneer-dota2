treasure_on_a_tree_conecentrated_nature = class({})

function treasure_on_a_tree_conecentrated_nature:OnSpellStart()

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
	local damage                      = self:GetSpecialValueFor("damage")
	local delay                       = self:GetSpecialValueFor("delay")
	local phase_two_percentage        = self:GetSpecialValueFor("phase_two_percentage")
	local phase_two_laser_count       = self:GetSpecialValueFor("phase_two_laser_count")

	caster:AddNewModifier(caster, self, "casting_rooted_modifier", {duration=delay})
	
	StartAnimation(caster, {duration=delay, activity=ACT_DOTA_RUN, rate=0.40})

	TurnToLoc(caster, victim_loc, delay)

	EncounterGroundAOEWarningSticky(victim_loc, AoERadius, delay+0.1)

	-- PHASE 2 --
	local locs = {}
	if caster:GetHealthPercent() < phase_two_percentage then

		for i=1,phase_two_laser_count do
			local location = RandomLocationMinDistance( victim_loc, AoERadius*RandomFloat(1.5, 2.5))
			table.insert(locs, location)

			EncounterGroundAOEWarningSticky(location, AoERadius, delay+0.5)
		end
	end

	local timer = Timers:CreateTimer(delay, function()

		-- Sound and Animation --
		local sound = {"treant_treant_pain_01", "treant_treant_pain_02",
						"treant_treant_pain_03", "treant_treant_pain_13"}
		EmitAnnouncerSound( sound[RandomInt(1, #sound)] )
	
		StartSoundEventFromPositionReliable("Hero_Pugna.NetherWard", victim_loc)
		
		StartAnimation(caster, {duration=delay, activity=ACT_DOTA_SPAWN, rate=1.75})

		local particle = ParticleManager:CreateParticle("particles/econ/items/pugna/pugna_ward_ti5/pugna_ward_attack_medium_ti_5.vpcf", PATTACH_ABSORIGIN, caster)
		ParticleManager:SetParticleControlEnt( particle, 0, caster, PATTACH_POINT_FOLLOW, "attach_hitloc", caster:GetAttachmentOrigin(caster:ScriptLookupAttachment("attach_hitloc")), true)
		ParticleManager:SetParticleControl( particle, 1, victim_loc )
		ParticleManager:ReleaseParticleIndex( particle )
		particle = nil

		-- DOTA_UNIT_TARGET_TEAM_FRIENDLY; DOTA_UNIT_TARGET_TEAM_ENEMY; DOTA_UNIT_TARGET_TEAM_BOTH
		local units	= FindUnitsInRadius(team, victim_loc, nil, AoERadius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
		for _,victim in pairs(units) do

			-- Apply Damage --
			EncounterApplyDamage(victim, caster, self, damage, DAMAGE_TYPE_MAGICAL, DOTA_DAMAGE_FLAG_NONE)

		end

		-- PHASE 2 --
		if caster:GetHealthPercent() < phase_two_percentage then
			for _,location in pairs(locs) do

				local timer = Timers:CreateTimer(0.25+RandomFloat(0.00, 1.00), function()

					StartSoundEventFromPositionReliable("Hero_Pugna.NetherWard", location)

					local particle = ParticleManager:CreateParticle("particles/econ/items/pugna/pugna_ward_ti5/pugna_ward_attack_medium_ti_5.vpcf", PATTACH_ABSORIGIN, caster)
					ParticleManager:SetParticleControlEnt( particle, 0, caster, PATTACH_POINT_FOLLOW, "attach_hitloc", caster:GetAttachmentOrigin(caster:ScriptLookupAttachment("attach_hitloc")), true)
					ParticleManager:SetParticleControl( particle, 1, location )
					ParticleManager:ReleaseParticleIndex( particle )
					particle = nil

					-- DOTA_UNIT_TARGET_TEAM_FRIENDLY; DOTA_UNIT_TARGET_TEAM_ENEMY; DOTA_UNIT_TARGET_TEAM_BOTH
					local units	= FindUnitsInRadius(team, location, nil, AoERadius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
					for _,victim in pairs(units) do

						-- Apply Damage --
						EncounterApplyDamage(victim, caster, self, damage, DAMAGE_TYPE_MAGICAL, DOTA_DAMAGE_FLAG_NONE)

					end

				end)
				PersistentTimer_Add(timer)

			end
		end

	end)
	PersistentTimer_Add(timer)

end

function treasure_on_a_tree_conecentrated_nature:OnAbilityPhaseStart()
	local caster			= self:GetCaster()
	local playerID			= caster:GetPlayerOwnerID()
	local player			= PlayerResource:GetPlayer(playerID)

	return true
end

function treasure_on_a_tree_conecentrated_nature:GetManaCost(abilitylevel)
	return self.BaseClass.GetManaCost(self, abilitylevel)
end

function treasure_on_a_tree_conecentrated_nature:GetCooldown(abilitylevel)
	return self.BaseClass.GetCooldown(self, abilitylevel)
end