ferocious_lava_elemental_annihilation = class({})

function ferocious_lava_elemental_annihilation:OnSpellStart()

	--- Get Caster, Victim, Player, Point ---
	local caster		= self:GetCaster()
	local caster_loc	= caster:GetAbsOrigin()
	local playerID		= caster:GetPlayerOwnerID()
	local player		= PlayerResource:GetPlayer(playerID)
	local team			= caster:GetTeamNumber()
	
	if caster.the_dungeoneer_time_warp == true then
		local order = {
			UnitIndex = caster:entindex(),
			AbilityIndex = unit:GetAbilityByIndex( RandomInt(0, 2) ):entindex(),
			OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
			Queue = false
		}
		ExecuteOrderFromTable(order)

		return
	end

	--- Get Special Values ---
	local duration                    = self:GetSpecialValueFor("duration")
	local damage                      = self:GetSpecialValueFor("damage")
	local hp_loss_to_cancel_percentage= self:GetSpecialValueFor("hp_loss_to_cancel_percentage")

	local hp_to_reach = caster:GetHealth() - ( caster:GetMaxHealth() * ( hp_loss_to_cancel_percentage / 100 ) )

	EncounterUnitWarning(caster, 2.0, true, "red") --nil=yellow, "red", "orange", "green"

	caster:AddNewModifier(caster, self, "casting_rooted_modifier", {duration=duration})

	-- Particle --
	local particle = ParticleManager:CreateParticle("particles/econ/events/ti6/teleport_end_ti6_ground_flash.vpcf", PATTACH_ABSORIGIN, caster)
	ParticleManager:SetParticleControl( particle, 0, caster:GetAbsOrigin() )
	PersistentParticle_Add(particle)

	-- Sound --
	caster:EmitSound("Hero_Antimage.Blink_out")

	local timer = Timers:CreateTimer(2.0, function()
		ParticleManager:DestroyParticle( particle, false )
		ParticleManager:ReleaseParticleIndex( particle )
		particle = nil
	end)
	PersistentTimer_Add(timer)

	caster_loc = GetRandomBorderPoint()
	FindClearSpaceForUnit(caster, caster_loc, false)

	caster:FaceTowards( GetSpecificBorderPoint("point_center") )

	DisableMotionControllers(caster, duration)

	-- Sound and Animation --
	local sound = {"nevermore_nev_ability_presence_01", "nevermore_nev_ability_presence_03",
					"nevermore_nev_kill_04", "nevermore_nev_anger_01"}
	EmitAnnouncerSound( sound[RandomInt(1, #sound)] )

	local timer = Timers:CreateTimer(0, function()
		StartAnimation(caster, {duration=duration, activity=ACT_DOTA_FLAIL, rate=0.5})

		return 2.0
	end)
	PersistentTimer_Add(timer)


	-- Particle -- PATTACH_ABSORIGIN-PATTACH_ABSORIGIN_FOLLOW-PATTACH_CUSTOMORIGIN
	local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_batrider/batrider_firefly.vpcf", PATTACH_ABSORIGIN, caster)
	ParticleManager:SetParticleControl( particle, 0, caster_loc )	
	PersistentParticle_Add(particle)
	

	local timer1 = Timers:CreateTimer(duration, function()

		-- Sound and Animation --
		local sound = {"nevermore_nev_win_01", "nevermore_nev_win_05",
						"nevermore_nev_win_06"}
		EmitAnnouncerSound( sound[RandomInt(1, #sound)] )

		ParticleManager:DestroyParticle( particle, false )
		ParticleManager:ReleaseParticleIndex( particle )
		particle = nil

		-- Sound --
		StartSoundEventFromPositionReliable("Hero_Phoenix.SuperNova.Explode", caster_loc)

		-- Particle -- PATTACH_ABSORIGIN-PATTACH_ABSORIGIN_FOLLOW-PATTACH_CUSTOMORIGIN
		local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_phoenix/phoenix_supernova_reborn_shockwave.vpcf", PATTACH_CUSTOMORIGIN, nil)
		ParticleManager:SetParticleControl( particle, 0, caster_loc )	
		ParticleManager:ReleaseParticleIndex( particle )
		particle = nil

		-- DOTA_UNIT_TARGET_TEAM_FRIENDLY; DOTA_UNIT_TARGET_TEAM_ENEMY; DOTA_UNIT_TARGET_TEAM_BOTH
		local units	= FindUnitsInRadius(team, caster_loc, nil, 99999, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
		for _,victim in pairs(units) do

			-- Apply Damage --
			EncounterApplyDamage(victim, caster, self, damage, DAMAGE_TYPE_PURE, DOTA_DAMAGE_FLAG_HPLOSS + DOTA_DAMAGE_FLAG_BYPASSES_INVULNERABILITY + DOTA_DAMAGE_FLAG_NO_DAMAGE_MULTIPLIERS)	

		end

	end)
	PersistentTimer_Add(timer1)

	local timer2 = Timers:CreateTimer(0.1, function()

		if caster:GetHealth() <= hp_to_reach then

			Cancel_DisableMotionControllers(caster)

			if timer ~= nil then
				Timers:RemoveTimer(timer)
				timer = nil
			end

			Timers:RemoveTimer(timer1)
			timer1 = nil

			caster:RemoveModifierByName("casting_rooted_modifier")

			EndAnimation(caster)

			-- Sound and Animation --
			local sound = {"nevermore_nev_lose_01", "nevermore_nev_anger_07",
							"nevermore_nev_anger_02"}
			EmitAnnouncerSound( sound[RandomInt(1, #sound)] )

			-- Sound --
			StartSoundEventFromPositionReliable("Hero_Phoenix.SuperNova.Death", caster_loc)

			ParticleManager:DestroyParticle( particle, false )
			ParticleManager:ReleaseParticleIndex( particle )
			particle = nil

			return
		end

		return 0.1
	end)
	PersistentTimer_Add(timer2)

	local timer3 = Timers:CreateTimer(duration+0.1, function()

		Cancel_DisableMotionControllers(caster)

		if timer ~= nil then
			Timers:RemoveTimer(timer)
			timer = nil
		end

		Timers:RemoveTimer(timer2)
		timer2 = nil

	end)
	PersistentTimer_Add(timer3)
	
end

function ferocious_lava_elemental_annihilation:OnAbilityPhaseStart()
	local caster			= self:GetCaster()
	local playerID			= caster:GetPlayerOwnerID()
	local player			= PlayerResource:GetPlayer(playerID)

	return true
end

function ferocious_lava_elemental_annihilation:GetManaCost(abilitylevel)
	return self.BaseClass.GetManaCost(self, abilitylevel)
end

function ferocious_lava_elemental_annihilation:GetCooldown(abilitylevel)
	return self.BaseClass.GetCooldown(self, abilitylevel)
end