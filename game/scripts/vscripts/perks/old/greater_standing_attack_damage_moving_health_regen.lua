greater_standing_attack_damage_moving_health_regen = class({})

function greater_standing_attack_damage_moving_health_regen:OnCreated( data )
	-- ### VALUES START ### --
	self.attack_damage                 = 24
	self.health_regen                  = 1.5
	self.effectiveness_defensive       = 18.0
	self.effectiveness_supportive      = 32.0
	-- ### VALUES END ### --

	if not IsServer() then return end
	self.perkname = data.perkName
	self.perkID = data.perkID
	self.level = data.level
	self.perkEffectiveness = data.perkEffectiveness

	Change_PerkEffectivenessStats(self, true)

	local caster = self:GetParent()
	self.oldPos = caster:GetAbsOrigin()

	self.stacks = 0

	self:StartIntervalThink(0.1)
end

function greater_standing_attack_damage_moving_health_regen:OnRemoved()
	if not IsServer() then return end
	Change_PerkEffectivenessStats(self, false)
end

function greater_standing_attack_damage_moving_health_regen:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_BASEDAMAGEOUTGOING_PERCENTAGE,
		MODIFIER_PROPERTY_HEALTH_REGEN_PERCENTAGE,
	}

	return funcs
end

function greater_standing_attack_damage_moving_health_regen:OnIntervalThink()
	local caster = self:GetParent()

	self:SetStackCount( 10000 * self.perkEffectiveness )

	local distance = ( self.oldPos - caster:GetAbsOrigin() ):Length2D()
	if distance == 0 then
		self:SetStackCount( 10000 * self.perkEffectiveness )
	else
		self:SetStackCount( -1 * 10000 * self.perkEffectiveness )
	end

	self.oldPos = caster:GetAbsOrigin()
end

function greater_standing_attack_damage_moving_health_regen:GetModifierBaseDamageOutgoing_Percentage( params )
	if self:GetStackCount() > 0 then
		return self.attack_damage * ( self:GetStackCount() / 10000 )
	else
		return 0
	end
end

function greater_standing_attack_damage_moving_health_regen:GetModifierHealthRegenPercentage( params )
	if self:GetStackCount() < 0 then
		return self.health_regen * ( self:GetStackCount() / 10000 ) * -1
	else
		return 0
	end
end

function greater_standing_attack_damage_moving_health_regen:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE + MODIFIER_ATTRIBUTE_MULTIPLE
end

function greater_standing_attack_damage_moving_health_regen:IsHidden()
    return true
end

function greater_standing_attack_damage_moving_health_regen:IsPurgable()
	return false
end

function greater_standing_attack_damage_moving_health_regen:IsPurgeException()
	return false
end

function greater_standing_attack_damage_moving_health_regen:IsStunDebuff()
	return false
end

function greater_standing_attack_damage_moving_health_regen:IsDebuff()
	return false
end



















































































