deathspeaker_xunra_runic_penalty = class({})

LinkLuaModifier( 'deathspeaker_xunra_rune_of_roots_modifier', 'encounters/deathspeaker_xunra/deathspeaker_xunra_rune_of_roots_modifier', LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( 'deathspeaker_xunra_rune_of_roots_penalty_modifier', 'encounters/deathspeaker_xunra/deathspeaker_xunra_rune_of_roots_penalty_modifier', LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( 'deathspeaker_xunra_rune_of_haste_modifier', 'encounters/deathspeaker_xunra/deathspeaker_xunra_rune_of_haste_modifier', LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( 'deathspeaker_xunra_rune_of_solitude_modifier', 'encounters/deathspeaker_xunra/deathspeaker_xunra_rune_of_solitude_modifier', LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( 'deathspeaker_xunra_runic_penalty_modifier', 'encounters/deathspeaker_xunra/deathspeaker_xunra_runic_penalty_modifier', LUA_MODIFIER_MOTION_NONE )

function deathspeaker_xunra_runic_penalty:OnSpellStart()

	--- Get Caster, Victim, Player, Point ---
	local caster		= self:GetCaster()
	local caster_loc	= caster:GetAbsOrigin()
	local playerID		= caster:GetPlayerOwnerID()
	local player		= PlayerResource:GetPlayer(playerID)
	local team			= caster:GetTeamNumber()
	
	--- Get Special Values ---
	local duration                    = self:GetSpecialValueFor("duration")
	local delay                       = self:GetSpecialValueFor("delay")
	local roots_damage                = self:GetSpecialValueFor("roots_damage")
	local roots_move_speed_percentage = self:GetSpecialValueFor("roots_move_speed_percentage")
	local roots_duration              = self:GetSpecialValueFor("roots_duration")
	local haste_damage                = self:GetSpecialValueFor("haste_damage")
	local haste_knockback             = self:GetSpecialValueFor("haste_knockback")
	local solitude_damage             = self:GetSpecialValueFor("solitude_damage")
	local solitude_aoe                = self:GetSpecialValueFor("solitude_aoe")

	caster:AddNewModifier(caster, self, "casting_rooted_modifier", {duration=delay+duration})
	DisableMotionControllers(caster, delay+duration)

	-- Sound and Animation --
	local sound = {"necrolyte_necr_deny_08", "necrolyte_necr_lasthit_02",
					"necrolyte_necr_ability_sadist_01", "necrolyte_necr_ability_sadist_02"}
	EmitAnnouncerSound( sound[RandomInt(1, #sound)] )
	
	StartAnimation(caster, {duration=delay+duration, activity=ACT_DOTA_GENERIC_CHANNEL_1, rate=1.0})

	local units	= GetHeroesAliveEntities_Active()
	for _,victim in pairs(units) do

		-- Create Particle --
		local particle = ParticleManager:CreateParticle("particles/econ/items/dark_willow/dark_willow_ti8_immortal_head/dw_ti8_immortal_cursed_crown_start.vpcf", PATTACH_OVERHEAD_FOLLOW, victim)
		ParticleManager:SetParticleControl( particle, 0, victim:GetAbsOrigin() )
		ParticleManager:SetParticleControl( particle, 4, Vector(0,1,0) )
		PersistentParticle_Add(particle)

		-- Sound --
		StartSoundEventReliable("Hero_DarkWillow.Ley.Cast", victim)
		StartSoundEventReliable("Hero_DarkWillow.Ley.Target", victim)

		-- Modifier --
		local modifier = victim:AddNewModifier(caster, self, "deathspeaker_xunra_runic_penalty_modifier", {duration = delay})
		modifier:SetStackCount(5)

		local timer1 = Timers:CreateTimer(0.0, function()

			-- Sound --
			StartSoundEventReliable("Hero_DarkWillow.Ley.Count", victim)

			modifier:DecrementStackCount()

			return 1.0
		end)
		PersistentTimer_Add(timer1)

		local timer = Timers:CreateTimer(delay-0.1, function()

			Timers:RemoveTimer(timer1)
			timer1 = nil
			
		end)
		PersistentTimer_Add(timer)

		local rune = RandomInt(1, 3)

		if rune == 1 then

			-- Modifier --
			victim:AddNewModifier(caster, self, "deathspeaker_xunra_rune_of_roots_modifier", {duration = delay+duration})

			EncounterGroundAOEWarningStickyOnUnit(victim, 100, delay+duration, Vector(88,180,255))

		elseif rune == 2 then

			-- Modifier --
			victim:AddNewModifier(caster, self, "deathspeaker_xunra_rune_of_haste_modifier", {duration = delay+duration})

			EncounterGroundAOEWarningStickyOnUnit(victim, 100, delay+duration, Vector(255,255,0))

		elseif rune == 3 then

			-- Modifier --
			victim:AddNewModifier(caster, self, "deathspeaker_xunra_rune_of_solitude_modifier", {duration = delay+duration})

			EncounterGroundAOEWarningStickyOnUnit(victim, solitude_aoe, delay+duration, Vector(227,87,255))

		end

		local timer = Timers:CreateTimer(delay, function()

			ParticleManager:DestroyParticle( particle, false )
			ParticleManager:ReleaseParticleIndex( particle )
			particle = nil

			-- Sound --
			StartSoundEventReliable("Hero_DarkWillow.Ley.Stun", victim)

		end)
		PersistentTimer_Add(timer)

	end



--[[
	

	
	EncounterGroundAOEWarningSticky(loc, AoERadius, delay+0.1)
	
	-- Particle -- PATTACH_ABSORIGIN-PATTACH_ABSORIGIN_FOLLOW-PATTACH_CUSTOMORIGIN
	local particle = ParticleManager:CreateParticle("xxx", PATTACH_ABSORIGIN, caster)
	local particle = ParticleManager:CreateParticle("xxx", PATTACH_CUSTOMORIGIN, nil)
	ParticleManager:SetParticleControl( particle, 0, loc )
	
	ParticleManager:SetParticleControlEnt( particle, 3, caster, PATTACH_POINT_FOLLOW, "attach_hitloc", caster:GetAttachmentOrigin(caster:ScriptLookupAttachment("attach_hitloc")), true)
	
	PersistentParticle_Add(particle)
	
	ParticleManager:ReleaseParticleIndex( particle )
	particle = nil

	local timer = Timers:CreateTimer(duration, function()
			ParticleManager:DestroyParticle( particle, false )
			ParticleManager:ReleaseParticleIndex( particle )
			particle = nil
	end)
	PersistentTimer_Add(timer)
	
	local unit = CreateUnitByName("xxx", loc, true, nil, nil, DOTA_TEAM_BADGUYS)
	PersistentUnit_Add(unit)

	unit:AddNewModifier(caster, self, "modifier_invulnerable", {})
	unit:AddNewModifier(caster, self, "modifier_unselectable", {})
	unit:AddNewModifier(caster, self, "modifier_phased", {})

	unit:Stop()
	unit:MoveToPosition(loc)
	
	-- Sound --
	StartSoundEventReliable("xxx", victim)
	StartSoundEventFromPositionReliable("xxx", loc)
	
	-- DOTA_UNIT_TARGET_TEAM_FRIENDLY; DOTA_UNIT_TARGET_TEAM_ENEMY; DOTA_UNIT_TARGET_TEAM_BOTH
	local units	= FindUnitsInRadius(team, loc, nil, AoERadius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
	for _,victim in pairs(units) do
	
	end
	
	TurnToLoc(caster, victim_loc, 1.5)
	RandomLocationMinDistance( GetSpecificBorderPoint("point_center"), 750*RandomFloat(0.25, 1.0))
	
	-- Modifier --
	victim:AddNewModifier(caster, self, "deathspeaker_xunra_rune_of_roots_modifier", {duration = duration})
	-- Modifier --
	victim:AddNewModifier(caster, self, "deathspeaker_xunra_rune_of_roots_penalty_modifier", {duration = duration})
	-- Modifier --
	victim:AddNewModifier(caster, self, "deathspeaker_xunra_rune_of_haste_modifier", {duration = duration})
	-- Modifier --
	victim:AddNewModifier(caster, self, "deathspeaker_xunra_rune_of_solitude_modifier", {duration = duration})
	
	
	]]
end

function deathspeaker_xunra_runic_penalty:OnAbilityPhaseStart()
	local caster			= self:GetCaster()
	local playerID			= caster:GetPlayerOwnerID()
	local player			= PlayerResource:GetPlayer(playerID)

	return true
end

function deathspeaker_xunra_runic_penalty:GetManaCost(abilitylevel)
	return self.BaseClass.GetManaCost(self, abilitylevel)
end

function deathspeaker_xunra_runic_penalty:GetCooldown(abilitylevel)
	return self.BaseClass.GetCooldown(self, abilitylevel)
end