-- This file contains all barebones-registered events and has already set up the passed-in parameters for your use.

-- Cleanup a player when they leave
function GameMode:OnDisconnect(keys)
  local name = keys.name
  local networkid = keys.networkid
  local reason = keys.reason
  local userid = keys.userid

  local playerID = keys.PlayerID
  local player = PlayerResource:GetPlayer(playerID)
  local hero = player:GetAssignedHero()

  Timers:CreateTimer(0.5, function()

    if GetPlayerCountConnected() == 0 then

      --HTTP_Aggregate_Data(false)
      --GameRules:SetGameWinner(DOTA_TEAM_NEUTRALS)

    else

      Notifications:BottomToAll({text="A player disconnected from the game! Players left: "..GetPlayerCountConnected(), duration=3, style={color="rgb(200, 48, 48)", ["font-size"]="22px", ["text-shadow"]="1px 1px 4px 5.0 #333333b0"}, continue=false})

      hero:AddNewModifier(hero, nil, "modifier_player_disconnected", {})

      if LOOT_PERKS_TIMER1 ~= nil then
        if LOOT_PERKS_TIMER1[playerID] ~= nil then
          Timers:RemoveTimer(LOOT_PERKS_TIMER1[playerID])
          LOOT_PERKS_TIMER1[playerID] = nil
        end
      end

      if LOOT_PERKS_TIMER2 ~= nil then
        if LOOT_PERKS_TIMER2[playerID] ~= nil then
          Timers:RemoveTimer(LOOT_PERKS_TIMER2[playerID])
          LOOT_PERKS_TIMER2[playerID] = nil
        end
      end

    end

  end)

end

-- A player has reconnected to the game. This function can be used to repaint Player-based particles or change
-- state as necessary
function GameMode:OnPlayerReconnect(keys)
  local playerID = keys.PlayerID

  Notifications:BottomToAll({text="A Player is reconnecting", duration=4.0, style={color="rgb(48, 200, 48)", ["font-size"]="22px", ["text-shadow"]="1px 1px 4px 5.0 #333333b0"}, continue=false})
  Timers:CreateTimer(1.0, function()
    Notifications:BottomToAll({text=".", duration=3.0, style={color="rgb(48, 200, 48)", ["font-size"]="22px", ["text-shadow"]="1px 1px 4px 5.0 #333333b0"}, continue=true})
  end)
  Timers:CreateTimer(2.0, function()
    Notifications:BottomToAll({text=".", duration=2.0, style={color="rgb(48, 200, 48)", ["font-size"]="22px", ["text-shadow"]="1px 1px 4px 5.0 #333333b0"}, continue=true})
  end)
  Timers:CreateTimer(3.0, function()
    Notifications:BottomToAll({text=".", duration=1.0, style={color="rgb(48, 200, 48)", ["font-size"]="22px", ["text-shadow"]="1px 1px 4px 5.0 #333333b0"}, continue=true})
  end)

  Timers:CreateTimer(4.0, function()

    local player = PlayerResource:GetPlayer(playerID)
    local hero = player:GetAssignedHero()

    Notifications:BottomToAll({text="A player reconnected! Active players: "..GetPlayerCountConnected(), duration=3, style={color="rgb(48, 200, 48)", ["font-size"]="22px", ["text-shadow"]="1px 1px 4px 5.0 #333333b0"}, continue=false})

    --Game Mode
    if GameMode_Active == nil then
      GameModeVote_Show(playerID)
    else
      GameModeVote_Hide(playerID)
    end

    if DEBUG then
      CustomGameEventManager:Send_ServerToAllClients("debug_msg", { msg="DEBUG - GameMode:OnPlayerReconnect() Game Mode ShowHide" } )
    end

    --Info
    InfoSetGameMode()

    if DEBUG then
      CustomGameEventManager:Send_ServerToAllClients("debug_msg", { msg="DEBUG - GameMode:OnPlayerReconnect() InfoSetGameMode" } )
    end

    InfoRefreshScore()

    if DEBUG then
      CustomGameEventManager:Send_ServerToAllClients("debug_msg", { msg="DEBUG - GameMode:OnPlayerReconnect() InfoRefreshScore" } )
    end

    --Active Perks
    GenerateActivePerks(playerID)

    if DEBUG then
      CustomGameEventManager:Send_ServerToAllClients("debug_msg", { msg="DEBUG - GameMode:OnPlayerReconnect() Active Perks" } )
    end

    --Revive
    if not hero:IsAlive() then
      --hero:RespawnHero(false, false)
    end

    if DEBUG then
      CustomGameEventManager:Send_ServerToAllClients("debug_msg", { msg="DEBUG - GameMode:OnPlayerReconnect() revive" } )
    end

    --Unstuck
    FindClearSpaceForUnit(hero, hero:GetAbsOrigin(), false)

    if DEBUG then
      CustomGameEventManager:Send_ServerToAllClients("debug_msg", { msg="DEBUG - GameMode:OnPlayerReconnect() unstuck" } )
    end

    --Modifier
    hero:RemoveModifierByName("modifier_player_disconnected")

    if DEBUG then
      CustomGameEventManager:Send_ServerToAllClients("debug_msg", { msg="DEBUG - GameMode:OnPlayerReconnect() Modifier" } )
    end

  end)

