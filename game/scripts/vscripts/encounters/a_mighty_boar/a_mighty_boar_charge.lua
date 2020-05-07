a_mighty_boar_charge = class({})

function a_mighty_boar_charge:OnSpellStart()

	local victim		= GetRandomHeroEntities(1)
	if not victim then return end
	victim				= victim[1]
	local victim_loc	= victim:GetAbsOrigin()

	--- Get Caster, Victim, Player, Point ---
	local caster		= self:GetCaster()
	local caster_loc	= caster:GetAbsOrigin()
	local playerID		= caster:GetPlayerOwnerID()
	local player		= PlayerResource:GetPlayer(playerID)
	local team			= caster:GetTeamNumber()

	--- Get Special Values ---
	local damage                      = self:GetSpecialValueFor("damage")
	local delay                       = self:GetSpecialValueFor("delay")
	local stun                        = self:GetSpecialValueFor("stun")
	local push_force                  = self:GetSpecialValueFor("push_force")

	caster:AddNewModifier(caster, self, "casting_rooted_modifier", {})

	self.traveled = 0
	self.initial_distance = (victim_loc - caster_loc):Length2D()
	self.velocity = 133
	self.life_break_z = 0.0

	-- Sound --
	victim:EmitSound("Hero_Huskar.Life_Break")

	caster:StartGestureWithPlaybackRate(ACT_DOTA_RUN, 5.0)

	self.timer = Timers:CreateTimer(delay, function()
		a_mighty_boar_charge:JumpHorizonal( caster, self, victim )
		a_mighty_boar_charge:JumpVertical( caster, self, victim )

		caster:SetForwardVector( victim_loc - caster_loc )

		return 0.03
	end)
	PersistentTimer_Add(self.timer)

end

function a_mighty_boar_charge:OnMotionDone( caster, ability, victim )

	--- Get Special Values ---
	local damage                      = ability:GetSpecialValueFor("damage")
	local delay                       = ability:GetSpecialValueFor("delay")
	local stun                        = ability:GetSpecialValueFor("stun")
	local push_force                  = ability:GetSpecialValueFor("push_force")
	local push_damage                 = ability:GetSpecialValueFor("push_damage")

	FindClearSpaceForUnit(caster, caster:GetAbsOrigin(), false)

	-- Timer --
	Timers:RemoveTimer(ability.timer)

	-- Modifier --
	caster:RemoveModifierByName("casting_rooted_modifier")

	-- Animation --
	caster:RemoveGesture(ACT_DOTA_RUN)

	-- Sound --
	victim:EmitSound("Hero_Spirit_Breaker.GreaterBash")

	-- Particle --
	local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_sandking/sandking_sandstorm_eruption_dust_low.vpcf", PATTACH_ABSORIGIN, victim)
	ParticleManager:SetParticleControlEnt( particle, 0, victim, PATTACH_ABSORIGIN, nil, victim:GetAbsOrigin(), true)
	ParticleManager:ReleaseParticleIndex( particle )
	particle = nil

	-- Move the caster to the ground
	caster:SetAbsOrigin(GetGroundPosition(caster:GetAbsOrigin(), caster))
	caster:SetAngles(0, caster:GetAngles().y, 0)

	-- Modifier --
	local modifier = victim:AddNewModifier(caster, ability, "modifier_stunned", {duration = stun})
	PersistentModifier_Add(modifier)

	-- Apply Damage --
	EncounterApplyDamage(victim, caster, ability, damage, DAMAGE_TYPE_PHYSICAL, DOTA_DAMAGE_FLAG_BYPASSES_BLOCK)

    victim:SetRebounceFrames(12)
	victim:AddPhysicsVelocity(caster:GetForwardVector() * push_force)
	victim:OnBounce(function(victim, normal)
		EncounterApplyDamage(victim, caster, ability, push_damage, DAMAGE_TYPE_PHYSICAL, DOTA_DAMAGE_FLAG_NONE)
	end)



end


--[[Moves the caster on the horizontal axis until it has traveled the distance]]
function a_mighty_boar_charge:JumpHorizonal( caster, ability, victim )
	-- Variables
	local victim_loc = GetGroundPosition(victim:GetAbsOrigin(), victim)
	local caster_loc = GetGroundPosition(caster:GetAbsOrigin(), caster)
	local direction = (victim_loc - caster_loc):Normalized()

	-- Particle --
	local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_sandking/sandking_sandstorm_eruption_dust_low.vpcf", PATTACH_ABSORIGIN, caster)
	ParticleManager:SetParticleControl( particle, 0, caster:GetAbsOrigin() )
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

		a_mighty_boar_charge:OnMotionDone(caster, ability, victim)
	end
end

--[[Moves the caster on the vertical axis until movement is interrupted]]
function a_mighty_boar_charge:JumpVertical( caster, ability, victim )
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

function a_mighty_boar_charge:OnAbilityPhaseStart()
	local caster			= self:GetCaster()
	local playerID			= caster:GetPlayerOwnerID()
	local player			= PlayerResource:GetPlayer(playerID)

	return true
end

function a_mighty_boar_charge:GetManaCost(abilitylevel)
	return self.BaseClass.GetManaCost(self, abilitylevel)
end

function a_mighty_boar_charge:GetCooldown(abilitylevel)
	return self.BaseClass.GetCooldown(self, abilitylevel)
end