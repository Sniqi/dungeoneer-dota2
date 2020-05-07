smodhex_satyr_warlock_spiral_of_death = class({})

function smodhex_satyr_warlock_spiral_of_death:OnSpellStart()

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
	local duration_max_hp             = self:GetSpecialValueFor("duration_max_hp")
	local duration_min_hp             = self:GetSpecialValueFor("duration_min_hp")

	local duration_range = duration_max_hp - duration_min_hp
	local duration = duration_min_hp + ( duration_range * ( caster:GetHealthPercent() / 100 ) )

	local explosion_count = 10
	local explosion_delay = duration / explosion_count

	DelayAbilityCooldown(caster, "smodhex_satyr_warlock_shadow_fountain", delay+duration, 2.0)

	caster:AddNewModifier(caster, self, "casting_rooted_modifier", {duration=duration/2})

	--[[

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

	caster_loc = GetSpecificBorderPoint("point_center")
	FindClearSpaceForUnit(caster, caster_loc, false)

	]]

	--caster:FaceTowards( GetRandomPointWithinArena() )

	DisableMotionControllers(caster, duration/2)

	-- Animation --
	StartAnimation(caster, {duration=delay, activity=ACT_DOTA_DISABLED, rate=0.85})

	-- Sound --
	local sound = {"leshrac_lesh_move_09", "leshrac_lesh_attack_03",
					"leshrac_lesh_attack_09", "leshrac_lesh_attack_08"}
	EmitAnnouncerSound( sound[RandomInt(1, #sound)] )

	local i = 0
	for x=1,explosion_count do

		local AoERadius = 400 * ( x / 5.0 )
		local rad = ( 360 / explosion_count ) + ( x * 3 )
		local distance = 900 * ( x / explosion_count )

		local direction = RotateVector2D( caster:GetForwardVector(), math.rad(x*rad) )
		local pos = ( caster:GetAbsOrigin() + ( caster:GetForwardVector() * 100 ) ) + (direction * distance)
		pos = GetGroundPosition(pos, caster)
		pos.z = pos.z + 25

		local timer = Timers:CreateTimer( (delay-(explosion_delay*1.5) ), function()
			-- Animation --
			StartAnimation(caster, {duration=delay, activity=ACT_DOTA_CAST_ABILITY_1, rate=1.0})
		end)
		PersistentTimer_Add(timer)

		local timer = Timers:CreateTimer( explosion_delay * i, function()
			EncounterGroundAOEWarningSticky(pos, AoERadius, 1.0 )
		end)
		PersistentTimer_Add(timer)

		local timer = Timers:CreateTimer( (delay-explosion_delay) + (explosion_delay * i), function()

			-- Particle --
			local particle = ParticleManager:CreateParticle("particles/encounter/smodhex_satyr_warlock/smodhex_satyr_warlock_spiral_of_death.vpcf", PATTACH_CUSTOMORIGIN, nil)
			ParticleManager:SetParticleControl( particle, 0, pos )
			ParticleManager:SetParticleControl( particle, 1, Vector(AoERadius,0,0) )
			ParticleManager:ReleaseParticleIndex( particle )
			particle = nil
			--PersistentParticle_Add(particle)

			-- Sound --
			StartSoundEventFromPositionReliable("Hero_Bane.Nightmare", pos)

			-- DOTA_UNIT_TARGET_TEAM_FRIENDLY; DOTA_UNIT_TARGET_TEAM_ENEMY; DOTA_UNIT_TARGET_TEAM_BOTH
			local units	= FindUnitsInRadius(team, pos, nil, AoERadius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
			for _,victim in pairs(units) do
				-- Apply Damage --
				EncounterApplyDamage(victim, caster, self, damage, DAMAGE_TYPE_PURE, DOTA_DAMAGE_FLAG_NONE)
			end

			local timer1 = Timers:CreateTimer(explosion_delay, function()

				--ParticleManager:DestroyParticle( particle, false )
				--ParticleManager:ReleaseParticleIndex( particle )
				--particle = nil

			end)
			PersistentTimer_Add(timer1)

		end)
		PersistentTimer_Add(timer)

		i = i + 1
	end

end

function smodhex_satyr_warlock_spiral_of_death:OnAbilityPhaseStart()
	local caster			= self:GetCaster()
	local playerID			= caster:GetPlayerOwnerID()
	local player			= PlayerResource:GetPlayer(playerID)

	return true
end

function smodhex_satyr_warlock_spiral_of_death:GetManaCost(abilitylevel)
	return self.BaseClass.GetManaCost(self, abilitylevel)
end

function smodhex_satyr_warlock_spiral_of_death:GetCooldown(abilitylevel)
	return self.BaseClass.GetCooldown(self, abilitylevel)
end