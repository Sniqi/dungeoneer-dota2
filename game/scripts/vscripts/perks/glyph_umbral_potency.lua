glyph_umbral_potency = class({})

function glyph_umbral_potency:OnCreated( data )
	-- ### VALUES START ### --
	self.interval                      = 3
	self.cooldown_reduction            = 10
	self.effectiveness_defensive       = -5.0
	self.effectiveness_lightning       = 5.0
	-- ### VALUES END ### --
	
	if not IsServer() then return end
	self.perkname = data.perkName
	self.perkID = data.perkID
	self.level = data.level
	self.perkEffectiveness = data.perkEffectiveness

	Change_PerkEffectivenessStats(self, true)

	self:StartIntervalThink(self.interval)
end

function glyph_umbral_potency:OnRemoved()
	if not IsServer() then return end
	Change_PerkEffectivenessStats(self, false)
end

function glyph_umbral_potency:DeclareFunctions()
	local funcs = {

	}

	return funcs
end

function glyph_umbral_potency:OnIntervalThink()
	if not IsServer() then return end

	self:SetStackCount( 10000 * self.perkEffectiveness )

	local caster = self:GetParent()

	local abilities = {}

	for i=0,9 do
		local ability = caster:GetAbilityByIndex(i)

		if ability ~= nil then
			if ability:GetCooldownTimeRemaining() > 1 and ability:GetAbilityName() ~= "artifact_ability" then
				table.insert(abilities, ability)
			end
		end
	end

	if abilities ~= nil then
		if table.getn(abilities) > 0 then
			self.stacks = self.interval / ( self:GetStackCount() / 10000 )

			local rng = RandomInt(1, table.getn(abilities))
			local ability = abilities[rng]

			local ability_cd = ability:GetCooldownTimeRemaining()

			local cd_reduction = self.cooldown_reduction * ( self:GetStackCount() / 10000 )
			cd_reduction = ( ( 100 - self.cooldown_reduction ) / 100 )

			local ability_cd_new = ability_cd * cd_reduction

			ability:EndCooldown()
			ability:StartCooldown(ability_cd_new)
		end
	end
end

function glyph_umbral_potency:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE + MODIFIER_ATTRIBUTE_MULTIPLE
end

function glyph_umbral_potency:IsHidden()
    return true
end

function glyph_umbral_potency:IsPurgable()
	return false
end

function glyph_umbral_potency:IsPurgeException()
	return false
end

function glyph_umbral_potency:IsStunDebuff()
	return false
end

function glyph_umbral_potency:IsDebuff()
	return false
end




















































































































































