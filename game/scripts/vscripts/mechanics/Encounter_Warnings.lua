function EncounterUnitWarning(unit, duration, follow, color) --nil, "red", "orange", "green"
	--SendOverheadEventMessage(unit, OVERHEAD_ALERT_DENY, unit, 0, unit:GetPlayerOwner() )

	if duration == nil then
		duration = 1.5
	end

	local pattach_type = nil
	local pattach_unit = nil
	if follow then
		pattach_type = PATTACH_CUSTOMORIGIN_FOLLOW--PATTACH_ABSORIGIN_FOLLOW
		pattach_unit = unit
	else
		pattach_type = PATTACH_CUSTOMORIGIN
	end

	if color == nil then
		color = Vector(255, 255, 255)
	end
	if color == "red" then
		color = Vector(255, 0, 0)
	end
	if color == "orange" then
		color = Vector(255, 155, 0)
	end
	if color == "green" then
		color = Vector(0, 255, 0)
	end

	-- Create WARNING Particle --
	local particleWarning = ParticleManager:CreateParticle("particles/warning_unit_exclamation_mark.vpcf", pattach_type, pattach_unit)
	ParticleManager:SetParticleControl( particleWarning, 0, unit:GetAbsOrigin() ) --Pos
	ParticleManager:SetParticleControl( particleWarning, 3, color ) --Color
	ParticleManager:SetParticleControl( particleWarning, 4, Vector(20, 0, 0) ) --Seq
	ParticleManager:SetParticleControl( particleWarning, 5, Vector(duration, 0, 0) ) --Duration
	PersistentParticle_Add(particleWarning)

	local timer = Timers:CreateTimer(duration+0.5, function()
		ParticleManager:DestroyParticle(particleWarning, false)
		ParticleManager:ReleaseParticleIndex(particleWarning)
		particleWarning = nil
	end)
	PersistentTimer_Add(timer)
end

function EncounterGroundAOEWarning(pos, aoe)

	-- Create WARNING Particle --
	local particleWarning = ParticleManager:CreateParticle("particles/warning_aoe_ring.vpcf", PATTACH_CUSTOMORIGIN, nil)
	ParticleManager:SetParticleControl( particleWarning, 0, pos + Vector(0,0,12) )
	ParticleManager:SetParticleControl( particleWarning, 1, Vector(aoe, 0, 0) )
	PersistentParticle_Add(particleWarning)

	local timer = Timers:CreateTimer(2.0, function()
		ParticleManager:DestroyParticle(particleWarning, false)
		ParticleManager:ReleaseParticleIndex(particleWarning)
		particleWarning = nil
	end)
	PersistentTimer_Add(timer)
end

function EncounterGroundAOEWarningSticky(pos, aoe, duration, color)

	local victim		= GetRandomHeroEntities(1)
	if not victim then return end
	victim				= victim[1]

	local model = "particles/warning_aoe_ring_sticky.vpcf"
	if color == nil then
		color = Vector(255,0,0)
	end

	pos = pos * Vector(1,1,0)
	pos = pos + ( GetGroundPosition(pos, victim) * Vector(0,0,1) ) + Vector(0,0,16)

	-- Create STICKY WARNING Particle --
	local particleWarningSticky = ParticleManager:CreateParticle(model, PATTACH_CUSTOMORIGIN, nil)
	ParticleManager:SetParticleControl( particleWarningSticky, 0, pos )
	ParticleManager:SetParticleControl( particleWarningSticky, 1, Vector(aoe, 0, 0) )
	ParticleManager:SetParticleControl( particleWarningSticky, 3, color )
	PersistentParticle_Add(particleWarningSticky)

	if duration ~= nil then
		
		local timer = Timers:CreateTimer(0, function()
			--[[
			if not BossCheckInfight() then
				ParticleManager:DestroyParticle(particleWarningSticky, false)
				ParticleManager:ReleaseParticleIndex(particleWarningSticky)
				return
			end
			]]
			return 0.1
		end)
		PersistentTimer_Add(timer)
		
		local timer2 = Timers:CreateTimer(duration, function()
			Timers:RemoveTimer(timer)
			--if BossCheckInfight() then
				ParticleManager:DestroyParticle(particleWarningSticky, false)
				ParticleManager:ReleaseParticleIndex(particleWarningSticky)
				particleWarningSticky = nil
			--end
		end)
		PersistentTimer_Add(timer2)
	else
		return particleWarningSticky
	end
