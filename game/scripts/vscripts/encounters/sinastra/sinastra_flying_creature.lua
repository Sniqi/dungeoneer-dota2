sinastra_flying_creature = class({})

LinkLuaModifier( 'sinastra_flying_creature_modifier', 'encounters/sinastra/sinastra_flying_creature_modifier', LUA_MODIFIER_MOTION_NONE )

function sinastra_flying_creature:OnSpellStart()

	if self.casted then return end
	self.casted = true

	--- Get Caster, Victim, Player, Point ---
	local caster		= self:GetCaster()
	local caster_loc	= caster:GetAbsOrigin()
	local playerID		= caster:GetPlayerOwnerID()
	local player		= PlayerResource:GetPlayer(playerID)
	local team			= caster:GetTeamNumber()
	
	--- Get Special Values ---
	local AoERadius                   = self:GetSpecialValueFor("AoERadius")
	local phase_two_percentage        = self:GetSpecialValueFor("phase_two_percentage")

	local modifier_invulnerable = caster:AddNewModifier(caster, self, "sinastra_flying_creature_modifier", {})
	local modifier_phased = caster:AddNewModifier(caster, self, "modifier_phased", {})
	local modifier_flying = caster:AddNewModifier(caster, self, "modifier_flying", {})

	caster:Stop()

	local loc = GetSpecificBorderPoint("point_center")

	local unit = CreateUnitByName("sinastra_turret", loc, true, nil, nil, DOTA_TEAM_GOODGUYS)
	PersistentUnit_Add(unit)

	unit:AddNewModifier(unit, self, "modifier_invulnerable", {})
	unit:AddNewModifier(unit, self, "modifier_phased", {})
	unit:AddNewModifier(unit, self, "modifier_rooted", {})

	unit:Stop()

	local ground_warning = EncounterGroundAOEWarningSticky(loc, AoERadius, nil, Vector(0,255,0))

	local timer1 = Timers:CreateTimer(0.5, function()

		-- DOTA_UNIT_TARGET_TEAM_FRIENDLY; DOTA_UNIT_TARGET_TEAM_ENEMY; DOTA_UNIT_TARGET_TEAM_BOTH
		local units	= FindUnitsInRadius(DOTA_TEAM_GOODGUYS, loc, nil, AoERadius, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_CLOSEST, false)
		
		if units[1] ~= nil then
			unit:SetControllableByPlayer( units[1]:GetPlayerOwnerID(), false)
		else
			unit:SetControllableByPlayer( -1, false)
		end

		return 0.5
	end)
	PersistentTimer_Add(timer1)

	local timer2 = Timers:CreateTimer(0.5, function()

		if caster:GetHealthPercent() <= phase_two_percentage+1 then

			Timers:RemoveTimer(timer1)
			timer1 = nil

			UTIL_Remove(unit)

			ParticleManager:DestroyParticle( ground_warning, false )
			ParticleManager:ReleaseParticleIndex( ground_warning )
			ground_warning = nil

			-- Modifier --
			modifier_invulnerable:Destroy()
			modifier_phased:Destroy()
			modifier_flying:Destroy()

			-- Sound and Animation --
			local sound = {"winter_wyvern_winwyv_death_09"}
			EmitAnnouncerSound( sound[RandomInt(1, #sound)] )

			AddAnimationTranslate(caster, "injured")
			
			StartAnimation(caster, {duration=5.0, activity=ACT_DOTA_TELEPORT_END, rate=0.5})

			return
		end

		return 0.5
	end)
	PersistentTimer_Add(timer2)

end

function sinastra_flying_creature:OnAbilityPhaseStart()
	local caster			= self:GetCaster()
	local playerID			= caster:GetPlayerOwnerID()
	local player			= PlayerResource:GetPlayer(playerID)

	return true
end

function sinastra_flying_creature:GetManaCost(abilitylevel)
	return self.BaseClass.GetManaCost(self, abilitylevel)
end

function sinastra_flying_creature:GetCooldown(abilitylevel)
	return self.BaseClass.GetCooldown(self, abilitylevel)
end