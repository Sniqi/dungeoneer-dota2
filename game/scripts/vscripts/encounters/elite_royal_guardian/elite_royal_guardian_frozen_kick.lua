elite_royal_guardian_frozen_kick = class({})

LinkLuaModifier( 'elite_royal_guardian_frozen_kick_movement_modifier', 'encounters/elite_royal_guardian/elite_royal_guardian_frozen_kick_movement_modifier', LUA_MODIFIER_MOTION_NONE )

function elite_royal_guardian_frozen_kick:OnSpellStart()

	local victim		= GetRandomHeroEntities(1)
	if not victim then return end
	victim				= victim[1]
	local victim_loc    = victim:GetAbsOrigin()

	--- Get Caster, Victim, Player, Point ---
	local caster		= self:GetCaster()
	local caster_loc	= caster:GetAbsOrigin()
	local playerID		= caster:GetPlayerOwnerID()
	local player		= PlayerResource:GetPlayer(playerID)
	local team			= caster:GetTeamNumber()
	
	--- Get Special Values ---
	local damage                      = self:GetSpecialValueFor("damage")
	local delay                       = self:GetSpecialValueFor("delay")
	local push_force                  = self:GetSpecialValueFor("push_force")
	local move_speed_absolute         = self:GetSpecialValueFor("move_speed_absolute")

	local loc = nil

	caster:AddNewModifier(caster, self, "casting_rooted_modifier", {duration = 0.5})

	caster:Stop()

	-- Sound and Animation --
	local sound = {"sven_sven_kill_01"}
	EmitAnnouncerSound( sound[RandomInt(1, #sound)] )
	
	StartAnimation(caster, {duration=0.5, activity=ACT_DOTA_CAST_ABILITY_1, rate=2.0})

	EncounterGroundAOEWarningSticky(victim:GetAbsOrigin(), 100, 0.5)

	local timer = Timers:CreateTimer(0.5, function()

		local casting_modifier = caster:AddNewModifier(caster, self, "casting_modifier", {})
		local movement_modifier = caster:AddNewModifier(caster, self, "elite_royal_guardian_frozen_kick_movement_modifier", {})

		-- Modifier --
		local modifierFrozen = victim:AddNewModifier(caster, self, "casting_frozen_modifier", {})
		PersistentModifier_Add(modifierFrozen)
		local modifierStunned = victim:AddNewModifier(caster, self, "modifier_stunned", {})
		PersistentModifier_Add(modifierStunned)

		-- Sound --
		StartSoundEventReliable("Hero_Winter_Wyvern.ColdEmbrace", victim)

		-- Particle -- PATTACH_ABSORIGIN-PATTACH_ABSORIGIN_FOLLOW-PATTACH_CUSTOMORIGIN
		local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_winter_wyvern/wyvern_cold_embrace_buff.vpcf", PATTACH_ABSORIGIN, victim)
		ParticleManager:SetParticleControl( particle, 0, victim:GetAbsOrigin() )
		PersistentParticle_Add(particle)

		if caster.elite_royal_guardian_eternal_ice_chosenPoint then
			loc = victim:GetAbsOrigin() + ( ( caster.elite_royal_guardian_eternal_ice_chosenPoint - victim:GetAbsOrigin() ):Normalized() * -250 )
		else
			loc = victim:GetAbsOrigin()
		end

		caster:MoveToPosition(loc)

		local timer1 = Timers:CreateTimer(function()

			if (caster:GetAbsOrigin() - loc):Length2D() < 25 then

				caster_loc = caster:GetAbsOrigin()

				casting_modifier:Destroy()
				movement_modifier:Destroy()

				caster:AddNewModifier(caster, self, "casting_rooted_modifier", {duration = delay})

				TurnToLoc(caster, victim:GetAbsOrigin(), delay/2)
				
				local timer2 = Timers:CreateTimer(delay-0.45, function()

					-- Sound --
					StartSoundEventReliable("Hero_Sven.GodsStrength.PreAttack", caster)

					-- Sound and Animation --
					local sound = {"sven_sven_laugh_01", "sven_sven_laugh_02",
									"sven_sven_laugh_03"}
					EmitAnnouncerSound( sound[RandomInt(1, #sound)] )
					
					StartAnimation(caster, {duration=1.1, activity=ACT_DOTA_ATTACK, rate=1.0, translate="sven_warcry", translate2="sven_shield"})

				end)
				PersistentTimer_Add(timer2)

				local timer3 = Timers:CreateTimer(delay, function()

					ParticleManager:DestroyParticle( particle, false )
					ParticleManager:ReleaseParticleIndex( particle )
					particle = nil

					-- Sound --
					StartSoundEventReliable("Hero_Sven.IronWill", victim)

					-- Modifier --
					--local modifier = victim:AddNewModifier(caster, ability, "modifier_stunned", {duration = stun})
					--PersistentModifier_Add(modifier)
					modifierFrozen:Destroy()
					modifierStunned:Destroy()

					-- Apply Damage --
					EncounterApplyDamage(victim, caster, self, damage, DAMAGE_TYPE_PHYSICAL, DOTA_DAMAGE_FLAG_BYPASSES_BLOCK)

					victim:SetRebounceFrames(12)
					victim:SetPhysicsVelocityMax(push_force)
					victim:AddPhysicsVelocity(caster:GetForwardVector() * push_force)
					--victim:OnBounce(function(victim, normal)
						--EncounterApplyDamage(victim, caster, ability, push_damage, DAMAGE_TYPE_PHYSICAL, DOTA_DAMAGE_FLAG_NONE)
					--end)

				end)
				PersistentTimer_Add(timer3)

				return
			end

			return 0.06
		end)
		PersistentTimer_Add(timer1)


	end)
	PersistentTimer_Add(timer)

end

function elite_royal_guardian_frozen_kick:OnAbilityPhaseStart()
	local caster			= self:GetCaster()
	local playerID			= caster:GetPlayerOwnerID()
	local player			= PlayerResource:GetPlayer(playerID)

	return true
end

function elite_royal_guardian_frozen_kick:GetManaCost(abilitylevel)
	return self.BaseClass.GetManaCost(self, abilitylevel)
end

function elite_royal_guardian_frozen_kick:GetCooldown(abilitylevel)
	return self.BaseClass.GetCooldown(self, abilitylevel)
end