end

function EncounterGroundAOEWarningStickyOnUnit(victim, aoe, duration, color)

	local pos = victim:GetAbsOrigin()

	local model = "particles/warning_aoe_ring_sticky.vpcf"
	if color == nil then
		color = Vector(255,0,0)
	end

	pos = pos * Vector(1,1,0)
	pos = pos + ( GetGroundPosition(pos, victim) * Vector(0,0,1) ) + Vector(0,0,16)

	-- Create STICKY WARNING Particle --
	local particleWarningSticky = ParticleManager:CreateParticle(model, PATTACH_POINT_FOLLOW, victim)
	--ParticleManager:SetParticleControlEnt( particleWarningSticky, 0, victim, PATTACH_POINT_FOLLOW, "attach_hitloc", victim:GetAttachmentOrigin(victim:ScriptLookupAttachment("attach_hitloc")), true)
	ParticleManager:SetParticleControl( particleWarningSticky, 0, victim:GetAbsOrigin()+Vector(0,0,20) )
	ParticleManager:SetParticleControl( particleWarningSticky, 1, Vector(aoe, 0, 0) )
	ParticleManager:SetParticleControl( particleWarningSticky, 3, color )
	PersistentParticle_Add(particleWarningSticky)

	if duration ~= nil then
		
		local timer = Timers:CreateTimer(0, function()
			--[[
			if not BossCheckInfight() then
				ParticleManager:DestroyParticle(particleWarningSticky, false)
				ParticleManager:ReleaseParticleIndex(particleWarningSticky)
				return
			end
			]]
			return 0.1
		end)
		PersistentTimer_Add(timer)
		
		local timer2 = Timers:CreateTimer(duration, function()
			Timers:RemoveTimer(timer)
			--if BossCheckInfight() then
				ParticleManager:DestroyParticle(particleWarningSticky, false)
				ParticleManager:ReleaseParticleIndex(particleWarningSticky)
				particleWarningSticky = nil
			--end
		end)
		PersistentTimer_Add(timer2)
	else
		return particleWarningSticky
	end
end


function EncounterGroundLineWarning(caster, start_radius, end_radius, start_loc, forward_vector, range, duration)

	local warnings_steps = end_radius
	local warnings_count = range / warnings_steps

	local count = 0
	local timer = Timers:CreateTimer(0, function()

		local location = start_loc + ( (forward_vector * warnings_steps) * count )
		location = location * Vector(1,1,0)
		location = location + ( GetGroundPosition(location, caster) * Vector(0,0,1) )
		EncounterGroundAOEWarningSticky( location, start_radius + ( ( (end_radius-start_radius) / warnings_count ) * count ), duration)

		count = count + 1
		if count >= warnings_count then
			return
		else
			return 0.03
		end
	end)
	PersistentTimer_Add(timer)

	local timer2 = Timers:CreateTimer(duration*1.25, function()
		Timers:RemoveTimer(timer)
		timer = nil
	end)
	PersistentTimer_Add(timer2)

end


function EncounterGroundConeWarning(caster, start_radius, end_radius, start_loc, forward_vector, range, duration)

	local warnings_steps = end_radius
	local warnings_count = range / warnings_steps

	local count = 1
	local timer = Timers:CreateTimer(0, function()

		local location = start_loc + ( (forward_vector * warnings_steps) * count )
		location = location * Vector(1,1,0)
		location = location + ( GetGroundPosition(location, caster) * Vector(0,0,1) )
		EncounterGroundAOEWarningSticky( location, start_radius + ( ( (end_radius-start_radius) / warnings_count ) * count ), duration)

		count = count + 1
		if count >= warnings_count then
			return
		else
			return 0.03
		end
	end)
	PersistentTimer_Add(timer)

	local timer2 = Timers:CreateTimer(duration*1.25, function()
		Timers:RemoveTimer(timer)
		timer = nil
	end)
	PersistentTimer_Add(timer2)

end


