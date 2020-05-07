demonic_warrior_chase = class({})

LinkLuaModifier( 'demonic_warrior_chase_modifier', 'encounters/demonic_warrior/demonic_warrior_chase_modifier', LUA_MODIFIER_MOTION_NONE )

function demonic_warrior_chase:OnSpellStart()

	--- Get Caster, Victim, Player, Point ---
	local caster		= self:GetCaster()
	local caster_loc	= caster:GetAbsOrigin()
	local playerID		= caster:GetPlayerOwnerID()
	local player		= PlayerResource:GetPlayer(playerID)
	local team			= caster:GetTeamNumber()
	
	--- Get Special Values ---
	local duration                    = self:GetSpecialValueFor("duration")
	local move_speed_absolute         = self:GetSpecialValueFor("move_speed_absolute")

	-- Sound --
	caster:EmitSound("Hero_Slardar.Sprint")

	-- Modifier --
	caster:AddNewModifier(caster, self, "demonic_warrior_chase_modifier", {duration = duration})

	local timer = Timers:CreateTimer(0.0, function()

		local caster_loc = caster:GetAbsOrigin()

		-- Particle --
		local particle = ParticleManager:CreateParticle("particles/econ/items/juggernaut/jugg_arcana/juggernaut_arcana_v2_omni_slash_trail_dust_l.vpcf", PATTACH_ABSORIGIN, caster)
		ParticleManager:SetParticleControl( particle, 0, caster_loc )
		ParticleManager:SetParticleControl( particle, 1, caster_loc )
		ParticleManager:ReleaseParticleIndex( particle )
		particle = nil

		return 0.25
	end)
	PersistentTimer_Add(timer)

	local timer = Timers:CreateTimer(duration, function()
		Timers:RemoveTimer(timer)
		timer = nil
	end)
	PersistentTimer_Add(timer)
	

end

function demonic_warrior_chase:OnAbilityPhaseStart()
	local caster			= self:GetCaster()
	local playerID			= caster:GetPlayerOwnerID()
	local player			= PlayerResource:GetPlayer(playerID)

	return true
end

function demonic_warrior_chase:GetManaCost(abilitylevel)
	return self.BaseClass.GetManaCost(self, abilitylevel)
end

function demonic_warrior_chase:GetCooldown(abilitylevel)
	-- ChallengerMode 1 --
	if GameMode_Active == "Challenger" and ChallengerMode_Active == 1 then
		return self.BaseClass.GetCooldown(self, abilitylevel) * 0.50
	end
	return self.BaseClass.GetCooldown(self, abilitylevel)
end