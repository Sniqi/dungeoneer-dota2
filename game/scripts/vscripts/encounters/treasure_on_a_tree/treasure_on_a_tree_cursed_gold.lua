treasure_on_a_tree_cursed_gold = class({})

function treasure_on_a_tree_cursed_gold:OnSpellStart()

	--- Get Caster, Victim, Player, Point ---
	local caster		= self:GetCaster()
	local caster_loc	= caster:GetAbsOrigin()
	local playerID		= caster:GetPlayerOwnerID()
	local player		= PlayerResource:GetPlayer(playerID)
	local team			= caster:GetTeamNumber()
	
	--- Get Special Values ---
	local duration                    = self:GetSpecialValueFor("duration")
	local delay                       = self:GetSpecialValueFor("delay")
	local pull_force                  = self:GetSpecialValueFor("pull_force")

	local loc = GetRandomPointWithinArena()

	-- Sound and Animation --
	local sound = {"treant_treant_laugh_01", "treant_treant_laugh_02",
					"treant_treant_laugh_03", "treant_treant_laugh_13"}
	EmitAnnouncerSound( sound[RandomInt(1, #sound)] )
	StartAnimation(caster, {duration=delay, activity=ACT_DOTA_SPAWN, rate=0.75})

	EncounterGroundAOEWarningSticky(loc, 175, delay)

	local particle1
	local particle2
	
	local timer = Timers:CreateTimer(delay, function()

		-- Sound --
		StartSoundEventFromPositionReliable("General.Coins", loc)

		-- Particle -- PATTACH_ABSORIGIN-PATTACH_ABSORIGIN_FOLLOW-PATTACH_CUSTOMORIGIN
		local particle = ParticleManager:CreateParticle("particles/econ/items/dazzle/dazzle_ti6_gold/dazzle_ti6_shallow_grave_gold_glyph_flare.vpcf", PATTACH_CUSTOMORIGIN, nil)
		ParticleManager:SetParticleControl( particle, 0, loc )
		ParticleManager:ReleaseParticleIndex( particle )
		particle = nil

		-- Particle -- PATTACH_ABSORIGIN-PATTACH_ABSORIGIN_FOLLOW-PATTACH_CUSTOMORIGIN
		local particle = ParticleManager:CreateParticle("particles/econ/items/bounty_hunter/bounty_hunter_hunters_hoard/bounty_hunter_hoard_shield_center_gold.vpcf", PATTACH_CUSTOMORIGIN, nil)
		ParticleManager:SetParticleControl( particle, 0, loc )
		PersistentParticle_Add(particle)
		particle1 = particle

		-- Particle -- PATTACH_ABSORIGIN-PATTACH_ABSORIGIN_FOLLOW-PATTACH_CUSTOMORIGIN
		local particle = ParticleManager:CreateParticle("particles/econ/events/ti7/golden_treasure_ti7_ambient.vpcf", PATTACH_CUSTOMORIGIN, nil)
		ParticleManager:SetParticleControl( particle, 0, loc )
		PersistentParticle_Add(particle)
		particle2 = particle

		local ent = SpawnEntityFromTableSynchronous("prop_dynamic", {model = "models/props_debris/goldcoins_01.vmdl", targetname=DoUniqueString("treasure_on_a_tree_cursed_gold")})
		ent:SetAbsOrigin( GetGroundPosition( loc, caster ) )
		ent:SetModelScale( 3.0 )
		PersistentEntity_Add(ent)

		local affected_units = GetHeroesAliveEntities()

		for _,victim in pairs( affected_units ) do
			if victim ~= nil then
			if not victim:IsNull() then
			if victim:IsAlive() then
			if IsPhysicsUnit(victim) then
				-- Animation --
				--StartAnimation(victim, {duration=duration, activity=ACT_DOTA_FLAIL, rate=1.0})

				-- Physics --
				victim:SetPhysicsVelocityMax(500)
				victim:PreventDI()

				local direction = loc - victim:GetAbsOrigin()
				direction = direction:Normalized()
				victim:SetPhysicsAcceleration(direction * pull_force)

				victim:OnPhysicsFrame(function(victim)
						-- Retarget acceleration vector
						local distance = loc - victim:GetAbsOrigin() - Vector(0,0,150)
						local direction = distance:Normalized()

						local factor = 5000 / distance:Length()
						if factor > 2 then factor = 2 end

						victim:SetPhysicsAcceleration(direction * pull_force * factor)

						-- Stop if reached the unit
						if distance:Length() <= 150 + 100 then
							victim:SetPhysicsAcceleration(Vector(0,0,0))
							victim:SetPhysicsVelocity(Vector(0,0,0))
							victim:OnPhysicsFrame(nil)

							StartSoundEventFromPositionReliable("Hero_Terrorblade.Metamorphosis", loc)

							-- Particle -- PATTACH_ABSORIGIN-PATTACH_ABSORIGIN_FOLLOW-PATTACH_CUSTOMORIGIN
							local particle = ParticleManager:CreateParticle("particles/econ/items/chaos_knight/chaos_knight_ti7_shield/chaos_knight_ti7_golden_reality_rift.vpcf", PATTACH_CUSTOMORIGIN, nil)
							ParticleManager:SetParticleControl( particle, 1, victim:GetAbsOrigin() )
							ParticleManager:SetParticleControl( particle, 2, victim:GetAbsOrigin() )
							ParticleManager:SetParticleControlOrientation( particle, 1, victim:GetForwardVector(), victim:GetRightVector(), victim:GetUpVector() )
							ParticleManager:SetParticleControlOrientation( particle, 2, victim:GetForwardVector(), victim:GetRightVector(), victim:GetUpVector() )
							PersistentParticle_Add(particle)

							local timer2 = Timers:CreateTimer(2.0, function()
								-- Particle --
								ParticleManager:DestroyParticle( particle, false )
								ParticleManager:ReleaseParticleIndex( particle )
								particle = nil
							end)

							-- Apply Damage --
							EncounterApplyDamage(victim, caster, self, 10000, DAMAGE_TYPE_PURE, DOTA_DAMAGE_FLAG_BYPASSES_INVULNERABILITY + DOTA_DAMAGE_FLAG_BYPASSES_BLOCK + DOTA_DAMAGE_FLAG_NO_DAMAGE_MULTIPLIERS)


					end
				end)

			end
			end
			end
			end
		end

		local timer1 = Timers:CreateTimer(duration, function()

			-- Particle --
			ParticleManager:DestroyParticle( particle1, false )
			ParticleManager:ReleaseParticleIndex( particle1 )
			particle1 = nil

			-- Particle --
			ParticleManager:DestroyParticle( particle2, false )
			ParticleManager:ReleaseParticleIndex( particle2 )
			particle2 = nil

			for _,victim in pairs( affected_units ) do
				if IsPhysicsUnit(victim) then
					victim:SetPhysicsAcceleration(Vector(0,0,0))
					victim:SetPhysicsVelocity(Vector(0,0,0))
					victim:OnPhysicsFrame(nil)
				end
			end

			UTIL_Remove(ent)

		end)
		PersistentTimer_Add(timer1)

	end)
	PersistentTimer_Add(timer)

end

function treasure_on_a_tree_cursed_gold:OnAbilityPhaseStart()
	local caster			= self:GetCaster()
	local playerID			= caster:GetPlayerOwnerID()
	local player			= PlayerResource:GetPlayer(playerID)

	return true
end

function treasure_on_a_tree_cursed_gold:GetManaCost(abilitylevel)
	return self.BaseClass.GetManaCost(self, abilitylevel)
end

function treasure_on_a_tree_cursed_gold:GetCooldown(abilitylevel)
	return self.BaseClass.GetCooldown(self, abilitylevel)
end