stikx_the_gentleman_mega_coin = class({})

function stikx_the_gentleman_mega_coin:OnSpellStart()

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
	local coin_spawn_distance         = self:GetSpecialValueFor("coin_spawn_distance")

	caster:AddNewModifier(caster, self, "casting_rooted_modifier", {duration=delay+0.1})

	caster:Stop()

	-- Sound and Animation --
	local sound = {"monkey_king_monkey_lasthit_04", "monkey_king_monkey_bounty_02",
					"monkey_king_monkey_bounty_03", "monkey_king_monkey_bottle_03"}
	EmitAnnouncerSound( sound[RandomInt(1, #sound)] )
	
	StartAnimation(caster, {duration=delay, activity=ACT_DOTA_SPAWN, rate=0.5})

	-- Particle --
	local particle = ParticleManager:CreateParticle("particles/econ/events/ti6/teleport_end_ti6_ground_flash.vpcf", PATTACH_ABSORIGIN, caster)
	ParticleManager:SetParticleControl( particle, 0, caster:GetAbsOrigin() )
	PersistentParticle_Add(particle)

	-- Sound --
	caster:EmitSound("Hero_QueenOfPain.Blink_out")

	local timer = Timers:CreateTimer(2.0, function()
		ParticleManager:DestroyParticle( particle, false )
		ParticleManager:ReleaseParticleIndex( particle )
		particle = nil
	end)
	PersistentTimer_Add(timer)

	-- Port to top left, facing right, disable turning
	local location = RandomLocationMinDistance( GetSpecificBorderPoint("point_center"), 300 * RandomFloat(0.1, 1.0) )
	FindClearSpaceForUnit(caster, location, false)

	DisableMotionControllers(caster, delay)

	local loc = RandomLocationMinDistance( caster:GetAbsOrigin(), coin_spawn_distance)

	local ent = SpawnEntityFromTableSynchronous("prop_dynamic", {model = "models/props_gameplay/gold_coin001.vmdl", DefaultAnim="gold_coin001_idle", targetname=DoUniqueString("stikx_the_gentleman_mega_coin")})
	ent:SetAbsOrigin( GetGroundPosition( loc, caster ) )
	ent:SetModelScale( 1.25 )
	PersistentEntity_Add(ent)
	
	EncounterGroundAOEWarningSticky(loc, 100, delay*1.5, Vector(0,255,0))

	-- Sound --
	StartSoundEventFromPositionReliable("General.Coins", loc)

	-- Particle --
	local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_brewmaster/brewmaster_primal_split_explosion_swirl.vpcf", PATTACH_CUSTOMORIGIN, nil)
	ParticleManager:SetParticleControl( particle, 0, loc )
	ParticleManager:ReleaseParticleIndex( particle )
	particle = nil

	local timer = Timers:CreateTimer(delay, function()

		caster:AddNewModifier(caster, self, "casting_modifier", {})

		caster:MoveToPosition(loc)

	end)
	PersistentTimer_Add(timer)

	local timer = Timers:CreateTimer(delay+0.1, function()

		-- DOTA_UNIT_TARGET_TEAM_FRIENDLY; DOTA_UNIT_TARGET_TEAM_ENEMY; DOTA_UNIT_TARGET_TEAM_BOTH
		local units	= FindUnitsInRadius(team, loc, nil, 100, DOTA_UNIT_TARGET_TEAM_BOTH, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_CLOSEST, false)

		for _,victim in ipairs(units) do
			if _ > 1 then break end

			UTIL_Remove(ent)

			caster:FindModifierByName("casting_modifier"):Destroy()

			-- Sound --
			StartSoundEventFromPositionReliable("General.CoinsBig", loc)

			if victim:GetTeamNumber() == DOTA_TEAM_GOODGUYS then

				caster:Stop()

				-- Sound and Animation --
				local sound = {"monkey_king_monkey_anger_09", "monkey_king_monkey_anger_11",
								"monkey_king_monkey_anger_13", "monkey_king_monkey_anger_14"}
				EmitAnnouncerSound( sound[RandomInt(1, #sound)] )

				return nil
			end


			if victim:GetTeamNumber() == DOTA_TEAM_BADGUYS then

				-- Sound and Animation --
				local sound = {"monkey_king_monkey_laugh_12", "monkey_king_monkey_laugh_15",
								"monkey_king_monkey_laugh_16", "monkey_king_monkey_laugh_09"}
				EmitAnnouncerSound( sound[RandomInt(1, #sound)] )

				StartAnimation(caster, {duration=1.25, activity=ACT_DOTA_SPAWN, rate=1.5})

				-- Sound --
				StartSoundEventFromPositionReliable("Hero_Luna.LucentBeam.Cast", loc)
				
				-- Particle --
				local particle = ParticleManager:CreateParticle("particles/encounter/stikx_the_gentleman/stikx_the_gentleman_mega_coin.vpcf", PATTACH_CUSTOMORIGIN, nil)
				ParticleManager:SetParticleControl( particle, 0, loc )
				ParticleManager:ReleaseParticleIndex( particle )
				particle = nil
				
				-- DOTA_UNIT_TARGET_TEAM_FRIENDLY; DOTA_UNIT_TARGET_TEAM_ENEMY; DOTA_UNIT_TARGET_TEAM_BOTH
				local units	= FindUnitsInRadius(team, loc, nil, AoERadius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
				for _,victim in pairs(units) do

					-- Sound --
					StartSoundEventFromPositionReliable("Hero_Luna.LucentBeam.Cast", victim:GetAbsOrigin() )

					-- Apply Damage --
					EncounterApplyDamage(victim, caster, self, damage, DAMAGE_TYPE_PURE, DOTA_DAMAGE_FLAG_BYPASSES_BLOCK + DOTA_DAMAGE_FLAG_BYPASSES_INVULNERABILITY)

				end

				return nil
			end

		end

		return 0.1
	end)
	PersistentTimer_Add(timer)

end

function stikx_the_gentleman_mega_coin:OnAbilityPhaseStart()
	local caster			= self:GetCaster()
	local playerID			= caster:GetPlayerOwnerID()
	local player			= PlayerResource:GetPlayer(playerID)

	return true
end

function stikx_the_gentleman_mega_coin:GetManaCost(abilitylevel)
	return self.BaseClass.GetManaCost(self, abilitylevel)
end

function stikx_the_gentleman_mega_coin:GetCooldown(abilitylevel)
	return self.BaseClass.GetCooldown(self, abilitylevel)
end