greater_double_cast = class({})

function greater_double_cast:OnCreated( data )
	-- ### VALUES START ### --
	self.chance                        = 40
	self.effectiveness_offensive       = 25.0
	self.effectiveness_defensive       = 25.0
	-- ### VALUES END ### --
	
	if not IsServer() then return end
	self.perkname = data.perkName
	self.perkID = data.perkID
	self.level = data.level
	self.perkEffectiveness = data.perkEffectiveness

	Change_PerkEffectivenessStats(self, true)

	local caster = self:GetParent()

	self.triggered = false
	self.pseudochance = 0.0

	self:StartIntervalThink(1.00)
end

function greater_double_cast:OnRemoved()
	if not IsServer() then return end
	Change_PerkEffectivenessStats(self, false)
end

function greater_double_cast:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_ABILITY_FULLY_CAST,
		MODIFIER_PROPERTY_CASTTIME_PERCENTAGE
	}

	return funcs
end

function greater_double_cast:OnIntervalThink()
	if not IsServer() then return end

	self:SetStackCount( 10000 * self.perkEffectiveness )
end

function greater_double_cast:GetModifierPercentageCasttime( params )
	if not IsServer() then return end

	if self.triggered then
		return 10000
	else
		return 0
	end
end

function greater_double_cast:OnAbilityFullyCast( params )
	if not IsServer() then return end
	if params.ability:GetAbilityType() == DOTA_ABILITY_TYPE_ATTRIBUTES then return end
	if params.ability:GetAbilityType() == DOTA_ABILITY_TYPE_HIDDEN then return end
	if params.ability:GetCaster() ~= self:GetParent() then return end
	if params.ability:IsItem() then return end

	if self.triggered then return end

	if self.pseudochance == 0.0 then self.pseudochance = 0.01
	else
		self.pseudochance = (self.pseudochance+2.5) * 1.33
	end

	if not RollPercentage( ( self.chance * ( self:GetStackCount() / 10000 ) ) + self.pseudochance) then return end

	self.triggered = true
	self.pseudochance = 0.0

	local caster = self:GetParent()
	local ability	= params.ability
	local playerID	= caster:GetPlayerOwnerID()

	local previous_cd = ability:GetCooldownTimeRemaining()

	if not caster:IsAlive() then return end

	Timers:CreateTimer(0.03, function()

		if caster:IsChanneling() then

			local loc = caster:GetAbsOrigin()
			local illusion = CreateUnitByName("dummy", loc, true, caster, nil, caster:GetTeamNumber())
			illusion:SetControllableByPlayer(playerID, true)

			illusion:AddNewModifier(caster, ability, "modifier_invulnerable", {})
			illusion:AddNewModifier(caster, ability, "modifier_attack_immune", {})
			illusion:AddNewModifier(caster, ability, "modifier_unselectable", {})
			illusion:AddNewModifier(caster, ability, "modifier_phased", {})

			local abilityLevel = ability:GetLevel()
			local abilityName = ability:GetAbilityName()
			illusion:AddAbility( abilityName )
			local illusionAbility = illusion:FindAbilityByName(abilityName)
			illusionAbility:SetLevel(abilityLevel)

			Timers:CreateTimer(0.1, function()

				--No Target
				if ability:GetCursorTarget() == nil and ability:GetCursorTarget() == nil then
					illusion:CastAbilityNoTarget(illusionAbility, playerID)
				end

				--Point
				if ability:GetCursorPosition() ~= nil and ability:GetCursorTarget() == nil then

					if ability:GetCursorPosition() == Vector(0,0,0) then
						illusion:CastAbilityOnPosition(caster:GetCursorPosition(), illusionAbility, playerID)
					else
						illusion:CastAbilityOnPosition(ability:GetCursorPosition(), illusionAbility, playerID)
					end
				end

				--Target
				if ability:GetCursorTarget() ~= nil then
					illusion:CastAbilityOnTarget(ability:GetCursorTarget(), illusionAbility, playerID)
				end
			end)

			Timers:CreateTimer(ability:GetChannelTime()*1.5, function()
				UTIL_Remove(illusion)
			end)

		else

			ability:EndCooldown()

			local diff = caster:GetMaxMana() - caster:GetMana() 
			if diff < ability:GetManaCost(ability:GetLevel()) then

				--No Target
				if ability:GetCursorTarget() == nil and ability:GetCursorPosition() == Vector(0,0,0) and caster:GetCursorPosition() == Vector(0,0,0) then
					caster:CastAbilityNoTarget(ability, playerID)

				--Point
				elseif ability:GetCursorPosition() ~= nil and ability:GetCursorTarget() == nil then

					if ability:GetCursorPosition() == Vector(0,0,0) then
						caster:CastAbilityOnPosition(caster:GetCursorPosition(), ability, playerID)
					else
						caster:CastAbilityOnPosition(ability:GetCursorPosition(), ability, playerID)
					end

				--Target
				elseif ability:GetCursorTarget() ~= nil then
					caster:CastAbilityOnTarget(ability:GetCursorTarget(), ability, playerID)
				end

				ability:RefundManaCost()
			else
				ability:RefundManaCost()

				--No Target
				if ability:GetCursorTarget() == nil and ability:GetCursorPosition() == Vector(0,0,0) and caster:GetCursorPosition() == Vector(0,0,0) then
					caster:CastAbilityNoTarget(ability, playerID)

				--Point
				elseif ability:GetCursorPosition() ~= nil and ability:GetCursorTarget() == nil then

					if ability:GetCursorPosition() == Vector(0,0,0) then
						caster:CastAbilityOnPosition(caster:GetCursorPosition(), ability, playerID)
					else
						caster:CastAbilityOnPosition(ability:GetCursorPosition(), ability, playerID)
					end

				--Target
				elseif ability:GetCursorTarget() ~= nil then
					caster:CastAbilityOnTarget(ability:GetCursorTarget(), ability, playerID)
				end

			end

		end

		Timers:CreateTimer(ability:GetCastPoint()*1.25, function()
			ability:EndCooldown()
			ability:StartCooldown(previous_cd)
			self.triggered = false
		end)

	end)

end

function greater_double_cast:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE + MODIFIER_ATTRIBUTE_MULTIPLE
end

function greater_double_cast:IsHidden()
    return true
end

function greater_double_cast:IsPurgable()
	return false
end

function greater_double_cast:IsPurgeException()
	return false
end

function greater_double_cast:IsStunDebuff()
	return false
end

function greater_double_cast:IsDebuff()
	return false
end



























































































































































































































































































































