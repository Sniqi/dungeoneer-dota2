strength_resilience_modifier = class({})

function strength_resilience_modifier:OnCreated( kv )
	if not IsServer() then return end

	self:StartIntervalThink(0.5)
end

function strength_resilience_modifier:OnIntervalThink()
	if not IsServer() then return end

	local caster = self:GetParent()
	local health = caster:GetMaxHealth()
	local str = caster:GetStrength()
	local agi = caster:GetAgility()
	local int = caster:GetIntellect()
	local armor = caster:GetPhysicalArmorValue(false)
	local magic_resist = caster:GetMagicalArmorValue() * 100
	local stats = str + agi + int

	--The formula
	local factor1 = 35
	local factor2 = 40
	local factor3 = 0.5
	local factor4 = -1
	local factor5 = 0.0003
	local factor6 = 3
	local factor7 = 10

	local resilience = factor1 - factor2 * math.pow( math.exp(factor3), factor4 * ( factor5 * ( health + ( ( ( armor * factor6 ) + magic_resist ) * factor7 ) ) ) )

	--Perks
	local perks = caster:FindAllModifiers()
	if perks ~= nil then
		for _,perk in pairs(perks) do
			if perk.resilienceBuff ~= nil then
				resilience = resilience * ( 1 + ( ( perk.resilienceBuff ) / 100 ) )
			end
		end
	end

	--Should not be below 0
	if resilience < 0 then resilience = 0 end

	--increase resolution
	self:SetStackCount( resilience * 10 )
end

function strength_resilience_modifier:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE
	}

	return funcs
end

function strength_resilience_modifier:GetModifierIncomingDamage_Percentage()
	return ( self:GetStackCount() / 10 ) * -1
end

function strength_resilience_modifier:GetAttributes()
	return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE + MODIFIER_ATTRIBUTE_PERMANENT
end

function strength_resilience_modifier:IsHidden()
	return false
end

function strength_resilience_modifier:IsPurgable()
	return false
end

function strength_resilience_modifier:IsPurgeException()
	return false
end

function strength_resilience_modifier:IsStunDebuff()
	return false
end

function strength_resilience_modifier:IsDebuff()
	return false
end

function strength_resilience_modifier:GetTexture()
	return "centaur_return"
end