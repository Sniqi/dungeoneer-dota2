treasure_on_a_tree_spiral_of_death = class({})

function treasure_on_a_tree_spiral_of_death:OnSpellStart()

	--- Get Caster, Victim, Player, Point ---
	local caster		= self:GetCaster()
	local caster_loc	= caster:GetAbsOrigin()
	local playerID		= caster:GetPlayerOwnerID()
	local player		= PlayerResource:GetPlayer(playerID)
	local team			= caster:GetTeamNumber()
	
	--- Get Special Values ---
	local duration                    = self:GetSpecialValueFor("duration")
	local damage                      = self:GetSpecialValueFor("damage")
	local delay                       = self:GetSpecialValueFor("delay")

	-- ChallengerMode 1 --
	if GameMode_Active == "Challenger" and ChallengerMode_Active == 1 then
		duration = duration * 1.5
	end

	local loc = caster:GetAbsOrigin() + Vector( RandomInt(-1000, 1000), RandomInt(-1000, 1000), 0 )  --RandomLocationMinDistance( GetSpecificBorderPoint("point_center"), 100)

	caster:AddNewModifier(caster, self, "casting_rooted_modifier", {duration=delay})
	
	StartAnimation(caster, {duration=delay, activity=ACT_DOTA_RUN, rate=0.40})

	TurnToLoc(caster, loc, delay)

	EncounterGroundAOEWarningSticky(loc, 50, delay+0.1)

	local timer1 = Timers:CreateTimer(delay, function()

		-- Sound and Animation --
		local sound = {"treant_treant_laugh_01", "treant_treant_laugh_02",
						"treant_treant_laugh_03", "treant_treant_laugh_13"}
		EmitAnnouncerSound( sound[RandomInt(1, #sound)] )

		StartSoundEventFromPositionReliable("Hero_Furion.Sprout", loc)
		
		StartAnimation(caster, {duration=delay, activity=ACT_DOTA_SPAWN, rate=1.75})

		local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_treant/treant_overgrowth_cast_tree.vpcf", PATTACH_CUSTOMORIGIN, nil)
		ParticleManager:SetParticleControl( particle, 0, loc )
		ParticleManager:ReleaseParticleIndex( particle )
		particle = nil

		local particle = ParticleManager:CreateParticle("particles/items3_fx/ggbranch_tree.vpcf", PATTACH_CUSTOMORIGIN, nil)
		ParticleManager:SetParticleControl( particle, 0, loc )
		PersistentParticle_Add(particle)

		local info = 
		{
			Ability = self,
			EffectName = "particles/encounter/treasure_on_a_tree/treasure_on_a_tree_spiral_of_death.vpcf",
			vSpawnOrigin = loc,
			iMoveSpeed = 425,
			fDistance = 3000,
			fStartRadius = 48,
			fEndRadius = 96,
			Source = caster,
			bIgnoreSource = true,
			bHasFrontalCone = false,
			bReplaceExisting = false,
			iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
			iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
			iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
			fExpireTime = GameRules:GetGameTime() + 40,
			bDeleteOnHit = false,
			vVelocity = 0.0,
			--vAcceleration = 0.0,
			--fMaxSpeed = 1000.0,
			bVisibleToEnemies = true,
		}

		-- Create Projectile --
		local projectile = {}
		local rotate = QAngle(0,0,0)

		local negative = false
		if RollPercentage(50) then
			negative = true
		end

		local timer = Timers:CreateTimer(duration/4, function()
			if RollPercentage(75) then
				if negative == true then negative = false end
				if negative == false then negative = true end
			end
		end)
		PersistentTimer_Add(timer)

		local timer = Timers:CreateTimer(duration/2, function()
			if RollPercentage(75) then
				if negative == true then negative = false end
				if negative == false then negative = true end
			end
		end)
		PersistentTimer_Add(timer)

		local timer = Timers:CreateTimer(duration/1.33333333333, function()
			if RollPercentage(75) then
				if negative == true then negative = false end
				if negative == false then negative = true end
			end
		end)
		PersistentTimer_Add(timer)

		local count = 0
		local timer = Timers:CreateTimer(0, function()

		local num_of_emitters = 4

		-- ChallengerMode 1 --
		if GameMode_Active == "Challenger" and ChallengerMode_Active == 1 then
			num_of_emitters = 6
			info.iMoveSpeed = info.iMoveSpeed * 0.975
		end

			for i=0,num_of_emitters-1 do

				--info.vVelocity = RotatePosition( Vector(0,0,0), QAngle(0,(90)*i,0)+rotate , Vector( RandomFloat(0.45,0.60) ,0,0) ) * info.iMoveSpeed --unit:GetForwardVector()
				info.vVelocity = RotatePosition( Vector(0,0,0), QAngle(0,(360/num_of_emitters)*i,0)+rotate , Vector( 0.50 ,0,0) ) * info.iMoveSpeed --unit:GetForwardVector()
				projectile[count+i] = ProjectileManager:CreateLinearProjectile(info)
				PersistentProjectile_Add(projectile[count+i])
			end

			local rotation = rotate

			if negative then
				--rotation = RotateOrientation(rotate, QAngle(0,RandomInt(-10,-25),0))
				rotation = RotateOrientation(rotate, QAngle(0,-6,0))

				-- ChallengerMode 1 --
				if GameMode_Active == "Challenger" and ChallengerMode_Active == 1 then
					rotation = RotateOrientation(rotate, QAngle(0,3,0))
				end
			else
				--rotation = RotateOrientation(rotate, QAngle(0,RandomInt(5,15),0))
				rotation = RotateOrientation(rotate, QAngle(0,6,0))

				-- ChallengerMode 1 --
				if GameMode_Active == "Challenger" and ChallengerMode_Active == 1 then
					rotation = RotateOrientation(rotate, QAngle(0,3,0))
				end
			end

			rotate = rotation
			
			count = count + num_of_emitters
			return 0.25
		end)
		PersistentTimer_Add(timer)

		local timer = Timers:CreateTimer(duration, function()

			Timers:RemoveTimer(timer)

			ParticleManager:DestroyParticle(particle, false)
			ParticleManager:ReleaseParticleIndex( particle )

		end)
		PersistentTimer_Add(timer)

	end)
	PersistentTimer_Add(timer1)

end


function treasure_on_a_tree_spiral_of_death:OnProjectileHit(hTarget, vLocation)

	local victim = hTarget

	if victim ~= nil then

		local caster = self:GetCaster()
		
		local damage = self:GetSpecialValueFor("damage")

		-- Apply Damage --
		EncounterApplyDamage(victim, caster, self, damage, DAMAGE_TYPE_MAGICAL, DOTA_DAMAGE_FLAG_NONE)
	end

	return true
end

function treasure_on_a_tree_spiral_of_death:OnAbilityPhaseStart()
	local caster			= self:GetCaster()
	local playerID			= caster:GetPlayerOwnerID()
	local player			= PlayerResource:GetPlayer(playerID)

	return true
end

function treasure_on_a_tree_spiral_of_death:GetManaCost(abilitylevel)
	return self.BaseClass.GetManaCost(self, abilitylevel)
end

function treasure_on_a_tree_spiral_of_death:GetCooldown(abilitylevel)
	return self.BaseClass.GetCooldown(self, abilitylevel)
end