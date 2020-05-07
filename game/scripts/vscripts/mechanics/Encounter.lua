-- CONSTANTS

local PERSISTENT_OBJECTS = {}

-- FUNCTIONS

function EncounterDefaultAI(attackType, level)
	if attackType == nil then return end

	local unit = GetCurrentEncounterEntity()

	if unit.abilityPriority == nil then
		unit.abilityPriority = {}
	end

	--normal_attack
	--spell_melee
	--spell_ranged

	if attackType == "spell_melee" or attackType == "spell_ranged" then
		local timer = Timers:CreateTimer(1.0, function()

			if unit:FindModifierByName("casting_modifier") == nil and
				unit:FindModifierByName("casting_rooted_modifier") == nil and
				unit:FindModifierByName("casting_no_turning_modifier") == nil and
				unit:FindModifierByName("casting_frozen_modifier") == nil then

				local order

				local factor = 0.6
				if attackType == "spell_melee" then factor = 0.2 end

				if RandomFloat(0.0, 1.0) < factor then

					if unit:FindModifierByName("casting_modifier") == nil then

						order = {
							UnitIndex = unit:entindex(),
							Position = GetRandomBorderPoint(),
							OrderType = DOTA_UNIT_ORDER_MOVE_TO_POSITION,
							Queue = false
						}

					end

				else

					local hero = GetRandomHeroEntities(1)

					if hero then
						hero = hero[1]

						order = {
							UnitIndex = unit:entindex(),
							TargetIndex = hero:entindex(),
							OrderType = DOTA_UNIT_ORDER_MOVE_TO_TARGET,
							Queue = false
						}
					else
						order = {
							UnitIndex = unit:entindex(),
							Position = GetRandomBorderPoint(),
							OrderType = DOTA_UNIT_ORDER_MOVE_TO_POSITION,
							Queue = false
						}
					end

				end

				if order ~= nil then
					ExecuteOrderFromTable(order)
				end

			end

			return RandomFloat(0.5, 2.0)
		end)
		PersistentTimer_Add(timer)
		
	end


	local ability_priority_list = {}
	for i=0,9 do
		local ability = unit:GetAbilityByIndex(i)

		--

		if ability ~= nil then

			local temp_table = {}
			table.insert(temp_table, ability:GetCooldown(level) )
			table.insert(temp_table, ability:GetAbilityName() )

			table.insert(ability_priority_list, temp_table )
		end
	end

	table.sort(ability_priority_list, compare)

	--DeepPrintTable(ability_priority_list)

	local timer = Timers:CreateTimer(1.0, function()

		if unit.abilityPriority[1] ~= nil then

			local ability = unit.abilityPriority[1]

			if ability:IsCooldownReady() then

				table.remove(unit.abilityPriority, 1)

				local order = {
					UnitIndex = unit:entindex(),
					AbilityIndex = ability:entindex(),
					OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
					Queue = false
				}
				ExecuteOrderFromTable(order)

			end

		else

			for k,v in ipairs(ability_priority_list) do
				for key,value in ipairs(v) do
					if type(value) == "string" then

						local ability = unit:FindAbilityByName( value )

						if ability ~= nil and not unit:IsSilenced() then
							if ability:IsCooldownReady() then

								local order = {
									UnitIndex = unit:entindex(),
									AbilityIndex = ability:entindex(),
									OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
									Queue = false
								}
								ExecuteOrderFromTable(order)

							end
						end
					end
				end
			end

		end

		return 1.0
	end)
	PersistentTimer_Add(timer)


--[[
	local timer = Timers:CreateTimer(1.0, function()
		for i=0,9 do
			local ability = unit:GetAbilityByIndex(i)

			if ability ~= nil then
				if ability:IsCooldownReady() then

					local order = {
						UnitIndex = unit:entindex(),
						AbilityIndex = ability:entindex(),
						OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
						Queue = false
					}
					ExecuteOrderFromTable(order)
					
				end
			end
		end

		return 1.0
	end)
	PersistentTimer_Add(timer)
]]
end

function compare(a,b)
	return a[1] > b[1]
end

