air_ship_high_tides = class({})

function air_ship_high_tides:OnSpellStart()

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
	local knockback                   = self:GetSpecialValueFor("knockback")

	local deltaX = GetSpecificBorderPoint("point_bottom_right").x - GetSpecificBorderPoint("point_bottom_left").x
	local offsetX = RandomFloat(0.0, 1.0) * deltaX
	local loc = GetSpecificBorderPoint("point_bottom_left") + Vector(offsetX,0,0)

	caster:AddNewModifier(caster, self, "casting_rooted_modifier", {duration=delay})
	DisableMotionControllers(caster, delay)

	caster:Stop()

	EncounterUnitWarning(caster, 1.0, true, "red") --nil=yellow, "red", "orange", "green"

	local unit = CreateUnitByName("dummy", loc, true, nil, nil, DOTA_TEAM_BADGUYS)
	PersistentUnit_Add(unit)

	unit:AddNewModifier(caster, self, "modifier_invulnerable", {})
	unit:AddNewModifier(caster, self, "modifier_unselectable", {})
	unit:AddNewModifier(caster, self, "modifier_phased", {})

	unit:Stop()

	-- Particle -- PATTACH_ABSORIGIN-PATTACH_ABSORIGIN_FOLLOW-PATTACH_CUSTOMORIGIN
	local particle = ParticleManager:CreateParticle("particles/encounter/air_ship/air_ship_high_tides.vpcf", PATTACH_ABSORIGIN_FOLLOW, unit)
	ParticleManager:SetParticleControl( particle, 3, unit:GetAbsOrigin() )
	--ParticleManager:SetParticleControlEnt( particle, 0, unit, PATTACH_POINT_FOLLOW, "attach_hitloc", unit:GetAttachmentOrigin(unit:ScriptLookupAttachment("attach_hitloc")), true)
	PersistentParticle_Add(particle)

	local particleWarning = EncounterGroundAOEWarningStickyOnUnit(unit, AoERadius, nil, nil)

	local timer1 = Timers:CreateTimer(delay, function()
		unit:MoveToNPC(caster)
	end)
	PersistentTimer_Add(timer1)

	--Sound
	local timer2 = Timers:CreateTimer(0, function()

			-- Sound --
			StartSoundEventReliable("Ability.pre.Torrent", unit)

			return 1.75
	end)
	PersistentTimer_Add(timer2)

	local timer3 = Timers:CreateTimer(0, function()

			-- DOTA_UNIT_TARGET_TEAM_FRIENDLY; DOTA_UNIT_TARGET_TEAM_ENEMY; DOTA_UNIT_TARGET_TEAM_BOTH
			local units	= FindUnitsInRadius(team, unit:GetAbsOrigin(), nil, AoERadius, DOTA_UNIT_TARGET_TEAM_BOTH, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
			for _,victim in pairs(units) do

				--Check if goal reached
				if victim:GetUnitName() == "npc_dota_hero_air_ship" then

					Timers:RemoveTimer(timer1)
					timer1 = nil

					Timers:RemoveTimer(timer2)
					timer2 = nil

					ParticleManager:DestroyParticle( particle, false )
					ParticleManager:ReleaseParticleIndex( particle )
					particle = nil

					ParticleManager:DestroyParticle( particleWarning, false )
					ParticleManager:ReleaseParticleIndex( particleWarning )
					particleWarning = nil

					unit:RemoveSelf()
					unit = nil

					return
				end

				if victim:GetTeamNumber() == DOTA_UNIT_TARGET_TEAM_ENEMY then

					-- Sound --
					StartSoundEventReliable("Ability.GushImpact", victim)

					-- Apply Damage --
					EncounterApplyDamage(victim, caster, self, damage, DAMAGE_TYPE_MAGICAL, DOTA_DAMAGE_FLAG_NONE)

					victim:SetRebounceFrames(12)
					victim:SetPhysicsVelocityMax(knockback)
					victim:AddPhysicsVelocity( ( victim:GetAbsOrigin() - unit:GetAbsOrigin() ):Normalized() * knockback )
					victim:OnBounce(function(victim, normal)
						EncounterApplyDamage(victim, caster, self, damage / 2, DAMAGE_TYPE_PHYSICAL, DOTA_DAMAGE_FLAG_NONE)
					end)
					
				end


			end

			return 0.5
	end)
	PersistentTimer_Add(timer3)

end

function air_ship_high_tides:OnAbilityPhaseStart()
	local caster			= self:GetCaster()
	local playerID			= caster:GetPlayerOwnerID()
	local player			= PlayerResource:GetPlayer(playerID)

	return true
end

function air_ship_high_tides:GetManaCost(abilitylevel)
	return self.BaseClass.GetManaCost(self, abilitylevel)
end

function air_ship_high_tides:GetCooldown(abilitylevel)
	return self.BaseClass.GetCooldown(self, abilitylevel)
end