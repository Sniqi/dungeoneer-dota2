lesser_casting_cooldown_next_spell = class({})

function lesser_casting_cooldown_next_spell:OnCreated( data )
	-- ### VALUES START ### --
	self.cooldown_reduction            = 50
	self.trigger_cd                    = 2.5
	-- ### VALUES END ### --

	if not IsServer() then return end
	self.triggered = false
	self.on_cd = false
end

function lesser_casting_cooldown_next_spell:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_ABILITY_FULLY_CAST
	}

	return funcs
end

function lesser_casting_cooldown_next_spell:OnAbilityFullyCast( params )
	if not IsServer() then return end

	local heroEntity = self:GetParent()
	local ability = params.ability

	if self.triggered and not self.on_cd then
		self.triggered = false

		-- Cooldown Reduction --

		local ability_cd = ability:GetCooldownTimeRemaining()
		local ability_cd_new = ability_cd * ( ( 100 - self.cooldown_reduction ) / 100 )
		ability:EndCooldown()
		ability:StartCooldown(ability_cd_new)

		-- Trigger Cooldown --

		self.on_cd = true
		self:SetStackCount(self.trigger_cd)

		local timer1 = Timers:CreateTimer(1.0, function()
			self:DecrementStackCount()
			return 1.0
		end)
		PersistentTimer_Add(timer1)
		local timer2 = Timers:CreateTimer(self.trigger_cd+1, function()
			self.on_cd = false
			Timers:RemoveTimer(timer1)
		end)
		PersistentTimer_Add(timer2)
	end

	if not self.triggered and not self.on_cd then
		self.triggered = true
		self:SetStackCount(self.trigger_cd)
	end
	
end

function lesser_casting_cooldown_next_spell:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE + MODIFIER_ATTRIBUTE_MULTIPLE
end

function lesser_casting_cooldown_next_spell:IsHidden()
    return true
end

function lesser_casting_cooldown_next_spell:IsPurgable()
	return false
end

function lesser_casting_cooldown_next_spell:IsPurgeException()
	return false
end

function lesser_casting_cooldown_next_spell:IsStunDebuff()
	return false
end

function lesser_casting_cooldown_next_spell:IsDebuff()
	return false
end















































































































































































































































