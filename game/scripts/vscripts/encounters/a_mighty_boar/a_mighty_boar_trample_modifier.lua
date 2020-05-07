a_mighty_boar_trample_modifier = class({})

function a_mighty_boar_trample_modifier:OnCreated( kv )
	self.AoERadius		= self:GetAbility():GetSpecialValueFor("AoERadius")
	self.damage			= self:GetAbility():GetSpecialValueFor("damage")
	self.push_force		= self:GetAbility():GetSpecialValueFor("push_force")

	if not IsServer() then return end

	self.units_hit = {}

	self:StartIntervalThink(0.06)
end

function a_mighty_boar_trample_modifier:OnIntervalThink()
	if not IsServer() then return end

	--- Get Caster, Victim, Player, Point ---
	local caster		= self:GetParent()
	local caster_loc	= caster:GetAbsOrigin()
	local playerID		= caster:GetPlayerOwnerID()
	local player		= PlayerResource:GetPlayer(playerID)
	local team			= caster:GetTeamNumber()

	local hit = false

	-- DOTA_UNIT_TARGET_TEAM_FRIENDLY; DOTA_UNIT_TARGET_TEAM_ENEMY; DOTA_UNIT_TARGET_TEAM_BOTH
	local units	= FindUnitsInRadius(team, caster_loc, nil, self.AoERadius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
	local particle = {}
	for _,victim in pairs(units) do

		for _,unit in pairs(self.units_hit) do
			if unit == victim then hit = true end
		end

		if not hit then
			table.insert(self.units_hit, victim)

			-- Particle --
			particle[_] = ParticleManager:CreateParticle("particles/econ/items/earthshaker/egteam_set/hero_earthshaker_egset/earthshaker_fissure_dust_egset.vpcf", PATTACH_ABSORIGIN, victim)
			ParticleManager:SetParticleControl( particle[_], 0, victim:GetAbsOrigin() )
			ParticleManager:SetParticleControl( particle[_], 1, victim:GetAbsOrigin() )
			ParticleManager:ReleaseParticleIndex( particle[_] )
			particle[_] = nil

			-- Apply Damage --
			EncounterApplyDamage(victim, caster, self, self.damage, DAMAGE_TYPE_PHYSICAL, DOTA_DAMAGE_FLAG_NONE)

			if IsPhysicsUnit(victim) then
				victim:SetRebounceFrames(12)
				victim:AddPhysicsVelocity(caster:GetForwardVector() * self.push_force)
				victim:OnBounce(nil)
			end
		end
	end

end

function a_mighty_boar_trample_modifier:DeclareFunctions()
	local funcs = {
	}

	return funcs
end


function a_mighty_boar_trample_modifier:GetAttributes()
	return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE
end

function a_mighty_boar_trample_modifier:IsHidden()
    return false
end

function a_mighty_boar_trample_modifier:IsPurgable()
	return false
end

function a_mighty_boar_trample_modifier:IsPurgeException()
	return false
end

function a_mighty_boar_trample_modifier:IsStunDebuff()
	return false
end

function a_mighty_boar_trample_modifier:IsDebuff()
	return false
end