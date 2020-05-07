lesser_quick_steps = class({})

function lesser_quick_steps:OnCreated( data )
	-- ### VALUES START ### --
	self.move_speed                    = 6
	self.resilience                    = 20
	self.effectiveness_offensive       = 10.0
	self.effectiveness_supportive      = 40.0
	-- ### VALUES END ### --
	
	if not IsServer() then return end
	self.perkname = data.perkName
	self.perkID = data.perkID
	self.level = data.level
	self.perkEffectiveness = data.perkEffectiveness

	Change_PerkEffectivenessStats(self, true)

	self.resilience_orig = self.resilience

	self:StartIntervalThink(1.00)
end

function lesser_quick_steps:OnRemoved()
	if not IsServer() then return end
	Change_PerkEffectivenessStats(self, false)
end

function lesser_quick_steps:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
	}

	return funcs
end

function lesser_quick_steps:OnIntervalThink()
	if not IsServer() then return end

	self:SetStackCount( 10000 * self.perkEffectiveness )

	self.resilience = self.resilience_orig * ( self:GetStackCount() / 10000 )
end

function lesser_quick_steps:GetModifierMoveSpeedBonus_Percentage( params )
	return self.move_speed * ( self:GetStackCount() / 10000 )
end

function lesser_quick_steps:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE + MODIFIER_ATTRIBUTE_MULTIPLE
end

function lesser_quick_steps:IsHidden()
    return true
end

function lesser_quick_steps:IsPurgable()
	return false
end

function lesser_quick_steps:IsPurgeException()
	return false
end

function lesser_quick_steps:IsStunDebuff()
	return false
end

function lesser_quick_steps:IsDebuff()
	return false
end






















