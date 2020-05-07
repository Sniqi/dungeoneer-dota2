wind_harpy_tornado = class({})

LinkLuaModifier( 'wind_harpy_tornado_checker_modifier', 'encounters/wind_harpy/wind_harpy_tornado_checker_modifier', LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( 'wind_harpy_tornado_damage_modifier', 'encounters/wind_harpy/wind_harpy_tornado_damage_modifier', LUA_MODIFIER_MOTION_NONE )

function wind_harpy_tornado:OnSpellStart()

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
	local victim		= caster
	local victim_loc	= victim:GetAbsOrigin()
	
	--- Get Special Values ---
	local AoERadius                   = self:GetSpecialValueFor("AoERadius")
	local damage                      = self:GetSpecialValueFor("damage")
	local damage_interval             = self:GetSpecialValueFor("damage_interval")
	local move_speed                  = self:GetSpecialValueFor("move_speed")
	local phase_two                   = self:GetSpecialValueFor("phase_two")
	local phase_two_move_speed        = self:GetSpecialValueFor("phase_two_move_speed")
	local phase_two_radius_percentage = self:GetSpecialValueFor("phase_two_radius_percentage")
	local phase_three                 = self:GetSpecialValueFor("phase_three")
	local phase_three_move_speed      = self:GetSpecialValueFor("phase_three_move_speed")
	local phase_three_radius_percentage= self:GetSpecialValueFor("phase_three_radius_percentage")

	caster:AddNewModifier(caster, self, "casting_rooted_modifier", {duration=delay+duration})
	DisableMotionControllers(caster, delay+duration)

	-- Sound and Animation --
	local sound = {"xxx", "xxx",
					"xxx", "xxx"}
	EmitAnnouncerSound( sound[RandomInt(1, #sound)] )
	
	StartAnimation(caster, {duration=delay, activity=ACT_DOTA_SPAWN, rate=0.75})

	
	local timer = Timers:CreateTimer(0.1, function()

	end)
	PersistentTimer_Add(timer)
	
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
		victim:AddNewModifier(caster, self, "wind_harpy_tornado_checker_modifier", {duration = duration})
		-- Modifier --
		victim:AddNewModifier(caster, self, "wind_harpy_tornado_damage_modifier", {duration = duration})
	

		-- Apply Damage --
		EncounterApplyDamage(victim, caster, self, damage, DAMAGE_TYPE_MAGICAL, DOTA_DAMAGE_FLAG_NONE)
	
	
	
end

function wind_harpy_tornado:OnAbilityPhaseStart()
	local caster			= self:GetCaster()
	local playerID			= caster:GetPlayerOwnerID()
	local player			= PlayerResource:GetPlayer(playerID)

	return true
end

function wind_harpy_tornado:GetManaCost(abilitylevel)
	return self.BaseClass.GetManaCost(self, abilitylevel)
end

function wind_harpy_tornado:GetCooldown(abilitylevel)
	return self.BaseClass.GetCooldown(self, abilitylevel)
end