DUNGEONEER_VERSION = "3.0"

DEBUG = false
if IsInToolsMode() then
	DEBUG = true
end

if GameMode == nil then
	_G.GameMode = class({})
end

require('libraries/timers')
require('libraries/physics')
require('libraries/projectiles')
require('libraries/notifications')
require('libraries/animations')
require('libraries/playertables')
require('libraries/pathgraph')
require('libraries/selection')

require("statcollection/init")

require('mechanics/ApplyDamage')
require('mechanics/Arena')
require('mechanics/Encounter')
require('mechanics/Encounter_Warnings')
require('mechanics/GameCycle')
require('mechanics/GameModeVote')
require('mechanics/Hero_GetsChecks')
require('mechanics/Info')
require('mechanics/Math')
require('mechanics/Perks')
require('mechanics/Dungeoneer_Lore')
require('mechanics/HttpSend')
require('mechanics/ChallengerMode')
require('mechanics/Currencies')
require('mechanics/Checklist')
require('mechanics/Tutorial')

require('events')
require('gamemode_init')
require('settings')


LinkLuaModifier( 'power_buff', 'modifier/power_buff', LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( 'modifier_player_disconnected', 'modifier/modifier_player_disconnected', LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( 'casting_modifier', 'modifier/casting_modifier', LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( 'casting_rooted_modifier', 'modifier/casting_rooted_modifier', LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( 'casting_no_turning_modifier', 'modifier/casting_no_turning_modifier', LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( 'casting_frozen_modifier', 'modifier/casting_frozen_modifier', LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( 'modifier_attack_immune', 'modifier/modifier_attack_immune', LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( 'modifier_unselectable', 'modifier/modifier_unselectable', LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( 'modifier_flying_for_pathing', 'modifier/modifier_flying_for_pathing', LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( 'modifier_out_of_world', 'modifier/modifier_out_of_world', LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( 'modifier_move_speed_no_limit', 'modifier/modifier_move_speed_no_limit', LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( 'turn_rate_modifier', 'modifier/turn_rate_modifier', LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( 'strength_resilience_modifier', 'modifier/strength_resilience_modifier', LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( 'percentage_based_auto_attack_damage', 'modifier/percentage_based_auto_attack_damage', LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( 'modifier_encounter_health', 'modifier/modifier_encounter_health', LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( 'modifier_encounter_damage', 'modifier/modifier_encounter_damage', LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( 'modifier_muted', 'modifier/modifier_muted', LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( 'damage_meter', 'modifier/damage_meter', LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( 'modifier_flying', 'modifier/modifier_flying', LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( 'modifier_true_sight', 'modifier/modifier_true_sight', LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( 'modifier_fake_ally', 'modifier/modifier_fake_ally', LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( 'modifier_untargetable', 'modifier/modifier_untargetable', LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( 'modifier_dummy', 'modifier/modifier_dummy', LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( 'arcane_knowledge_modifier', 'modifier/arcane_knowledge_modifier', LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( 'modifier_special_invis', 'modifier/modifier_special_invis', LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( 'modifier_slowed', 'modifier/modifier_slowed', LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( 'modifier_disable_damage_block', 'modifier/modifier_disable_damage_block', LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( 'castrange_modifier_ability', 'modifier/castrange_modifier_ability', LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( 'cooldown_modifier_ability', 'modifier/cooldown_modifier_ability', LUA_MODIFIER_MOTION_NONE )

-- ### Perk Modifiers Start ### --
LinkLuaModifier( 'glyph_blazing_gold', 'perks/glyph_blazing_gold', LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( 'glyph_blazing_knowledge', 'perks/glyph_blazing_knowledge', LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( 'glyph_blazing_mind', 'perks/glyph_blazing_mind', LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( 'glyph_blazing_power', 'perks/glyph_blazing_power', LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( 'glyph_mystic_book', 'perks/glyph_mystic_book', LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( 'glyph_mystic_flask', 'perks/glyph_mystic_flask', LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( 'glyph_mystic_rune', 'perks/glyph_mystic_rune', LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( 'glyph_mystic_stream', 'perks/glyph_mystic_stream', LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( 'glyph_petrified_cloak', 'perks/glyph_petrified_cloak', LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( 'glyph_petrified_jewel', 'perks/glyph_petrified_jewel', LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( 'glyph_petrified_particles', 'perks/glyph_petrified_particles', LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( 'glyph_petrified_soil', 'perks/glyph_petrified_soil', LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( 'glyph_sacred_bracing', 'perks/glyph_sacred_bracing', LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( 'glyph_sacred_glory', 'perks/glyph_sacred_glory', LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( 'glyph_sacred_vigor', 'perks/glyph_sacred_vigor', LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( 'glyph_sacred_vitality', 'perks/glyph_sacred_vitality', LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( 'glyph_sparking_agility', 'perks/glyph_sparking_agility', LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( 'glyph_sparking_alacrity', 'perks/glyph_sparking_alacrity', LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( 'glyph_sparking_swiftness', 'perks/glyph_sparking_swiftness', LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( 'glyph_sparking_thunder', 'perks/glyph_sparking_thunder', LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( 'glyph_umbral_energy', 'perks/glyph_umbral_energy', LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( 'glyph_umbral_force', 'perks/glyph_umbral_force', LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( 'glyph_umbral_fragments', 'perks/glyph_umbral_fragments', LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( 'glyph_umbral_potency', 'perks/glyph_umbral_potency', LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( 'artifact_bound_souls', 'perks/artifact_bound_souls', LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( 'artifact_celestial_barrage', 'perks/artifact_celestial_barrage', LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( 'artifact_crackling_lightning', 'perks/artifact_crackling_lightning', LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( 'artifact_crunching_ground', 'perks/artifact_crunching_ground', LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( 'artifact_fiery_eruption', 'perks/artifact_fiery_eruption', LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( 'artifact_holy_gush', 'perks/artifact_holy_gush', LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( 'artifact_purifiying_mana_burst', 'perks/artifact_purifiying_mana_burst', LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( 'artifact_time_anomaly', 'perks/artifact_time_anomaly', LUA_MODIFIER_MOTION_NONE )
-- ### Perk Modifiers End ### --


GameRules.DAMAGE_METER                        = {}
GameRules.DAMAGE_METER_TIMER                  = {}
GameRules.DAMAGE_METER_BOSS_TIMER             = {}
GameRules.DAMAGE_METER_BOSS_TIMER_TIME        = 0
GameRules.DAMAGE_METER_TIMER_COUNT            = {}
GameRules.DAMAGE_METER_TOTAL_DAMAGE           = 0
GameRules.DAMAGE_METER_TOTAL_DAMAGE_HERO      = {}
GameRules.DAMAGE_METER_DPS_HERO               = {}
GameRules.DAMAGE_METER_DAMAGE_PERCENTAGE_HERO = {}

GameRules.HTTP_PAYLOAD = {}
PlayerCount_Start = 0

HeroEntities = {}

ItemsBuyTime = {}


if not Dungeoneer then
	Dungeoneer = {}
end

function GameMode:PostLoadPrecache()

end

function GameMode:OnFirstPlayerLoaded()
	SetActiveArena( GetRandomArena() )

	Physics:GenerateAngleGrid()
end

function GameMode:OnHeroInGame(unit)

	local player = unit:GetPlayerOwner()
	local playerID = unit:GetPlayerOwnerID()

	local isIllusion = false

	--Remove Outpost Capture Ability
	unit:RemoveAbility("ability_capture")

	if unit:GetTeamNumber() == DOTA_TEAM_GOODGUYS then

		local delayAdded = 0.2
		local delay = 0

		Timers:CreateTimer(0.1, function()
			if unit:FindModifierByName("modifier_illusion") ~= nil then
				isIllusion = true
			end
		end)

		if isIllusion then return end

		-- Add Artifact Ability --
		delay = delay + RandomFloat(0.0, delayAdded)
		Timers:CreateTimer(delay, function()
			if not unit:IsTempestDouble() then

				local abilityArtifact = unit:AddAbility("artifact_ability")
				abilityArtifact:SetLevel(1)
				abilityArtifact:SetActivated(false)

				if unit:GetAbilityByIndex(3):GetAbilityName() ~= "generic_hidden" and
				 	unit:GetAbilityByIndex(4):GetAbilityName() ~= "generic_hidden" then

					local abilityReplace = unit:GetAbilityByIndex(4)
					unit:SwapAbilities(abilityReplace:GetAbilityName(), "artifact_ability", false, true)

				else
					unit:SwapAbilities("generic_hidden", "artifact_ability", false, true)
				end

			end

			if not unit:HasModifier("castrange_modifier_ability") then
				unit:AddNewModifier(unit, self, "castrange_modifier_ability", {} )
			end
			if not unit:HasModifier("cooldown_modifier_ability") then
				unit:AddNewModifier(unit, self, "cooldown_modifier_ability", {} )
			end

		end)

		-- Teleport to Arena
		delay = delay + RandomFloat(0.0, delayAdded)
		Timers:CreateTimer(delay, function()
			if not unit:IsTempestDouble() then
				PlayerResource:SetCameraTarget(playerID, unit)
				FindClearSpaceForUnit(unit, GetSpecificBorderPoint("point_center"), false)
				unit:Stop()
			end
		end)

		-- Add Level --
		delay = delay + RandomFloat(0.0, delayAdded)
		Timers:CreateTimer(delay, function()
			if not unit:IsTempestDouble() then
				unit:AddExperience(400, DOTA_ModifyXP_Unspecified, false, true)
			end
		end)

		-- Add Items --
		delay = delay + RandomFloat(0.0, delayAdded)
		Timers:CreateTimer(delay, function()
			if not unit:IsTempestDouble() then
				local itemDrop = unit:AddItemByName("item_boots_of_rejunivation")
				itemDrop:SetPurchaser(unit)
				itemDrop:SetPurchaseTime(GameRules:GetGameTime()-10.01)
			end
		end)

		-- Add to HeroEntities --
		delay = delay + RandomFloat(0.0, delayAdded)
		Timers:CreateTimer(delay, function()
			if not unit:IsTempestDouble() then
				--table.insert(HeroEntities, unit)
				CustomGameEventManager:Send_ServerToAllClients("debug_msg", { msg="xxxxxxx HeroEntities === "..tonumber(playerID+1).." -- "..unit:GetUnitName() } )
				HeroEntities[tonumber(playerID+1)] = unit
			end
		end)
		
		-- Add Physics --
		delay = delay + RandomFloat(0.0, delayAdded)
		Timers:CreateTimer(delay, function()
			if not IsPhysicsUnit(unit) then
				Physics:Unit(unit)
			end
		end)

		delay = delay + RandomFloat(0.0, delayAdded)
		Timers:CreateTimer(delay, function()
			if IsPhysicsUnit(unit) then
				unit:AdaptiveNavGridLookahead(true)
			end
		end)

		delay = delay + RandomFloat(0.0, delayAdded)
		Timers:CreateTimer(delay, function()
			if IsPhysicsUnit(unit) then
				unit:SetNavCollisionType(PHYSICS_NAV_BOUNCE)
			end
		end)

		delay = delay + RandomFloat(0.0, delayAdded)
		Timers:CreateTimer(delay, function()
			if IsPhysicsUnit(unit) then
				unit:SetGroundBehavior(PHYSICS_GROUND_LOCK)
			end
		end)

		delay = delay + RandomFloat(0.0, delayAdded)
		Timers:CreateTimer(delay, function()
			if IsPhysicsUnit(unit) then
				unit:SetBounceMultiplier(1.0)
			end
		end)

		-- Add Hero Special Mechanic Modifiers --
		delay = delay + RandomFloat(0.0, delayAdded)
		Timers:CreateTimer(delay, function()
			unit:AddNewModifier(unit, nil, "strength_resilience_modifier", {})
			unit:AddNewModifier(unit, nil, "arcane_knowledge_modifier", {})
		end)

		-- Add No Invis Debuff --
		delay = delay + RandomFloat(0.0, delayAdded)
		Timers:CreateTimer(delay, function()
			unit:AddNewModifier(unit, nil, "modifier_true_sight", {})
		end)

		-- Tutorial --
		delay = delay + RandomFloat(0.0, delayAdded)
		Timers:CreateTimer(delay, function()
			if not unit:IsTempestDouble() then
				Tutorial(playerID)
			end
		end)

		-- Free Camera --
		delay = delay + RandomFloat(0.0, delayAdded)
		Timers:CreateTimer(delay, function()
			if not unit:IsTempestDouble() then
				PlayerResource:SetCameraTarget(playerID, nil)
			end
		end)

		-- This project has been abandoned - thanks for playing! --
		--[[
		delay = delay + RandomFloat(0.0, delayAdded)
		Timers:CreateTimer(delay, function()
			if not unit:IsTempestDouble() then
				Notifications:TopToAll({text="This project has been abandoned - thanks for playing!", duration=10.0, style={color="rgb(200, 32, 32)", ["font-size"]="40px", ["text-shadow"]="1px 1px 4px 5.0 #333333b0"}, continue=false})
			end
		end)
		]]
		
		-- #### DEBUG #### DEBUG #### DEBUG #### DEBUG #### DEBUG #### --
		-- #### DEBUG #### DEBUG #### DEBUG #### DEBUG #### DEBUG #### --
		-- #### DEBUG #### DEBUG #### DEBUG #### DEBUG #### DEBUG #### --

		--unit:AddExperience(900, 0, false, true)

		-- Perk Debug --
		--unit:AddNewModifier(unit, nil, "greater_crusader_shield", {})

		-- #### DEBUG #### DEBUG #### DEBUG #### DEBUG #### DEBUG #### --
		-- #### DEBUG #### DEBUG #### DEBUG #### DEBUG #### DEBUG #### --
		-- #### DEBUG #### DEBUG #### DEBUG #### DEBUG #### DEBUG #### --
	end
end

function GameMode:OnAllPlayersLoaded()

	Timers:CreateTimer(1.0, function()

		GeneratePerksAllPlayers()

		PerkReplaceInit()

		ChecklistsInitialize()

		CustomGameEventManager:Send_ServerToAllClients("toggle_boss_info_visibility", { visible=false } )

		CustomGameEventManager:Send_ServerToAllClients("info_round", { round=1 } )

	end)
	
end

function GameMode:OnGameInProgress()
	Timers:CreateTimer(1.0, function()

		for i=0,GetPlayerCount()-1 do

			--[[
			local player = PlayerResource:GetPlayer(i)
			if player ~= nil then
				local hero = player:GetAssignedHero()
				if hero ~= nil then
					table.insert(HeroEntities, hero)
				end
			end]]

			GameModeVote_Initilize(i)
		end

		GameModeVote_InitilizeAll()

		PlayerCount_Start = GetPlayerCount()

		if DEBUG then
			CustomGameEventManager:Send_ServerToAllClients("perkspicker_debug", {} )
		end

	end)

	--[[
	if IsInToolsMode() then
		local player = PlayerResource:GetPlayer(0)
		local hero = player:GetAssignedHero()

		Timers:CreateTimer(5.0, function()

			for i=0,14 do
				local item = hero:GetItemInSlot(i)
				if item ~= nil then
					print(" - DEBUG - 1", (item:GetPurchaseTime() * 100) / 100)
				end
			end

			return 2.0
		end)
	end
	]]

	Timers:CreateTimer(10.0, function()

		ArenaOutOfBoundsDetector()

	end)
end

function GameMode:InitGameMode()
	GameMode = self

	-- Commands
	--Convars:RegisterCommand( "win", Dynamic_Wrap(GameMode, 'Win'), "A console command example", FCVAR_CHEAT )

	-- Listeners
	--CustomGameEventManager:RegisterListener( "readycheck_vote", Dynamic_Wrap(GameMode, 'ReadyCheck_Vote'))
	CustomGameEventManager:RegisterListener( "gamemode_lock", Dynamic_Wrap(GameMode, 'GameModeVote_Lock'))
	CustomGameEventManager:RegisterListener( "gamemode_upvote", Dynamic_Wrap(GameMode, 'GameModeVote_Upvote'))

	CustomGameEventManager:RegisterListener( "gamemode_classicsubmode_lock", Dynamic_Wrap(GameMode, 'GameModeVote_ClassicSubMode_Lock'))
	CustomGameEventManager:RegisterListener( "gamemode_classicsubmode_difficulty", Dynamic_Wrap(GameMode, 'GameModeVote_ClassicSubMode_Difficulty'))
	CustomGameEventManager:RegisterListener( "gamemode_classicsubmode_casualmode", Dynamic_Wrap(GameMode, 'GameModeVote_ClassicSubMode_CasualMode'))
	CustomGameEventManager:RegisterListener( "gamemode_classicsubmode_endlessmode", Dynamic_Wrap(GameMode, 'GameModeVote_ClassicSubMode_EndlessMode'))

	CustomGameEventManager:RegisterListener( "loot_empower", Dynamic_Wrap(GameMode, 'Loot_Empower'))
	CustomGameEventManager:RegisterListener( "loot_overview_lock", Dynamic_Wrap(GameMode, 'Loot_Lock'))

	CustomGameEventManager:RegisterListener( "perks_lock", Dynamic_Wrap(GameMode, 'Perks_Lock'))
	CustomGameEventManager:RegisterListener( "perks_upvote", Dynamic_Wrap(GameMode, 'Perks_Upvote'))
	CustomGameEventManager:RegisterListener( "perks_sell", Dynamic_Wrap(GameMode, 'Perks_Sell'))
	CustomGameEventManager:RegisterListener( "perks_reroll", Dynamic_Wrap(GameMode, 'Perks_Reroll'))
	CustomGameEventManager:RegisterListener( "perks_skip", Dynamic_Wrap(GameMode, 'Perks_Skip'))
	CustomGameEventManager:RegisterListener( "activeperks_replace", Dynamic_Wrap(GameMode, 'Perks_Replace'))
	CustomGameEventManager:RegisterListener( "activeperks_use_ability", Dynamic_Wrap(GameMode, 'Perks_UseAbility'))

	CustomGameEventManager:RegisterListener( "boss_info_reroll_boss", Dynamic_Wrap(GameMode, 'Encounter_Reroll'))
	CustomGameEventManager:RegisterListener( "retryfight", Dynamic_Wrap(GameMode, 'Encounter_Retry'))
	CustomGameEventManager:RegisterListener( "ready", Dynamic_Wrap(GameMode, 'Encounter_Ready'))

	CustomGameEventManager:RegisterListener( "continue_vote", Dynamic_Wrap(GameMode, 'Continue_Vote'))

	-- Filters --
	GameRules:GetGameModeEntity():SetDamageFilter(Dynamic_Wrap(GameMode, "DamageFilter"), self)
	GameRules:GetGameModeEntity():SetModifyGoldFilter(Dynamic_Wrap(GameMode, "GoldGainedFilter"), self)
	GameRules:GetGameModeEntity():SetItemAddedToInventoryFilter(Dynamic_Wrap(GameMode, "ItemAddedToInventoryFilter"), self)
	--GameRules:GetGameModeEntity():SetModifierGainedFilter(Dynamic_Wrap(GameMode, "ModifierGainedFilter"), self)

end


function GameMode:DamageFilter(event)
	local damage      = event.damage
	local damageType  = event.damagetype_const

	if event.entindex_attacker_const ~= nil and event.entindex_victim_const ~= nil then

		local attacker = EntIndexToHScript(event.entindex_attacker_const)
		local victim = EntIndexToHScript(event.entindex_victim_const)

		--

		local Modifier = victim:FindModifierByName("glyph_petrified_cloak")

		if Modifier ~= nil then

			local staggered_damage_percentage = ( Modifier.staggered_damage / 100 ) * ( Modifier:GetStackCount() / 10000 )
			if staggered_damage_percentage > 1.0 then staggered_damage_percentage = 1.0 end
			local staggered_damage = damage * staggered_damage_percentage
			event.damage = event.damage - staggered_damage
		end

		--

		local Modifier = victim:FindModifierByName("glyph_sacred_bracing")

		if Modifier ~= nil then

			if Modifier.shield_hp > 0 then
				local result = Modifier.shield_hp - damage

				if result < 0 then
					Modifier.shield_hp = 0
					event.damage = math.abs(result)

					-- Particle --
					if victim.shield_particle ~= nil then
						ParticleManager:DestroyParticle( victim.shield_particle, false )
						ParticleManager:ReleaseParticleIndex( victim.shield_particle )
						victim.shield_particle = nil
					end

				else
					Modifier.shield_hp = result
					return false
				end
			end
		end

		--

		if victim:GetUnitName() == "npc_dota_hero_treasure_on_a_tree" and victim.golden_shield_hero_angle ~= nil then

			local angle = 90

			--local hero_angle = victim:GetAnglesAsVector().y
			local hero_angle = victim.golden_shield_hero_angle
			local origin_difference = attacker:GetAbsOrigin() - victim:GetAbsOrigin()

			local origin_difference_radian = math.atan2(origin_difference.y, origin_difference.x)

			origin_difference_radian = origin_difference_radian * 180
			local caster_angle = origin_difference_radian / math.pi
			caster_angle = caster_angle + 0.0 -- +180 for opposite side

			local result_angle = caster_angle - hero_angle
			result_angle = math.abs(result_angle)

			if result_angle > 360.00 then
				result_angle = result_angle - 360.00
			end

			if ( result_angle >= 0 and result_angle <= (angle / 2) ) or
				( result_angle >= (360 - (angle / 2)) and result_angle <= 360 ) then

				-- Sound --
				StartSoundEventReliable("Hero_Bristleback.Bristleback", victim)

				return false
			end


		end

		--

	end

	return true
end

function GameMode:GoldGainedFilter(event)
	local reason		= event.reason_const
	local reliable		= event.reliable
	local playerID		= event.player_id_const
	local gold			= event.gold

	if reason ~= DOTA_ModifyGold_Unspecified then
		return false
	end

	return true
end

function GameMode:ItemAddedToInventoryFilter(event, context)

	local unit = EntIndexToHScript( event.item_parent_entindex_const ) --event.inventory_parent_entindex_const
	local item = EntIndexToHScript( event.item_entindex_const )
	local suggested_slot = event.suggested_slot

	--print("DEBUG - ItemAddedToInventoryFilter !!! unit:GetUnitName", unit:GetUnitName() )
	--print("DEBUG - ItemAddedToInventoryFilter !!! item:GetAbilityName", item:GetAbilityName() )
	--print("DEBUG - ItemAddedToInventoryFilter !!! suggested_slot", suggested_slot)
	--print("DEBUG - ItemAddedToInventoryFilter END !!!")

	if item:GetAbilityName() == "item_book_of_agility" then
		Item_ConsumeBook(unit, item, "item_book_of_agility", "item_book_of_agility_modifier", "bonus_agility")
		return false
	end
	if item:GetAbilityName() == "item_book_of_strength" then
		Item_ConsumeBook(unit, item, "item_book_of_strength", "item_book_of_strength_modifier", "bonus_strength")
		return false
	end
	if item:GetAbilityName() == "item_book_of_intelligence" then
		Item_ConsumeBook(unit, item, "item_book_of_intelligence", "item_book_of_intelligence_modifier", "bonus_intelligence")
		return false
	end
	if item:GetAbilityName() == "item_ancient_book_of_proficiency" then

		local bonus = item:GetSpecialValueFor("bonus_all_stats")

		unit:AddNewModifier(unit, nil, "item_ancient_book_of_proficiency_modifier", {bonus=bonus} )
		unit:EmitSound("Item.TomeOfKnowledge")

		UTIL_Remove(item)

		return false
	end

	if item:GetAbilityName() == "item_artifact_of_lesser_knowledge" then

		local limit_per_hero = item:GetSpecialValueFor("limit_per_hero")

		if unit.item_consumed_books == nil then
			unit.item_consumed_books = {}
		end

		if unit.item_consumed_books["item_artifact_of_lesser_knowledge"] == nil then
			unit.item_consumed_books["item_artifact_of_lesser_knowledge"] = 0
		end

		if unit.item_consumed_books["item_artifact_of_lesser_knowledge"] < limit_per_hero then
			--unit:AddNewModifier(unit, nil, "item_artifact_of_lesser_knowledge_modifier", {})
			unit:EmitSound("Item.MoonShard.Consume")
			LootPerks( unit:GetPlayerOwnerID(), true, "lesser" )
			unit.item_consumed_books["item_artifact_of_lesser_knowledge"] = unit.item_consumed_books["item_artifact_of_lesser_knowledge"] + 1
		else
			unit:ModifyGold(item:GetCost(), true, DOTA_ModifyGold_Unspecified)
			Notifications:Bottom(unit:GetPlayerOwnerID(), {text="You cannot exceed the hero limit of "..limit_per_hero, duration=2.0, style={color="rgb(200, 48, 48)", ["font-size"]="20", ["text-shadow"]="1px 1px 4px 5.0 #333333b0"}, continue=false})
		end

		UTIL_Remove(item)

		return false
	end

	if item:GetAbilityName() == "item_artifact_of_greater_knowledge" then

		local limit_per_hero = item:GetSpecialValueFor("limit_per_hero")

		if unit.item_consumed_books == nil then
			unit.item_consumed_books = {}
		end

		if unit.item_consumed_books["item_artifact_of_greater_knowledge"] == nil then
			unit.item_consumed_books["item_artifact_of_greater_knowledge"] = 0
		end

		if unit.item_consumed_books["item_artifact_of_greater_knowledge"] < limit_per_hero then
			--unit:AddNewModifier(unit, nil, "item_artifact_of_lesser_knowledge_modifier", {})
			unit:EmitSound("Item.MoonShard.Consume")
			LootPerks( unit:GetPlayerOwnerID(), true, "greater" )
			unit.item_consumed_books["item_artifact_of_greater_knowledge"] = unit.item_consumed_books["item_artifact_of_greater_knowledge"] + 1
		else
			unit:ModifyGold(item:GetCost(), true, DOTA_ModifyGold_Unspecified)
			Notifications:Bottom(unit:GetPlayerOwnerID(), {text="You cannot exceed the hero limit of "..limit_per_hero, duration=2.0, style={color="rgb(200, 48, 48)", ["font-size"]="20", ["text-shadow"]="1px 1px 4px 5.0 #333333b0"}, continue=false})
		end

		UTIL_Remove(item)

		return false
	end

	return true
end

function Item_ConsumeBook(unit, item, item_name, item_modifier_name, item_bonus)

		local bonus = item:GetSpecialValueFor(item_bonus)
		local limit_per_hero = item:GetSpecialValueFor("limit_per_hero")

		if unit.item_consumed_books == nil then
			unit.item_consumed_books = {}
		end

		if unit.item_consumed_books[item_name] == nil then
			unit.item_consumed_books[item_name] = 0
		end

		if unit.item_consumed_books[item_name] < limit_per_hero then
			unit:AddNewModifier(unit, nil, item_modifier_name, {bonus=bonus} )
			unit:EmitSound("Item.TomeOfKnowledge")
			unit.item_consumed_books[item_name] = unit.item_consumed_books[item_name] + 1
		else
			unit:ModifyGold(item:GetCost(), true, DOTA_ModifyGold_Unspecified)
			Notifications:Bottom(unit:GetPlayerOwnerID(), {text="You cannot exceed the hero limit of "..limit_per_hero, duration=2.0, style={color="rgb(200, 48, 48)", ["font-size"]="20", ["text-shadow"]="1px 1px 4px 5.0 #333333b0"}, continue=false})
		end

		UTIL_Remove(item)
end

function stringSplit(inputstr, sep)
        if sep == nil then
                sep = "%s"
        end
        local t={} ; i=1
        for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
                t[i] = str
                i = i + 1
        end
        return t
end

function round(number, decimals)
    local power = 10^decimals
    return math.floor(number * power) / power
end

function titleCase( first, rest )
   return first:upper()..rest:lower()
end











































































































































