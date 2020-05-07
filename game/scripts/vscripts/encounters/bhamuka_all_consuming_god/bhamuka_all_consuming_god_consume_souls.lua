bhamuka_all_consuming_god_consume_souls = class({})

LinkLuaModifier( 'bhamuka_all_consuming_god_consume_souls_modifier', 'encounters/bhamuka_all_consuming_god/bhamuka_all_consuming_god_consume_souls_modifier', LUA_MODIFIER_MOTION_NONE )

function bhamuka_all_consuming_god_consume_souls:OnSpellStart()

	--- Get Caster, Victim, Player, Point ---
	local caster		= self:GetCaster()
	local caster_loc	= caster:GetAbsOrigin()
	local playerID		= caster:GetPlayerOwnerID()
	local player		= PlayerResource:GetPlayer(playerID)
	local team			= caster:GetTeamNumber()
	local victim		= caster
	local victim_loc	= victim:GetAbsOrigin()
	
	--- Get Special Values ---
	local duration                    = self:GetSpecialValueFor("duration")
	local damage                      = self:GetSpecialValueFor("damage")
	local damage_interval             = self:GetSpecialValueFor("damage_interval")
	local delay                       = self:GetSpecialValueFor("delay")
	local soul_consumed_per_second    = self:GetSpecialValueFor("soul_consumed_per_second")

	caster:AddNewModifier(caster, self, "casting_rooted_modifier", {duration=duration+delay})
	DisableMotionControllers(caster, duration+delay)

	EncounterUnitWarning(caster, delay, true, nil) --nil=yellow, "red", "orange", "green"

	-- Sound --
	local sound = {"outworld_destroyer_odest_ability_eclipse_02", "outworld_destroyer_odest_ability_eclipse_10",
					"outworld_destroyer_odest_ability_eclipse_06", "outworld_destroyer_odest_ability_eclipse_07",
					"outworld_destroyer_odest_ability_eclipse_08"}
	EmitAnnouncerSound( sound[RandomInt(1, #sound)] )

	local timer = Timers:CreateTimer(2.00, function()
		local sound = {"outworld_destroyer_odest_laugh_01", "outworld_destroyer_odest_laugh_02",
						"outworld_destroyer_odest_laugh_03", "outworld_destroyer_odest_laugh_04",
						"outworld_destroyer_odest_laugh_05", "outworld_destroyer_odest_laugh_06",
						"outworld_destroyer_odest_laugh_07", "outworld_destroyer_odest_laugh_08",
						"outworld_destroyer_odest_laugh_09", "outworld_destroyer_odest_laugh_10",
						"outworld_destroyer_odest_laugh_11", "outworld_destroyer_odest_laugh_12",}
		EmitAnnouncerSound( sound[RandomInt(1, #sound)] )
	end)
	PersistentTimer_Add(timer)

	self.timers = {}

	local timer = Timers:CreateTimer(delay, function()

		-- Animation --
		StartAnimation(caster, {duration=duration, activity=ACT_DOTA_RUN, rate=0.75})

		-- Sound --
		caster:EmitSound("Hero_ObsidianDestroyer.SanityEclipse")

		for _,victim in pairs(GetHeroesAliveEntities()) do

			-- Modifier --
			local modifier = victim:FindModifierByName("bhamuka_all_consuming_god_consume_souls_modifier")
			if modifier == nil then
				local modifier = victim:AddNewModifier(caster, self, "bhamuka_all_consuming_god_consume_souls_modifier", {})
				PersistentModifier_Add(modifier)
				modifier:SetStackCount(0)
			end

			self.timers[_] = Timers:CreateTimer(0, function()

				local fear_angle = 150

				local hero_angle = victim:GetAnglesAsVector().y
				local origin_difference = victim:GetAbsOrigin() - caster_loc

				local origin_difference_radian = math.atan2(origin_difference.y, origin_difference.x)

				origin_difference_radian = origin_difference_radian * 180
				local caster_angle = origin_difference_radian / math.pi
				caster_angle = caster_angle + 180.0

				local result_angle = caster_angle - hero_angle
				result_angle = math.abs(result_angle)

				if ( result_angle >= 0 and result_angle <= (fear_angle / 2) ) or
					( result_angle >= (360 - (fear_angle / 2)) and result_angle <= 360 ) then

					-- Particle --
					local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_bane/bane_fiendsgrip_ground_rubble.vpcf", PATTACH_ABSORIGIN, victim)
					ParticleManager:SetParticleControl( particle, 0, victim:GetAbsOrigin() )
					ParticleManager:ReleaseParticleIndex( particle )
					particle = nil

					-- Modifier --
					local modifier = victim:FindModifierByName("bhamuka_all_consuming_god_consume_souls_modifier")
					modifier:SetStackCount( modifier:GetStackCount() + (soul_consumed_per_second * damage_interval) )
					modifier:ForceRefresh()

					-- Apply Damage --
					EncounterApplyDamage(victim, caster, self, damage*damage_interval, DAMAGE_TYPE_MAGICAL, DOTA_DAMAGE_FLAG_NONE)

				end

				return damage_interval
			end)
			PersistentTimer_Add(self.timers[_])

		end

	end)
	PersistentTimer_Add(timer)

	local timer = Timers:CreateTimer(delay + duration, function()
		for _,timer in pairs(self.timers) do
			Timers:RemoveTimer(self.timers[_])
			self.timers[_] = nil
		end
	end)
	PersistentTimer_Add(timer)

end

function bhamuka_all_consuming_god_consume_souls:OnAbilityPhaseStart()
	local caster			= self:GetCaster()
	local playerID			= caster:GetPlayerOwnerID()
	local player			= PlayerResource:GetPlayer(playerID)

	return true
end

function bhamuka_all_consuming_god_consume_souls:GetManaCost(abilitylevel)
	return self.BaseClass.GetManaCost(self, abilitylevel)
end

function bhamuka_all_consuming_god_consume_souls:GetCooldown(abilitylevel)
	return self.BaseClass.GetCooldown(self, abilitylevel)
end