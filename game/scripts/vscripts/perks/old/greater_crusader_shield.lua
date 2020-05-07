greater_crusader_shield = class({})

LinkLuaModifier( 'greater_crusader_shield_buff1', 'perks/greater_crusader_shield_buff1', LUA_MODIFIER_MOTION_NONE )

function greater_crusader_shield:OnCreated( data )
	-- ### VALUES START ### --
	self.duration                      = 3
	self.trigger_cd                    = 120
	self.shield                        = 12
	self.interval                      = 8
	self.effectiveness_offensive       = 15.0
	self.effectiveness_supportive      = 35.0
	-- ### VALUES END ### --
	
	self.current_cooldown = 0
	self.active = false

	self.deactivated = false
	
	if not IsServer() then return end
	self.perkname = data.perkName
	self.perkID = data.perkID
	self.level = data.level
	self.perkEffectiveness = data.perkEffectiveness

	Change_PerkEffectivenessStats(self, true)

	local caster = self:GetParent()
	self.minHealthModifier = caster:AddNewModifier(caster, nil, "greater_crusader_shield_buff1", {})

	self.cheatdeath_stacks = 0.0

	self.additional_modifier = {}
	table.insert(self.additional_modifier, self.minHealthModifier)

	self.shield_stacks = 0.0
	self.shield_hp = 0

	self:StartIntervalThink(0.1)
end

function greater_crusader_shield:OnRemoved()
	if not IsServer() then return end
	Change_PerkEffectivenessStats(self, false)
end

function greater_crusader_shield:OnIntervalThink()
	if not IsServer() then return end

	local caster = self:GetParent()

	if not caster:IsAlive() then return end

	self:SetStackCount( 10000 * self.perkEffectiveness )

	--Crusader Shield
	if self.shield_stacks <= 0.0 then

		self.shield_stacks = self.interval

		local caster = self:GetParent()

		local abilities = {}

		self.shield_hp = ( caster:GetMaxHealth() * ( self.shield / 100 ) ) * ( self:GetStackCount() / 10000 )

		-- Particle --
		if caster.greater_crusader_shield_particle ~= nil then
			ParticleManager:DestroyParticle( caster.greater_crusader_shield_particle, false )
			ParticleManager:ReleaseParticleIndex( caster.greater_crusader_shield_particle )
			caster.greater_crusader_shield_particle = nil
		end
		caster.greater_crusader_shield_particle = ParticleManager:CreateParticle("particles/perks/greater_interval_absorbing_shield.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster)
		ParticleManager:SetParticleControl( caster.greater_crusader_shield_particle, 0, caster:GetAbsOrigin() )
		ParticleManager:SetParticleControl( caster.greater_crusader_shield_particle, 1, caster:GetAbsOrigin() )

		--PerkAppearance_Active(self:GetParent():GetPlayerOwnerID(), self.perkname, self.perkID, "#ffcb21", "!")

	else
		self.shield_stacks = self.shield_stacks - 0.1

		--PerkAppearance_Inactive(self:GetParent():GetPlayerOwnerID(), self.perkname, self.perkID, self:GetStackCount())
	end

	--Cheat Death
	if (caster:GetHealthPercent() <= 1 and self.active == false and self.current_cooldown <= 0) and not self.deactivated then

		self.active = true
		self.current_cooldown = self.trigger_cd / ( self:GetStackCount() / 10000 )

		self.cheatdeath_stacks = self.duration * ( self:GetStackCount() / 10000 )

		local timer1 = Timers:CreateTimer(1, function()
			if self.cheatdeath_stacks > 0 then
				self.cheatdeath_stacks = self.cheatdeath_stacks - 1
			end

			PerkAppearance_Active(self:GetParent():GetPlayerOwnerID(), self.perkname, self.perkID, "#f48942", math.floor(self.cheatdeath_stacks) )

			return 1
		end)

		-- Particle --
		self.particle = ParticleManager:CreateParticle("particles/units/heroes/hero_omniknight/omniknight_guardian_angel_omni.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster)
		ParticleManager:SetParticleControl( self.particle, 0, caster:GetAbsOrigin() )
		ParticleManager:SetParticleControl( self.particle, 5, caster:GetAbsOrigin() )		

		Timers:CreateTimer( ( self.duration * ( self:GetStackCount() / 10000 ) ) + 0.5, function()
			Timers:RemoveTimer(timer1)
			timer1 = nil

			-- Particle --
			ParticleManager:DestroyParticle( self.particle, false )
			ParticleManager:ReleaseParticleIndex( self.particle )
			self.particle = nil

			if self.minHealthModifier == nil then
				self.minHealthModifier = caster:FindModifierByName("greater_crusader_shield_buff1")
			end

			self.minHealthModifier:Destroy()

			local timer2 = Timers:CreateTimer(1, function()
				if self.current_cooldown > 0 then
					self.current_cooldown = self.current_cooldown - 1
					PerkAppearance_Inactive(self:GetParent():GetPlayerOwnerID(), self.perkname, self.perkID, math.floor(self.current_cooldown) )
				else
					if caster:IsAlive() then
						self.minHealthModifier = caster:AddNewModifier(caster, nil, "greater_crusader_shield_buff1", {})
						self.current_cooldown = 0
						self.active = false
						PerkAppearance_Inactive(self:GetParent():GetPlayerOwnerID(), self.perkname, self.perkID, "")
						return
					else
						return 0.25
					end

				end

				return 1
			end)
		end)

	end
end

function greater_crusader_shield:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE + MODIFIER_ATTRIBUTE_MULTIPLE
end

function greater_crusader_shield:IsHidden()
    return true
end

function greater_crusader_shield:IsPurgable()
	return false
end

function greater_crusader_shield:IsPurgeException()
	return false
end

function greater_crusader_shield:IsStunDebuff()
	return false
end

function greater_crusader_shield:IsDebuff()
	return false
end

function greater_crusader_shield:GetTexture()
	return "greater_crusader_shield"
end






















