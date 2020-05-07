greater_rune_sword = class({})

function greater_rune_sword:OnCreated( data )
	-- ### VALUES START ### --
	self.attack_damage                 = 12
	self.spell_damage                  = 12
	self.lifesteal                     = 3
	self.effectiveness_defensive       = 20.0
	self.effectiveness_supportive      = 30.0
	-- ### VALUES END ### --
	
	if not IsServer() then return end
	self.perkname = data.perkName
	self.perkID = data.perkID
	self.level = data.level
	self.perkEffectiveness = data.perkEffectiveness

	Change_PerkEffectivenessStats(self, true)

	self:StartIntervalThink(1.00)
end

function greater_rune_sword:OnRemoved()
	if not IsServer() then return end
	Change_PerkEffectivenessStats(self, false)
end

function greater_rune_sword:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_BASEDAMAGEOUTGOING_PERCENTAGE,
		MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,
		MODIFIER_EVENT_ON_TAKEDAMAGE
	}

	return funcs
end

function greater_rune_sword:OnIntervalThink()
	if not IsServer() then return end

	self:SetStackCount( 10000 * self.perkEffectiveness )
end

function greater_rune_sword:OnTakeDamage( params )
	if not IsServer() then return end
	if self:GetParent() ~= params.attacker then return end

	local caster = self:GetParent()

	local lifesteal = (self.lifesteal/100) * ( self:GetStackCount() / 10000 )

	caster:Heal(params.damage * lifesteal, caster)

	-- params.unit
	-- params.damage_type
	-- params.attacker
	-- params.original_damage
	-- params.damage
	-- params.inflictor
end

function greater_rune_sword:GetModifierBaseDamageOutgoing_Percentage( params )
	return self.attack_damage * ( self:GetStackCount() / 10000 )
end

function greater_rune_sword:GetModifierSpellAmplify_Percentage( params )
	return self.spell_damage * ( self:GetStackCount() / 10000 )
end

function greater_rune_sword:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE + MODIFIER_ATTRIBUTE_MULTIPLE
end

function greater_rune_sword:IsHidden()
    return true
end

function greater_rune_sword:IsPurgable()
	return false
end

function greater_rune_sword:IsPurgeException()
	return false
end

function greater_rune_sword:IsStunDebuff()
	return false
end

function greater_rune_sword:IsDebuff()
	return false
end





















