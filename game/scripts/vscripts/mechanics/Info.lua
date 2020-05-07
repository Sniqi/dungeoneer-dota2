-- CONSTANTS

local TimeScore_Timer = nil

-- FUNCTIONS

function InfoSetGameMode()
	CustomGameEventManager:Send_ServerToAllClients("info_difficulty", {gamemode = GameMode_Active, difficulty = GameMode_Difficulty, casual = ClassicSubMode_Casual, endless = ClassicSubMode_Endless} )
end

function InfoAlterScore(score)
	if score ~= 0 then
		if ClassicSubMode_Casual then
			score = score * ClassicSubMode_Casual_ScoreMutliplier
		end
		score = score * GameMode_Difficulty
		Score = Score + score
		if score > 1 or score < -1 then
			CustomGameEventManager:Send_ServerToAllClients("score", {score = Score, diff = score} )
		end
	end
end

function InfoRefreshScore()
	CustomGameEventManager:Send_ServerToAllClients("score", {score = Score, diff = 0} )
end

function InfoTimeScore()
	if TimeScore_Timer ~= nil then return end

	TimeScore_Timer = Timers:CreateTimer(ScoreTimeCycle, function()

		InfoAlterScore( ScoreData_Time[ GameMode_Active ] )

		return ScoreTimeCycle
	end)
end
