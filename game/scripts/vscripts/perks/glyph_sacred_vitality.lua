glyph_sacred_vitality = class({})

function glyph_sacred_vitality:OnCreated( data )
	-- ### VALUES START ### --
	self.health_refund                 = 10
	self.duration                      = 8
	self.effectiveness_offensive       = 8
	self.effectiveness_fire            = -4.0
	self.effectiveness_lightning       = -4.0
	-- ### VALUES END ### --
	
	if not IsServer() then return end
	self.perkname = data.perkName
	self.perkID = data.perkID
	self.level = data.level
	self.perkEffectiveness = data.perkEffectiveness

	Change_PerkEffectivenessStats(self, true)

	self:StartIntervalThink(1.00)
end

function glyph_sacred_vitality:OnRemoved()
	if not IsServer() then return end
	Change_PerkEffectivenessStats(self, false)
end

function glyph_sacred_vitality:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_TAKEDAMAGE
	}

	return funcs
end

function glyph_sacred_vitality:OnIntervalThink()
	if not IsServer() then return end

	self:SetStackCount( 10000 * self.perkEffectiveness )
end

function glyph_sacred_vitality:OnTakeDamage( params )
	if not IsServer() then return end
	if params.unit ~= self:GetParent() then return end

	-- params.damage_type
	-- params.attacker
	-- params.original_damage
	-- params.damage

	local caster = self:GetParent()

	local duration = self.duration
	local interval = 0.1
	local health_refund = ( params.damage * (self.health_refund / 100) ) / ( duration / interval )
	health_refund = health_refund * ( self:GetStackCount() / 10000 )

	local timer = Timers:CreateTimer(0, function()

		if caster:IsAlive() then
			caster:Heal(health_refund, nil)
		end

		return interval
	end)

	Timers:CreateTimer(duration, function()
		Timers:RemoveTimer(timer)
	end)


end

function glyph_sacred_vitality:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE + MODIFIER_ATTRIBUTE_MULTIPLE
end

function glyph_sacred_vitality:IsHidden()
    return true
end

function glyph_sacred_vitality:IsPurgable()
	return false
end

function glyph_sacred_vitality:IsPurgeException()
	return false
end

function glyph_sacred_vitality:IsStunDebuff()
	return false
end

function glyph_sacred_vitality:IsDebuff()
	return false
end




















































































































































