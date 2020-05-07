lesser_resilience = class({})

function lesser_resilience:OnCreated( data )
	-- ### VALUES START ### --
	self.resilience                    = 20
	-- ### VALUES END ### --
	
	if not IsServer() then return end
	self:SetStackCount(self.resilience)
end

function lesser_resilience:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE + MODIFIER_ATTRIBUTE_MULTIPLE
end

function lesser_resilience:IsHidden()
    return true
end

function lesser_resilience:IsPurgable()
	return false
end

function lesser_resilience:IsPurgeException()
	return false
end

function lesser_resilience:IsStunDebuff()
	return false
end

function lesser_resilience:IsDebuff()
	return false
end

























































































































































































































