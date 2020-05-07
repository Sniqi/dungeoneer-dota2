wind_harpy_tornado_checker_modifier = class({})

function wind_harpy_tornado_checker_modifier:OnCreated( kv )
	if not IsServer() then return end
	self.activations = 0
	self:StartIntervalThink(0.25)
end

function wind_harpy_tornado_checker_modifier:OnIntervalThink()
	if not IsServer() then return end

	local caster = self:GetParent()
	local health_pct = caster:GetHealthPercent()

	if health_pct <= 90 and self.activations == 0 then
		self.activations = self.activations + 1
		wind_harpy_tornado_checker_modifier:SpawnTornado(self)
	end

	if health_pct <= 75 and self.activations == 1 then
		self.activations = self.activations + 1
		wind_harpy_tornado_checker_modifier:SpawnTornado(self)
	end

	if health_pct <= 60 and self.activations == 2 then
		self.activations = self.activations + 1
		wind_harpy_tornado_checker_modifier:SpawnTornado(self)
	end

	if health_pct <= 45 and self.activations == 3 then
		self.activations = self.activations + 1
		wind_harpy_tornado_checker_modifier:SpawnTornado(self)
	end

	if health_pct <= 30 and self.activations == 4 then
		self.activations = self.activations + 1
		wind_harpy_tornado_checker_modifier:SpawnTornado(self)
	end
end

function wind_harpy_tornado_checker_modifier:SpawnTornado(self)
	local caster = self:GetParent()
	local caster_loc = caster:GetAbsOrigin()

	local point = nil
	if RollPercentage(50) then
		point = caster_loc + RandomVector(300)
	else
		point = caster_loc - RandomVector(300)
	end

	-- Sound and Animation --
	local sound = {"naga_siren_naga_deny_10", "naga_siren_naga_deny_11",
					"naga_siren_naga_deny_12", "naga_siren_naga_deny_13"}
	EmitAnnouncerSound( sound[RandomInt(1, #sound)] )
	caster:StartGestureWithPlaybackRate(ACT_DOTA_CAST_ABILITY_1, 1.0)

	if caster.tornado == nil then caster.tornado = {} end

	caster.tornado[self.activations] = CreateUnitByName("dummy", point, true, nil, nil, DOTA_TEAM_BADGUYS)
	local unit = caster.tornado[self.activations]
	PersistentUnit_Add(unit)
	unit:AddNewModifier(caster, self:GetAbility(), "wind_harpy_tornado_damage_modifier", {})
	unit:AddNewModifier(unit, nil, "modifier_dummy", {})
	unit:AddNewModifier(unit, nil, "modifier_phased", {})
end

function wind_harpy_tornado_checker_modifier:OnDestroy()
	if not IsServer() then return end
	local caster = self:GetParent()

	if caster == nil then return end
	if caster:IsNull() then return end

	if tornado ~= nil then
		for i=1,3 do
			local unit = caster.tornado[i]

			if unit ~= nil then
				if not unit:IsNull() then
					unit:RemoveSelf()
				end
			end
		end
	end
end

function wind_harpy_tornado_checker_modifier:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_TOOLTIP,
	}

	return funcs
end


function wind_harpy_tornado_checker_modifier:OnTooltip( params )
	return self.damage
end

function wind_harpy_tornado_checker_modifier:GetAttributes()
	return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE
end

function wind_harpy_tornado_checker_modifier:IsHidden()
    return true
end

function wind_harpy_tornado_checker_modifier:IsPurgable()
	return false
end

function wind_harpy_tornado_checker_modifier:IsPurgeException()
	return false
end

function wind_harpy_tornado_checker_modifier:IsStunDebuff()
	return false
end

function wind_harpy_tornado_checker_modifier:IsDebuff()
	return false
end