function DisableMotionControllers(unit, duration)
	local unit_location = unit:GetAbsOrigin()

	local timer = Timers:CreateTimer(0, function()
		if unit ~= nil then
			if not unit:IsNull() then
				unit:InterruptMotionControllers(false)
				if (unit:GetAbsOrigin() - unit_location):Length2D() > 1 then
					unit:SetAbsOrigin(unit_location)
				end
			end
		end
		return 0.03
	end)
	PersistentTimer_Add(timer)

	unit.DisableMotionControllers_Timer = timer

	if duration > 0 then
		local timer = Timers:CreateTimer(duration, function()
			Timers:RemoveTimer(timer)
			timer = nil
		end)
		PersistentTimer_Add(timer)
	end
end

function Cancel_DisableMotionControllers(unit)

	Timers:RemoveTimer( unit.DisableMotionControllers_Timer )
	unit.DisableMotionControllers_Timer = nil

end

function TurnToLoc(caster, location, duration)

	caster:Stop()
	caster:FaceTowards(location)

	if duration ~= nil then
		--caster:AddNewModifier(caster, nil, "command_restricted_modifier", {duration = duration})
		--caster:AddNewModifier(caster, nil, "rooted_modifier", {duration = duration})
		--[[
		local timer1 = Timers:CreateTimer(0.05, function()
			--if BossCheckInfight() then caster:Stop() end
			--caster:Stop()
			return 0.1
		end)
		PersistentTimer_Add(timer1)
		]]

		local timer2 = Timers:CreateTimer(0.1, function()
			--if BossCheckInfight() then caster:FaceTowards(location) end
			caster:FaceTowards(location)
			return 0.1
		end)
		PersistentTimer_Add(timer2)

		local timer3 = Timers:CreateTimer(duration+0.01, function()
			--Timers:RemoveTimer(timer1)
			Timers:RemoveTimer(timer2)
		end)
		PersistentTimer_Add(timer3)

	end
end

function RandomLocationMinDistance(loc, min_distance)
	local new_loc = nil

	local i = 0
	local loop = true
	while loop do
		new_loc = loc + Vector( RandomInt(-min_distance, min_distance), RandomInt(-min_distance, min_distance), 0 )
		local distance = CalcDistanceToLineSegment2D(loc, new_loc, new_loc)

		if i > 50 or distance > min_distance then
			loop = false
		end
		i=i+1
	end
	return new_loc
end

function DelayAbilityCooldown(unit, ability, duration, delay)

	--local caster = GetCurrentEncounterEntity()
	local ability = unit:FindAbilityByName(ability)

	if unit.abilityPriority ~= nil then
		if ability:GetCooldownTimeRemaining() == 0 then
			table.insert(unit.abilityPriority, ability)
		end
	end

	if ability:GetCooldownTimeRemaining() < duration+delay then
		ability:StartCooldown(duration+delay)
	end

end


function DelayAllAbilitiesCooldown(duration, delay)

	local caster = GetCurrentEncounterEntity()
	local ability = caster:FindAbilityByName(ability)

	local ability_count = #ENCOUNTERS_ABILITIES_INITIAL_CD[ GetCurrentEncounter() ] - 1

	for i=0,ability_count do

		local ability = caster:GetAbilityByIndex(i)
		
		if ability:GetCooldownTimeRemaining() < duration+delay then
			ability:StartCooldown(duration+delay)
		end

	end
	
end

