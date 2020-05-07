greater_interval_attack_speed_attack_damage = class({})

function greater_interval_attack_speed_attack_damage:OnCreated( data )
	-- ### VALUES START ### --
	self.interval                      = 12
	self.attack_speed                  = 100
	self.attack_damage                 = 50
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

function greater_interval_attack_speed_attack_damage:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_BASEDAMAGEOUTGOING_PERCENTAGE,
		MODIFIER_PROPERTY_TOOLTIP
	}

	return funcs
end

function greater_interval_attack_speed_attack_damage:OnIntervalThink()
	if not IsServer() then return end

	if self:GetStackCount() == 0 and self.active_time > 0 then 
		self.active_time = self.active_time - 1

		PerkAppearance_Active(self:GetParent():GetPlayerOwnerID(), self.perkname, self.perkID, "#d14500", self.active_time)

		if self.active_time == 0 then
			self:SetStackCount(self.interval)
		end
	else
		self:DecrementStackCount()
		self.active_time = self.duration

		PerkAppearance_Inactive(self:GetParent():GetPlayerOwnerID(), self.perkname, self.perkID, self:GetStackCount())
	end
end

function greater_interval_attack_speed_attack_damage:GetModifierAttackSpeedBonus_Constant()
	if self:GetStackCount() == 0 then
		return self.attack_speed
	else
		return 0
	end
end

function greater_interval_attack_speed_attack_damage:GetModifierBaseDamageOutgoing_Percentage()
	if self:GetStackCount() == 0 then
		return self.attack_damage
	else
		return 0
	end
end

function greater_interval_attack_speed_attack_damage:OnTooltip()
	return self.duration
end

function greater_interval_attack_speed_attack_damage:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE + MODIFIER_ATTRIBUTE_MULTIPLE
end

function greater_interval_attack_speed_attack_damage:IsHidden()
    return true
end

function greater_interval_attack_speed_attack_damage:IsPurgable()
	return false
end

function greater_interval_attack_speed_attack_damage:IsPurgeException()
	return false
end

function greater_interval_attack_speed_attack_damage:IsStunDebuff()
	return false
end

function greater_interval_attack_speed_attack_damage:IsDebuff()
	return false
end

function greater_interval_attack_speed_attack_damage:GetTexture()
	return "greater_interval_attack_speed_attack_damage"
end



































































































































































































































