bhamuka_all_consuming_god_consume_the_weak = class({})

LinkLuaModifier( 'bhamuka_all_consuming_god_consume_the_weak_dummy_modifier', 'encounters/bhamuka_all_consuming_god/bhamuka_all_consuming_god_consume_the_weak_dummy_modifier', LUA_MODIFIER_MOTION_NONE )

function bhamuka_all_consuming_god_consume_the_weak:OnSpellStart()

	--- Get Caster, Victim, Player, Point ---
	local caster		= self:GetCaster()
	local caster_loc	= caster:GetAbsOrigin()
	local playerID		= caster:GetPlayerOwnerID()
	local player		= PlayerResource:GetPlayer(playerID)
	local team			= caster:GetTeamNumber()
	local victim		= caster
	local victim_loc	= victim:GetAbsOrigin()
	
	--- Get Special Values ---
	local heal_percentage             = self:GetSpecialValueFor("heal_percentage")

	-- Sound --
	local sound = {"outworld_destroyer_odest_attack_02", "outworld_destroyer_odest_attack_11",
					"outworld_destroyer_odest_ability_eclipse_05"}
	EmitAnnouncerSound( sound[RandomInt(1, #sound)] )

	local unit_loc = GetRandomBorderPointCounterpart("border_top") + Vector(0,250,0)
	local unit = CreateUnitByName("consume_the_weak", unit_loc, true, nil, nil, DOTA_TEAM_BADGUYS)
	PersistentUnit_Add(unit)
	EncounterCreate_Health(unit)
	unit:AddNewModifier(caster, self, "bhamuka_all_consuming_god_consume_the_weak_dummy_modifier", {})
	unit:AddNewModifier(caster, self, "modifier_phased", {})
	

	unit:SetOriginalModel("models/heroes/undying/undying_minion_torso.vmdl")
	unit:SetModel("models/heroes/undying/undying_minion_torso.vmdl")
	unit:ManageModelChanges()

	unit:Stop()

	unit:StartGestureWithPlaybackRate( ACT_DOTA_RUN, 0.8 )

	local triggered = false

	local timer1 = Timers:CreateTimer(0.1, function()

		unit:MoveToNPC(caster)

		local timer2 = Timers:CreateTimer(0, function()

			local distance = ( caster:GetAbsOrigin() - unit:GetAbsOrigin() ):Length2D()

			if distance < 425 and unit:IsAlive() and not triggered then

				triggered = true

				unit:Kill(self, caster)
				
				unit:StartGestureWithPlaybackRate( ACT_DOTA_DIE, 1.0 )

				-- Sound --
				local sound = {"outworld_destroyer_odest_denied_08", "outworld_destroyer_odest_denied_09",
								"outworld_destroyer_odest_denied_10"}
				EmitAnnouncerSound( sound[RandomInt(1, #sound)] )

				local timer3 = Timers:CreateTimer(1.75, function()
					local sound = {"outworld_destroyer_odest_laugh_01", "outworld_destroyer_odest_laugh_02",
									"outworld_destroyer_odest_laugh_03", "outworld_destroyer_odest_laugh_04",
									"outworld_destroyer_odest_laugh_05", "outworld_destroyer_odest_laugh_06",
									"outworld_destroyer_odest_laugh_07", "outworld_destroyer_odest_laugh_08",
									"outworld_destroyer_odest_laugh_09", "outworld_destroyer_odest_laugh_10",
									"outworld_destroyer_odest_laugh_11", "outworld_destroyer_odest_laugh_12",}
					EmitAnnouncerSound( sound[RandomInt(1, #sound)] )
				end)
				PersistentTimer_Add(timer3)

				caster:EmitSound("Hero_ObsidianDestroyer.EssenceAura")

				-- Particle --
				local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_oracle/oracle_false_promise_break_heal.vpcf", PATTACH_ABSORIGIN, caster)
				ParticleManager:SetParticleControl( particle, 0, caster:GetAbsOrigin() )
				ParticleManager:SetParticleControl( particle, 1, caster:GetAbsOrigin() )
				ParticleManager:ReleaseParticleIndex( particle )
				particle = nil

				-- Heal --
				local tentacles = caster:FindAbilityByName("bhamuka_all_consuming_god_malignant_growth").units
				for _,tentacle in pairs(tentacles) do
					if tentacle ~= nil then
						if not tentacle:IsNull() then
							if tentacle:IsAlive() then
								tentacle:Heal( tentacle:GetMaxHealth() * ( heal_percentage / 100 ), self )
							end
						end
					end
				end
				
				return
			end

			if not unit:IsAlive() and not triggered then
				-- Sound --
				local sound = {"outworld_destroyer_odest_anger_01", "outworld_destroyer_odest_anger_02",
								"outworld_destroyer_odest_anger_03"}
				EmitAnnouncerSound( sound[RandomInt(1, #sound)] )

				return
			end

			if not caster:IsAlive() and unit:IsAlive() then
				unit:RemoveSelf()
				return
			end

			return 0.25
		end)
		PersistentTimer_Add(timer2)


	end)
	PersistentTimer_Add(timer1)

end

function bhamuka_all_consuming_god_consume_the_weak:OnAbilityPhaseStart()
	local caster			= self:GetCaster()
	local playerID			= caster:GetPlayerOwnerID()
	local player			= PlayerResource:GetPlayer(playerID)

	return true
end

function bhamuka_all_consuming_god_consume_the_weak:GetManaCost(abilitylevel)
	return self.BaseClass.GetManaCost(self, abilitylevel)
end

function bhamuka_all_consuming_god_consume_the_weak:GetCooldown(abilitylevel)
	return self.BaseClass.GetCooldown(self, abilitylevel)
end