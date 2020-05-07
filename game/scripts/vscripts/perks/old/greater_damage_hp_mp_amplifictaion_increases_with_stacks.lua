greater_damage_hp_mp_amplifictaion_increases_with_stacks = class({})

function greater_damage_hp_mp_amplifictaion_increases_with_stacks:OnCreated( data )
	-- ### VALUES START ### --
	self.hp_regen_amplify              = 20
	self.mp_regen_amplify              = 20
	self.main_attribute                = 8
	self.bonus                         = 20
	self.stacks_max                    = 5
	self.stack_trigger_cd              = 0.2
	self.effectiveness_dealingdamage_offensive= 50.0
	-- ### VALUES END ### --
	
	if not IsServer() then return end
	self.perkname = data.perkName
	self.perkID = data.perkID
	self.level = data.level
	self.perkEffectiveness = data.perkEffectiveness

	Change_PerkEffectivenessStats(self, true)

	self.stacks = 0

	self.on_cd = false
	self.on_trigger_cd = false

	self.id = DoUniqueString("greater_damage_hp_mp_amplifictaion_increases_with_stacks")
end

function greater_damage_hp_mp_amplifictaion_increases_with_stacks:OnRemoved()
	if not IsServer() then return end
	Change_PerkEffectivenessStats(self, false)
end

function greater_damage_hp_mp_amplifictaion_increases_with_stacks:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_TAKEDAMAGE,
		MODIFIER_PROPERTY_HP_REGEN_AMPLIFY_PERCENTAGE,
		MODIFIER_PROPERTY_MP_REGEN_AMPLIFY_PERCENTAGE,
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS
	}

	return funcs
end

function greater_damage_hp_mp_amplifictaion_increases_with_stacks:OnTakeDamage( params )
	if not IsServer() then return end
	if self.on_cd then return end
	if self.on_trigger_cd then return end
	if self:GetParent() ~= params.attacker then return end
	if self:GetParent() == params.unit then return end
	if params.damage <= 0 then return end
	if params.damage_flags == DOTA_DAMAGE_FLAG_NO_DIRECTOR_EVENT then return end

	--Trigger CD
	self.on_trigger_cd = true
	Timers:CreateTimer(self.stack_trigger_cd, function()
		self.on_trigger_cd = false
	end)

	local caster = self:GetParent()
	local victim = params.unit

	PerkAppearance_Inactive(self:GetParent():GetPlayerOwnerID(), self.perkname, self.perkID, self.stacks)

	if self.stacks == self.stacks_max then
		self.stacks = 0
	end

	self.stacks = self.stacks + 1

	self:SetStackCount( ( self.stacks * ( self.bonus / 100 ) ) * 10000 * self.perkEffectiveness )
end

function greater_damage_hp_mp_amplifictaion_increases_with_stacks:GetModifierHPRegenAmplify_Percentage( params )
	return self.hp_regen_amplify * ( self:GetStackCount() / 10000 )
end

function greater_damage_hp_mp_amplifictaion_increases_with_stacks:GetModifierMPRegenAmplify_Percentage( params )
	return self.mp_regen_amplify * ( self:GetStackCount() / 10000 )
end

function greater_damage_hp_mp_amplifictaion_increases_with_stacks:GetModifierBonusStats_Strength( params )
	local caster = self:GetParent()
	if caster:GetPrimaryAttribute() == 0 then
		return ( caster:GetBaseStrength() * ( self.main_attribute / 100 ) ) * ( self:GetStackCount() / 10000 )
	else
		return 0
	end
end

function greater_damage_hp_mp_amplifictaion_increases_with_stacks:GetModifierBonusStats_Agility( params )
	local caster = self:GetParent()
	if caster:GetPrimaryAttribute() == 1 then
		return ( caster:GetBaseAgility() * ( self.main_attribute / 100 ) ) * ( self:GetStackCount() / 10000 )
	else
		return 0
	end
end

function greater_damage_hp_mp_amplifictaion_increases_with_stacks:GetModifierBonusStats_Intellect( params )
	local caster = self:GetParent()
	if caster:GetPrimaryAttribute() == 2 then
		return ( caster:GetBaseIntellect() * ( self.main_attribute / 100 ) ) * ( self:GetStackCount() / 10000 )
	else
		return 0
	end
end

function greater_damage_hp_mp_amplifictaion_increases_with_stacks:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE + MODIFIER_ATTRIBUTE_MULTIPLE
end

function greater_damage_hp_mp_amplifictaion_increases_with_stacks:IsHidden()
    return true
end

function greater_damage_hp_mp_amplifictaion_increases_with_stacks:IsPurgable()
	return false
end

function greater_damage_hp_mp_amplifictaion_increases_with_stacks:IsPurgeException()
	return false
end

function greater_damage_hp_mp_amplifictaion_increases_with_stacks:IsStunDebuff()
	return false
end

function greater_damage_hp_mp_amplifictaion_increases_with_stacks:IsDebuff()
	return false
end










































































