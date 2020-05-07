a_mighty_boar_trample = class({})

LinkLuaModifier( 'a_mighty_boar_trample_modifier', 'encounters/a_mighty_boar/a_mighty_boar_trample_modifier', LUA_MODIFIER_MOTION_NONE )

function a_mighty_boar_trample:OnSpellStart()

	--- Get Caster, Victim, Player, Point ---
	local caster		= self:GetCaster()
	local caster_loc	= caster:GetAbsOrigin()
	local playerID		= caster:GetPlayerOwnerID()
	local player		= PlayerResource:GetPlayer(playerID)
	local team			= caster:GetTeamNumber()
	
	--- Get Special Values ---
	local AoERadius                   = self:GetSpecialValueFor("AoERadius")
	local damage                      = self:GetSpecialValueFor("damage")
	local push_force                  = self:GetSpecialValueFor("push_force")
	local phase_two                   = self:GetSpecialValueFor("phase_two")
	local burning_trail_damage        = self:GetSpecialValueFor("burning_trail_damage")
	local burning_trail_damage_duration= self:GetSpecialValueFor("burning_trail_damage_duration")
	local burning_trail_damage_interval= self:GetSpecialValueFor("burning_trail_damage_interval")
	local burning_trail_aoe           = self:GetSpecialValueFor("burning_trail_aoe")

	caster:AddNewModifier(caster, self, "casting_rooted_modifier", {})
	caster:AddNewModifier(caster, self, "turn_rate_modifier", { duration=6.5 })

	local loc_start = GetRandomBorderPoint()

	caster_loc	= caster:GetAbsOrigin()
	self.traveled = 0
	self.initial_distance = (loc_start - caster_loc):Length2D()
	self.velocity = 133
	self.life_break_z = 0.0

	-- ChallengerMode 1 --
	if GameMode_Active == "Challenger" and ChallengerMode_Active == 1 then self.velocity = 233 end

	self.warnings_steps = AoERadius
	self.warnings_count = self.initial_distance / self.warnings_steps

	self.timers = {}

	-- Sound --
	caster:EmitSound("Hero_Huskar.Life_Break")

	caster:StartGestureWithPlaybackRate(ACT_DOTA_RUN, 5.0)

	self.timer = Timers:CreateTimer(0.0, function()
		a_mighty_boar_trample:JumpHorizonal( caster, self, loc_start )
		a_mighty_boar_trample:JumpVertical( caster, self, loc_start )

		caster:SetForwardVector( loc_start - caster_loc )

		return 0.03
	end)
	PersistentTimer_Add(self.timer)

	local location
	local interval = 2.0

	-- ChallengerMode 1 --
	if GameMode_Active == "Challenger" and ChallengerMode_Active == 1 then interval = 1.55 end

	local timer1 = Timers:CreateTimer(0.5, function()
		location = a_mighty_boar_trample:Charge(self, loc_start)

		local timer2 = Timers:CreateTimer(interval, function()
			location = a_mighty_boar_trample:Charge(self, location)

			local timer3 = Timers:CreateTimer(interval, function()
				location = a_mighty_boar_trample:Charge(self, location)

				local timer4 = Timers:CreateTimer(interval, function()
					caster:RemoveModifierByName("casting_rooted_modifier")
				end)
				PersistentTimer_Add(timer4)
			end)
			PersistentTimer_Add(timer3)
		end)
		PersistentTimer_Add(timer2)
	end)
	PersistentTimer_Add(timer1)

end

