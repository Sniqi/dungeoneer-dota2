iron_claw_rear_up = class({})

LinkLuaModifier( 'iron_claw_rear_up_modifier', 'encounters/iron_claw/iron_claw_rear_up_modifier', LUA_MODIFIER_MOTION_NONE )

function iron_claw_rear_up:OnSpellStart()

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
	local delay                       = self:GetSpecialValueFor("delay")

	caster:AddNewModifier(caster, self, "casting_rooted_modifier", {duration=delay*2})
	DisableMotionControllers(caster, delay*2)

	EncounterUnitWarning(caster, 1.0, true, nil) --nil=yellow, "red", "orange", "green"
	
	-- Sound --
	caster:EmitSound("Hero_LoneDruid.BattleCry.Bear")

	-- Animation --
	caster:StartGestureWithPlaybackRate(ACT_DOTA_IDLE_RARE, 0.8)

	local timer = Timers:CreateTimer(delay, function()

		local resting_mod = caster:FindModifierByName("iron_claw_iron_hide_resting_modifier")
		if resting_mod ~= nil then return end

		-- Sound --
		caster:EmitSound("Hero_LoneDruid.SavageRoar.Cast")

		-- Particle --
		local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_lone_druid/lone_druid_savage_roar.vpcf", PATTACH_ABSORIGIN, caster)
		ParticleManager:SetParticleControl( particle, 0, caster:GetAbsOrigin() )
		ParticleManager:SetParticleControl( particle, 1, caster:GetAbsOrigin() )
		ParticleManager:ReleaseParticleIndex( particle )
		particle = nil

		for _,hero in pairs( GetHeroesAliveEntities() ) do

			local fear_angle = 150

			local hero_angle = hero:GetAnglesAsVector().y
			local origin_difference = hero:GetAbsOrigin() - caster_loc

			local origin_difference_radian = math.atan2(origin_difference.y, origin_difference.x)

			origin_difference_radian = origin_difference_radian * 180
			local caster_angle = origin_difference_radian / math.pi
			caster_angle = caster_angle + 180.0

			local result_angle = caster_angle - hero_angle
			result_angle = math.abs(result_angle)

			local forward = hero:GetForwardVector()

			if ( result_angle >= 0 and result_angle <= (fear_angle / 2) ) or
				( result_angle >= (360 - (fear_angle / 2)) and result_angle <= 360 ) then

				-- Modifier --
				local modifier = hero:AddNewModifier(caster, self, "iron_claw_rear_up_modifier", {duration = duration})
				PersistentModifier_Add(modifier)

			end
		end

	end)
	PersistentTimer_Add(timer)

end

function iron_claw_rear_up:OnAbilityPhaseStart()
	local caster			= self:GetCaster()
	local playerID			= caster:GetPlayerOwnerID()
	local player			= PlayerResource:GetPlayer(playerID)

	return true
end

function iron_claw_rear_up:GetManaCost(abilitylevel)
	return self.BaseClass.GetManaCost(self, abilitylevel)
end

function iron_claw_rear_up:GetCooldown(abilitylevel)
	return self.BaseClass.GetCooldown(self, abilitylevel)
end