nether_drake_twisted_nether = class({})

function nether_drake_twisted_nether:OnSpellStart()

	--- Get Caster, Victim, Player, Point ---
	local caster		= self:GetCaster()
	local caster_loc	= caster:GetAbsOrigin()
	local playerID		= caster:GetPlayerOwnerID()
	local player		= PlayerResource:GetPlayer(playerID)
	local team			= caster:GetTeamNumber()

	--- Get Special Values ---
	local duration                    = self:GetSpecialValueFor("duration")
	local delay                       = self:GetSpecialValueFor("delay")

	local location = caster_loc + Vector(0,0,150)

	EncounterUnitWarning(caster, delay, true, "red") --nil=yellow, "red", "orange", "green"

	local affected_units
	
	caster.twisted_nether = true
	caster.waitForCleanup = true

	caster:AddNewModifier(caster, self, "casting_rooted_modifier", {duration=delay+duration})
	DisableMotionControllers(caster, delay+duration)

	-- Animation --
	StartAnimation(caster, {duration=delay, activity=ACT_DOTA_FLAIL, rate=1.0})

	-- Sound --
	StartSoundEventReliable("Hero_Enigma.Midnight_Pulse", caster)
	PersistentSoundEvent_Add("Hero_Enigma.Midnight_Pulse", caster)

	-- Particle --
	local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_enigma/enigma_blackhole_h.vpcf", PATTACH_CUSTOMORIGIN, nil)
	ParticleManager:SetParticleControl( particle, 0, location )
	PersistentParticle_Add(particle)

	local timer = Timers:CreateTimer(delay, function()

		-- Particle --
		ParticleManager:DestroyParticle( particle, false )
		ParticleManager:ReleaseParticleIndex( particle )
		particle = nil

		-- Animation --
		StartAnimation(caster, {duration=duration, activity=ACT_DOTA_FLAIL, rate=0.5})

		-- Sound --
		StopSoundEvent("Hero_Enigma.Midnight_Pulse", caster)
		StartSoundEventReliable("Hero_Enigma.Black_Hole", caster)
		PersistentSoundEvent_Add("Hero_Enigma.Black_Hole", caster)

		-- Particle --
		particle = ParticleManager:CreateParticle("particles/units/heroes/hero_enigma/enigma_blackhole.vpcf", PATTACH_CUSTOMORIGIN, nil)
		ParticleManager:SetParticleControl( particle, 0, location )
		ParticleManager:SetParticleControl( particle, 1, location )
		PersistentParticle_Add(particle)

		affected_units = FindUnitsInRadius(team, caster_loc, nil, 5000, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)

		for _,victim in pairs( affected_units ) do
			if IsPhysicsUnit(victim) then
				-- Animation --
				StartAnimation(victim, {duration=duration, activity=ACT_DOTA_FLAIL, rate=1.0})

				-- Physics --
				victim:SetPhysicsVelocityMax(500)
				victim:PreventDI()

				local direction = location - victim:GetAbsOrigin()
				direction = direction:Normalized()
				victim:SetPhysicsAcceleration(direction * 400)

				local i = 0
				victim:OnPhysicsFrame(function(victim)

					if i == 3 then
						i = 0

						-- Retarget acceleration vector
						local distance = location - victim:GetAbsOrigin() - Vector(0,0,150)
						local direction = distance:Normalized()

						local factor = 5000 / distance:Length()
						if factor > 2 then factor = 2 end

						victim:SetPhysicsAcceleration(direction * 400 * factor)

						-- Stop if reached the unit
						if distance:Length() < 100 then
							victim:OnPhysicsFrame(nil)
							victim:SetPhysicsAcceleration(Vector(0,0,0))
							victim:SetPhysicsVelocity(Vector(0,0,0))

							-- Apply Damage --
							EncounterApplyDamage(victim, caster, self, 300, DAMAGE_TYPE_PURE, DOTA_DAMAGE_FLAG_BYPASSES_INVULNERABILITY + DOTA_DAMAGE_FLAG_BYPASSES_BLOCK + DOTA_DAMAGE_FLAG_NO_DAMAGE_MULTIPLIERS)
						end
					end

					i = i + 1
				end)
			end
		end

		for i=0,18 do
			local time = i * RandomFloat(0.03, 0.1)
			local timer = Timers:CreateTimer(time, function()
				self:pull_tree(time)
			end)
			PersistentTimer_Add(timer)
		end

	end)
	PersistentTimer_Add(timer)

	local timer = Timers:CreateTimer(delay+duration, function()

		-- Sound --
		StopSoundEvent("Hero_Enigma.Black_Hole", caster)
		StartSoundEventReliable("Hero_Enigma.Black_Hole.Stop", caster)

		-- Particle --
		ParticleManager:DestroyParticle( particle, false )
		ParticleManager:ReleaseParticleIndex( particle )
		particle = nil

		for _,victim in pairs( affected_units ) do
			if IsPhysicsUnit(victim) then
				victim:SetPhysicsAcceleration(Vector(0,0,0))
				victim:SetPhysicsVelocity(Vector(0,0,0))
				victim:OnPhysicsFrame(nil)
			end
		end

		caster.twisted_nether = false
		caster.waitForCleanup = false
	end)
	PersistentTimer_Add(timer)