function Cleanup_Persistents(defeated)
	local bossUnit = GetCurrentEncounterEntity()

	Timers:CreateTimer(0.1, function()

		if not bossUnit.waitForCleanup then

			Timers:CreateTimer(0.0, function()
				if PERSISTENT_OBJECTS["persistent_timer"] ~= nil then
					for key,value in pairs(PERSISTENT_OBJECTS["persistent_timer"]) do
						if value ~= nil then
							Timers:RemoveTimer(value)
							value = nil
						end
					end
				end
			end)

			Timers:CreateTimer(0.25, function()
				if PERSISTENT_OBJECTS["persistent_modifier"] ~= nil then
					for key,value in pairs(PERSISTENT_OBJECTS["persistent_modifier"]) do
						if value ~= nil then
							if not value:IsNull() then
								value:Destroy()
								value = nil
							end
						end
					end
				end
			end)

			Timers:CreateTimer(0.50, function()
				if PERSISTENT_OBJECTS["persistent_soundevent"] ~= nil then
					for key,value in pairs(PERSISTENT_OBJECTS["persistent_soundevent"]) do
						if value[1] ~= nil and value[2] ~= nil then
							StopSoundEvent(value[1], value[2])
							value = nil
						end
					end
				end
			end)

			Timers:CreateTimer(0.75, function()
				if PERSISTENT_OBJECTS["persistent_particle"] ~= nil then
					for key,value in pairs(PERSISTENT_OBJECTS["persistent_particle"]) do
						if value ~= nil then
							ParticleManager:DestroyParticle( value, true )
							ParticleManager:ReleaseParticleIndex( value )
							value = nil
						end
					end
				end
			end)

			Timers:CreateTimer(1.00, function()
				if PERSISTENT_OBJECTS["persistent_projectile"] ~= nil then
					for key,value in pairs(PERSISTENT_OBJECTS["persistent_projectile"]) do
						if value ~= nil then
							ProjectileManager:DestroyLinearProjectile(value)
							value = nil
						end
					end
				end
			end)

			Timers:CreateTimer(1.25, function()
				if PERSISTENT_OBJECTS["persistent_advancedprojectile"] ~= nil then
					for key,value in pairs(PERSISTENT_OBJECTS["persistent_advancedprojectile"]) do
						if value ~= nil then
							value:Destroy()
							value = nil
						end
					end
				end
			end)

			Timers:CreateTimer(1.50, function()
				if PERSISTENT_OBJECTS["persistent_unit"] ~= nil then
					for key,value in pairs(PERSISTENT_OBJECTS["persistent_unit"]) do
						if value ~= nil then
							if not value:IsNull() then
								value:RemoveSelf()
								value = nil
							end
						end
					end
				end
			end)

			Timers:CreateTimer(1.75, function()
				if PERSISTENT_OBJECTS["persistent_entity"] ~= nil then
					for key,value in pairs(PERSISTENT_OBJECTS["persistent_entity"]) do
						if value ~= nil then
							UTIL_Remove(value)
							value = nil
						end
					end
				end
			end)

			Timers:CreateTimer(2.00, function()

				if PERSISTENT_OBJECTS["persistent_boss_hp"] ~= nil then
					for key,value in pairs(PERSISTENT_OBJECTS["persistent_boss_hp"]) do
						if value ~= nil then
							CustomGameEventManager:Send_ServerToAllClients("on_remove_boss_hp", { id=value } )
							value = nil
						end
					end
				end

				for _,hero in pairs(GetHeroesEntities()) do
					hero:SetPhysicsAcceleration(Vector(0,0,0))
					hero:SetPhysicsVelocity(Vector(0,0,0))
					hero:OnPhysicsFrame(nil)
				end

				
			end)

			Timers:CreateTimer(2.25, function()

				if bossUnit ~= nil then
					UTIL_Remove(bossUnit)
				end

				PERSISTENT_OBJECTS["persistent_timer"] = nil
				PERSISTENT_OBJECTS["persistent_modifier"] = nil
				PERSISTENT_OBJECTS["persistent_soundevent"] = nil
				PERSISTENT_OBJECTS["persistent_particle"] = nil
				PERSISTENT_OBJECTS["persistent_projectile"] = nil
				PERSISTENT_OBJECTS["persistent_advancedprojectile"] = nil
				PERSISTENT_OBJECTS["persistent_unit"] = nil
				PERSISTENT_OBJECTS["persistent_entity"] = nil

				if defeated then
					Notifications:TopToAll({text="You were defeated!", duration=5, style={color="rgb(200, 32, 32)", ["font-size"]="55px", ["text-shadow"]="1px 1px 4px 5.0 #333333b0"}, continue=false})
					EmitGlobalSound("announcer_ann_custom_end_04")

					PlayersDefeated_ShowContinue()
				end
			end)

			return
		else
			return 0.25
		end
	end)

end