end


-- The overall game state has changed
function GameMode:OnGameRulesStateChange(keys)
  local newState = GameRules:State_Get()
end

-- An NPC has spawned somewhere in game. This includes heroes
function GameMode:OnNPCSpawned(keys)
  local unit = EntIndexToHScript(keys.entindex)

  if string.match(unit:GetUnitName(), "npc_dota_lone_druid_bear") then
    local hero = Entities:FindAllByName("npc_dota_hero_lone_druid")[1]
    hero.spirit_bear = unit
    hero.spirit_bear:FindAbilityByName("treant_living_armor"):SetLevel( hero:FindAbilityByName("treant_living_armor"):GetLevel() )
  end
end

-- An entity somewhere has been hurt. This event fires very often with many units so don't do too many expensive
-- operations here
function GameMode:OnEntityHurt(keys)
  --[[
  local damagebits = keys.damagebits -- This might always be 0 and therefore useless
  if keys.entindex_attacker ~= nil and keys.entindex_killed ~= nil then
    local entCause = EntIndexToHScript(keys.entindex_attacker)
    local entVictim = EntIndexToHScript(keys.entindex_killed)

    -- The ability/item used to damage, or nil if not damaged by an item/ability
    local damagingAbility = nil

    if keys.entindex_inflictor ~= nil then
      damagingAbility = EntIndexToHScript( keys.entindex_inflictor )
    end
  end
  ]]
end

-- An item was picked up off the ground
function GameMode:OnItemPickedUp(keys)

  local unitEntity = nil
  if keys.UnitEntitIndex then
    unitEntity = EntIndexToHScript(keys.UnitEntitIndex)
  elseif keys.HeroEntityIndex then
    unitEntity = EntIndexToHScript(keys.HeroEntityIndex)
  end

  local itemEntity = EntIndexToHScript(keys.ItemEntityIndex)
  local player = PlayerResource:GetPlayer(keys.PlayerID)
  local itemname = keys.itemname

  --RefreshPerkModifiers()
end