function a_mighty_boar_trample:Charge(ability, loc_start)

	local caster		= ability:GetCaster()
	local caster_loc	= caster:GetAbsOrigin()
	local playerID		= caster:GetPlayerOwnerID()
	local player		= PlayerResource:GetPlayer(playerID)
	local team			= caster:GetTeamNumber()

	--- Get Special Values ---
	local AoERadius                   = ability:GetSpecialValueFor("AoERadius")
	local damage                      = ability:GetSpecialValueFor("damage")
	local push_force                  = ability:GetSpecialValueFor("push_force")
	local phase_two                   = ability:GetSpecialValueFor("phase_two")
	local burning_trail_damage        = ability:GetSpecialValueFor("burning_trail_damage")
	local burning_trail_damage_duration= ability:GetSpecialValueFor("burning_trail_damage_duration")
	local burning_trail_damage_interval= ability:GetSpecialValueFor("burning_trail_damage_interval")
	local burning_trail_aoe           = ability:GetSpecialValueFor("burning_trail_aoe")

	local loc_end = GetRandomBorderPointCounterpart(loc_start)

	caster:Stop()

	caster:RemoveModifierByName("turn_rate_modifier")
	local timer1 = Timers:CreateTimer(0.0, function()
		caster:FaceTowards(loc_end)
		return 0.03
	end)
	PersistentTimer_Add(timer1)

	local timer2 = Timers:CreateTimer(0.45, function()
		Timers:RemoveTimer(timer1)
		timer1 = nil
	end)
	PersistentTimer_Add(timer2)

	local count = 0
	local timer3 = Timers:CreateTimer(0.50, function()
		caster_loc	= caster:GetAbsOrigin()
		ability.traveled = 0
		ability.initial_distance = (loc_end - caster_loc):Length2D()

		ability.warnings_steps = AoERadius
		ability.warnings_count = ability.initial_distance / ability.warnings_steps

		local location = caster:GetAbsOrigin() + ( (caster:GetForwardVector() * ability.warnings_steps) * count )
		location = location * Vector(1,1,0)
		location = location + ( GetGroundPosition(location, caster) * Vector(0,0,1) )
		EncounterGroundAOEWarningSticky( location, AoERadius, 1.5)

		count = count + 1
		if count >= ability.warnings_count then
			return
		else
			return 0.03
		end
	end)
	PersistentTimer_Add(timer3)

	local timer4 = Timers:CreateTimer(1.33, function()
		-- Sound --
		caster:EmitSound("Hero_Huskar.Life_Break")

		caster:StartGestureWithPlaybackRate(ACT_DOTA_RUN, 5.0)

		caster:AddNewModifier(caster, ability, "a_mighty_boar_trample_modifier", {})

		ability.timer = Timers:CreateTimer(0.0, function()
			a_mighty_boar_trample:JumpHorizonal( caster, ability, loc_end )
			a_mighty_boar_trample:JumpVertical( caster, ability, loc_end )

			caster:SetForwardVector( loc_end - caster_loc )

			return 0.03
		end)
		PersistentTimer_Add(ability.timer)

		-- PHASE 2 --
		if caster:GetHealthPercent() < phase_two then

			local timer5 = Timers:CreateTimer(0, function()
				if caster == nil then return end
				if caster:IsNull() then return end
				if not caster:IsAlive() then return end

				local caster_loc = caster:GetAbsOrigin() + Vector( RandomInt(-200,200), RandomInt(-200,200), 0 )

				-- Particle --
				local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_batrider/batrider_firefly.vpcf", PATTACH_CUSTOMORIGIN, nil)
				ParticleManager:SetParticleControl( particle, 0, caster_loc )
				PersistentParticle_Add(particle)

				EncounterGroundAOEWarningSticky(caster_loc, burning_trail_aoe, burning_trail_damage_duration)

				local timer6 = Timers:CreateTimer(0, function()

					-- DOTA_UNIT_TARGET_TEAM_FRIENDLY; DOTA_UNIT_TARGET_TEAM_ENEMY; DOTA_UNIT_TARGET_TEAM_BOTH
					local units	= FindUnitsInRadius(team, caster_loc, nil, burning_trail_aoe, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
					local particle = {}
					for _,victim in pairs(units) do
					
						-- Sound --
						victim:EmitSound("Hero_Batrider.Firefly.Cast")

						-- Apply Damage --
						EncounterApplyDamage(victim, caster, self, burning_trail_damage*burning_trail_damage_interval, DAMAGE_TYPE_MAGICAL, DOTA_DAMAGE_FLAG_NONE)
					end

					return burning_trail_damage_interval
				end)
				PersistentTimer_Add(timer6)

				local timer7 = Timers:CreateTimer(burning_trail_damage_duration, function()

					Timers:RemoveTimer(timer6)
					timer6 = nil

					ParticleManager:DestroyParticle( particle, false )
					ParticleManager:ReleaseParticleIndex( particle )
					particle = nil

				end)
				PersistentTimer_Add(timer5)

				return 0.05
			end)
			PersistentTimer_Add(timer7)

			local timer8 = Timers:CreateTimer(0.5, function()
				Timers:RemoveTimer(timer5)
				timer5 = nil
			end)
			PersistentTimer_Add(timer8)
		end
		-- PHASE 2 END --


	end)
	PersistentTimer_Add(timer4)

	return loc_end
end

function a_mighty_boar_trample:OnMotionDone( caster, ability, loc )

	FindClearSpaceForUnit(caster, caster:GetAbsOrigin(), false)

	-- Timer --
	Timers:RemoveTimer(ability.timer)

	-- Modifier --
	--caster:RemoveModifierByName("casting_rooted_modifier")
	caster:RemoveModifierByName("a_mighty_boar_trample_modifier")

	-- Animation --
	caster:RemoveGesture(ACT_DOTA_RUN)

	-- Move the caster to the ground
	caster:SetAbsOrigin(GetGroundPosition(caster:GetAbsOrigin(), caster))
	caster:SetAngles(0, caster:GetAngles().y, 0)

end


--[[Moves the caster on the horizontal axis until it has traveled the distance]]
function a_mighty_boar_trample:JumpHorizonal( caster, ability, loc )
	-- Variables
	local victim_loc = loc
	local caster_loc = GetGroundPosition(caster:GetAbsOrigin(), caster)
	local direction = (victim_loc - caster_loc):Normalized()

	-- Particle --
	local particle = ParticleManager:CreateParticle("particles/econ/items/earthshaker/egteam_set/hero_earthshaker_egset/earthshaker_fissure_dust_egset.vpcf", PATTACH_ABSORIGIN, caster)
	ParticleManager:SetParticleControl( particle, 0, caster:GetAbsOrigin() )
	ParticleManager:SetParticleControl( particle, 1, caster:GetAbsOrigin() )
	ParticleManager:ReleaseParticleIndex( particle )
	particle = nil

	--local max_distance = ability:GetLevelSpecialValueFor("max_distance", ability:GetLevel()-1)

	-- Max distance break condition
	--if (victim_loc - caster_loc):Length2D() >= max_distance then
	--	caster:InterruptMotionControllers(true)
	--end

	-- Moving the caster closer to the victim until it reaches the enemy
	if (victim_loc - caster_loc):Length2D() > 200 then
		caster:SetAbsOrigin(caster:GetAbsOrigin() + direction * ability.velocity)
		ability.traveled = ability.traveled + ability.velocity
	else
		caster:InterruptMotionControllers(true)

		-- Move the caster to the ground
		caster:SetAbsOrigin(GetGroundPosition(caster:GetAbsOrigin(), caster))

		a_mighty_boar_trample:OnMotionDone(caster, ability, loc)
	end
end

--[[Moves the caster on the vertical axis until movement is interrupted]]
function a_mighty_boar_trample:JumpVertical( caster, ability, loc )
	-- Variables
	local caster_loc = caster:GetAbsOrigin()
	local caster_loc_ground = GetGroundPosition(caster_loc, caster)

	-- If we happen to be under the ground just pop the caster up
	if caster_loc.z < caster_loc_ground.z then
		caster:SetAbsOrigin(caster_loc_ground)
	end

--[[
	-- For the first half of the distance the caster goes up and for the second half it goes down
	if ability.traveled < ability.initial_distance/2 then
		-- Go up
		-- This is to memorize the z point when it comes to cliffs and such although the division of speed by 2 isnt necessary, its more of a cosmetic thing
		ability.life_break_z = ability.life_break_z + ability.velocity/2
		-- Set the new location to the current ground location + the memorized z point
		caster:SetAbsOrigin(caster_loc_ground + Vector(0,0,ability.life_break_z))
	elseif caster_loc.z > caster_loc_ground.z then
		-- Go down
		ability.life_break_z = ability.life_break_z - ability.velocity/2
		caster:SetAbsOrigin(caster_loc_ground + Vector(0,0,ability.life_break_z))
    end
]]
end


function a_mighty_boar_trample:OnAbilityPhaseStart()
	local caster			= self:GetCaster()
	local playerID			= caster:GetPlayerOwnerID()
	local player			= PlayerResource:GetPlayer(playerID)

	return true
end

function a_mighty_boar_trample:GetManaCost(abilitylevel)
	return self.BaseClass.GetManaCost(self, abilitylevel)
end

function a_mighty_boar_trample:GetCooldown(abilitylevel)
	return self.BaseClass.GetCooldown(self, abilitylevel)
end