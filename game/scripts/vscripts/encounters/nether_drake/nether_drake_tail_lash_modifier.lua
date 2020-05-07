nether_drake_tail_lash_modifier = class({})

function nether_drake_tail_lash_modifier:OnCreated( kv )
	self.AoERadius                    = self:GetAbility():GetSpecialValueFor("AoERadius")
	self.damage                       = self:GetAbility():GetSpecialValueFor("damage")
	self.delay                        = self:GetAbility():GetSpecialValueFor("delay")
	self.stun                         = self:GetAbility():GetSpecialValueFor("stun")
	self.cooldown                     = self:GetAbility():GetCooldown( self:GetAbility():GetLevel() )

	if not IsServer() then return end
	self.triggered = false
	self:StartIntervalThink(0.25)
end

function nether_drake_tail_lash_modifier:OnIntervalThink()
	if not IsServer() then return end

	local caster		= self:GetParent()
	local caster_loc	= caster:GetAbsOrigin()
	local playerID		= caster:GetPlayerOwnerID()
	local player		= PlayerResource:GetPlayer(playerID)
	local team			= caster:GetTeamNumber()

	local AoERadius		= self.AoERadius
	local damage		= self.damage
	local delay			= self.delay
	local stun			= self.stun
	local cooldown		= self.cooldown

	if not self.triggered and caster.twisted_nether ~= true then

		local location = caster_loc - ( caster:GetForwardVector() * ( AoERadius ) )
		location = GetGroundPosition(location, caster)

		-- DOTA_UNIT_TARGET_TEAM_FRIENDLY; DOTA_UNIT_TARGET_TEAM_ENEMY; DOTA_UNIT_TARGET_TEAM_BOTH
		local units	= FindUnitsInRadius(team, location, nil, AoERadius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
		
		if units[1] ~= nil then

			self.triggered = true

			local timer = Timers:CreateTimer(cooldown, function()
				self.triggered = false
			end)
			PersistentTimer_Add(timer)

			EncounterGroundAOEWarningSticky(location, AoERadius, 1)

			local timer = Timers:CreateTimer(delay, function()

				-- Sound --
				StartSoundEventFromPositionReliable("Hero_DragonKnight.DragonTail.Target", location)

				-- Particle --
				local particle = ParticleManager:CreateParticle("particles/econ/items/juggernaut/jugg_arcana/juggernaut_arcana_loadout_debut_dust_hit.vpcf", PATTACH_CUSTOMORIGIN, nil)
				ParticleManager:SetParticleControl( particle, 0, location )
				ParticleManager:SetParticleControl( particle, 1, location )
				ParticleManager:ReleaseParticleIndex( particle )
				particle = nil

				local location = caster_loc - ( caster:GetForwardVector() * ( AoERadius ) )

				-- DOTA_UNIT_TARGET_TEAM_FRIENDLY; DOTA_UNIT_TARGET_TEAM_ENEMY; DOTA_UNIT_TARGET_TEAM_BOTH
				local units	= FindUnitsInRadius(team, location, nil, AoERadius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
				for _,victim in pairs(units) do

					-- Apply Damage --
					EncounterApplyDamage(victim, caster, self:GetAbility(), damage, DAMAGE_TYPE_PHYSICAL, DOTA_DAMAGE_FLAG_NONE)

					-- Knockback --
					local knockback =
						{
							knockback_duration = stun,
							duration = stun,
							knockback_distance = 120,
							knockback_height = 120,
						}
					victim:RemoveModifierByName("modifier_knockback")
					local modifier = victim:AddNewModifier(caster, self, "modifier_knockback", knockback)
					PersistentModifier_Add(modifier)

				end

			end)
			PersistentTimer_Add(timer)

		end

	end

end

function nether_drake_tail_lash_modifier:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_TOOLTIP,
	}

	return funcs
end


function nether_drake_tail_lash_modifier:OnTooltip( params )
	return self.damage
end


function nether_drake_tail_lash_modifier:GetAttributes()
	return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE
end

function nether_drake_tail_lash_modifier:IsHidden()
    return true
end

function nether_drake_tail_lash_modifier:IsPurgable()
	return false
end

function nether_drake_tail_lash_modifier:IsPurgeException()
	return false
end

function nether_drake_tail_lash_modifier:IsStunDebuff()
	return false
end

function nether_drake_tail_lash_modifier:IsDebuff()
	return false
end