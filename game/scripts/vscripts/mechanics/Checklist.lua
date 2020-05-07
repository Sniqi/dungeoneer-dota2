-- CONSTANTS

local ChecklistItems = {}
ChecklistItems["empower"] = "Empower one currency"
ChecklistItems["artifact"] = "Use your Artifact Fragments to buy and upgrade Artifacts"
ChecklistItems["glyph"] = "Use your Glyph Particles to buy and upgrade Glyphs"
ChecklistItems["level"] = "Level up your hero"
ChecklistItems["gold"] = "Spend gold for items"

local PlayerChecklists = {}

-- FUNCTIONS

function ChecklistsInitialize()
	for playerID=0,GetPlayerCount()-1 do
		PlayerChecklists[playerID] = {}
	end
end

function ChecklistShowItems(playerID, items)
	local loopsStart = playerID
	local loopsEnd = playerID
	if playerID == nil then
		loopsStart = 0
		loopsEnd = GetPlayerCount()-1
	end
	for i=loopsStart,loopsEnd do
		playerID = i
		for _,item in pairs(items) do
			PlayerChecklists[playerID][item] = false
			CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(playerID), "on_new_checklist_item", { name=item, descr=ChecklistItems[item] } )
		end
	end
end

function ChecklistUpdateItems(playerID, items, updatetype)
	local loopsStart = playerID
	local loopsEnd = playerID
	if playerID == nil then
		loopsStart = 0
		loopsEnd = GetPlayerCount()-1
	end
	for i=loopsStart,loopsEnd do
		playerID = i
		for _,item in pairs(items) do
			PlayerChecklists[playerID][item] = true
			CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(playerID), "checklist_item_update", { name=item, descr=ChecklistItems[item], updatetype=updatetype } )
		end
	end
end

function ChecklistRemoveItems(playerID, items)
	local loopsStart = playerID
	local loopsEnd = playerID
	if playerID == nil then
		loopsStart = 0
		loopsEnd = GetPlayerCount()-1
	end
	for i=loopsStart,loopsEnd do
		playerID = i
		for _,item in pairs(items) do
			CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(playerID), "checklist_item_remove", { name=item } )
			PlayerChecklists[playerID][item] = nil
		end
	end
end

--for GameCycle

function ShowFirstChecklist()
	Timers:CreateTimer(0.0, function()
		ChecklistShowItems(nil, {"level"})
	end)

	Timers:CreateTimer(0.2, function()
		ChecklistShowItems(nil, {"gold"})
	end)
end

function RemoveFirstChecklist()
	Timers:CreateTimer(0.0, function()
		ChecklistRemoveItems(nil, {"level"})
	end)

	Timers:CreateTimer(0.2, function()
		ChecklistRemoveItems(nil, {"gold"})
	end)
end

function ShowEncounterDefeatedChecklist()
	Timers:CreateTimer(0.0, function()
		ChecklistShowItems(nil, {"empower"})
	end)

	Timers:CreateTimer(0.2, function()
		ChecklistShowItems(nil, {"artifact"})
	end)

	Timers:CreateTimer(0.4, function()
		ChecklistShowItems(nil, {"glyph"})
	end)

	Timers:CreateTimer(0.6, function()
		ChecklistShowItems(nil, {"level"})
	end)

	Timers:CreateTimer(0.8, function()
		ChecklistShowItems(nil, {"gold"})
	end)
end

function RemoveEncounterDefeatedChecklist()
	Timers:CreateTimer(0.0, function()
		ChecklistRemoveItems(nil, {"empower"})
	end)

	Timers:CreateTimer(0.2, function()
		ChecklistRemoveItems(nil, {"artifact"})
	end)

	Timers:CreateTimer(0.4, function()
		ChecklistRemoveItems(nil, {"glyph"})
	end)

	Timers:CreateTimer(0.6, function()
		ChecklistRemoveItems(nil, {"level"})
	end)

	Timers:CreateTimer(0.8, function()
		ChecklistRemoveItems(nil, {"gold"})
	end)
end