--[[
function Cleanup_Persistents(defeated)
	local bossUnit = GetCurrentEncounterEntity()

	Timers:CreateTimer(0, function()

		if not bossUnit.waitForCleanup then

			Timers:CreateTimer(0.0, function()
				if bossUnit.persistent_timer ~= nil then
					for key,value in pairs(bossUnit.persistent_timer) do
						if value ~= nil then
							Timers:RemoveTimer(value)
							value = nil
						end
					end
				end
			end)

			Timers:CreateTimer(0.2, function()
				if bossUnit.persistent_modifier ~= nil then
					for key,value in pairs(bossUnit.persistent_modifier) do
						if value ~= nil then
							if not value:IsNull() then
								value:Destroy()
								value = nil
							end
						end
					end
				end
			end)

			Timers:CreateTimer(0.4, function()
				if bossUnit.persistent_unit ~= nil then
					for key,value in pairs(bossUnit.persistent_unit) do
						if value ~= nil then
							if not value:IsNull() then
								value:RemoveSelf()
								value = nil
							end
						end
					end
				end
			end)

			Timers:CreateTimer(0.6, function()
				if bossUnit.persistent_particle ~= nil then
					for key,value in pairs(bossUnit.persistent_particle) do
						if value ~= nil then
							ParticleManager:DestroyParticle( value, true )
							ParticleManager:ReleaseParticleIndex( value )
							value = nil
						end
					end
				end
			end)

			Timers:CreateTimer(0.8, function()
				if bossUnit.persistent_entity ~= nil then
					for key,value in pairs(bossUnit.persistent_entity) do
						if value ~= nil then
							UTIL_Remove(value)
							value = nil
						end
					end
				end
			end)

			Timers:CreateTimer(1.0, function()
				if bossUnit.persistent_projectile ~= nil then
					for key,value in pairs(bossUnit.persistent_projectile) do
						if value ~= nil then
							ProjectileManager:DestroyLinearProjectile(value)
							value = nil
						end
					end
				end
			end)

			Timers:CreateTimer(1.2, function()
				if bossUnit.persistent_advancedprojectile ~= nil then
					for key,value in pairs(bossUnit.persistent_advancedprojectile) do
						if value ~= nil then
							value:Destroy()
							value = nil
						end
					end
				end
			end)

			Timers:CreateTimer(1.4, function()
				if bossUnit.persistent_soundevent ~= nil then
					for key,value in pairs(bossUnit.persistent_soundevent) do
						if value[1] ~= nil and value[2] ~= nil then
							StopSoundEvent(value[1], value[2])
							value = nil
						end
					end
				end
			end)

			Timers:CreateTimer(1.6, function()
				for _,hero in pairs(GetHeroesEntities()) do
					hero:SetPhysicsAcceleration(Vector(0,0,0))
					hero:SetPhysicsVelocity(Vector(0,0,0))
					hero:OnPhysicsFrame(nil)
				end

			end)

			Timers:CreateTimer(2.0, function()

				UTIL_Remove(bossUnit)

				if defeated then
					Notifications:TopToAll({text="You were defeated!", duration=5, style={color="rgb(200, 32, 32)", ["font-size"]="55px", ["text-shadow"]="1px 1px 4px 5.0 #333333b0"}, continue=false})
					EmitGlobalSound("announcer_ann_custom_end_04")

					PlayersDefeated_ShowContinue()
				end
			end)

			return
		else
			return 0.25
		end
	end)

end
]]

function PersistentModifier_Add(modifier)
	if PERSISTENT_OBJECTS["persistent_modifier"] == nil then PERSISTENT_OBJECTS["persistent_modifier"] = {} end
	table.insert(PERSISTENT_OBJECTS["persistent_modifier"], modifier)
end

function PersistentUnit_Add(unit)
	if PERSISTENT_OBJECTS["persistent_unit"] == nil then PERSISTENT_OBJECTS["persistent_unit"] = {} end
	table.insert(PERSISTENT_OBJECTS["persistent_unit"], unit)
end

function PersistentParticle_Add(particle)
	if PERSISTENT_OBJECTS["persistent_particle"] == nil then PERSISTENT_OBJECTS["persistent_particle"] = {} end
	table.insert(PERSISTENT_OBJECTS["persistent_particle"], particle)
end

function PersistentTimer_Add(timer)
	if PERSISTENT_OBJECTS["persistent_timer"] == nil then PERSISTENT_OBJECTS["persistent_timer"] = {} end
	table.insert(PERSISTENT_OBJECTS["persistent_timer"], timer)
end