end

function nether_drake_twisted_nether:pull_tree(time)

	--- Get Caster, Victim, Player, Point ---
	local caster		= self:GetCaster()

	if caster == nil then return end
	if caster:IsNull() then return end
	if not caster:IsAlive() then return end

	local caster_loc	= caster:GetAbsOrigin()
	local playerID		= caster:GetPlayerOwnerID()
	local player		= PlayerResource:GetPlayer(playerID)
	local team			= caster:GetTeamNumber()

	--- Get Special Values ---
	local duration                    = self:GetSpecialValueFor("duration")
	local delay                       = self:GetSpecialValueFor("delay")

	local trees = GridNav:GetAllTreesAroundPoint(caster_loc, 3000, true)
	if #trees > 0 then
		local tree = trees[ RandomInt(1, #trees) ]

		local tree_loc = tree:GetAbsOrigin()

		tree:CutDownRegrowAfter(8, DOTA_TEAM_GOODGUYS )

		local unit = CreateUnitByName("dummy", tree_loc, true, nil, nil, DOTA_TEAM_BADGUYS)
		PersistentUnit_Add(unit)
		unit:AddNewModifier(unit, nil, "modifier_dummy", {})
		unit:AddNewModifier(unit, nil, "modifier_phased", {})
		unit:AddNewModifier(unit, nil, "modifier_creature_hybrid_flyer", {})

		local speed = ( ( caster_loc - tree_loc ):Length2D() ) / ( duration - time )

		unit:SetBaseMoveSpeed(speed)

		local timer = Timers:CreateTimer(0.05, function()
			unit:Stop()
		end)
		PersistentTimer_Add(timer)

		local timer = Timers:CreateTimer(0.1, function()
			local Order = {
					UnitIndex = unit:entindex(), 
					OrderType = DOTA_UNIT_ORDER_MOVE_TO_TARGET,
					TargetIndex = caster:entindex(),
				}
			--ExecuteOrderFromTable(Order)

			unit:MoveToNPC(caster)
		end)
		PersistentTimer_Add(timer)

		-- Particle --
		local particle = ParticleManager:CreateParticle("particles/encounter/nether_drake/nether_drake_twisted_nether_tree.vpcf", PATTACH_ABSORIGIN_FOLLOW, unit)
		ParticleManager:SetParticleControl( particle, 0, unit:GetAbsOrigin() + Vector(0,0,150) )
		PersistentParticle_Add(particle)

		local timer = Timers:CreateTimer(duration-time, function()

			ParticleManager:ReleaseParticleIndex( particle )
			particle = nil

			unit:RemoveSelf()

		end)
		PersistentTimer_Add(timer)
	end

end

function nether_drake_twisted_nether:OnAbilityPhaseStart()
	local caster			= self:GetCaster()
	local playerID			= caster:GetPlayerOwnerID()
	local player			= PlayerResource:GetPlayer(playerID)

	return true
end

function nether_drake_twisted_nether:GetManaCost(abilitylevel)
	return self.BaseClass.GetManaCost(self, abilitylevel)
end

function nether_drake_twisted_nether:GetCooldown(abilitylevel)
	return self.BaseClass.GetCooldown(self, abilitylevel)
end