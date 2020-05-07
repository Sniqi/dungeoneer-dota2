greater_interval_health_regen_mana_regen = class({})

function greater_interval_health_regen_mana_regen:OnCreated( data )
	-- ### VALUES START ### --
	self.interval                      = 12
	self.health_regen                  = 12
	self.mana_regen                    = 20
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

function greater_interval_health_regen_mana_regen:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_HEALTH_REGEN_PERCENTAGE,
		MODIFIER_PROPERTY_MANA_REGEN_TOTAL_PERCENTAGE,
		MODIFIER_PROPERTY_TOOLTIP
	}

	return funcs
end

function greater_interval_health_regen_mana_regen:OnIntervalThink()
	if not IsServer() then return end

	if self:GetStackCount() == 0 and self.active_time > 0 then 
		self.active_time = self.active_time - 1

		PerkAppearance_Active(self:GetParent():GetPlayerOwnerID(), self.perkname, self.perkID, "#5ee001", self.active_time)

		if self.active_time == 0 then
			self:SetStackCount(self.interval)
		end
	else
		self:DecrementStackCount()
		self.active_time = self.duration

		PerkAppearance_Inactive(self:GetParent():GetPlayerOwnerID(), self.perkname, self.perkID, self:GetStackCount())
	end
end

function greater_interval_health_regen_mana_regen:GetModifierHealthRegenPercentage()
	if self:GetStackCount() == 0 then
		return self.health_regen
	else
		return 0
	end
end

function greater_interval_health_regen_mana_regen:GetModifierTotalPercentageManaRegen()
	if self:GetStackCount() == 0 then
		return self.mana_regen
	else
		return 0
	end
end

function greater_interval_health_regen_mana_regen:OnTooltip()
	return self.duration
end

function greater_interval_health_regen_mana_regen:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE + MODIFIER_ATTRIBUTE_MULTIPLE
end

function greater_interval_health_regen_mana_regen:IsHidden()
    return true
end

function greater_interval_health_regen_mana_regen:IsPurgable()
	return false
end

function greater_interval_health_regen_mana_regen:IsPurgeException()
	return false
end

function greater_interval_health_regen_mana_regen:IsStunDebuff()
	return false
end

function greater_interval_health_regen_mana_regen:IsDebuff()
	return false
end

function greater_interval_health_regen_mana_regen:GetTexture()
	return "greater_interval_health_regen_mana_regen"
end



































































































































































































































