%ModifierClass% = class({})

function %ModifierClass%:OnCreated( kv )
	-- ### VALUES START ### --%GetSpecialValueFor%	-- ### VALUES END ### --
	
	if not IsServer() then return end
	Change_PerkEffectivenessStats(self, true)

	self.perkname = data.perkName
	self.perkID = data.perkID

	self:StartIntervalThink(1.00)
end

function %ModifierClass%:OnRemoved()
	if not IsServer() then return end
	Change_PerkEffectivenessStats(self, false)
end

function %ModifierClass%:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
		MODIFIER_PROPERTY_HP_REGEN_AMPLIFY_PERCENTAGE,
		MODIFIER_PROPERTY_MP_REGEN_AMPLIFY_PERCENTAGE,
		MODIFIER_PROPERTY_BASEDAMAGEOUTGOING_PERCENTAGE,
		MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
		MODIFIER_PROPERTY_HEALTH_REGEN_PERCENTAGE,
		MODIFIER_PROPERTY_MANA_REGEN_CONSTANT,
		MODIFIER_PROPERTY_MANA_REGEN_TOTAL_PERCENTAGE,
		MODIFIER_PROPERTY_COOLDOWN_PERCENTAGE_STACKING,
		MODIFIER_PROPERTY_CASTTIME_PERCENTAGE,
	}

	return funcs
end

function %ModifierClass%:OnIntervalThink()
	if not IsServer() then return end

	self:SetStackCount( 10000 * PerkEffectiveness[self:GetParent():GetPlayerOwnerID()][self:GetName()] )
end

function %ModifierClass%:GetModifierPhysicalArmorBonus( params )
	return self.armor * ( self:GetStackCount() / 10000 )
end

function %ModifierClass%:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE + MODIFIER_ATTRIBUTE_MULTIPLE
end

function %ModifierClass%:IsHidden()
    return true
end

function %ModifierClass%:IsPurgable()
	return false
end

function %ModifierClass%:IsPurgeException()
	return false
end

function %ModifierClass%:IsStunDebuff()
	return false
end

function %ModifierClass%:IsDebuff()
	return false
end