function EncounterGroundLineParticle(caster, start_radius, end_radius, start_loc, forward_vector, range, duration, particle_path, particle_data)

	local particles = {}

	local warnings_steps = end_radius
	local warnings_count = range / warnings_steps

	local count = 0
	local timer = Timers:CreateTimer(0, function()

		local location = start_loc + ( (forward_vector * warnings_steps) * count )
		location = location * Vector(1,1,0)
		location = location + ( GetGroundPosition(location, caster) * Vector(0,0,1) )

		-- Particle --
		local particle = ParticleManager:CreateParticle(particle_path, PATTACH_CUSTOMORIGIN, nil)
		table.insert(particles, particle)
		PersistentParticle_Add(particle)
		
		for key,value in pairs(particle_data) do
			if value == "LOCATION" then
				ParticleManager:SetParticleControl( particle, tonumber(key), location )
			else
				ParticleManager:SetParticleControl( particle, tonumber(key), value )
			end
		end

		count = count + 1
		if count >= warnings_count then
			return
		else
			return 0.03
		end
	end)
	PersistentTimer_Add(timer)

	if duration == 0 then
		duration = (warnings_count * 0.03) * 1.1
	end

	local timer2 = Timers:CreateTimer(duration, function()

		if particles ~= nil then
			for key,value in pairs(particles) do
				if not value ~= nil then
					ParticleManager:DestroyParticle( value, false )
					ParticleManager:ReleaseParticleIndex( value )
					value = nil
				end
			end
		end

	end)
	PersistentTimer_Add(timer2)

	local timer3 = Timers:CreateTimer(duration*1.25, function()
		Timers:RemoveTimer(timer)
		timer = nil
	end)
	PersistentTimer_Add(timer3)

end

function EncounterGroundConeParticle(caster, start_radius, end_radius, start_loc, forward_vector, range, duration, particle_path, particle_data)

	local particles = {}

	local warnings_steps = end_radius
	local warnings_count = range / warnings_steps

	local count = 1
	local timer = Timers:CreateTimer(0, function()

		local location = start_loc + ( (forward_vector * warnings_steps) * count )
		location = location * Vector(1,1,0)
		location = location + ( GetGroundPosition(location, caster) * Vector(0,0,1) )

		-- Particle --
		local particle = ParticleManager:CreateParticle(particle_path, PATTACH_CUSTOMORIGIN, nil)
		table.insert(particles, particle)
		PersistentParticle_Add(particle)
		
		for key,value in pairs(particle_data) do
			if value == "LOCATION" then
				ParticleManager:SetParticleControl( particle, tonumber(key), location )
			else
				ParticleManager:SetParticleControl( particle, tonumber(key), value )
			end
		end

		count = count + 1
		if count >= warnings_count then
			return
		else
			return 0.03
		end
	end)
	PersistentTimer_Add(timer)

	if duration == 0 then
		duration = (warnings_count * 0.03) * 1.1
	end

	local timer2 = Timers:CreateTimer(duration, function()

		if particles ~= nil then
			for key,value in pairs(particles) do
				if not value ~= nil then
					ParticleManager:DestroyParticle( value, false )
					ParticleManager:ReleaseParticleIndex( value )
					value = nil
				end
			end
		end

	end)
	PersistentTimer_Add(timer2)

	local timer3 = Timers:CreateTimer(duration*1.25, function()
		Timers:RemoveTimer(timer)
		timer = nil
	end)
	PersistentTimer_Add(timer3)

end

function EncounterGroundConeFindUnits(caster, start_radius, end_radius, start_loc, forward_vector, range, team, target_team, target_type, target_flag)

	local all_units = {}

	local warnings_steps = end_radius
	local warnings_count = range / warnings_steps

	for count=1,warnings_count-1 do

		local location = start_loc + ( (forward_vector * warnings_steps) * count )
		location = location * Vector(1,1,0)
		location = location + ( GetGroundPosition(location, caster) * Vector(0,0,1) )

		local units = FindUnitsInRadius(team, location, nil, start_radius + ( ( (end_radius-start_radius) / warnings_count ) * count ), target_team, target_type, target_flag, FIND_ANY_ORDER, false)

		for _,hero in pairs(units) do
			table.insert(all_units, hero);
		end

	end

	local hash = {}
	local result = {}
	for _,v in ipairs(all_units) do
		if (not hash[v]) then
			result[#result+1] = v
			hash[v] = true
		end
	end

	return all_units
end
