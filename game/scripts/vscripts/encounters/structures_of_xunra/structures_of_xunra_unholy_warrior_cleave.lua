structures_of_xunra_unholy_warrior_cleave = class({})

LinkLuaModifier( 'structures_of_xunra_unholy_warrior_cleave_modifier', 'encounters/structures_of_xunra/structures_of_xunra_unholy_warrior_cleave_modifier', LUA_MODIFIER_MOTION_NONE )

function structures_of_xunra_unholy_warrior_cleave:OnSpellStart()

	--- Get Caster, Victim, Player, Point ---
	local caster		= self:GetCaster()
	local caster_loc	= caster:GetAbsOrigin()
	local playerID		= caster:GetPlayerOwnerID()
	local player		= PlayerResource:GetPlayer(playerID)
	local team			= caster:GetTeamNumber()
	
	--- Get Special Values ---
	local AbilityCastRange            = self:GetSpecialValueFor("AbilityCastRange")
	local AoERadius                   = self:GetSpecialValueFor("AoERadius")
	local damage                      = self:GetSpecialValueFor("damage")
	local delay                       = self:GetSpecialValueFor("delay")
	local move_speed_percentage       = self:GetSpecialValueFor("move_speed_percentage")
	local debuff_duration             = self:GetSpecialValueFor("debuff_duration")

	local victim = GetNearestHeroEntity(caster)
	local victim_loc = victim:GetAbsOrigin()

	caster:AddNewModifier(caster, self, "casting_rooted_modifier", {duration=delay})
	DisableMotionControllers(caster, delay)

	caster:Stop()

	local timer1 = Timers:CreateTimer(0, function()
		victim_loc = victim:GetAbsOrigin()
		caster:FaceTowards(victim_loc)

		return 0.03
	end)
	PersistentTimer_Add(timer1)

	StartAnimation(caster, {duration=delay, activity=ACT_DOTA_DISABLED, translate=nil, rate=0.5})

	local timer2 = Timers:CreateTimer(0, function()

		Timers:RemoveTimer(timer1)
		timer1 = nil

		local rad = 25

		local projectile_start = -2
		local projectile_end = 2

		for i=projectile_start,projectile_end do

			local direction

			direction = RotateVector2D(caster:GetForwardVector(),math.rad(i*rad))

			EncounterGroundConeWarning(caster, AoERadius/3, AoERadius, caster_loc, direction, AbilityCastRange, delay+0.25)

			local timer = Timers:CreateTimer(delay, function()

				if caster == nil then return end
				if caster:IsNull() then return end
				if not caster:IsAlive() then return end

				if i == 0 then
					-- Sound --
					caster:EmitSound("Hero_Centaur.DoubleEdge")

					StartAnimation(caster, {duration=1.0, activity=ACT_DOTA_ATTACK2, translate=nil, rate=1.5})
				end

				-- Particle --
				local data = {}
				data["0"] = "LOCATION"
				data["1"] = "LOCATION"
				data["2"] = "LOCATION"
				EncounterGroundConeParticle(caster, AoERadius/3, AoERadius, caster_loc, direction, AbilityCastRange, 2.0, "particles/units/heroes/hero_riki/riki_tricks_cast_dust_hit_ring.vpcf", data)

				-- Particle --
				local data = {}
				data["0"] = "LOCATION"

				-- DOTA_UNIT_TARGET_TEAM_FRIENDLY; DOTA_UNIT_TARGET_TEAM_ENEMY; DOTA_UNIT_TARGET_TEAM_BOTH
				local units	= EncounterGroundConeFindUnits(caster, AoERadius/3, AoERadius, caster_loc, direction, AbilityCastRange, team, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE)
				for _,victim in pairs(units) do
					-- Modifier --
					local modifier = victim:AddNewModifier(caster, self, "structures_of_xunra_unholy_warrior_cleave_modifier", {duration = debuff_duration})
					PersistentModifier_Add(modifier)

					-- Apply Damage --
					EncounterApplyDamage(victim, caster, self, damage, DAMAGE_TYPE_PHYSICAL, DOTA_DAMAGE_FLAG_NONE)
				end


			end)
			PersistentTimer_Add(timer)

		end

	end)
	PersistentTimer_Add(timer2)

end

function structures_of_xunra_unholy_warrior_cleave:OnAbilityPhaseStart()
	local caster			= self:GetCaster()
	local playerID			= caster:GetPlayerOwnerID()
	local player			= PlayerResource:GetPlayer(playerID)

	return true
end

function structures_of_xunra_unholy_warrior_cleave:GetManaCost(abilitylevel)
	return self.BaseClass.GetManaCost(self, abilitylevel)
end

function structures_of_xunra_unholy_warrior_cleave:GetCooldown(abilitylevel)
	return self.BaseClass.GetCooldown(self, abilitylevel)
end