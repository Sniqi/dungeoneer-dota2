lesser_regeneration_stream = class({})

function lesser_regeneration_stream:OnCreated( data )
	-- ### VALUES START ### --
	self.interval                      = 3
	self.cooldown_reduction            = 15
	self.health_regen_amp              = 16
	self.mana_regen_amp                = 32
	self.effectiveness_offensive       = 25.0
	self.effectiveness_defensive       = 25.0
	-- ### VALUES END ### --
	
	if not IsServer() then return end
	self.perkname = data.perkName
	self.perkID = data.perkID
	self.level = data.level
	self.perkEffectiveness = data.perkEffectiveness

	Change_PerkEffectivenessStats(self, true)

	self.stacks = self.interval

	self:StartIntervalThink(0.1)
end

function lesser_regeneration_stream:OnRemoved()
	if not IsServer() then return end
	Change_PerkEffectivenessStats(self, false)
end

function lesser_regeneration_stream:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_HP_REGEN_AMPLIFY_PERCENTAGE,
		MODIFIER_PROPERTY_MP_REGEN_AMPLIFY_PERCENTAGE
	}

	return funcs
end

function lesser_regeneration_stream:OnIntervalThink()
	if not IsServer() then return end

	self:SetStackCount( 10000 * self.perkEffectiveness )

	if self.stacks <= 0 then

		local caster = self:GetParent()

		local abilities = {}

		for i=0,9 do
			local ability = caster:GetAbilityByIndex(i)

			if ability ~= nil then
				if ability:GetCooldownTimeRemaining() > 1 then
					table.insert(abilities, ability)
				end
			end
		end

		if abilities ~= nil then
			if table.getn(abilities) > 0 then
				self.stacks = self.interval / ( self:GetStackCount() / 10000 )

				local rng = RandomInt(1, table.getn(abilities))
				local ability = abilities[rng]

				local ability_cd = ability:GetCooldownTimeRemaining()

				local cd_reduction = self.cooldown_reduction * ( self:GetStackCount() / 10000 )
				cd_reduction = ( ( 100 - self.cooldown_reduction ) / 100 )

				local ability_cd_new = ability_cd * cd_reduction

				ability:EndCooldown()
				ability:StartCooldown(ability_cd_new)
			end
		end

		PerkAppearance_Active(self:GetParent():GetPlayerOwnerID(), self.perkname, self.perkID, "#226ac1", "!")

	else
		self.stacks = self.stacks - 0.1

		PerkAppearance_Inactive(self:GetParent():GetPlayerOwnerID(), self.perkname, self.perkID, math.floor(self.stacks) )
	end
end

function lesser_regeneration_stream:GetModifierHPRegenAmplify_Percentage( params )
	return self.health_regen_amp * ( self:GetStackCount() / 10000 )
end

function lesser_regeneration_stream:GetModifierMPRegenAmplify_Percentage( params )
	return self.mana_regen_amp * ( self:GetStackCount() / 10000 )
end

function lesser_regeneration_stream:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE + MODIFIER_ATTRIBUTE_MULTIPLE
end

function lesser_regeneration_stream:IsHidden()
    return true
end

function lesser_regeneration_stream:IsPurgable()
	return false
end

function lesser_regeneration_stream:IsPurgeException()
	return false
end

function lesser_regeneration_stream:IsStunDebuff()
	return false
end

function lesser_regeneration_stream:IsDebuff()
	return false
end






