-- An item was purchased by a player
function GameMode:OnItemPurchased( keys )

  local playerID = keys.PlayerID
  if not playerID then return end
  local player = PlayerResource:GetPlayer(playerID)
  local hero = player:GetAssignedHero()
  local itemName = keys.itemname 
  local itemcost = keys.itemcost

  SetItemPurchaseTime(hero, itemName)

  if string.match(itemName, "item_recipe_assault" ) or
    string.match(itemName, "item_recipe_radiance" ) or
    string.match(itemName, "item_recipe_shivas_guard" ) or
    string.match(itemName, "item_recipe_vladmir" ) then

    itemName = string.gsub( itemName, "item_recipe", "item" )
    itemName = string.gsub( itemName, "_2", "" )
    itemName = string.gsub( itemName, "_3", "" )

    for i,mod in pairs( hero:FindAllModifiers() ) do

      local abilityName = mod:GetClass()

      if string.match(abilityName, itemName) then -- and mod:GetElapsedTime() ~= 0
        mod:Destroy()
      end
      
    end

    for i=0,16 do
      local itemHandle = hero:GetItemInSlot(i)
      if itemHandle ~= nil then
        if string.match(itemHandle:GetAbilityName(), itemName) then
          
          Timers:CreateTimer(0.01, function()
            hero:SwapItems(i, 6)
          end)
          

          Timers:CreateTimer(0.1, function()
            hero:SwapItems(6, i)
          end)

        end
      end
    end
    
  end

  --if caster:GetGold() <= 500 then
    ChecklistUpdateItems(playerID, {"gold"}, "done")
  --end

  --RefreshPerkModifiers()
end

-- This function is called whenever an item is combined to create a new item
function GameMode:OnItemCombined(keys)
  -- The playerID of the hero who is buying something
  local playerID = keys.PlayerID
  if not playerID then return end
  local player = PlayerResource:GetPlayer(playerID)
  local hero = player:GetAssignedHero()

  -- The name of the item purchased
  local itemName = keys.itemname 
  
  -- The cost of the item purchased
  local itemcost = keys.itemcost

  SetItemPurchaseTime(hero, itemName)

  RefreshPerkModifiers()
end

function SetItemPurchaseTime(hero, itemName)

  for i=0,14 do
    local item = hero:GetItemInSlot(i)

    if item ~= nil then
      if itemName == item:GetAbilityName() and item.buytime == nil then
        item.buytime = math.floor(GameRules:GetGameTime() * 100) / 100
      end
    end

  end

end

-- This function is called whenever an ability begins its PhaseStart phase (but before it is actually cast)
function GameMode:OnAbilityCastBegins(keys)
  local player = PlayerResource:GetPlayer(keys.PlayerID)
  local abilityName = keys.abilityname
end

-- An ability was used by a player
function GameMode:OnAbilityUsed(keys)
  local playerID = keys.PlayerID
  local player = PlayerResource:GetPlayer(playerID)
  local hero = player:GetAssignedHero()
  local abilityname = keys.abilityname

  --RefreshPerkModifiers()

  if abilityname == "lone_druid_true_form" and hero:FindAbilityByName("lone_druid_spirit_bear"):GetLevel() > 0 then

    local artifactAbility = hero:FindAbilityByName("artifact_ability")
    local artifactLvl = artifactAbility:GetLevel()
    local artifactStatus = artifactAbility:IsActivated()

    local timer = Timers:CreateTimer(0.1, function()

      local ability = hero:GetAbilityByIndex(3)
      if ability ~= nil then
        if ability:GetAbilityName() == "lone_druid_spirit_bear_demolish" then

          local ability = hero:AddAbility("artifact_ability")

          hero:SwapAbilities("lone_druid_spirit_bear_demolish", "artifact_ability", false, true)
          hero:SwapAbilities("artifact_ability", "lone_druid_spirit_bear_entangle", true, true)
          ability:SetLevel(artifactLvl)
          ability:SetActivated(artifactStatus)

          return
        end
      end

      return 0.1
    end)

  end

end

-- A non-player entity (necro-book, chen creep, etc) used an ability
function GameMode:OnNonPlayerUsedAbility(keys)
  local abilityname = keys.abilityname
end

-- A channelled ability finished by either completing or being interrupted
function GameMode:OnAbilityChannelFinished(keys)
  local abilityname = keys.abilityname
  local interrupted = keys.interrupted == 1
end

-- A player changed their name
function GameMode:OnPlayerChangedName(keys)
  local newName = keys.newname
  local oldName = keys.oldName
end

