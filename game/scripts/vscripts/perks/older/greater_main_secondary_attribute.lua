greater_main_secondary_attribute = class({})

function greater_main_secondary_attribute:OnCreated( data )
	-- ### VALUES START ### --
	self.main_attribute                = 20
	self.secondary_attributes          = 15
	self.attributes_max                = 60
	-- ### VALUES END ### --
	
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

function greater_main_secondary_attribute:OnIntervalThink()
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

	caster:CalculateStatBonus()

end

function greater_main_secondary_attribute:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS
	}

	return funcs
end

function greater_main_secondary_attribute:GetModifierBonusStats_Strength( params )
	return self:GetStackCount() * self.str
end

function greater_main_secondary_attribute:GetModifierBonusStats_Agility( params )
	return self:GetStackCount() * self.agi
end

function greater_main_secondary_attribute:GetModifierBonusStats_Intellect( params )
	return self:GetStackCount() * self.int
end

function greater_main_secondary_attribute:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE + MODIFIER_ATTRIBUTE_MULTIPLE
end

function greater_main_secondary_attribute:IsHidden()
    return true
end

function greater_main_secondary_attribute:IsPurgable()
	return false
end

function greater_main_secondary_attribute:IsPurgeException()
	return false
end

function greater_main_secondary_attribute:IsStunDebuff()
	return false
end

function greater_main_secondary_attribute:IsDebuff()
	return false
end







































































































































































































