function PersistentEntity_Add(entity)
	if PERSISTENT_OBJECTS["persistent_entity"] == nil then PERSISTENT_OBJECTS["persistent_entity"] = {} end
	table.insert(PERSISTENT_OBJECTS["persistent_entity"], entity)
end

function PersistentProjectile_Add(projectile)
	if PERSISTENT_OBJECTS["persistent_projectile"] == nil then PERSISTENT_OBJECTS["persistent_projectile"] = {} end
	table.insert(PERSISTENT_OBJECTS["persistent_projectile"], projectile)
end

function PersistentAdvancedProjectile_Add(advancedprojectile)
	if PERSISTENT_OBJECTS["persistent_advancedprojectile"] == nil then PERSISTENT_OBJECTS["persistent_advancedprojectile"] = {} end
	table.insert(PERSISTENT_OBJECTS["persistent_advancedprojectile"], advancedprojectile)
end

function PersistentSoundEvent_Add(soundevent, handle)
	local bossUnit = GetCurrentEncounterEntity()

	if PERSISTENT_OBJECTS["persistent_soundevent"] == nil then PERSISTENT_OBJECTS["persistent_soundevent"] = {} end
	local temp_table = {}
	temp_table[1] = soundevent
	temp_table[2] = handle
	table.insert(PERSISTENT_OBJECTS["persistent_soundevent"], temp_table)
end

function PersistentBossHp_Add(persistent_boss_hp)
	if PERSISTENT_OBJECTS["persistent_boss_hp"] == nil then PERSISTENT_OBJECTS["persistent_boss_hp"] = {} end
	table.insert(PERSISTENT_OBJECTS["persistent_boss_hp"], persistent_boss_hp)
end

--[[
function PersistentModifier_Add(modifier)
	local bossUnit = GetCurrentEncounterEntity()

	if bossUnit.persistent_modifier == nil then bossUnit.persistent_modifier = {} end
	table.insert(bossUnit.persistent_modifier, modifier)
end

function PersistentUnit_Add(unit)
	local bossUnit = GetCurrentEncounterEntity()

	if bossUnit.persistent_unit == nil then bossUnit.persistent_unit = {} end
	table.insert(bossUnit.persistent_unit, unit)
end

function PersistentParticle_Add(particle)
	local bossUnit = GetCurrentEncounterEntity()

	if bossUnit.persistent_particle == nil then bossUnit.persistent_particle = {} end
	table.insert(bossUnit.persistent_particle, particle)
end

function PersistentTimer_Add(timer)
	local bossUnit = GetCurrentEncounterEntity()

	if bossUnit.persistent_timer == nil then bossUnit.persistent_timer = {} end
	table.insert(bossUnit.persistent_timer, timer)
end

function PersistentEntity_Add(entity)
	local bossUnit = GetCurrentEncounterEntity()

	if bossUnit.persistent_entity == nil then bossUnit.persistent_entity = {} end
	table.insert(bossUnit.persistent_entity, entity)
end

function PersistentProjectile_Add(projectile)
	local bossUnit = GetCurrentEncounterEntity()

	if bossUnit.persistent_projectile == nil then bossUnit.persistent_projectile = {} end
	table.insert(bossUnit.persistent_projectile, projectile)
end

function PersistentAdvancedProjectile_Add(advancedprojectile)
	local bossUnit = GetCurrentEncounterEntity()

	if bossUnit.persistent_advancedprojectile == nil then bossUnit.persistent_advancedprojectile = {} end
	table.insert(bossUnit.persistent_advancedprojectile, advancedprojectile)
end

function PersistentSoundEvent_Add(soundevent, handle)
	local bossUnit = GetCurrentEncounterEntity()

	if bossUnit.persistent_soundevent == nil then bossUnit.persistent_soundevent = {} end
	local temp_table = {}
	temp_table[1] = soundevent
	temp_table[2] = handle
	table.insert(bossUnit.persistent_soundevent, temp_table)
end
]]

