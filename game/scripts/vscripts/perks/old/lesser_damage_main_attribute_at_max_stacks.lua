lesser_damage_main_attribute_at_max_stacks = class({})

function lesser_damage_main_attribute_at_max_stacks:OnCreated( data )
	-- ### VALUES START ### --
	self.stack_trigger                 = 8
	self.main_attribute                = 30
	self.duration                      = 10
	self.cooldown                      = 10
	self.stack_trigger_cd              = 0.5
	self.effectiveness_offensive       = 50.0
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
end

function lesser_damage_main_attribute_at_max_stacks:OnRemoved()
	if not IsServer() then return end
	Change_PerkEffectivenessStats(self, false)
end

function lesser_damage_main_attribute_at_max_stacks:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_TAKEDAMAGE,
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS
	}

	return funcs
end

function lesser_damage_main_attribute_at_max_stacks:OnTakeDamage( params )
	if not IsServer() then return end
	if self.on_cd then return end
	if self.on_trigger_cd then return end
	if self:GetParent() ~= params.attacker then return end
	if self:GetParent() == params.unit then return end
	if params.damage <= 0 then return end
	if params.damage_flags == DOTA_DAMAGE_FLAG_NO_DIRECTOR_EVENT then return end

	local caster = self:GetParent()
	local victim = params.unit

	self.stacks = self.stacks + 1

	PerkAppearance_Inactive(self:GetParent():GetPlayerOwnerID(), self.perkname, self.perkID, self.stacks)

	if self.stacks < self.stack_trigger then

		--Trigger CD
		self.on_trigger_cd = true
		Timers:CreateTimer(self.stack_trigger_cd, function()
			self.on_trigger_cd = false
		end)

	else --Active

		self:SetStackCount( 10000 * self.perkEffectiveness )

		local time = self.duration
		local timer = Timers:CreateTimer(0, function()
			PerkAppearance_Active(self:GetParent():GetPlayerOwnerID(), self.perkname, self.perkID, "#d14500", time)

			time = time - 1
			return 1.0
		end)

		--Duration
		self.on_cd = true
		Timers:CreateTimer(self.duration, function()

			Timers:RemoveTimer(timer)
			timer = nil

			self.stacks = 0

			self:SetStackCount(0)
		end)

		--CD
		self.on_cd = true
		Timers:CreateTimer(self.cooldown, function()
			self.on_cd = false
		end)

	end
end

function lesser_damage_main_attribute_at_max_stacks:GetModifierBonusStats_Strength( params )
	local caster = self:GetParent()
	if caster:GetPrimaryAttribute() == 0 then
		return ( caster:GetBaseStrength() * ( self.main_attribute / 100 ) ) * ( self:GetStackCount() / 10000 )
	else
		return 0
	end
end

function lesser_damage_main_attribute_at_max_stacks:GetModifierBonusStats_Agility( params )
	local caster = self:GetParent()
	if caster:GetPrimaryAttribute() == 1 then
		return ( caster:GetBaseAgility() * ( self.main_attribute / 100 ) ) * ( self:GetStackCount() / 10000 )
	else
		return 0
	end
end

function lesser_damage_main_attribute_at_max_stacks:GetModifierBonusStats_Intellect( params )
	local caster = self:GetParent()
	if caster:GetPrimaryAttribute() == 2 then
		return ( caster:GetBaseIntellect() * ( self.main_attribute / 100 ) ) * ( self:GetStackCount() / 10000 )
	else
		return 0
	end
end

function lesser_damage_main_attribute_at_max_stacks:GetModifierPhysicalArmorBonus( params )

end

function lesser_damage_main_attribute_at_max_stacks:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE + MODIFIER_ATTRIBUTE_MULTIPLE
end

function lesser_damage_main_attribute_at_max_stacks:IsHidden()
    return true
end

function lesser_damage_main_attribute_at_max_stacks:IsPurgable()
	return false
end

function lesser_damage_main_attribute_at_max_stacks:IsPurgeException()
	return false
end

function lesser_damage_main_attribute_at_max_stacks:IsStunDebuff()
	return false
end

function lesser_damage_main_attribute_at_max_stacks:IsDebuff()
	return false
end


















