sinastra_cold_presence_modifier = class({})

function sinastra_cold_presence_modifier:OnCreated( kv )
	self.damage                       = self:GetAbility():GetSpecialValueFor("damage")
	self.move_speed_percentage        = self:GetAbility():GetSpecialValueFor("move_speed_percentage")
	self.no_movement_duration         = self:GetAbility():GetSpecialValueFor("no_movement_duration")
	self.ice_block_duration           = self:GetAbility():GetSpecialValueFor("ice_block_duration")

	if not IsServer() then return end

	local caster = self:GetParent()

	self.oldPos = caster:GetAbsOrigin()
	self.stacks = 0

	self.interval = 0.1

	self:StartIntervalThink( self.interval )
end

function sinastra_cold_presence_modifier:OnIntervalThink()
	if not IsServer() then return end

	local caster = self:GetParent()

	-- Apply Damage --
	EncounterApplyDamage(caster, self:GetCaster(), self, self.damage * self.interval, DAMAGE_TYPE_MAGICAL, DOTA_DAMAGE_FLAG_NONE)

	if self.stacks >= 100 then return end

	local vector_distance = self.oldPos - caster:GetAbsOrigin()
	local distance = (vector_distance):Length2D()

	if distance ~= 0 then
		self.stacks = self.stacks - ( distance / 10 )

		if self.stacks < 0 then self.stacks = 0 end

		self:SetStackCount( self.stacks )
	else
		self.stacks = self.stacks + ( 100 / self.no_movement_duration * self.interval )
		self:SetStackCount( self.stacks  )
	end

	self.oldPos = caster:GetAbsOrigin()

	if self.stacks >= 100 then

		-- Modifier --
		caster:AddNewModifier(self:GetCaster(), self, "casting_frozen_modifier", {duration = self.ice_block_duration})
		caster:AddNewModifier(self:GetCaster(), self, "modifier_stunned", {duration = self.ice_block_duration})

		-- Particle -- PATTACH_ABSORIGIN-PATTACH_ABSORIGIN_FOLLOW-PATTACH_CUSTOMORIGIN
		local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_winter_wyvern/wyvern_cold_embrace_buff.vpcf", PATTACH_ABSORIGIN, caster)
		ParticleManager:SetParticleControl( particle, 0, caster:GetAbsOrigin() )
		PersistentParticle_Add(particle)

		-- Sound --
		StartSoundEventReliable("Hero_Winter_Wyvern.ColdEmbrace", caster)

		local timer = Timers:CreateTimer(self.ice_block_duration, function()

			ParticleManager:DestroyParticle( particle, false )
			ParticleManager:ReleaseParticleIndex( particle )
			particle = nil

			self.stacks = 0
			self:SetStackCount( self.stacks )

		end)
		PersistentTimer_Add(timer)

	end

end

function sinastra_cold_presence_modifier:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_PROPERTY_TOOLTIP,
	}

	return funcs
end


function sinastra_cold_presence_modifier:GetModifierMoveSpeedBonus_Percentage( params )
	return self.move_speed_percentage
end

function sinastra_cold_presence_modifier:OnTooltip( params )
	return self.no_movement_duration
end


function sinastra_cold_presence_modifier:GetAttributes()
	return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE
end

function sinastra_cold_presence_modifier:IsHidden()
    return false
end

function sinastra_cold_presence_modifier:IsPurgable()
	return false
end

function sinastra_cold_presence_modifier:IsPurgeException()
	return false
end

function sinastra_cold_presence_modifier:IsStunDebuff()
	return false
end

function sinastra_cold_presence_modifier:IsDebuff()
	return true
end