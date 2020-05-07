artifact_ability = class({})

function artifact_ability:OnSpellStart()

	--- Get Caster, Victim, Player, Point ---
	local caster		= self:GetCaster()
	local caster_loc	= caster:GetAbsOrigin()
	local playerID		= caster:GetPlayerOwnerID()
	local player		= PlayerResource:GetPlayer(playerID)
	local team			= caster:GetTeamNumber()
	local perkName		= self.perkName
	local perkID		= self.perkID

	--- Get Special Values ---
	--local AoERadius                   = self:GetSpecialValueFor("AoERadius")

	local modifiers = caster:FindAllModifiersByName( perkName )

	for i,mod in ipairs( modifiers ) do

		if tonumber(mod.perkID) == perkID then

			mod.activated = true

			self:StartCooldown(mod.cooldown)

			break

		end
	end

--[[
	for i,mod in ipairs( modifiers ) do

		if tonumber(mod.perkID) == perkID then

			if PERK_ABILITY_COOLDOWN1[playerID] == nil then
				mod.activated = true

				local time = mod.cooldown

				if DEBUG then
					time = 5
				end

				PERK_ABILITY_COOLDOWN1[playerID] = Timers:CreateTimer(function()
					CustomGameEventManager:Send_ServerToPlayer(player, "on_update_activeperks_ability_cooldown", { name=perkName, id=perkID, time=time } )

					time = time - 1

					if time == 0 then return end
					return 1.0
				end)

				PERK_ABILITY_COOLDOWN2[playerID] = Timers:CreateTimer(time+1, function()
					Timers:RemoveTimer( PERK_ABILITY_COOLDOWN1[playerID] )
					PERK_ABILITY_COOLDOWN1[playerID] = nil
				end)

			end

			break

		end
	end
]]

end

function artifact_ability:OnAbilityPhaseStart()
	local caster			= self:GetCaster()
	local playerID			= caster:GetPlayerOwnerID()
	local player			= PlayerResource:GetPlayer(playerID)

	return true
end

function artifact_ability:GetManaCost(abilitylevel)
	return self.BaseClass.GetManaCost(self, abilitylevel)
end

function artifact_ability:GetCooldown(abilitylevel)
--[[
	local caster = self:GetCaster()

	local cooldown = 0

	if caster:HasModifier("cooldown_modifier_ability") then
		cooldown = caster:GetModifierStackCount("cooldown_modifier_ability", caster)
	end

	return cooldown--self.BaseClass.GetCooldown(self, abilitylevel)
]]
	return self.BaseClass.GetCooldown(self, abilitylevel)
end

function artifact_ability:GetCastRange(vLocation, hTarget)

	local caster = self:GetCaster()

	local cast_range = 0

	if caster:HasModifier("castrange_modifier_ability") then
		cast_range = caster:GetModifierStackCount("castrange_modifier_ability", caster)
	end

	return cast_range--self.BaseClass.GetCastRange(self, vLocation, hTarget)
end