lesser_interval_cooldown_random_spell = class({})

function lesser_interval_cooldown_random_spell:OnCreated( data )
	-- ### VALUES START ### --
	self.interval                      = 1
	self.cooldown_reduction            = 25
	-- ### VALUES END ### --
	
	if not IsServer() then return end
	self.perkname = data.perkName
	self.perkID = data.perkID
	self.level = data.level
	self.perkEffectiveness = data.perkEffectiveness

	self:StartIntervalThink(1.0)
	self:SetStackCount(self.interval)
end

function lesser_interval_cooldown_random_spell:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_TOOLTIP
	}

	return funcs
end

function lesser_interval_cooldown_random_spell:OnIntervalThink()
	if not IsServer() then return end

	if self:GetStackCount() == 0 then

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
				self:SetStackCount(self.interval)

				local rng = RandomInt(1, table.getn(abilities))
				local ability = abilities[rng]

				local ability_cd = ability:GetCooldownTimeRemaining()
				local ability_cd_new = ability_cd * ( ( 100 - self.cooldown_reduction ) / 100 )
				ability:EndCooldown()
				ability:StartCooldown(ability_cd_new)
			end
		end

		PerkAppearance_Active(self:GetParent():GetPlayerOwnerID(), self.perkname, self.perkID, "#226ac1", "!")

	else
		self:DecrementStackCount()

		PerkAppearance_Inactive(self:GetParent():GetPlayerOwnerID(), self.perkname, self.perkID, self:GetStackCount())
	end
end

function lesser_interval_cooldown_random_spell:OnTooltip()
	return self.cooldown_reduction
end

function lesser_interval_cooldown_random_spell:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE + MODIFIER_ATTRIBUTE_MULTIPLE
end

function lesser_interval_cooldown_random_spell:IsHidden()
    --return true
end

function lesser_interval_cooldown_random_spell:IsPurgable()
	return false
end

function lesser_interval_cooldown_random_spell:IsPurgeException()
	return false
end

function lesser_interval_cooldown_random_spell:IsStunDebuff()
	return false
end

function lesser_interval_cooldown_random_spell:IsDebuff()
	return false
end

function lesser_interval_cooldown_random_spell:GetTexture()
	return "lesser_interval_cooldown_random_spell"
end























































































































































































































































































