deathspeaker_xunra_soulcatcher = class({})

LinkLuaModifier( 'deathspeaker_xunra_soulcatcher_checker_modifier', 'encounters/deathspeaker_xunra/deathspeaker_xunra_soulcatcher_checker_modifier', LUA_MODIFIER_MOTION_NONE )

function deathspeaker_xunra_soulcatcher:OnSpellStart()


	--- Get Caster, Victim, Player, Point ---
	local caster		= self:GetCaster()
	local caster_loc	= caster:GetAbsOrigin()
	local playerID		= caster:GetPlayerOwnerID()
	local player		= PlayerResource:GetPlayer(playerID)
	local team			= caster:GetTeamNumber()
	
	--- Get Special Values ---
	local duration                    = self:GetSpecialValueFor("duration")
	local damage                      = self:GetSpecialValueFor("damage")
	local delay                       = self:GetSpecialValueFor("delay")
	local link_break_range            = self:GetSpecialValueFor("link_break_range")
	local phase_two_percentage        = self:GetSpecialValueFor("phase_two_percentage")
	local phase_two_damage_percentage = self:GetSpecialValueFor("phase_two_damage_percentage")

	caster:AddNewModifier(caster, self, "casting_rooted_modifier", {duration=delay+duration})
	DisableMotionControllers(caster, delay+duration)

	-- Sound and Animation --
	local sound = {"necrolyte_necr_kill_01", "necrolyte_necr_kill_04",
					"necrolyte_necr_kill_09", "necrolyte_necr_kill_10"}
	EmitAnnouncerSound( sound[RandomInt(1, #sound)] )
	
	StartAnimation(caster, {duration=delay+duration, activity=ACT_DOTA_GENERIC_CHANNEL_1, rate=1.0})

	

	local units	= GetHeroesAliveEntities_Active()
	for _,victim in pairs(units) do

		EncounterUnitWarning(victim, 1.0, true, "red")
	
		-- Create Particle --
		local particle = ParticleManager:CreateParticle("particles/encounter/structures_of_xunra/structures_of_xunra_linked_obelisks_beam_1.vpcf", PATTACH_POINT_FOLLOW, caster)
		ParticleManager:SetParticleControlEnt( particle, 0, caster, PATTACH_POINT_FOLLOW, "attach_hitloc", caster:GetAttachmentOrigin(caster:ScriptLookupAttachment("attach_hitloc")), true)
		ParticleManager:SetParticleControlEnt( particle, 1, victim, PATTACH_POINT_FOLLOW, "attach_hitloc", victim:GetAttachmentOrigin(victim:ScriptLookupAttachment("attach_attack1")), true)
		ParticleManager:SetParticleControl( particle, 10, Vector(1,0,0) )
		ParticleManager:SetParticleControl( particle, 11, Vector(1,0,0) )
		PersistentParticle_Add(particle)

		-- Modifier --
		victim:AddNewModifier(caster, self, "deathspeaker_xunra_soulcatcher_checker_modifier", {duration = duration})
		
		local interval = 0.1
		local count = interval

		local timer = Timers:CreateTimer(delay, function()

				
				if victim:HasModifier("deathspeaker_xunra_soulcatcher_checker_modifier") then

					local periodicDamage = damage

					if count > 0 and count <= 1  then
						periodicDamage = ( periodicDamage / 12 ) * interval
					elseif count > 1 and count <= 2  then
						periodicDamage = ( periodicDamage / 10 ) * interval
					elseif count > 2 and count <= 3  then
						periodicDamage = ( periodicDamage / 7 ) * interval
					elseif count > 3 and count <= 4  then
						periodicDamage = ( periodicDamage / 5 ) * interval
					elseif count > 4 and count <= 5  then
						periodicDamage = ( periodicDamage / 2 ) * interval
					elseif count > 5 then
						return
					end

					-- PHASE 2 --
					if caster:GetHealthPercent() < phase_two_percentage then
						periodicDamage = ( phase_two_damage_percentage / 5 ) * interval
					end

					-- Apply Damage --
					EncounterApplyDamage(victim, caster, self, periodicDamage, DAMAGE_TYPE_MAGICAL, DOTA_DAMAGE_FLAG_NONE)

				else
					ParticleManager:DestroyParticle( particle, false )
					ParticleManager:ReleaseParticleIndex( particle )
					particle = nil

					return
				end

				count = count + interval
			return interval
		end)
		PersistentTimer_Add(timer)

	end





	--[[

	
	
	
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
	victim:AddNewModifier(caster, self, "deathspeaker_xunra_soulcatcher_checker_modifier", {duration = duration})
	
]]
	
	
	
end

function deathspeaker_xunra_soulcatcher:OnAbilityPhaseStart()
	local caster			= self:GetCaster()
	local playerID			= caster:GetPlayerOwnerID()
	local player			= PlayerResource:GetPlayer(playerID)

	return true
end

function deathspeaker_xunra_soulcatcher:GetManaCost(abilitylevel)
	return self.BaseClass.GetManaCost(self, abilitylevel)
end

function deathspeaker_xunra_soulcatcher:GetCooldown(abilitylevel)
	return self.BaseClass.GetCooldown(self, abilitylevel)
end