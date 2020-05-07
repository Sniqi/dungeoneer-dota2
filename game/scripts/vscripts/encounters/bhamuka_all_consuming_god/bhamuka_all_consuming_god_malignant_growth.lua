bhamuka_all_consuming_god_malignant_growth = class({})

function bhamuka_all_consuming_god_malignant_growth:OnSpellStart()

	--- Get Caster, Victim, Player, Point ---
	local caster		= self:GetCaster()
	local caster_loc	= caster:GetAbsOrigin()
	local playerID		= caster:GetPlayerOwnerID()
	local player		= PlayerResource:GetPlayer(playerID)
	local team			= caster:GetTeamNumber()
	local victim		= caster
	local victim_loc	= victim:GetAbsOrigin()
	
	if self.units == nil then

		self.units = {}
		self.timer = {}

		for i=0,3 do

			local offset = nil
			if i == 0 then offset = Vector(-125,-175,0) end
			if i == 1 then offset = Vector(-75,-275,0) end
			if i == 2 then offset = Vector(75,-275,0) end
			if i == 3 then offset = Vector(125,-175,0) end

			local unit_loc = caster:GetAbsOrigin() + offset
			local unit = CreateUnitByName("npc_dota_hero_bhamuka_all_consuming_god_tentacle", unit_loc, false, nil, nil, DOTA_TEAM_BADGUYS)
			PersistentUnit_Add(unit)
			EncounterCreate_Health(unit)
			DisableMotionControllers(unit, -1)

			table.insert(self.units, unit)

			--unit:SetOriginalModel("models/heroes/tidehunter/tidehuntertentacle.vmdl")
			--unit:SetModel("models/heroes/tidehunter/tidehuntertentacle.vmdl")
			unit:SetModelScale(18.0)
			--unit:ManageModelChanges()

			unit:Stop()

			local timer1 = Timers:CreateTimer(math.abs(0.5-i), function()

				-- Particle --
				local particle = ParticleManager:CreateParticle("particles/encounter/bhamuka_all_consuming_god/bhamuka_all_consuming_god_malignant_growth.vpcf", PATTACH_ABSORIGIN_FOLLOW, unit)
				ParticleManager:SetParticleControl( particle, 0, unit_loc )
				PersistentParticle_Add(particle)

				local timer2 = Timers:CreateTimer(10.0, function()
					ParticleManager:DestroyParticle( particle, false )
					ParticleManager:ReleaseParticleIndex( particle )
					particle = nil
				end)
				PersistentTimer_Add(timer2)

				return 10.0
			end)
			PersistentTimer_Add(timer1)

			table.insert(self.timer, timer1)

			local offset = nil
			if i == 0 then offset = Vector(-10,-10,0) end
			if i == 1 then offset = Vector(-5,-15,0) end
			if i == 2 then offset = Vector(5,-15,0) end
			if i == 3 then offset = Vector(10,-10,0) end

			TurnToLoc(unit, unit_loc+offset, 1)

		end
	
		self.linkedBossHealth = -80

		local timer = Timers:CreateTimer(0, function()

			local unitsLeft = 0
			local bossHealthPct = 0

			for i,unit in pairs(self.units) do
				if unit ~= nil then
					if not unit:IsNull() then
						if unit:IsAlive() then

							if unit:GetHealthPercent() <= 20 and self.linkedBossHealth == -20 then
								self.linkedBossHealth = 20
							elseif unit:GetHealthPercent() <= 40 and self.linkedBossHealth == -40 then
								self.linkedBossHealth = 40
							elseif unit:GetHealthPercent() <= 60 and self.linkedBossHealth == -60 then
								self.linkedBossHealth = 60
							elseif unit:GetHealthPercent() <= 80 and self.linkedBossHealth == -80 then
								self.linkedBossHealth = 80
							end

						end
					end
				end
			end

			for i,unit in pairs(self.units) do
				if unit ~= nil then
					if not unit:IsNull() then
						if unit:IsAlive() then
							unitsLeft = unitsLeft + 1
							
							if self.linkedBossHealth > 0 then
								unit:SetHealth( unit:GetMaxHealth() * ( self.linkedBossHealth / 100 ) )
							end

							bossHealthPct = bossHealthPct + unit:GetHealthPercent()
						end
					end
				end
			end

			if self.linkedBossHealth > 0 then
				self.linkedBossHealth = (self.linkedBossHealth - 20) * -1
			end

			if unitsLeft > 0 and bossHealthPct > 0 then

				bossHealthPct = bossHealthPct / unitsLeft

				caster:SetHealth( caster:GetMaxHealth() * ( bossHealthPct / 100 ) )

			else

				local mod = caster:FindModifierByName("modifier_invulnerable")
				if mod ~= nil then
					mod:Destroy()
				end

				Timers:CreateTimer(0.1, function()
					caster:Kill(self, caster)

					for i,timer in pairs(self.timer) do
						Timers:RemoveTimer(timer)
						timer= nil
					end
				end)

			end

			return 0.2
		end)
		PersistentTimer_Add(timer)

	end
end

function bhamuka_all_consuming_god_malignant_growth:OnAbilityPhaseStart()
	local caster			= self:GetCaster()
	local playerID			= caster:GetPlayerOwnerID()
	local player			= PlayerResource:GetPlayer(playerID)

	return true
end

function bhamuka_all_consuming_god_malignant_growth:GetManaCost(abilitylevel)
	return self.BaseClass.GetManaCost(self, abilitylevel)
end

function bhamuka_all_consuming_god_malignant_growth:GetCooldown(abilitylevel)
	return self.BaseClass.GetCooldown(self, abilitylevel)
end