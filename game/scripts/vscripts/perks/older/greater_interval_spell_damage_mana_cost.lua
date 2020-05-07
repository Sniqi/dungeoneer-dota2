greater_interval_spell_damage_mana_cost = class({})

function greater_interval_spell_damage_mana_cost:OnCreated( data )
	-- ### VALUES START ### --
	self.interval                      = 12
	self.spell_damage                  = 160
	self.mana_cost                     = 100
	self.duration                      = 4
	-- ### VALUES END ### --
	
	if not IsServer() then return end
	self.perkname = data.perkName
	self.perkID = data.perkID
	self.level = data.level
	self.perkEffectiveness = data.perkEffectiveness

	self:StartIntervalThink(1.0)
	self:SetStackCount(self.interval)
	self.active_time = self.duration
end

function greater_interval_spell_damage_mana_cost:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,
		MODIFIER_PROPERTY_MANACOST_PERCENTAGE_STACKING,
		MODIFIER_PROPERTY_TOOLTIP
	}

	return funcs
end

function greater_interval_spell_damage_mana_cost:OnIntervalThink()
	if not IsServer() then return end

	if self:GetStackCount() == 0 and self.active_time > 0 then 
		self.active_time = self.active_time - 1

		PerkAppearance_Active(self:GetParent():GetPlayerOwnerID(), self.perkname, self.perkID, "#af47ff", self.active_time)

		if self.active_time == 0 then
			self:SetStackCount(self.interval)
		end
	else
		self:DecrementStackCount()
		self.active_time = self.duration

		PerkAppearance_Inactive(self:GetParent():GetPlayerOwnerID(), self.perkname, self.perkID, self:GetStackCount())
	end
end

function greater_interval_spell_damage_mana_cost:GetModifierSpellAmplify_Percentage()
	if self:GetStackCount() == 0 then
		return self.spell_damage
	else
		return 0
	end
end

function greater_interval_spell_damage_mana_cost:GetModifierPercentageManacostStacking()
	if self:GetStackCount() == 0 then
		return self.mana_cost
	else
		return 0
	end
end

function greater_interval_spell_damage_mana_cost:OnTooltip()
	return self.duration
end

function greater_interval_spell_damage_mana_cost:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE + MODIFIER_ATTRIBUTE_MULTIPLE
end

function greater_interval_spell_damage_mana_cost:IsHidden()
    return true
end

function greater_interval_spell_damage_mana_cost:IsPurgable()
	return false
end

function greater_interval_spell_damage_mana_cost:IsPurgeException()
	return false
end

function greater_interval_spell_damage_mana_cost:IsStunDebuff()
	return false
end

function greater_interval_spell_damage_mana_cost:IsDebuff()
	return false
end

function greater_interval_spell_damage_mana_cost:GetTexture()
	return "greater_interval_spell_damage_mana_cost"
end



































































































































































































































