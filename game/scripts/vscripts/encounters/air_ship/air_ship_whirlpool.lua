air_ship_whirlpool = class({})

LinkLuaModifier( 'air_ship_whirlpool_modifier', 'encounters/air_ship/air_ship_whirlpool_modifier', LUA_MODIFIER_MOTION_NONE )

function air_ship_whirlpool:OnSpellStart()

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
	local damage_interval             = self:GetSpecialValueFor("damage_interval")
	local delay                       = self:GetSpecialValueFor("delay")
	local suck_in_force               = self:GetSpecialValueFor("suck_in_force")

	local deltaX = GetSpecificBorderPoint("point_right").x - GetSpecificBorderPoint("point_left").x
	local offsetX = RandomFloat(0.2, 0.8) * deltaX
	local loc = GetSpecificBorderPoint("point_left") + Vector(offsetX,RandomFloat(200,600),0)

	caster:AddNewModifier(caster, self, "casting_rooted_modifier", {duration=delay})
	DisableMotionControllers(caster, delay)

	-- Sound --
	StartSoundEventFromPositionReliable("Ability.GushCast", loc)

	EncounterGroundAOEWarningSticky(loc, AoERadius, delay+1.0)

	-- Particle -- PATTACH_ABSORIGIN-PATTACH_ABSORIGIN_FOLLOW-PATTACH_CUSTOMORIGIN
	local particle = ParticleManager:CreateParticle("particles/encounter/air_ship/air_ship_whirlpool_caustic.vpcf", PATTACH_CUSTOMORIGIN, nil)
	ParticleManager:SetParticleControl( particle, 0, loc )
	PersistentParticle_Add(particle)

	local timer = Timers:CreateTimer(delay, function()

		ParticleManager:DestroyParticle( particle, false )
		ParticleManager:ReleaseParticleIndex( particle )
		particle = nil

		-- Particle -- PATTACH_ABSORIGIN-PATTACH_ABSORIGIN_FOLLOW-PATTACH_CUSTOMORIGIN
		local particle = ParticleManager:CreateParticle("particles/encounter/air_ship/air_ship_whirlpool.vpcf", PATTACH_CUSTOMORIGIN, nil)
		ParticleManager:SetParticleControl( particle, 0, loc )
		PersistentParticle_Add(particle)

		local timer1 = Timers:CreateTimer(0, function()

			-- DOTA_UNIT_TARGET_TEAM_FRIENDLY; DOTA_UNIT_TARGET_TEAM_ENEMY; DOTA_UNIT_TARGET_TEAM_BOTH
			local units	= FindUnitsInRadius(team, loc, nil, AoERadius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
			for _,victim in pairs(units) do

				victim.air_ship_whirlpool = true
			
				-- Modifier --
				victim:AddNewModifier(caster, self, "air_ship_whirlpool_modifier", {duration = 0.5})

				-- Apply Damage --
				EncounterApplyDamage(victim, caster, self, damage*damage_interval, DAMAGE_TYPE_MAGICAL, DOTA_DAMAGE_FLAG_NONE)

			end

			-- DOTA_UNIT_TARGET_TEAM_FRIENDLY; DOTA_UNIT_TARGET_TEAM_ENEMY; DOTA_UNIT_TARGET_TEAM_BOTH
			local units	= FindUnitsInRadius(team, loc, nil, 5000, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
			for _,victim in pairs(units) do

				if IsPhysicsUnit(victim) and victim:FindModifierByName("air_ship_whirlpool_modifier") ~= nil then
					-- Animation --
					StartAnimation(victim, {duration=damage_interval, activity=ACT_DOTA_FLAIL, rate=2.0})

					-- Physics --
					victim:SetPhysicsVelocityMax(victim:GetMoveSpeedModifier(victim:GetBaseMoveSpeed(),true) * suck_in_force)
					victim:PreventDI()

					local direction = loc - victim:GetAbsOrigin()
					direction = direction:Normalized()
					victim:SetPhysicsAcceleration(direction * 400)

					local i = 0
					victim:OnPhysicsFrame(function(victim)

						if i == 3 then
							i = 0

							-- Retarget acceleration vector
							local distance = loc - victim:GetAbsOrigin() - Vector(0,0,150)
							local direction = distance:Normalized()

							local factor = 5000 / distance:Length()
							if factor > 2 then factor = 2 end

							victim:SetPhysicsAcceleration(direction * 400 * factor)

							-- Stop if reached the unit
							if distance:Length() < 100 then
								victim:OnPhysicsFrame(nil)
								victim:SetPhysicsAcceleration(Vector(0,0,0))
								victim:SetPhysicsVelocity(Vector(0,0,0))
							end
						end

						i = i + 1
					end)
				elseif victim.air_ship_whirlpool then

					victim.air_ship_whirlpool = false

					victim:OnPhysicsFrame(nil)
					victim:SetPhysicsAcceleration(Vector(0,0,0))
					victim:SetPhysicsVelocity(Vector(0,0,0))
				end

			end

			return damage_interval
		end)
		PersistentTimer_Add(timer1)

		local timer2 = Timers:CreateTimer(delay+duration, function()

			Timers:RemoveTimer(timer1)
			timer1 = nil

			ParticleManager:DestroyParticle( particle, false )
			ParticleManager:ReleaseParticleIndex( particle )
			particle = nil

			-- DOTA_UNIT_TARGET_TEAM_FRIENDLY; DOTA_UNIT_TARGET_TEAM_ENEMY; DOTA_UNIT_TARGET_TEAM_BOTH
			local units	= FindUnitsInRadius(team, loc, nil, 5000, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
			for _,victim in pairs(units) do

				if IsPhysicsUnit(victim) then

					victim.air_ship_whirlpool = false

					victim:OnPhysicsFrame(nil)
					victim:SetPhysicsAcceleration(Vector(0,0,0))
					victim:SetPhysicsVelocity(Vector(0,0,0))
				end
			end
		end)
		PersistentTimer_Add(timer2)

	end)
	PersistentTimer_Add(timer)


	
--[[



	-- Particle -- PATTACH_ABSORIGIN-PATTACH_ABSORIGIN_FOLLOW-PATTACH_CUSTOMORIGIN
	local particle = ParticleManager:CreateParticle("xxx", PATTACH_ABSORIGIN, caster)
	local particle = ParticleManager:CreateParticle("xxx", PATTACH_CUSTOMORIGIN, nil)
	ParticleManager:SetParticleControl( particle, 0, loc )
	
	ParticleManager:SetParticleControlEnt( particle, 3, caster, PATTACH_POINT_FOLLOW, "attach_hitloc", caster:GetAttachmentOrigin(caster:ScriptLookupAttachment("attach_hitloc")), true)
	
	PersistentParticle_Add(particle)
	
	ParticleManager:ReleaseParticleIndex( particle )
	particle = nil

	local timer = Timers:CreateTimer(duration, function()
			ParticleManager:DestroyParticle( particle, false )
			ParticleManager:ReleaseParticleIndex( particle )
			particle = nil
	end)
	PersistentTimer_Add(timer)


	
	-- Sound --
	StartSoundEventReliable("xxx", victim)
	StartSoundEventFromPositionReliable("xxx", loc)
	
	-- DOTA_UNIT_TARGET_TEAM_FRIENDLY; DOTA_UNIT_TARGET_TEAM_ENEMY; DOTA_UNIT_TARGET_TEAM_BOTH
	local units	= FindUnitsInRadius(team, loc, nil, AoERadius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
	for _,victim in pairs(units) do
	
	end
	
	TurnToLoc(caster, victim_loc, 1.5)
	RandomlocMinDistance( GetSpecificBorderPoint("point_center"), 750*RandomFloat(0.25, 1.0))
	]]
	
	
end

function air_ship_whirlpool:OnAbilityPhaseStart()
	local caster			= self:GetCaster()
	local playerID			= caster:GetPlayerOwnerID()
	local player			= PlayerResource:GetPlayer(playerID)

	return true
end

function air_ship_whirlpool:GetManaCost(abilitylevel)
	return self.BaseClass.GetManaCost(self, abilitylevel)
end

function air_ship_whirlpool:GetCooldown(abilitylevel)
	return self.BaseClass.GetCooldown(self, abilitylevel)
end