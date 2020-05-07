function DungeoneerLore_Say(sound, text)
	if sound ~= nil then
		--StartSoundEventFromPositionReliable(sound, GetSpecificBorderPoint("point_center"))
		--EmitAnnouncerSound(sound)
		EmitGlobalSound(sound)
	end
	if text ~= nil then
		GameRules:SendCustomMessage("<font color='#ff4f4f'>The Dungeoneer</font>: "..text, 0, 0)
	end
end

function DungeoneerLore_Voice_GameStart_Lore()

	local choice = 1

	local sound = ""
	local text = ""
	local delay = 0

	--First
	Timers:CreateTimer(delay, function()

		choice = RandomInt(1, 4)

		if choice == 1 then
			sound = "grimstroke_grimstroke_move_29_01"
			text = "Well now."
			delay = 1.6
		end
		if choice == 2 then
			sound = "grimstroke_grimstroke_move_29_02"
			text = "Well now."
			delay = 1.6
		end
		if choice == 3 then
			sound = "grimstroke_grimstroke_move_30"
			text = "Fine."
			delay = 1.6
		end
		if choice == 4 then
			sound = "grimstroke_grimstroke_move_37"
			text = "Oh yes."
			delay = 1.6
		end

		DungeoneerLore_Say(sound, text)

		--Second
		Timers:CreateTimer(delay, function()

			choice = RandomInt(1, 4)

			if choice == 1 then
				sound = "grimstroke_grimstroke_spawn_09"
				text = "I alone hold back the ink tide."
				delay = 4.5
			end
			if choice == 2 then
				sound = "grimstroke_grimstroke_levelup_11"
				text = "The rules of this world bind me no more."
				delay = 4.5
			end
			if choice == 3 then
				sound = "grimstroke_grimstroke_attack_12_02"
				text = "Your end draws near."
				delay = 3.5
			end
			if choice == 4 then
				sound = "grimstroke_grimstroke_respawn_15"
				text = "Those who cross me learn soon enough."
				delay = 3.5
			end

			DungeoneerLore_Say(sound, text)

			--Third
			Timers:CreateTimer(delay, function()

				choice = RandomInt(1, 3)

				if choice == 1 then
					sound = "grimstroke_grimstroke_spawn_11"
					text = "I'll paint this world as I see fit."
					delay = 4.5
				end
				if choice == 2 then
					sound = "grimstroke_grimstroke_spawn_08"
					text = "The strokes of my brush mark your fate."
					delay = 5.0
				end
				if choice == 3 then
					sound = "grimstroke_grimstroke_spawn_15"
					text = "When all hope is gone, I remain."
					delay = 4.5
				end				

				DungeoneerLore_Say(sound, text)

				--Fourth
				Timers:CreateTimer(delay, function()

					choice = RandomInt(1, 3)

					if choice == 1 then
						sound = "grimstroke_grimstroke_laugh_12"
						text = nil
						delay = 4.5
					end
					if choice == 2 then
						sound = "grimstroke_grimstroke_laugh_13"
						text = nil
						delay = 5.5
					end
					if choice == 3 then
						sound = "grimstroke_grimstroke_laugh_14"
						text = nil
						delay = 4.5
					end	
					if choice == 3 then
						sound = "grimstroke_grimstroke_laugh_15"
						text = nil
						delay = 4.5
					end				

					DungeoneerLore_Say(sound, text)
				end)
			end)
		end)
	end)
	
end

function DungeoneerLore_Voice_BeginningBattle()

	local choice = 1

	local sound = ""
	local text = ""
	local delay = 0

	choice = RandomInt(1, 12)

	if choice == 1 then
		sound = "grimstroke_grimstroke_spawn_12"
		text = "What dark mural comes to life today?"
		delay = 5.0
	end
	if choice == 2 then
		sound = "grimstroke_grimstroke_spawn_03_02"
		text = "Time for the master stroke."
		delay = 5.0
	end
	if choice == 3 then
		sound = "grimstroke_grimstroke_spawn_04"
		text = "At last, the full majesty of my design."
		delay = 5.5
	end
	if choice == 4 then
		sound = "grimstroke_grimstroke_spawn_14"
		text = "These wretched fools have no idea."
		delay = 4.5
	end
	if choice == 5 then
		sound = "grimstroke_grimstroke_spawn_16_02"
		text = "Unveiled at last."
		delay = 2.5
	end
	if choice == 6 then
		sound = "grimstroke_grimstroke_cast_04"
		text = "What hope have you?"
		delay = 2.5
	end
	if choice == 7 then
		sound = "grimstroke_grimstroke_cast_02"
		text = "Face your fate."
		delay = 2.5
	end
	if choice == 8 then
		sound = "grimstroke_grimstroke_ability1_02"
		text = "Go now, my pet."
		delay = 2.5
	end
	if choice == 9 then
		sound = "grimstroke_grimstroke_ability4_02"
		text = "The corruption grows!"
		delay = 2.5
	end
	if choice == 10 then
		sound = "grimstroke_grimstroke_ability4_14"
		text = "Trussed up and ready to serve."
		delay = 2.5
	end
	if choice == 11 then
		sound = "grimstroke_grimstroke_levelup_02"
		text = "Fear what comes next!"
		delay = 2.5
	end
	if choice == 12 then
		sound = "grimstroke_grimstroke_win_04"
		text = "As one power falls, another must rise!"
		delay = 5.5
	end

	DungeoneerLore_Say(sound, text)

end