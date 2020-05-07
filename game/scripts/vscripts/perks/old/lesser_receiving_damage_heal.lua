lesser_receiving_damage_heal = class({})

function lesser_receiving_damage_heal:OnCreated( data )
	-- ### VALUES START ### --
	self.damage_received_of_max_health = 10
	self.heal                          = 30
	self.duration                      = 2
	self.trigger_cd                    = 2
	self.effectiveness_offensive       = 35.0
	self.effectiveness_defensive       = 15.0
	-- ### VALUES END ### --

	if not IsServer() then return end
	self.perkname = data.perkName
	self.perkID = data.perkID
	self.level = data.level
	self.perkEffectiveness = data.perkEffectiveness

	Change_PerkEffectivenessStats(self, true)

	self.cd = 0

	self:StartIntervalThink(1.00)
end

function lesser_receiving_damage_heal:OnRemoved()
	if not IsServer() then return end
	Change_PerkEffectivenessStats(self, false)
end

function lesser_receiving_damage_heal:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_TAKEDAMAGE
	}

	return funcs
end

function lesser_receiving_damage_heal:OnIntervalThink()
	if not IsServer() then return end

	self:SetStackCount( 10000 * self.perkEffectiveness )
end

function lesser_receiving_damage_heal:OnTakeDamage( params )
	if not IsServer() then return end
	if params.unit ~= self:GetParent() then return end

	-- params.damage_type
	-- params.attacker
	-- params.original_damage
	-- params.damage

	local caster = self:GetParent()
	local damage_threshold = caster:GetMaxHealth() * ( self.damage_received_of_max_health / 200 )

	if self.cd == 0 and params.original_damage >= damage_threshold then

		self.cd = self.trigger_cd
		local timer1 = Timers:CreateTimer(0, function()
			self.cd = self.cd - 1
			return 1.0
		end)
		Timers:CreateTimer(self.trigger_cd+0.03, function()
			Timers:RemoveTimer(timer1)
		end)

		local duration = self.duration
		local interval = 0.1
		local health_refund = ( caster:GetMaxHealth() * (self.heal / 100) ) / ( duration / interval )
		health_refund = health_refund * ( self:GetStackCount() / 10000 )

		local timer2 = Timers:CreateTimer(0, function()

			if caster:IsAlive() then
				caster:Heal(health_refund, nil)
			end

			return interval
		end)

		Timers:CreateTimer(duration, function()
			Timers:RemoveTimer(timer2)
		end)
	end

end


function lesser_receiving_damage_heal:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE + MODIFIER_ATTRIBUTE_MULTIPLE
end

function lesser_receiving_damage_heal:IsHidden()
    return true
end

function lesser_receiving_damage_heal:IsPurgable()
	return false
end

function lesser_receiving_damage_heal:IsPurgeException()
	return false
end

function lesser_receiving_damage_heal:IsStunDebuff()
	return false
end

function lesser_receiving_damage_heal:IsDebuff()
	return false
end















































































































































































































































































