-- A player leveled up an ability
function GameMode:OnPlayerLearnedAbility(keys)
  local playerID = keys.PlayerID
  local player = PlayerResource:GetPlayer(playerID)--EntIndexToHScript(keys.player)
  local abilityname = keys.abilityname
  local hero = player:GetAssignedHero()

  if hero:GetAbilityPoints() == 0 then
    ChecklistUpdateItems(playerID, {"level"}, "done")
  end

  if hero:GetUnitName() == "npc_dota_hero_lone_druid" then
    if hero.spirit_bear ~= nil then
      hero.spirit_bear:FindAbilityByName("treant_living_armor"):SetLevel( hero:FindAbilityByName("treant_living_armor"):GetLevel() )
    end
  end
end

-- A player leveled up
function GameMode:OnPlayerLevelUp(keys)
  local player = EntIndexToHScript(keys.player)
  local level = keys.level
end

-- A player last hit a creep, a tower, or a hero
function GameMode:OnLastHit(keys)
  local isFirstBlood = keys.FirstBlood == 1
  local isHeroKill = keys.HeroKill == 1
  local isTowerKill = keys.TowerKill == 1
  local player = PlayerResource:GetPlayer(keys.PlayerID)
  local killedEnt = EntIndexToHScript(keys.EntKilled)
end

-- A tree was cut down by tango, quelling blade, etc
function GameMode:OnTreeCut(keys)
  local treeX = keys.tree_x
  local treeY = keys.tree_y
end

-- A rune was activated by a player
function GameMode:OnRuneActivated (keys)
  local player = PlayerResource:GetPlayer(keys.PlayerID)
  local rune = keys.rune

  --[[ Rune Can be one of the following types
  DOTA_RUNE_DOUBLEDAMAGE
  DOTA_RUNE_HASTE
  DOTA_RUNE_HAUNTED
  DOTA_RUNE_ILLUSION
  DOTA_RUNE_INVISIBILITY
  DOTA_RUNE_BOUNTY
  DOTA_RUNE_MYSTERY
  DOTA_RUNE_RAPIER
  DOTA_RUNE_REGENERATION
  DOTA_RUNE_SPOOKY
  DOTA_RUNE_TURBO
  ]]
end

-- A player took damage from a tower
function GameMode:OnPlayerTakeTowerDamage(keys)
  local player = PlayerResource:GetPlayer(keys.PlayerID)
  local damage = keys.damage
end

-- A player picked a hero
function GameMode:OnPlayerPickHero(keys)
  local heroClass = keys.hero
  local heroEntity = EntIndexToHScript(keys.heroindex)
  local player = EntIndexToHScript(keys.player)
end

-- A player killed another player in a multi-team context
function GameMode:OnTeamKillCredit(keys)
  local killerPlayer = PlayerResource:GetPlayer(keys.killer_userid)
  local victimPlayer = PlayerResource:GetPlayer(keys.victim_userid)
  local numKills = keys.herokills
  local killerTeamNumber = keys.teamnumber
end

-- An entity died
function GameMode:OnEntityKilled( keys )
  -- The Unit that was Killed
  local killedUnit = EntIndexToHScript( keys.entindex_killed )
  -- The Killing entity
  local killerEntity = nil

  if keys.entindex_attacker ~= nil then
    killerEntity = EntIndexToHScript( keys.entindex_attacker )
  end

  -- The ability/item used to kill, or nil if not killed by an item/ability
  local killerAbility = nil

  if keys.entindex_inflictor ~= nil then
    killerAbility = EntIndexToHScript( keys.entindex_inflictor )
  end

  local damagebits = keys.damagebits -- This might always be 0 and therefore useless

  -- Put code here to handle when an entity gets killed

  if killedUnit == GetCurrentEncounterEntity() then
    EncounterDefeated()
  end

  if killedUnit:IsRealHero() and GetHeroesAliveCount_Active() == 0 then
    PlayersDefeated()
  end

  -- Score
  for _,hero in pairs(GetHeroesEntities()) do
    if killedUnit == hero then
      InfoAlterScore( ScoreData_Death[ GameMode_Active ] )
      ENCOUNTER_FIGHTS[ GetRound() .. "_" .. EncounterTries ]["deaths"] = ENCOUNTER_FIGHTS[ GetRound() .. "_" .. EncounterTries ]["deaths"] + 1
    end
  end
