bhamuka_all_consuming_god_consume_the_ground = class({})

function bhamuka_all_consuming_god_consume_the_ground:OnSpellStart()
	--- Get Caster, Victim, Player, Point ---
	local caster		= self:GetCaster()
	local caster_loc	= caster:GetAbsOrigin()
	local playerID		= caster:GetPlayerOwnerID()
	local player		= PlayerResource:GetPlayer(playerID)
	local team			= caster:GetTeamNumber()
	local victim		= caster
	local victim_loc	= victim:GetAbsOrigin()
	
	--- Get Special Values ---
	local damage                      = self:GetSpecialValueFor("damage")
	local damage_interval             = self:GetSpecialValueFor("damage_interval")
	local delay                       = self:GetSpecialValueFor("delay")

	if caster.consume_the_ground_offset == nil then caster.consume_the_ground_offset = 0 end
	if caster.consume_the_ground_offset > 2 then return end

	-- Sound --
	local sound = {"outworld_destroyer_odest_move_08", "outworld_destroyer_odest_move_10",
					"outworld_destroyer_odest_ability_eclipse_04", "outworld_destroyer_odest_attack_03"}
	EmitAnnouncerSound( sound[RandomInt(1, #sound)] )

	local timer = Timers:CreateTimer(1.75, function()
		local sound = {"outworld_destroyer_odest_laugh_01", "outworld_destroyer_odest_laugh_02",
						"outworld_destroyer_odest_laugh_03", "outworld_destroyer_odest_laugh_04",
						"outworld_destroyer_odest_laugh_05", "outworld_destroyer_odest_laugh_06",
						"outworld_destroyer_odest_laugh_07", "outworld_destroyer_odest_laugh_08",
						"outworld_destroyer_odest_laugh_09", "outworld_destroyer_odest_laugh_10",
						"outworld_destroyer_odest_laugh_11", "outworld_destroyer_odest_laugh_12",}
		EmitAnnouncerSound( sound[RandomInt(1, #sound)] )
	end)
	PersistentTimer_Add(timer)

	if self.particles == nil then self.particles = {} end
	if self.timers == nil then self.timers = {} end

	local AoERadius = 600

	local low
	local high
	local rad
	local distance

	if caster.consume_the_ground_offset == 0 then
		low = -3
		high = 3
		rad = 30
		distance = 2100
	end
	if caster.consume_the_ground_offset == 1 then
		low = -2
		high = 2
		rad = 36
		distance = 1600
	end
	if caster.consume_the_ground_offset == 2 then
		low = -1
		high = 1
		rad = 60
		distance = 1100
	end

	local i = 0
	for x=low,high do

		local direction = RotateVector2D( (  GetSpecificBorderPoint("point_bottom") - GetSpecificBorderPoint("point_top") ):Normalized(), math.rad(x*rad) )
		local pos = GetSpecificBorderPoint("point_top") + (direction * distance)

		local timer = Timers:CreateTimer(0.2 * i, function()
			EncounterGroundAOEWarningSticky(pos, AoERadius, 10.0)
		end)
		PersistentTimer_Add(timer)

		local timer = Timers:CreateTimer(delay + (0.2 * i), function()
			-- Particle --
			local particle = ParticleManager:CreateParticle("particles/encounter/bhamuka_all_consuming_god/bhamuka_all_consuming_god_consume_the_ground.vpcf", PATTACH_CUSTOMORIGIN, nil)
			ParticleManager:SetParticleControl( particle, 0, pos )

			self.particles[i] = particle

			PersistentParticle_Add(particle)

			-- Sound --
			StartSoundEventFromPositionReliable("Hero_ObsidianDestroyer.SanityEclipse.Cast", pos)
		end)
		PersistentTimer_Add(timer)

		self.timers[i] = Timers:CreateTimer(delay + (0.2 * i), function()

			-- DOTA_UNIT_TARGET_TEAM_FRIENDLY; DOTA_UNIT_TARGET_TEAM_ENEMY; DOTA_UNIT_TARGET_TEAM_BOTH
			local units	= FindUnitsInRadius(team, pos, nil, AoERadius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
			for _,victim in pairs(units) do
				-- Apply Damage --
				EncounterApplyDamage(victim, caster, self, damage*damage_interval, DAMAGE_TYPE_PURE, DOTA_DAMAGE_FLAG_NONE)
			end

			return damage_interval
		end)
		PersistentTimer_Add(self.timers[i])

		i = i + 1
	end

	caster.consume_the_ground_offset = caster.consume_the_ground_offset + 1
	
end

function bhamuka_all_consuming_god_consume_the_ground:OnAbilityPhaseStart()
	local caster			= self:GetCaster()
	local playerID			= caster:GetPlayerOwnerID()
	local player			= PlayerResource:GetPlayer(playerID)

	return true
end

function bhamuka_all_consuming_god_consume_the_ground:GetManaCost(abilitylevel)
	return self.BaseClass.GetManaCost(self, abilitylevel)
end

function bhamuka_all_consuming_god_consume_the_ground:GetCooldown(abilitylevel)
	return self.BaseClass.GetCooldown(self, abilitylevel)
end