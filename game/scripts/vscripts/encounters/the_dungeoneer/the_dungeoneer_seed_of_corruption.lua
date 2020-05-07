the_dungeoneer_seed_of_corruption = class({})

function the_dungeoneer_seed_of_corruption:OnSpellStart()

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
	local seed_count                  = self:GetSpecialValueFor("seed_count")

	DelayAbilityCooldown(caster, "the_dungeoneer_death_and_decay", duration, 2.0)
	DelayAbilityCooldown(caster, "the_dungeoneer_three_shell_game", duration, 2.0)

	caster:AddNewModifier(caster, self, "casting_rooted_modifier", {duration=duration/3})

	caster:Stop()

	-- Sound and Animation --
	local sound = {"grimstroke_grimstroke_ability2_04", "grimstroke_grimstroke_ability2_02_02",
					"grimstroke_grimstroke_ability4_12", "grimstroke_grimstroke_levelup_06"}
	EmitAnnouncerSound( sound[RandomInt(1, #sound)] )

	StartAnimation(caster, {duration=duration, activity=ACT_DOTA_TELEPORT_END, rate=0.8})

	for i=1,seed_count do

		local unit_loc = RandomLocationMinDistance( GetSpecificBorderPoint("point_center"), 750)
		local unit = CreateUnitByName("seed_of_corruption", unit_loc, true, nil, nil, DOTA_TEAM_BADGUYS)
		PersistentUnit_Add(unit)
		EncounterCreate_Health(unit)

		unit:FaceTowards( GetSpecificBorderPoint("point_center") )

		local count = 0
		for j=duration,1,-1 do

			local radius = AoERadius / j

			local timer = Timers:CreateTimer(count, function()
				if unit ~= nil then
				if not unit:IsNull() then
				if unit:IsAlive() then
					EncounterGroundAOEWarningSticky( unit_loc, radius, 1.0)
				end
				end
				end
			end)
			PersistentTimer_Add(timer)

			count = count + 1
		end

		local timer = Timers:CreateTimer(duration, function()

			if unit ~= nil then
			if not unit:IsNull() then
			if unit:IsAlive() then

				-- Particle --
				local particle = ParticleManager:CreateParticle("particles/encounter/the_dungeoneer/the_dungeoneer_seed_of_corruption.vpcf", PATTACH_CUSTOMORIGIN, nil)
				ParticleManager:SetParticleControl( particle, 0, unit_loc )
				PersistentParticle_Add(particle)

				local timer = Timers:CreateTimer(2.0, function()
					ParticleManager:DestroyParticle( particle, false )
					ParticleManager:ReleaseParticleIndex( particle )
					particle = nil
				end)
				PersistentTimer_Add(timer)
				
				local units	= FindUnitsInRadius(team, unit_loc, nil, AoERadius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
				for _,victim in pairs(units) do
					-- Apply Damage --
					EncounterApplyDamage(victim, caster, self, damage, DAMAGE_TYPE_MAGICAL, DOTA_DAMAGE_FLAG_NONE)
				end

				unit:RemoveSelf()

			end
			end
			end

		end)
		PersistentTimer_Add(timer)

	end
	
end

function the_dungeoneer_seed_of_corruption:OnAbilityPhaseStart()
	local caster			= self:GetCaster()
	local playerID			= caster:GetPlayerOwnerID()
	local player			= PlayerResource:GetPlayer(playerID)

	return true
end

function the_dungeoneer_seed_of_corruption:GetManaCost(abilitylevel)
	return self.BaseClass.GetManaCost(self, abilitylevel)
end

function the_dungeoneer_seed_of_corruption:GetCooldown(abilitylevel)
	return self.BaseClass.GetCooldown(self, abilitylevel)
end