end


-- This function is called 1 to 2 times as the player connects initially but before they 
-- have completely connected
function GameMode:PlayerConnect(keys)
end

-- This function is called once when the player fully connects and becomes "Ready" during Loading
function GameMode:OnConnectFull(keys)
  local entIndex = keys.index+1
  -- The Player entity of the joining user
  local ply = EntIndexToHScript(entIndex)
  
  -- The Player ID of the joining player
  local playerID = ply:GetPlayerID()
end

-- This function is called whenever illusions are created and tells you which was/is the original entity
function GameMode:OnIllusionsCreated(keys)
  local originalEntity = EntIndexToHScript(keys.original_entindex)
end

-- This function is called whenever a tower is killed
function GameMode:OnTowerKill(keys)
  local gold = keys.gold
  local killerPlayer = PlayerResource:GetPlayer(keys.killer_userid)
  local team = keys.teamnumber
end

-- This function is called whenever a player changes there custom team selection during Game Setup 
function GameMode:OnPlayerSelectedCustomTeam(keys)
  local player = PlayerResource:GetPlayer(keys.player_id)
  local success = (keys.success == 1)
  local team = keys.team_id
end

-- This function is called whenever an NPC reaches its goal position/target
function GameMode:OnNPCGoalReached(keys)
  local goalEntity = EntIndexToHScript(keys.goal_entindex)
  local nextGoalEntity = EntIndexToHScript(keys.next_goal_entindex)
  local npc = EntIndexToHScript(keys.npc_entindex)
end

-- This function is called whenever any player sends a chat message to team or All
function GameMode:OnPlayerChat(keys)
  local teamonly = keys.teamonly
  local userID = keys.userid
  local playerID = self.vUserIds[userID]:GetPlayerID()
  local player = PlayerResource:GetPlayer(playerID)
  local unit = player:GetAssignedHero()

  local text = keys.text

