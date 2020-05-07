glyph_petrified_cloak = class({})

function glyph_petrified_cloak:OnCreated( data )
	-- ### VALUES START ### --
	self.staggered_damage              = 20
	self.duration                      = 2
	self.effectiveness_offensive       = 8
	self.effectiveness_shadow          = -2.0
	-- ### VALUES END ### --
	
	if not IsServer() then return end
	self.perkname = data.perkName
	self.perkID = data.perkID
	self.level = data.level
	self.perkEffectiveness = data.perkEffectiveness

	Change_PerkEffectivenessStats(self, true)

	self.caster = nil
	self.staggered_damage_amount = 0
	self.count = 0

	self:StartIntervalThink(self.duration)
end

function glyph_petrified_cloak:OnRemoved()
	if not IsServer() then return end
	Change_PerkEffectivenessStats(self, false)
end

function glyph_petrified_cloak:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_TAKEDAMAGE
	}

	return funcs
end

function glyph_petrified_cloak:OnIntervalThink()
	if not IsServer() then return end

	self:SetStackCount( 10000 * self.perkEffectiveness )

	if not IsServer() then return end

	if self.staggered_damage_amount > 0 and self.caster ~= nil then

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

function glyph_petrified_cloak:OnTakeDamage( params )
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

function glyph_petrified_cloak:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE + MODIFIER_ATTRIBUTE_MULTIPLE
end

function glyph_petrified_cloak:IsHidden()
    return true
end

function glyph_petrified_cloak:IsPurgable()
	return false
end

function glyph_petrified_cloak:IsPurgeException()
	return false
end

function glyph_petrified_cloak:IsStunDebuff()
	return false
end

function glyph_petrified_cloak:IsDebuff()
	return false
end




















































































































































