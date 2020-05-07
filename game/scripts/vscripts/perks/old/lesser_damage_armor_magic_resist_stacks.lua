lesser_damage_armor_magic_resist_stacks = class({})

function lesser_damage_armor_magic_resist_stacks:OnCreated( data )
	-- ### VALUES START ### --
	self.armor                         = 0.75
	self.magic_resist                  = 3
	self.main_attribute                = 4
	self.stacks_max                    = 4
	self.duration                      = 6
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

	self.id = DoUniqueString("lesser_damage_armor_magic_resist_stacks")
end

function lesser_damage_armor_magic_resist_stacks:OnRemoved()
	if not IsServer() then return end
	Change_PerkEffectivenessStats(self, false)
end

function lesser_damage_armor_magic_resist_stacks:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_TAKEDAMAGE,
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
		MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS
	}

	return funcs
end

function lesser_damage_armor_magic_resist_stacks:OnTakeDamage( params )
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
	local playerID = caster:GetPlayerOwnerID()

	if self.stacks < self.stacks_max then
		self.stacks = self.stacks + 1
		self:SetStackCount( self.stacks * 10000 * PerkEffectiveness[playerID]["lesser_damage_armor_magic_resist_stacks"] )
	end

	PerkAppearance_Inactive(self:GetParent():GetPlayerOwnerID(), self.perkname, self.perkID, self.stacks)

	if caster.lesser_damage_armor_magic_resist_stacks == nil then
		caster.lesser_damage_armor_magic_resist_stacks = {}
	end

	if caster.lesser_damage_armor_magic_resist_stacks[self.id] == nil then
		caster.lesser_damage_armor_magic_resist_stacks[self.id] = {}
	end

	if caster.lesser_damage_armor_magic_resist_stacks[self.id]["duration"] ~= nil then
		Timers:RemoveTimer( caster.lesser_damage_armor_magic_resist_stacks[self.id]["duration"] )
	end

	local duration = Timers:CreateTimer(self.duration, function()
		if not IsValidEntity(caster) then return end
		if caster == nil then return end
		if caster:IsNull() then return end
		if not caster:IsAlive() then return end

		self.stacks = 0
		self:SetStackCount( self.stacks * 10000 * PerkEffectiveness[playerID]["lesser_damage_armor_magic_resist_stacks"] )
		PerkAppearance_Inactive(self:GetParent():GetPlayerOwnerID(), self.perkname, self.perkID, self.stacks)
	end)

	caster.lesser_damage_armor_magic_resist_stacks[self.id]["duration"] = duration
end

function lesser_damage_armor_magic_resist_stacks:GetModifierPhysicalArmorBonus( params )
	return ( self.armor ) * ( self:GetStackCount() / 10000 )
end

function lesser_damage_armor_magic_resist_stacks:GetModifierMagicalResistanceBonus( params )
	return ( self.magic_resist ) * ( self:GetStackCount() / 10000 )
end

function lesser_damage_armor_magic_resist_stacks:GetModifierBonusStats_Strength( params )
	local caster = self:GetParent()
	if caster:GetPrimaryAttribute() == 0 then
		return ( caster:GetBaseStrength() * ( self.main_attribute / 100 ) ) * ( self:GetStackCount() / 10000 )
	else
		return 0
	end
end

function lesser_damage_armor_magic_resist_stacks:GetModifierBonusStats_Agility( params )
	local caster = self:GetParent()
	if caster:GetPrimaryAttribute() == 1 then
		return ( caster:GetBaseAgility() * ( self.main_attribute / 100 ) ) * ( self:GetStackCount() / 10000 )
	else
		return 0
	end
end

function lesser_damage_armor_magic_resist_stacks:GetModifierBonusStats_Intellect( params )
	local caster = self:GetParent()
	if caster:GetPrimaryAttribute() == 2 then
		return ( caster:GetBaseIntellect() * ( self.main_attribute / 100 ) ) * ( self:GetStackCount() / 10000 )
	else
		return 0
	end
end

function lesser_damage_armor_magic_resist_stacks:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE + MODIFIER_ATTRIBUTE_MULTIPLE
end

function lesser_damage_armor_magic_resist_stacks:IsHidden()
    return true
end

function lesser_damage_armor_magic_resist_stacks:IsPurgable()
	return false
end

function lesser_damage_armor_magic_resist_stacks:IsPurgeException()
	return false
end

function lesser_damage_armor_magic_resist_stacks:IsStunDebuff()
	return false
end

function lesser_damage_armor_magic_resist_stacks:IsDebuff()
	return false
end


















