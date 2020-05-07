greater_staggered_damage = class({})

function greater_staggered_damage:OnCreated( data )
	-- ### VALUES START ### --
	self.staggered_damage              = 50
	self.duration                      = 4
	self.clear_interval                = 6
	-- ### VALUES END ### --
	
	if not IsServer() then return end
	self.caster = nil
	self.staggered_damage_amount = 0
	self.count = 0

	self:StartIntervalThink(self.duration)
end

function greater_staggered_damage:OnIntervalThink()
	if not IsServer() then return end

	if self.clear_interval / self.count <= 1 then
		
		self.staggered_damage_amount = 0

	elseif self.staggered_damage_amount > 0 and self.caster ~= nil then

		local caster = self.caster--self:GetParent()

		local health = self.staggered_damage_amount / ( ( self.duration * 10 ) - 1 )

		self.staggered_damage_amount = 0

		self.timer = Timers:CreateTimer(0.1, function()

			if caster:IsAlive() then
				caster:ModifyHealth( caster:GetHealth() - health , nil, true, 0)
			else
				return
			end

			return 0.1
		end)

		Timers:CreateTimer(self.duration - 0.15, function()
			Timers:RemoveTimer(self.timer)
		end)

	end

	self.count = self.count + self.duration
end

function greater_staggered_damage:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_TAKEDAMAGE,
	}

	return funcs
end

function greater_staggered_damage:OnTakeDamage( params )
	if not IsServer() then return end
	
	local caster = self:GetParent()

	if params.unit ~= self:GetParent() then return end

	self.caster = caster

	-- params.damage_type
	-- params.attacker
	-- params.original_damage
	-- params.damage

	local damage = params.damage

	local staggered_damage = damage * (self.staggered_damage/100)
	self.staggered_damage_amount = self.staggered_damage_amount + staggered_damage

end

function greater_staggered_damage:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE + MODIFIER_ATTRIBUTE_MULTIPLE
end

function greater_staggered_damage:IsHidden()
    return true
end

function greater_staggered_damage:IsPurgable()
	return false
end

function greater_staggered_damage:IsPurgeException()
	return false
end

function greater_staggered_damage:IsStunDebuff()
	return false
end

function greater_staggered_damage:IsDebuff()
	return false
end















































































































































































































































