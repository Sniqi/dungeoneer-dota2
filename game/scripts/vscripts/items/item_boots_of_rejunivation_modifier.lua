item_boots_of_rejunivation_modifier = class({})

function item_boots_of_rejunivation_modifier:OnCreated( kv )
	self.bonus_movement 			= self:GetAbility():GetSpecialValueFor("bonus_movement")
	self.hp_replenish_percentage 	= self:GetAbility():GetSpecialValueFor("hp_replenish_percentage")
	self.mana_replenish_percentage 	= self:GetAbility():GetSpecialValueFor("mana_replenish_percentage")
	self.replenish_duration 		= self:GetAbility():GetSpecialValueFor("replenish_duration")
	self.main_attribute 			= self:GetAbility():GetSpecialValueFor("main_attribute")
	self.secondary_attributes 		= self:GetAbility():GetSpecialValueFor("secondary_attributes")
	self.attributes_max 			= self:GetAbility():GetSpecialValueFor("attributes_max")

	if not IsServer() then return end
	local caster = self:GetParent()

	self.str = 0
	self.agi = 0
	self.int = 0

	local ratio = self.secondary_attributes / self.main_attribute

	if caster:GetPrimaryAttribute() == 0 then
		self.str = 1
		self.agi = ratio
		self.int = ratio
	elseif caster:GetPrimaryAttribute() == 1 then
		self.str = ratio
		self.agi = 1
		self.int = ratio
	elseif caster:GetPrimaryAttribute() == 2 then
		self.str = ratio
		self.agi = ratio
		self.int = 1
	end

	self.diff = 0

	self:StartIntervalThink(0.25)
end

function item_boots_of_rejunivation_modifier:OnIntervalThink()
	if not IsServer() then return end
	local caster = self:GetParent()

	local attr = 0

	if caster:GetPrimaryAttribute() == 0 then
		attr = ( caster:GetStrength() - self.diff ) * ( self.main_attribute / 100 )

		local attr_max = ( caster:GetBaseStrength() * (self.attributes_max/100) )

		if attr > attr_max then
			if caster:GetBaseStrength() > attr_max then
				attr = attr_max
			else
				attr = caster:GetBaseStrength()
			end
		end

	elseif caster:GetPrimaryAttribute() == 1 then
		attr = ( caster:GetAgility() - self.diff ) * ( self.main_attribute / 100 )

		local attr_max = ( caster:GetBaseAgility() * (self.attributes_max/100) )

		if attr > attr_max then
			if caster:GetBaseAgility() > attr_max then
				attr = attr_max
			else
				attr = caster:GetBaseAgility()
			end
		end

	elseif caster:GetPrimaryAttribute() == 2 then
		attr = ( caster:GetIntellect() - self.diff ) * ( self.main_attribute / 100 )

		local attr_max = ( caster:GetBaseIntellect() * (self.attributes_max/100) )

		if attr > attr_max then
			if caster:GetBaseIntellect() > attr_max then
				attr = attr_max
			else
				attr = caster:GetBaseIntellect()
			end
		end

	end

	attr = attr + 0.5 --round

	self.diff = math.floor(attr)

	self:SetStackCount(attr)

	caster:CalculateStatBonus(false)

end

function item_boots_of_rejunivation_modifier:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS
	}

	return funcs
end

function item_boots_of_rejunivation_modifier:GetModifierMoveSpeedBonus_Percentage( params )
	return self.bonus_movement
end

function item_boots_of_rejunivation_modifier:GetModifierBonusStats_Strength( params )
	return self:GetStackCount() * self.str
end

function item_boots_of_rejunivation_modifier:GetModifierBonusStats_Agility( params )
	return self:GetStackCount() * self.agi
end

function item_boots_of_rejunivation_modifier:GetModifierBonusStats_Intellect( params )
	return self:GetStackCount() * self.int
end

function item_boots_of_rejunivation_modifier:RemoveOnDeath()
	return false
end

function item_boots_of_rejunivation_modifier:IsHidden()
	return true
end

function item_boots_of_rejunivation_modifier:GetAttributes()
	return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE
end

function item_boots_of_rejunivation_modifier:IsPurgable()
	return false
end

function item_boots_of_rejunivation_modifier:IsPurgeException()
	return false
end

function item_boots_of_rejunivation_modifier:IsStunDebuff()
	return false
end

function item_boots_of_rejunivation_modifier:IsDebuff()
	return false
end