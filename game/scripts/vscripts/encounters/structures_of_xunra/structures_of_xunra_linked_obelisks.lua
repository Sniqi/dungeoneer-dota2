structures_of_xunra_linked_obelisks = class({})

function structures_of_xunra_linked_obelisks:OnSpellStart()

	if self.casted then return end
	self.casted = true

	--- Get Caster, Victim, Player, Point ---
	local caster		= self:GetCaster()
	local caster_loc	= caster:GetAbsOrigin()
	local playerID		= caster:GetPlayerOwnerID()
	local player		= PlayerResource:GetPlayer(playerID)
	local team			= caster:GetTeamNumber()
	
	--- Get Special Values ---
	--local delay                       = self:GetSpecialValueFor("delay")

	DisableMotionControllers(caster, -1)
	
	local modifier_invulnerable = caster:AddNewModifier(caster, self, "modifier_invulnerable", {})

	caster:Stop()

	caster:SetHullRadius(225)

	self.units = {}

	for i=1,4 do

		local loc
		local name_addition

		if i == 1 then
			loc = GetSpecificBorderPoint("point_top_left") + Vector(500,-500,0)
			name_addition = "Top Left"
		elseif i == 2 then
			loc = GetSpecificBorderPoint("point_top_right") + Vector(-500,-500,0)
			name_addition = "Top Right"
		elseif i == 3 then
			loc = GetSpecificBorderPoint("point_bottom_right") + Vector(-500,500,0)
			name_addition = "Bottom Right"
		elseif i == 4 then
			loc = GetSpecificBorderPoint("point_bottom_left") + Vector(500,500,0)
			name_addition = "Bottom Left"
		end

		local unit = CreateUnitByName("npc_dota_hero_structures_of_xunra_linked_obelisks", loc, true, nil, nil, DOTA_TEAM_BADGUYS)
		PersistentUnit_Add(unit)
		table.insert(self.units, unit)

		EncounterCreate_AttackDamage(unit)
		EncounterCreate_Health(unit)
		EncounterCreate_HPBars(unit, name_addition)

		DisableMotionControllers(unit, -1)

		unit:AddNewModifier(unit, nil, "modifier_phased", {})

		unit:Stop()

		-- Create Particle --
		local particle = ParticleManager:CreateParticle("particles/encounter/structures_of_xunra/structures_of_xunra_linked_obelisks_beam_1.vpcf", PATTACH_CUSTOMORIGIN, nil)
		ParticleManager:SetParticleControl( particle, 0, caster:GetAbsOrigin() + Vector(0,0,400) )
		ParticleManager:SetParticleControl( particle, 1, unit:GetAbsOrigin() + Vector(0,0,350) )
		ParticleManager:SetParticleControl( particle, 10, Vector(1,0,0) )
		ParticleManager:SetParticleControl( particle, 11, Vector(1,0,0) )
		PersistentParticle_Add(particle)

		local timer = Timers:CreateTimer(0.1, function()

			if not unit:IsAlive() then
				ParticleManager:DestroyParticle( particle, false )
				ParticleManager:ReleaseParticleIndex( particle )
				particle = nil

				return
			end

			return 0.1
		end)
		PersistentTimer_Add(timer)

	end

	local timer = Timers:CreateTimer(0.1, function()

		local alive = 0

		for _,unit in pairs(self.units) do
			if unit ~= nil then
			if not unit:IsNull() then
			if unit:IsAlive() then
				alive = alive + 1
			end
			end
			end
		end

		if alive == 0 then

			modifier_invulnerable:Destroy()

			return
		end

		return 0.1
	end)
	PersistentTimer_Add(timer)

end

function structures_of_xunra_linked_obelisks:OnAbilityPhaseStart()
	local caster			= self:GetCaster()
	local playerID			= caster:GetPlayerOwnerID()
	local player			= PlayerResource:GetPlayer(playerID)

	return true
end

function structures_of_xunra_linked_obelisks:GetManaCost(abilitylevel)
	return self.BaseClass.GetManaCost(self, abilitylevel)
end

function structures_of_xunra_linked_obelisks:GetCooldown(abilitylevel)
	return self.BaseClass.GetCooldown(self, abilitylevel)
end