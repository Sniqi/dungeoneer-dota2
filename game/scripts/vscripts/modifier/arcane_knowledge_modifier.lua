arcane_knowledge_modifier = class({})

function arcane_knowledge_modifier:OnCreated( kv )
	if not IsServer() then return end

	self:StartIntervalThink(0.5)
end

function arcane_knowledge_modifier:OnIntervalThink()
	if not IsServer() then return end

	local caster = self:GetParent()
	--local health = caster:GetMaxHealth()
	local max_mana = caster:GetMaxMana()
	--local str = caster:GetStrength()
	--local agi = caster:GetAgility()
	local int = caster:GetIntellect()
	--local armor = caster:GetPhysicalArmorValue()
	--local magic_resist = caster:GetMagicalArmorValue() * 100
	--local stats = str + agi + int
	

	--The formula
	local factor1 = 300
	local factor2 = 330
	local factor3 = 1
	local factor4 = -1
	local factor5 = 0.000075
	local factor6 = 20

	local arcane_knowledge = factor1 - factor2 * math.pow( math.exp(factor3), factor4 * ( factor5 * ( max_mana + ( int * factor6 ) ) ) )

	--Perks
	local perk_bonus = 1.0
	local perks = caster:FindAllModifiers()
	if perks ~= nil then
		for _,perk in pairs(perks) do
			if perk.arcane_knowledgeBuff ~= nil then
				perk_bonus = perk_bonus * ( 1 + ( ( perk.arcane_knowledgeBuff ) / 100 ) )
			end
		end
	end

	arcane_knowledge = arcane_knowledge * perk_bonus

	--Should not be below 0
	if arcane_knowledge < 0 then arcane_knowledge = 0 end

	if caster:GetPrimaryAttribute() ~= 2 then
		arcane_knowledge = arcane_knowledge / 3
	end

	--increase resolution
	self:SetStackCount( arcane_knowledge * 10 )
end

function arcane_knowledge_modifier:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE
	}

	return funcs
end

function arcane_knowledge_modifier:GetModifierSpellAmplify_Percentage()
	return ( self:GetStackCount() / 10 )
end

function arcane_knowledge_modifier:GetAttributes()
	return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE + MODIFIER_ATTRIBUTE_PERMANENT
end

function arcane_knowledge_modifier:IsHidden()
	return false
end

function arcane_knowledge_modifier:IsPurgable()
	return false
end

function arcane_knowledge_modifier:IsPurgeException()
	return false
end

function arcane_knowledge_modifier:IsStunDebuff()
	return false
end

function arcane_knowledge_modifier:IsDebuff()
	return false
end

function arcane_knowledge_modifier:GetTexture()
	return "chen_holy_persuasion"
end