lesser_interval_attack_speed = class({})

function lesser_interval_attack_speed:OnCreated( data )
	-- ### VALUES START ### --
	self.interval                      = 20
	self.attack_speed                  = 60
	self.duration                      = 6
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

function lesser_interval_attack_speed:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_TOOLTIP
	}

	return funcs
end

function lesser_interval_attack_speed:OnIntervalThink()
	if not IsServer() then return end

	if self:GetStackCount() == 0 and self.active_time > 0 then 
		self.active_time = self.active_time - 1

		PerkAppearance_Active(self:GetParent():GetPlayerOwnerID(), self.perkname, self.perkID, "#daff47", self.active_time)

		if self.active_time == 0 then
			self:SetStackCount(self.interval)
		end
	else
		self:DecrementStackCount()
		self.active_time = self.duration

		PerkAppearance_Inactive(self:GetParent():GetPlayerOwnerID(), self.perkname, self.perkID, self:GetStackCount())
	end
end

function lesser_interval_attack_speed:GetModifierAttackSpeedBonus_Constant()
	if self:GetStackCount() == 0 then
		return self.attack_speed
	else
		return 0
	end
end

function lesser_interval_attack_speed:OnTooltip()
	return self.duration
end

function lesser_interval_attack_speed:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE + MODIFIER_ATTRIBUTE_MULTIPLE
end

function lesser_interval_attack_speed:IsHidden()
    return true
end

function lesser_interval_attack_speed:IsPurgable()
	return false
end

function lesser_interval_attack_speed:IsPurgeException()
	return false
end

function lesser_interval_attack_speed:IsStunDebuff()
	return false
end

function lesser_interval_attack_speed:IsDebuff()
	return false
end

function lesser_interval_attack_speed:GetTexture()
	return "lesser_interval_attack_speed"
end



































































































































































































































