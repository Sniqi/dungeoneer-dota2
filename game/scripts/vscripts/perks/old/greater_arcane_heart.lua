greater_arcane_heart = class({})

function greater_arcane_heart:OnCreated( data )
	-- ### VALUES START ### --
	self.health                        = 50
	self.mana                          = 1500
	self.health_regen                  = 1.5
	self.mana_regen                    = 1
	self.effectiveness_offensive       = 30.0
	self.effectiveness_defensive       = 20.0
	-- ### VALUES END ### --
	
	if not IsServer() then return end
	self.perkname = data.perkName
	self.perkID = data.perkID
	self.level = data.level
	self.perkEffectiveness = data.perkEffectiveness

	Change_PerkEffectivenessStats(self, true)

	self:StartIntervalThink(1.00)
end

function greater_arcane_heart:OnRemoved()
	if not IsServer() then return end
	Change_PerkEffectivenessStats(self, false)
end

function greater_arcane_heart:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_EXTRA_HEALTH_PERCENTAGE,
		MODIFIER_PROPERTY_MANA_BONUS,
		MODIFIER_PROPERTY_HEALTH_REGEN_PERCENTAGE,
		MODIFIER_PROPERTY_MANA_REGEN_TOTAL_PERCENTAGE
	}

	return funcs
end

function greater_arcane_heart:OnIntervalThink()
	if not IsServer() then return end

	self:SetStackCount( 10000 * PerkEffectiveness[ self:GetParent():GetPlayerOwnerID()][self:GetName()] )
end

function greater_arcane_heart:GetModifierExtraHealthPercentage( params )
	return ( self.health / 100 )
end

function greater_arcane_heart:GetModifierManaBonus( params )
	return self.mana
end

function greater_arcane_heart:GetModifierHealthRegenPercentage( params )
	return self.health_regen * ( self:GetStackCount() / 10000 )
end

function greater_arcane_heart:GetModifierTotalPercentageManaRegen( params )
	return self.mana_regen * ( self:GetStackCount() / 10000 )
end

function greater_arcane_heart:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE + MODIFIER_ATTRIBUTE_MULTIPLE
end

function greater_arcane_heart:IsHidden()
    return true
end

function greater_arcane_heart:IsPurgable()
	return false
end

function greater_arcane_heart:IsPurgeException()
	return false
end

function greater_arcane_heart:IsStunDebuff()
	return false
end

function greater_arcane_heart:IsDebuff()
	return false
end





