function Encounter_SpecialCountdown()
	local unit = GetCurrentEncounterEntity()

	if GetCurrentEncounter() == "Bhamuka, All-Consuming God" then

		local timer = Timers:CreateTimer(0.5, function()
			FindClearSpaceForUnit(unit, GetSpecificBorderPoint("point_top"), false)
		end)
		PersistentTimer_Add(timer)

	end

	if GetCurrentEncounter() == "The Dungeoneer" then

		Encounter_AddAttachment(unit, "models/heroes/grimstroke/grimstroke_armor.vmdl")
		Encounter_AddAttachment(unit, "models/heroes/grimstroke/grimstroke_head_item.vmdl")
		Encounter_AddAttachment(unit, "models/heroes/grimstroke/grimstroke_skirt.vmdl")
		Encounter_AddAttachment(unit, "models/heroes/grimstroke/grimstroke_weapon.vmdl")

		-- Particle -- PATTACH_ABSORIGIN-PATTACH_ABSORIGIN_FOLLOW-PATTACH_CUSTOMORIGIN
		local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_grimstroke/grimstroke_brush_ambient.vpcf", PATTACH_POINT_FOLLOW, unit)
		ParticleManager:SetParticleControlEnt( particle, 0, unit, PATTACH_POINT_FOLLOW, "attach_attack2", unit:GetAttachmentOrigin(unit:ScriptLookupAttachment("attach_attack2")), true)
		ParticleManager:SetParticleControlEnt( particle, 1, unit, PATTACH_POINT_FOLLOW, "attach_attack2", unit:GetAttachmentOrigin(unit:ScriptLookupAttachment("attach_attack2")), true)

		-- Particle -- PATTACH_ABSORIGIN-PATTACH_ABSORIGIN_FOLLOW-PATTACH_CUSTOMORIGIN
		local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_grimstroke/grimstroke_head_ambient.vpcf", PATTACH_POINT_FOLLOW, unit)
		ParticleManager:SetParticleControlEnt( particle, 0, unit, PATTACH_POINT_FOLLOW, "attach_eye_l", unit:GetAttachmentOrigin(unit:ScriptLookupAttachment("attach_eye_l")), true)
		ParticleManager:SetParticleControlEnt( particle, 1, unit, PATTACH_POINT_FOLLOW, "attach_eye_r", unit:GetAttachmentOrigin(unit:ScriptLookupAttachment("attach_eye_r")), true)
		ParticleManager:SetParticleControlEnt( particle, 2, unit, PATTACH_POINT_FOLLOW, "attach_hitloc", unit:GetAttachmentOrigin(unit:ScriptLookupAttachment("attach_hitloc")), true)

	end

	if GetCurrentEncounter() == "Sinastra, Dragon of the Eternal Frost" then

		Encounter_AddAttachment(unit, "models/heroes/winterwyvern/winterwyvern_crown.vmdl")
		Encounter_AddAttachment(unit, "models/heroes/winterwyvern/winterwyvern_backitem.vmdl")

		-- Particle -- PATTACH_ABSORIGIN-PATTACH_ABSORIGIN_FOLLOW-PATTACH_CUSTOMORIGIN
		local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_winter_wyvern/wyvern_ambient.vpcf", PATTACH_POINT_FOLLOW, unit)
		ParticleManager:SetParticleControlEnt( particle, 0, unit, PATTACH_POINT_FOLLOW, "attach_hitloc", unit:GetAttachmentOrigin(unit:ScriptLookupAttachment("attach_hitloc")), true)
		ParticleManager:SetParticleControlEnt( particle, 1, unit, PATTACH_POINT_FOLLOW, "attach_attack1", unit:GetAttachmentOrigin(unit:ScriptLookupAttachment("attach_attack1")), true)
		ParticleManager:SetParticleControlEnt( particle, 2, unit, PATTACH_POINT_FOLLOW, "attach_eye_l", unit:GetAttachmentOrigin(unit:ScriptLookupAttachment("attach_eye_l")), true)
		ParticleManager:SetParticleControlEnt( particle, 3, unit, PATTACH_POINT_FOLLOW, "attach_eye_r", unit:GetAttachmentOrigin(unit:ScriptLookupAttachment("attach_eye_r")), true)

		unit:FindModifierByName("modifier_flying_for_pathing"):Destroy()

	end

	if GetCurrentEncounter() == "Air Ship 'Blue Balloon'" then

		local timer = Timers:CreateTimer(0.5, function()
			FindClearSpaceForUnit(unit, GetSpecificBorderPoint("point_top"), false)
		end)
		PersistentTimer_Add(timer)

	end

	if GetCurrentEncounter() == "Shijou, Samurai of Chaos" then

		AddAnimationTranslate(unit, "run")

		--(SET: Jagged Honor)
		Encounter_AddAttachment(unit, "models/items/juggernaut/jugg_year_beast_slayer_arms/jugg_year_beast_slayer_arms.vmdl")
		Encounter_AddAttachment(unit, "models/items/juggernaut/jugg_year_beast_slayer_back/jugg_year_beast_slayer_back.vmdl")
		Encounter_AddAttachment(unit, "models/items/juggernaut/jugg_year_beast_slayer_head/jugg_year_beast_slayer_head.vmdl")
		Encounter_AddAttachment(unit, "models/items/juggernaut/jugg_year_beast_slayer_legs/jugg_year_beast_slayer_legs.vmdl")
		local weapon = Encounter_AddAttachment(unit, "models/items/juggernaut/jugg_year_beast_slayer_weapon/jugg_year_beast_slayer_weapon.vmdl")

		-- Particle -- PATTACH_ABSORIGIN-PATTACH_ABSORIGIN_FOLLOW-PATTACH_CUSTOMORIGIN
		local particle = ParticleManager:CreateParticle("particles/econ/items/juggernaut/jugg_slayer/jugg_slayer_arms_ambient.vpcf", PATTACH_POINT_FOLLOW, unit)
		
		local particle = ParticleManager:CreateParticle("particles/econ/items/juggernaut/jugg_slayer/jugg_slayer_back_ambient.vpcf", PATTACH_POINT_FOLLOW, unit)
		
		local particle = ParticleManager:CreateParticle("particles/econ/items/juggernaut/jugg_slayer/jugg_slayer_head_ambient.vpcf", PATTACH_POINT_FOLLOW, unit)
		ParticleManager:SetParticleControlEnt( particle, 0, unit, PATTACH_POINT_FOLLOW, "attach_eye_l", unit:GetAttachmentOrigin(unit:ScriptLookupAttachment("attach_eye_l")), true)
		ParticleManager:SetParticleControlEnt( particle, 1, unit, PATTACH_POINT_FOLLOW, "attach_eye_r", unit:GetAttachmentOrigin(unit:ScriptLookupAttachment("attach_eye_r")), true)
		ParticleManager:SetParticleControlEnt( particle, 2, unit, PATTACH_POINT_FOLLOW, "attach_head", unit:GetAttachmentOrigin(unit:ScriptLookupAttachment("attach_head")), true)

		local particle = ParticleManager:CreateParticle("particles/econ/items/juggernaut/jugg_slayer/jugg_slayer_legs_ambient.vpcf", PATTACH_POINT_FOLLOW, unit)
		
		local particle = ParticleManager:CreateParticle("particles/econ/items/juggernaut/jugg_slayer/jugg_slayer_weapon_ambient.vpcf", PATTACH_POINT_FOLLOW, weapon)
		ParticleManager:SetParticleControlEnt( particle, 0, weapon, PATTACH_POINT_FOLLOW, "attach_eye_l", weapon:GetAttachmentOrigin(weapon:ScriptLookupAttachment("attach_eye_l")), false)
		ParticleManager:SetParticleControlEnt( particle, 1, weapon, PATTACH_POINT_FOLLOW, "attach_eye_r", weapon:GetAttachmentOrigin(weapon:ScriptLookupAttachment("attach_eye_r")), false)

	end

	if GetCurrentEncounter() == "Elite Royal Guardian" then 

		--(SET: Cry of the Battlehawk)
		Encounter_AddAttachment(unit, "models/items/sven/glittering_hawk_arms/glittering_hawk_arms.vmdl")
		Encounter_AddAttachment(unit, "models/items/sven/glittering_hawk_back/glittering_hawk_back.vmdl")
		Encounter_AddAttachment(unit, "models/items/sven/glittering_hawk_belt/glittering_hawk_belt.vmdl")
		Encounter_AddAttachment(unit, "models/items/sven/glittering_hawk_head/glittering_hawk_head.vmdl")
		Encounter_AddAttachment(unit, "models/items/sven/glittering_hawk_shoulder/glittering_hawk_shoulder.vmdl")
		Encounter_AddAttachment(unit, "models/items/sven/glittering_hawk_weapon/glittering_hawk_weapon.vmdl")

	end

	if GetCurrentEncounter() == "Deathspeaker Xun'Ra" then 

		--(SET: Wrath of Ka)
		Encounter_AddAttachment(unit, "models/items/necrolyte/necronub_head/necronub_head.vmdl")
		Encounter_AddAttachment(unit, "models/items/necrolyte/necronub_scythe/necronub_scythe.vmdl")
		Encounter_AddAttachment(unit, "models/items/necrolyte/necronub_top/necronub_top.vmdl")
		Encounter_AddAttachment(unit, "models/items/necrolyte/necronub_coffin/necronub_coffin.vmdl")

		-- Particle -- PATTACH_ABSORIGIN-PATTACH_ABSORIGIN_FOLLOW-PATTACH_CUSTOMORIGIN
		local particle = ParticleManager:CreateParticle("particles/econ/items/necrolyte/necronub_ambient/necrolyte_ambient_glow_ka.vpcf", PATTACH_ABSORIGIN, unit)
		ParticleManager:SetParticleControl( particle, 0, unit:GetAbsOrigin() )

	end