--$DEBUG
  -- Sniqi only commands --
  if tostring(PlayerResource:GetSteamAccountID(playerID)) == "41536950" and tostring(PlayerResource:GetSteamID(playerID)) == "76561198001802678" then

    if text == "-kill" then
      GetCurrentEncounterEntity():Kill(nil, nil)
    end

    if text == "-die" then
      for _,hero in pairs(GetHeroesEntities()) do
        hero:Kill(nil, nil)
      end
    end

    if text == "-pwr" then
      for _,hero in pairs(GetHeroesEntities()) do
        if hero:HasModifier("power_buff") then
          hero:RemoveModifierByName("power_buff")
          hero:SetMoveCapability(DOTA_UNIT_CAP_MOVE_GROUND)
        else
          hero:AddNewModifier(hero, nil, "power_buff", {})
          hero:SetMoveCapability(DOTA_UNIT_CAP_MOVE_FLY)

          --[[for i=1,6 do
            local itemDrop = hero:AddItemByName("item_butterfly")
            itemDrop:SetPurchaser(hero)
            itemDrop:SetPurchaseTime(GameRules:GetGameTime()-10.01)
          end]]
          
        end
      end
    end

    if text == "-pwri" then
      for _,hero in pairs(GetHeroesEntities()) do


        for i=1,6 do
          local itemDrop = hero:AddItemByName("item_butterfly")
          itemDrop:SetPurchaser(hero)
          itemDrop:SetPurchaseTime(GameRules:GetGameTime()-10.01)
        end

      end
    end

    if text == "-shop" then
      Entities:FindByName(nil, "shop"):Enable()
      print("DEBUG - SHOP")
    end

    if text == "-loot" then
      --LootPerks( 0, nil, "artifact" )
      LootOverviewStart(0)
      print("DEBUG - LOOT PERK")
    end

    if string.match(text, "-setround") then
      SetRound( stringSplit(text, " ")[2] )
      print("DEBUG - ROUND", GetRound())
    end

    if text == "-roundup" then
      IncrementRound()
      print("DEBUG - ROUND", GetRound())
    end

    if string.match(text, "-setstage") then
      SetStage( stringSplit(text, " ")[2] )
      print("DEBUG - STAGE", GetStage())
    end

    if text == "-stageup" then
      IncrementStage()
      print("DEBUG - STAGE", GetStage())
    end

    if text == "-DEBUG" then
      if DEBUG == true then
        DEBUG = false
        print("DEBUG - DEBUG", DEBUG)
      else
        DEBUG = true
        print("DEBUG - DEBUG", DEBUG)
      end
    end

    if text == "-http" then
      HTTP_Aggregate_Data(true)
    end

    if text == "-fake" then

      SendToServerConsole( 'dota_create_fake_clients' )

      for i=1,5 do
        Timers:CreateTimer(i*0.30, function()
          local fakeplayer = PlayerResource:GetPlayer(i)
          fakeplayer:SetTeam( DOTA_TEAM_GOODGUYS )
          fakeplayer:MakeRandomHeroSelection()
        end)
      end

    end

    if string.match(text, "-setboss:") then

      local encount = stringSplit(text, ":")[2]
      ENCOUNTERS[1] = { encount, encount, encount }
      ENCOUNTERS[2] = { encount, encount, encount }
      ENCOUNTERS[3] = { encount, encount, encount }
      print("DEBUG - SET BOSS TO", encount)

    end

    if text == "-normalbosses" then

      ENCOUNTERS = {}
      ENCOUNTERS[1] = {}
      for i,encounter in ipairs( ENCOUNTERS_ORIG[1] ) do
        table.insert(ENCOUNTERS[1], i, encounter)
      end
      ENCOUNTERS[2] = {}
      for i,encounter in ipairs( ENCOUNTERS_ORIG[2] ) do
        table.insert(ENCOUNTERS[2], i, encounter)
      end
      ENCOUNTERS[3] = {}
      for i,encounter in ipairs( ENCOUNTERS_ORIG[3] ) do
        table.insert(ENCOUNTERS[3], i, encounter)
      end

    end

    if text == "-buffs" then
      for _,hero in pairs(GetHeroesEntities()) do
        local allMods = hero:FindAllModifiers()

        for i,mod in pairs(allMods) do

          print("DEBUG - BUFFS", mod:GetName() )
          print("DEBUG - BUFFS --- END")


        end

      end
    end

    if string.match(text, "-seteff:") then

      local effec = stringSplit(text, ":")[2]
      PerkEffectivenessStats[0]["Defensive"] = tonumber(effec)
      print("DEBUG - SET EFFECTIVENESS TO", effec)

    end

    if text == "-showloot" then
      CustomGameEventManager:Send_ServerToAllClients("loot_show", {} )
      CustomGameEventManager:Send_ServerToAllClients("on_new_loot_line", { name="gold", descr="Gold", value=RandomInt(0, 1000), multiplier=RandomFloat(1.0, 1.5), empower=0.25, delay="0.0" } )
      CustomGameEventManager:Send_ServerToAllClients("on_new_loot_line", { name="artifact", descr=CurrencyTranslate["artifact"], value=100, multiplier=RandomFloat(1.0, 1.5), empower=0.25, delay="0.1" } )
      CustomGameEventManager:Send_ServerToAllClients("on_new_loot_line", { name="glyph", descr=CurrencyTranslate["glyph"], value=500, multiplier=RandomFloat(1.0, 1.5), empower=0.25, delay="0.2" } )
      CustomGameEventManager:Send_ServerToAllClients("on_new_loot_line", { name="level", descr="Level", value=(400/100), multiplier=1.0, empower=nil, delay="0.3" } )
    end

    if text == "-hideloot" then
      CustomGameEventManager:Send_ServerToAllClients("loot_hide", {} )
    end

  end

end