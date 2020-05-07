drono_red_dragonkin_commander_red_dragon_army = class({})

LinkLuaModifier( 'drono_red_dragonkin_commander_red_dragon_army_modifier', 'encounters/drono_red_dragonkin_commander/drono_red_dragonkin_commander_red_dragon_army_modifier', LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( 'drono_red_dragonkin_commander_red_dragonkin_armor_modifier', 'encounters/drono_red_dragonkin_commander/drono_red_dragonkin_commander_red_dragonkin_armor_modifier', LUA_MODIFIER_MOTION_NONE )

function drono_red_dragonkin_commander_red_dragon_army:OnSpellStart()

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
	local units_summoned              = self:GetSpecialValueFor("units_summoned")

	if caster.red_dragon_army_units == nil then caster.red_dragon_army_units = {} end

	-- Sound --
	local sound = {"troll_warlord_troll_underattack_02", "troll_warlord_troll_underattack_03",
					"troll_warlord_troll_ally_02", "troll_warlord_troll_ally_12"}
	EmitAnnouncerSound( sound[RandomInt(1, #sound)] )

	--for _,victim in pairs( GetHeroesAliveEntities() ) do

		for i=1,units_summoned do

			local location = GetSpecificBorderPoint("point_center")
			if RollPercentage(50) then
				location = location + RandomVector(750)
			else
				location = location - RandomVector(750)
			end

			EncounterGroundAOEWarningSticky(location, 100, delay+0.5)

			local timer = Timers:CreateTimer(delay, function()
				if not IsValidEntity(GetCurrentEncounterEntity()) then return end
				if GetCurrentEncounterEntity() == nil then return end
				if GetCurrentEncounterEntity():IsNull() then return end
				if not GetCurrentEncounterEntity():IsAlive() then return end
	
				-- Particle --
				local particle = ParticleManager:CreateParticle("particles/econ/items/monkey_king/arcana/fire/mk_arcana_spring_jump_start_dust.vpcf", PATTACH_CUSTOMORIGIN, nil)
				ParticleManager:SetParticleControl( particle, 0, location )
				ParticleManager:SetParticleControl( particle, 1, location )
				ParticleManager:ReleaseParticleIndex( particle )
				particle = nil

				local unit = CreateUnitByName("red_dragonking_warrior", location, true, nil, nil, DOTA_TEAM_BADGUYS)
				PersistentUnit_Add(unit)
				EncounterCreate_AttackDamage(unit)
				EncounterCreate_Health(unit)

				table.insert(caster.red_dragon_army_units, unit)

				-- Modifier --
				unit:AddNewModifier(caster, self, "drono_red_dragonkin_commander_red_dragon_army_modifier", {})

				-- Sound --
				unit:EmitSound("Visage_Familar.StoneForm.Stun")

			end)
			PersistentTimer_Add(timer)

		end
	--end

end

function drono_red_dragonkin_commander_red_dragon_army:OnAbilityPhaseStart()
	local caster			= self:GetCaster()
	local playerID			= caster:GetPlayerOwnerID()
	local player			= PlayerResource:GetPlayer(playerID)

	return true
end

function drono_red_dragonkin_commander_red_dragon_army:GetManaCost(abilitylevel)
	return self.BaseClass.GetManaCost(self, abilitylevel)
end

function drono_red_dragonkin_commander_red_dragon_army:GetCooldown(abilitylevel)
	return self.BaseClass.GetCooldown(self, abilitylevel)
end