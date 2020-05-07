greater_cheat_death = class({})

LinkLuaModifier( 'greater_cheat_death_buff1', 'perks/greater_cheat_death_buff1', LUA_MODIFIER_MOTION_NONE )

function greater_cheat_death:OnCreated( data )
	-- ### VALUES START ### --
	self.duration                      = 5
	self.trigger_cd                    = 90
	-- ### VALUES END ### --

	self.current_cooldown = 0
	self.active = false

	self.deactivated = false
	
	if not IsServer() then return end
	local caster = self:GetParent()
	self.minHealthModifier = caster:AddNewModifier(caster, nil, "greater_cheat_death_buff1", {})

	self.additional_modifier = {}
	table.insert(self.additional_modifier, self.minHealthModifier)

	self:StartIntervalThink(0.06)
end

function greater_cheat_death:OnIntervalThink()
	if not IsServer() then return end
	if self.deactivated then return end

	local caster = self:GetParent()

	if not caster:IsAlive() then return end

	if caster:GetHealthPercent() <= 1 and self.active == false and self.current_cooldown == 0 then

		self.active = true
		self.current_cooldown = self.trigger_cd

		self:SetStackCount(self.duration)

		local timer1 = Timers:CreateTimer(1, function()
			if self:GetStackCount() > 0 then
				self:DecrementStackCount()
			end

			return 1
		end)

		-- Particle --
		self.particle = ParticleManager:CreateParticle("particles/units/heroes/hero_omniknight/omniknight_guardian_angel_omni.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster)
		ParticleManager:SetParticleControl( self.particle, 0, caster:GetAbsOrigin() )
		ParticleManager:SetParticleControl( self.particle, 5, caster:GetAbsOrigin() )		

		Timers:CreateTimer(self.duration + 1, function()
			Timers:RemoveTimer(timer1)
			timer1 = nil

			-- Particle --
			ParticleManager:DestroyParticle( self.particle, false )
			ParticleManager:ReleaseParticleIndex( self.particle )
			self.particle = nil

			self.minHealthModifier:Destroy()

			self:SetStackCount( self.trigger_cd )

			local timer2 = Timers:CreateTimer(1, function()
				if self:GetStackCount() > 0 then
					self:DecrementStackCount()
					self.current_cooldown = self.current_cooldown - 1
				else
					if caster:IsAlive() then
						self.minHealthModifier = caster:AddNewModifier(caster, nil, "greater_cheat_death_buff1", {})
						self.current_cooldown = 0
						self.active = false
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

function greater_cheat_death:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE + MODIFIER_ATTRIBUTE_MULTIPLE
end

function greater_cheat_death:IsHidden()
    return false
end

function greater_cheat_death:IsPurgable()
	return false
end

function greater_cheat_death:IsPurgeException()
	return false
end

function greater_cheat_death:IsStunDebuff()
	return false
end

function greater_cheat_death:IsDebuff()
	return false
end

function greater_cheat_death:GetTexture()
	return "greater_cheat_death"
end

























































































































































































































































