end

function Encounter_SpecialPreparation()
	local unit = GetCurrentEncounterEntity()

	if GetCurrentEncounter() == "Drono, Red Dragonkin Commander" then
		
		local timer = Timers:CreateTimer(0.1, function()
			unit:AddNewModifier(unit, unit:FindAbilityByName("drono_red_dragonkin_commander_red_dragon_army"), "drono_red_dragonkin_commander_red_dragonkin_armor_modifier", {})
		end)
		PersistentTimer_Add(timer)

	end

	if GetCurrentEncounter() == "Stikx, The 'Gentleman'" then

		local timer = Timers:CreateTimer(2.75, function()
			DungeoneerLore_Say("monkey_king_monkey_spawn_13", nil)
		end)
		PersistentTimer_Add(timer)

		local timer = Timers:CreateTimer(5.25, function()
			DungeoneerLore_Say("grimstroke_grimstroke_anger_09", nil)
		end)
		PersistentTimer_Add(timer)

	end

	if GetCurrentEncounter() == "Treasure on a Tree" then

		local timer = Timers:CreateTimer(0.1, function()
			DisableMotionControllers(GetCurrentEncounterEntity(), -1)
		end)
		PersistentTimer_Add(timer)

	end

	if GetCurrentEncounter() == "Bhamuka, All-Consuming God" then

		local timer = Timers:CreateTimer(0.1, function()
			unit:AddNewModifier(unit, nil, "modifier_invulnerable", {})
			unit:AddNewModifier(unit, nil, "modifier_unselectable", {})
		end)
		PersistentTimer_Add(timer)

	end

	if GetCurrentEncounter() == "The Curse of Agony" then

		local timer = Timers:CreateTimer(0.1, function()
			unit:AddNewModifier(unit, nil, "modifier_invulnerable", {duration=5.0})
		end)
		PersistentTimer_Add(timer)

	end

	if GetCurrentEncounter() == "Air Ship 'Blue Balloon'" then

		local timer = Timers:CreateTimer(0.1, function()
	
			if unit:FindModifierByName("casting_modifier") == nil and
				unit:FindModifierByName("casting_rooted_modifier") == nil and
				unit:FindModifierByName("casting_no_turning_modifier") == nil and
				unit:FindModifierByName("casting_frozen_modifier") == nil then

				if unit:FindModifierByName("casting_modifier") == nil then

					local pos = { GetSpecificBorderPoint("point_top"), GetSpecificBorderPoint("point_top_left"), GetSpecificBorderPoint("point_top_right") }

					order = {
						UnitIndex = unit:entindex(),
						Position = pos[RandomInt(1, 3)],
						OrderType = DOTA_UNIT_ORDER_MOVE_TO_POSITION,
						Queue = false
					}
					ExecuteOrderFromTable(order)

				end

			end

			return RandomFloat(0.5, 2.0)	

		end)
		PersistentTimer_Add(timer)

	end

end

function Encounter_AddAttachment(unit, model)
	local attachment = SpawnEntityFromTableSynchronous("prop_dynamic", {model = model})
	attachment:FollowEntity(unit, true)

	return attachment
end
