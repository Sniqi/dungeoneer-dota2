demonic_warrior_axe_thrower = class({})

LinkLuaModifier( 'demonic_warrior_axe_thrower_modifier', 'encounters/demonic_warrior/demonic_warrior_axe_thrower_modifier', LUA_MODIFIER_MOTION_NONE )

function demonic_warrior_axe_thrower:OnSpellStart()

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
	local duration                    = self:GetSpecialValueFor("duration")
	local damage                      = self:GetSpecialValueFor("damage")
	local delay                       = self:GetSpecialValueFor("delay")
	local axe_amount_min              = self:GetSpecialValueFor("axe_amount_min")
	local axe_amount_max              = self:GetSpecialValueFor("axe_amount_max")
	local projectile_speed            = self:GetSpecialValueFor("projectile_speed")
	local move_speed_percentage       = self:GetSpecialValueFor("move_speed_percentage")
	local debuff_duration             = self:GetSpecialValueFor("debuff_duration")
	local deep_cutting_axe_stack_addition= self:GetSpecialValueFor("deep_cutting_axe_stack_addition")
	local phase_two_percentage        = self:GetSpecialValueFor("phase_two_percentage")

	EncounterUnitWarning(caster, delay, true, nil) --nil=yellow, "red", "orange", "green"

	local count = RandomInt(axe_amount_min, axe_amount_max)

	duration = duration / count

	local mod = caster:FindModifierByName("demonic_warrior_rest_enhancement_modifier")
	local mod_stacks = 0
	if mod ~= nil then
		mod_stacks = mod:GetStackCount()

		duration = duration * ( 1.5 / mod_stacks )
	end	

	local interval = duration / count

	-- PHASE 2 --
	if caster:GetHealthPercent() < phase_two_percentage then

	else
		caster:AddNewModifier(caster, self, "casting_rooted_modifier", {duration=delay+duration})
		DisableMotionControllers(caster, delay+duration)
	end


	caster:Stop()

	local timer1 = Timers:CreateTimer(0, function()
		victim_loc = victim:GetAbsOrigin()
		caster:FaceTowards(victim_loc)

		return 0.03
	end)
	PersistentTimer_Add(timer1)

	local timer2 = Timers:CreateTimer(duration+delay, function()
		Timers:RemoveTimer(timer1)
		timer = nil
	end)
	PersistentTimer_Add(timer2)


	local timer1 = Timers:CreateTimer(delay, function()
		for i=0,count-1 do

			local timer2 = Timers:CreateTimer(interval * i, function()

				local resting_mod = caster:FindModifierByName("demonic_warrior_rest_modifier")
				if resting_mod ~= nil then return end

				local victim_loc = RandomLocationMinDistance(victim:GetAbsOrigin(), AoERadius*RandomFloat(0.0, 2.0)) 

				-- Sound and Animation --
				StartAnimation(caster, {duration=interval, activity=ACT_DOTA_ATTACK, rate=1/interval})

				-- Sound --
				StartSoundEventReliable("Hero_TrollWarlord.PreAttack", caster)

				-- Particle -- PATTACH_ABSORIGIN-PATTACH_ABSORIGIN_FOLLOW-PATTACH_CUSTOMORIGIN
				local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_troll_warlord/troll_warlord_whirling_axe_ranged.vpcf", PATTACH_CUSTOMORIGIN, nil)
				ParticleManager:SetParticleControl( particle, 0, caster_loc )
				ParticleManager:SetParticleControl( particle, 1, caster:GetForwardVector() * projectile_speed )
				PersistentParticle_Add(particle)

				local projectile_duration = (victim_loc - caster_loc):Length2D() / projectile_speed

				EncounterGroundAOEWarningSticky(victim_loc, AoERadius, projectile_duration+0.1)

				local timer = Timers:CreateTimer(projectile_duration, function()

					ParticleManager:DestroyParticle( particle, false )
					ParticleManager:ReleaseParticleIndex( particle )
					particle = nil

					-- DOTA_UNIT_TARGET_TEAM_FRIENDLY; DOTA_UNIT_TARGET_TEAM_ENEMY; DOTA_UNIT_TARGET_TEAM_BOTH
					local units	= FindUnitsInRadius(team, victim_loc, nil, AoERadius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
					for _,victim in pairs(units) do

						if caster == nil then return end
						if caster:IsNull() then return end
						if not caster:IsAlive() then return end

						-- Sound --
						StartSoundEventReliable("Hero_TrollWarlord.ProjectileImpact", caster)

						-- DOTA_UNIT_TARGET_TEAM_FRIENDLY; DOTA_UNIT_TARGET_TEAM_ENEMY; DOTA_UNIT_TARGET_TEAM_BOTH
						for _,victim_hero in pairs( GetHeroesAliveEntities() ) do
							local mod = victim_hero:FindModifierByName("demonic_warrior_deep_cutting_axe_wound_modifier")
							if mod == nil then
								mod = victim_hero:AddNewModifier(caster, caster:FindAbilityByName("demonic_warrior_deep_cutting_axe"), "demonic_warrior_deep_cutting_axe_wound_modifier", {})
								PersistentModifier_Add(mod)
							end

							mod:SetStackCount( mod:GetStackCount() + deep_cutting_axe_stack_addition)
						end

						-- Modifier --
						local modifier = victim:AddNewModifier(caster, self, "demonic_warrior_axe_thrower_modifier", {duration = debuff_duration})
						PersistentModifier_Add(modifier)

						-- Apply Damage --
						EncounterApplyDamage(victim, caster, self, damage, DAMAGE_TYPE_PHYSICAL, DOTA_DAMAGE_FLAG_NONE)

					end

				end)
				PersistentTimer_Add(timer)

			end)
			PersistentTimer_Add(timer2)

		end
	end)
	PersistentTimer_Add(timer1)

end

function demonic_warrior_axe_thrower:OnAbilityPhaseStart()
	local caster			= self:GetCaster()
	local playerID			= caster:GetPlayerOwnerID()
	local player			= PlayerResource:GetPlayer(playerID)

	return true
end

function demonic_warrior_axe_thrower:GetManaCost(abilitylevel)
	return self.BaseClass.GetManaCost(self, abilitylevel)
end

function demonic_warrior_axe_thrower:GetCooldown(abilitylevel)
	return self.BaseClass.GetCooldown(self, abilitylevel)
end