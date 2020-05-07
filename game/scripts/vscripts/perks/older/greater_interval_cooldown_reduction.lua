greater_interval_cooldown_reduction = class({})

function greater_interval_cooldown_reduction:OnCreated( data )
	-- ### VALUES START ### --
	self.interval                      = 20
	self.cooldown_reduction            = 96
	self.mana_cost                     = 100
	self.duration                      = 8
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

function greater_interval_cooldown_reduction:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_COOLDOWN_PERCENTAGE,
		MODIFIER_PROPERTY_MANACOST_PERCENTAGE_STACKING,
		MODIFIER_PROPERTY_TOOLTIP
	}

	return funcs
end

function greater_interval_cooldown_reduction:OnIntervalThink()
	if not IsServer() then return end

	if self:GetStackCount() == 0 and self.active_time > 0 then 
		self.active_time = self.active_time - 1

		PerkAppearance_Active(self:GetParent():GetPlayerOwnerID(), self.perkname, self.perkID, "#02d5e0", self.active_time)

		if self.active_time == 0 then
			self:SetStackCount(self.interval)
		end
	else
		self:DecrementStackCount()
		self.active_time = self.duration

		PerkAppearance_Inactive(self:GetParent():GetPlayerOwnerID(), self.perkname, self.perkID, self:GetStackCount())
	end
end

function greater_interval_cooldown_reduction:GetModifierPercentageCooldown()
	if self:GetStackCount() == 0 then
		return self.cooldown_reduction
	else
		return 0
	end
end

function greater_interval_cooldown_reduction:GetModifierPercentageManacostStacking()
	if self:GetStackCount() == 0 then
		return self.mana_cost
	else
		return 0
	end
end

function greater_interval_cooldown_reduction:OnTooltip()
	return self.duration
end

function greater_interval_cooldown_reduction:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE + MODIFIER_ATTRIBUTE_MULTIPLE
end

function greater_interval_cooldown_reduction:IsHidden()
    return true
end

function greater_interval_cooldown_reduction:IsPurgable()
	return false
end

function greater_interval_cooldown_reduction:IsPurgeException()
	return false
end

function greater_interval_cooldown_reduction:IsStunDebuff()
	return false
end

function greater_interval_cooldown_reduction:IsDebuff()
	return false
end

function greater_interval_cooldown_reduction:GetTexture()
	return "greater_interval_cooldown_reduction"
end







































































































