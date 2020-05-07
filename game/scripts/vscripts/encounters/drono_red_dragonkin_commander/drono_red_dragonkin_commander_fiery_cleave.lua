drono_red_dragonkin_commander_fiery_cleave = class({})

LinkLuaModifier( 'drono_red_dragonkin_commander_fiery_cleave_modifier', 'encounters/drono_red_dragonkin_commander/drono_red_dragonkin_commander_fiery_cleave_modifier', LUA_MODIFIER_MOTION_NONE )

function drono_red_dragonkin_commander_fiery_cleave:OnSpellStart()

	local caster		= self:GetCaster()

	local victim		= GetNearestHeroEntity(caster)
	if not victim then return end
	local victim_loc	= victim:GetAbsOrigin()

	--- Get Caster, Victim, Player, Point ---
	local caster_loc	= caster:GetAbsOrigin()
	local playerID		= caster:GetPlayerOwnerID()
	local player		= PlayerResource:GetPlayer(playerID)
	local team			= caster:GetTeamNumber()
	
	--- Get Special Values ---
	local AoERadius                   = self:GetSpecialValueFor("AoERadius")
	local duration                    = self:GetSpecialValueFor("duration")
	local delay                       = self:GetSpecialValueFor("delay")
	local attack_speed_constant       = self:GetSpecialValueFor("attack_speed_constant")
	local move_speed_percentage       = self:GetSpecialValueFor("move_speed_percentage")
	local damage_max_hp_percentage    = self:GetSpecialValueFor("damage_max_hp_percentage")
	local damage_min_hp_percentage    = self:GetSpecialValueFor("damage_min_hp_percentage")
	local cooldown_max_hp             = self:GetSpecialValueFor("cooldown_max_hp")
	local cooldown_min_hp             = self:GetSpecialValueFor("cooldown_min_hp")

	local damage_range = damage_max_hp_percentage - damage_min_hp_percentage
	local damage = damage_min_hp_percentage + ( damage_range * ( caster:GetHealthPercent() / 100 ) )

	caster:AddNewModifier(caster, self, "casting_rooted_modifier", {duration=delay})
	DisableMotionControllers(caster, delay)

	TurnToLoc(caster, victim_loc, delay)

	-- Sound --
	local sound = {"troll_warlord_troll_attack_01", "troll_warlord_troll_attack_02",
					"troll_warlord_troll_attack_03", "troll_warlord_troll_attack_04",
					"troll_warlord_troll_attack_05", "troll_warlord_troll_attack_11",}
	EmitAnnouncerSound( sound[RandomInt(1, #sound)] )

	local location
	local turn_delay = 0.5

	local timer = Timers:CreateTimer(turn_delay, function()

		-- Location --
		location = caster_loc + ( caster:GetForwardVector() * ( AoERadius + (AoERadius/2.5) ) )
		location = GetGroundPosition(location, caster) + Vector(0,0,25)

		EncounterGroundAOEWarningSticky(location, AoERadius, delay+0.5)

	end)
	PersistentTimer_Add(timer)

	local timer = Timers:CreateTimer(delay-0.9, function()

		-- Animation --
		StartAnimation(caster, {duration=2, activity=ACT_DOTA_ATTACK, rate=1})

	end)
	PersistentTimer_Add(timer)

	local timer = Timers:CreateTimer(delay, function()

		-- Sound --
		caster:EmitSound("Hero_Centaur.DoubleEdge")

		-- Particle --
		local particle = ParticleManager:CreateParticle("particles/econ/items/sven/sven_ti7_sword/sven_ti7_sword_spell_great_cleave_gods_strength.vpcf", PATTACH_CUSTOMORIGIN, nil)
		ParticleManager:SetParticleControlOrientation( particle, 0, caster:GetForwardVector(), caster:GetRightVector(), caster:GetUpVector() )
		ParticleManager:SetParticleControl( particle, 0, location )
		ParticleManager:SetParticleControl( particle, 1, location )
		ParticleManager:SetParticleControl( particle, 2, location )
		ParticleManager:SetParticleControl( particle, 3, location )
		ParticleManager:SetParticleControl( particle, 4, location )
		ParticleManager:SetParticleControl( particle, 5, location )
		ParticleManager:SetParticleControl( particle, 6, location )
		ParticleManager:SetParticleControl( particle, 7, location )
		ParticleManager:SetParticleControl( particle, 8, location )
		ParticleManager:SetParticleControl( particle, 9, location )
		ParticleManager:SetParticleControl( particle, 10, location )
		ParticleManager:SetParticleControl( particle, 11, location )
		ParticleManager:SetParticleControl( particle, 12, location )
		ParticleManager:SetParticleControl( particle, 13, location )
		ParticleManager:SetParticleControl( particle, 14, location )
		ParticleManager:SetParticleControl( particle, 15, location )
		ParticleManager:SetParticleControl( particle, 16, location )
		ParticleManager:ReleaseParticleIndex( particle )
		particle = nil

		local ally_hit = false

		-- DOTA_UNIT_TARGET_TEAM_FRIENDLY; DOTA_UNIT_TARGET_TEAM_ENEMY; DOTA_UNIT_TARGET_TEAM_BOTH
		local units	= FindUnitsInRadius(team, location, nil, AoERadius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
		for _,victim in pairs(units) do

			-- Modifier --
			local modifier = victim:AddNewModifier(caster, self, "drono_red_dragonkin_commander_fiery_cleave_modifier", {duration = duration})
			PersistentModifier_Add(modifier)

			-- Apply Damage --
			EncounterApplyDamage(victim, caster, self, damage, DAMAGE_TYPE_PHYSICAL, DOTA_DAMAGE_FLAG_NONE)
		end

		-- DOTA_UNIT_TARGET_TEAM_FRIENDLY; DOTA_UNIT_TARGET_TEAM_ENEMY; DOTA_UNIT_TARGET_TEAM_BOTH
		local units	= FindUnitsInRadius(team, location, nil, AoERadius, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
		for _,victim in pairs(units) do
			if victim:GetUnitName() == "red_dragonking_warrior" then

				ally_hit = true

				-- Modifier --
				local modifier = victim:AddNewModifier(caster, self, "drono_red_dragonkin_commander_fiery_cleave_modifier", {duration = duration})
				PersistentModifier_Add(modifier)

				-- Apply Damage --
				EncounterApplyDamage(victim, caster, self, damage, DAMAGE_TYPE_PHYSICAL, DOTA_DAMAGE_FLAG_NONE)
			end
		end

		if ally_hit then
			-- Sound --
			local sound = {"troll_warlord_troll_ally_09", "troll_warlord_troll_ally_06",
							"troll_warlord_troll_ally_07", "troll_warlord_troll_ally_05"}
			EmitAnnouncerSound( sound[RandomInt(1, #sound)] )
		end

	end)
	PersistentTimer_Add(timer)

end

function drono_red_dragonkin_commander_fiery_cleave:OnAbilityPhaseStart()
	local caster			= self:GetCaster()
	local playerID			= caster:GetPlayerOwnerID()
	local player			= PlayerResource:GetPlayer(playerID)

	return true
end

function drono_red_dragonkin_commander_fiery_cleave:GetManaCost(abilitylevel)
	return self.BaseClass.GetManaCost(self, abilitylevel)
end

function drono_red_dragonkin_commander_fiery_cleave:GetCooldown(abilitylevel)
	local caster                      = self:GetCaster()

	local cooldown_max_hp             = self:GetSpecialValueFor("cooldown_max_hp")
	local cooldown_min_hp             = self:GetSpecialValueFor("cooldown_min_hp")

	local cooldown_range = cooldown_max_hp - cooldown_min_hp
	local cooldown = cooldown_min_hp + ( cooldown_range * ( caster:GetHealthPercent() / 100 ) )

	return cooldown--self.BaseClass.GetCooldown(self, abilitylevel)
end