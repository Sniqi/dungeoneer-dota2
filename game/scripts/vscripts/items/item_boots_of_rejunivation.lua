item_boots_of_rejunivation = class({})

LinkLuaModifier( 'item_boots_of_rejunivation_modifier', 'items/item_boots_of_rejunivation_modifier', LUA_MODIFIER_MOTION_NONE )

function item_boots_of_rejunivation:GetIntrinsicModifierName()
	return "item_boots_of_rejunivation_modifier"
end

function item_boots_of_rejunivation:OnSpellStart()

	--- Get Caster, Victim, Player, Point ---
	local caster		= self:GetCaster()
	local caster_loc	= caster:GetAbsOrigin()
	local playerID		= caster:GetPlayerOwnerID()
	local player		= PlayerResource:GetPlayer(playerID)
	local team			= caster:GetTeamNumber()
	
	--- Get Special Values ---
	local bonus_movement 			= self:GetSpecialValueFor("bonus_movement")
	local hp_replenish_percentage 	= self:GetSpecialValueFor("hp_replenish_percentage")
	local mana_replenish_percentage = self:GetSpecialValueFor("mana_replenish_percentage")
	local replenish_duration 		= self:GetSpecialValueFor("replenish_duration")
	local main_attribute 			= self:GetSpecialValueFor("main_attribute")
	local secondary_attributes 		= self:GetSpecialValueFor("secondary_attributes")
	local attributes_max 			= self:GetSpecialValueFor("attributes_max")

	local interval = 0.1
	local instances = replenish_duration / interval

	local hp_per_interval = ( caster:GetMaxHealth() * (hp_replenish_percentage / 100) ) / instances
	local mana_per_interval = ( caster:GetMaxMana() * (mana_replenish_percentage / 100) ) / instances

	-- Particle --
	local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_huskar/huskar_inner_vitality.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster)
	ParticleManager:SetParticleControl( particle, 0, caster_loc)

	-- Sound --
	StartSoundEventReliable("DOTA_Item.ClarityPotion.Activate", caster)
	StartSoundEventReliable("DOTA_Item.HealingSalve.Activate", caster)
	
	local timer1 = Timers:CreateTimer(function()

		if caster ~= nil then
		if not caster:IsNull() then
		if caster:IsAlive() then

			caster:Heal(hp_per_interval, self)
			caster:GiveMana(mana_per_interval)

		end
		end
		end

		return interval
	end)

	Timers:CreateTimer(replenish_duration - (interval/2), function()

		ParticleManager:DestroyParticle( particle, false )
		ParticleManager:ReleaseParticleIndex( particle )
		particle = nil

		Timers:RemoveTimer(timer1)
		timer1 = nil

	end)

end

function item_boots_of_rejunivation:GetManaCost(abilitylevel)
	return self.BaseClass.GetManaCost(self, abilitylevel)
end

function item_boots_of_rejunivation:GetCooldown(abilitylevel)
	return self.BaseClass.GetCooldown(self, abilitylevel)
end



item_boots_of_rejunivation_2 = class({})

function item_boots_of_rejunivation_2:GetIntrinsicModifierName()
	return "item_boots_of_rejunivation_modifier"
end

function item_boots_of_rejunivation_2:OnSpellStart()

	--- Get Caster, Victim, Player, Point ---
	local caster		= self:GetCaster()
	local caster_loc	= caster:GetAbsOrigin()
	local playerID		= caster:GetPlayerOwnerID()
	local player		= PlayerResource:GetPlayer(playerID)
	local team			= caster:GetTeamNumber()
	
	--- Get Special Values ---
	local bonus_movement 			= self:GetSpecialValueFor("bonus_movement")
	local hp_replenish_percentage 	= self:GetSpecialValueFor("hp_replenish_percentage")
	local mana_replenish_percentage = self:GetSpecialValueFor("mana_replenish_percentage")
	local replenish_duration 		= self:GetSpecialValueFor("replenish_duration")
	local main_attribute 			= self:GetSpecialValueFor("main_attribute")
	local secondary_attributes 		= self:GetSpecialValueFor("secondary_attributes")
	local attributes_max 			= self:GetSpecialValueFor("attributes_max")

	local interval = 0.1
	local instances = replenish_duration / interval

	local hp_per_interval = ( caster:GetMaxHealth() * (hp_replenish_percentage / 100) ) / instances
	local mana_per_interval = ( caster:GetMaxMana() * (mana_replenish_percentage / 100) ) / instances

	-- Particle --
	local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_huskar/huskar_inner_vitality.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster)
	ParticleManager:SetParticleControl( particle, 0, caster_loc)

	-- Sound --
	StartSoundEventReliable("DOTA_Item.ClarityPotion.Activate", caster)
	StartSoundEventReliable("DOTA_Item.HealingSalve.Activate", caster)
	
	local timer1 = Timers:CreateTimer(function()

		if caster ~= nil then
		if not caster:IsNull() then
		if caster:IsAlive() then

			caster:Heal(hp_per_interval, self)
			caster:GiveMana(mana_per_interval)

		end
		end
		end

		return interval
	end)

	Timers:CreateTimer(replenish_duration - (interval/2), function()

		ParticleManager:DestroyParticle( particle, false )
		ParticleManager:ReleaseParticleIndex( particle )
		particle = nil

		Timers:RemoveTimer(timer1)
		timer1 = nil

	end)

end

function item_boots_of_rejunivation_2:GetManaCost(abilitylevel)
	return self.BaseClass.GetManaCost(self, abilitylevel)
end

function item_boots_of_rejunivation_2:GetCooldown(abilitylevel)
	return self.BaseClass.GetCooldown(self, abilitylevel)
end



item_boots_of_rejunivation_3 = class({})

function item_boots_of_rejunivation_3:GetIntrinsicModifierName()
	return "item_boots_of_rejunivation_modifier"
end

function item_boots_of_rejunivation_3:OnSpellStart()

	--- Get Caster, Victim, Player, Point ---
	local caster		= self:GetCaster()
	local caster_loc	= caster:GetAbsOrigin()
	local playerID		= caster:GetPlayerOwnerID()
	local player		= PlayerResource:GetPlayer(playerID)
	local team			= caster:GetTeamNumber()
	
	--- Get Special Values ---
	local bonus_movement 			= self:GetSpecialValueFor("bonus_movement")
	local hp_replenish_percentage 	= self:GetSpecialValueFor("hp_replenish_percentage")
	local mana_replenish_percentage = self:GetSpecialValueFor("mana_replenish_percentage")
	local replenish_duration 		= self:GetSpecialValueFor("replenish_duration")
	local main_attribute 			= self:GetSpecialValueFor("main_attribute")
	local secondary_attributes 		= self:GetSpecialValueFor("secondary_attributes")
	local attributes_max 			= self:GetSpecialValueFor("attributes_max")

	local interval = 0.1
	local instances = replenish_duration / interval

	local hp_per_interval = ( caster:GetMaxHealth() * (hp_replenish_percentage / 100) ) / instances
	local mana_per_interval = ( caster:GetMaxMana() * (mana_replenish_percentage / 100) ) / instances

	-- Particle --
	local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_huskar/huskar_inner_vitality.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster)
	ParticleManager:SetParticleControl( particle, 0, caster_loc)

	-- Sound --
	StartSoundEventReliable("DOTA_Item.ClarityPotion.Activate", caster)
	StartSoundEventReliable("DOTA_Item.HealingSalve.Activate", caster)
	
	local timer1 = Timers:CreateTimer(function()

		if caster ~= nil then
		if not caster:IsNull() then
		if caster:IsAlive() then

			caster:Heal(hp_per_interval, self)
			caster:GiveMana(mana_per_interval)

		end
		end
		end

		return interval
	end)

	Timers:CreateTimer(replenish_duration - (interval/2), function()

		ParticleManager:DestroyParticle( particle, false )
		ParticleManager:ReleaseParticleIndex( particle )
		particle = nil

		Timers:RemoveTimer(timer1)
		timer1 = nil

	end)

end

function item_boots_of_rejunivation_3:GetManaCost(abilitylevel)
	return self.BaseClass.GetManaCost(self, abilitylevel)
end

function item_boots_of_rejunivation_3:GetCooldown(abilitylevel)
	return self.BaseClass.GetCooldown(self, abilitylevel)
end


item_boots_of_rejunivation_4 = class({})

function item_boots_of_rejunivation_4:GetIntrinsicModifierName()
	return "item_boots_of_rejunivation_modifier"
end

function item_boots_of_rejunivation_4:OnSpellStart()

	--- Get Caster, Victim, Player, Point ---
	local caster		= self:GetCaster()
	local caster_loc	= caster:GetAbsOrigin()
	local playerID		= caster:GetPlayerOwnerID()
	local player		= PlayerResource:GetPlayer(playerID)
	local team			= caster:GetTeamNumber()
	
	--- Get Special Values ---
	local bonus_movement 			= self:GetSpecialValueFor("bonus_movement")
	local hp_replenish_percentage 	= self:GetSpecialValueFor("hp_replenish_percentage")
	local mana_replenish_percentage = self:GetSpecialValueFor("mana_replenish_percentage")
	local replenish_duration 		= self:GetSpecialValueFor("replenish_duration")
	local main_attribute 			= self:GetSpecialValueFor("main_attribute")
	local secondary_attributes 		= self:GetSpecialValueFor("secondary_attributes")
	local attributes_max 			= self:GetSpecialValueFor("attributes_max")

	local interval = 0.1
	local instances = replenish_duration / interval

	local hp_per_interval = ( caster:GetMaxHealth() * (hp_replenish_percentage / 100) ) / instances
	local mana_per_interval = ( caster:GetMaxMana() * (mana_replenish_percentage / 100) ) / instances

	-- Particle --
	local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_huskar/huskar_inner_vitality.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster)
	ParticleManager:SetParticleControl( particle, 0, caster_loc)

	-- Sound --
	StartSoundEventReliable("DOTA_Item.ClarityPotion.Activate", caster)
	StartSoundEventReliable("DOTA_Item.HealingSalve.Activate", caster)
	
	local timer1 = Timers:CreateTimer(function()

		if caster ~= nil then
		if not caster:IsNull() then
		if caster:IsAlive() then

			caster:Heal(hp_per_interval, self)
			caster:GiveMana(mana_per_interval)

		end
		end
		end

		return interval
	end)

	Timers:CreateTimer(replenish_duration - (interval/2), function()

		ParticleManager:DestroyParticle( particle, false )
		ParticleManager:ReleaseParticleIndex( particle )
		particle = nil

		Timers:RemoveTimer(timer1)
		timer1 = nil

	end)

end

function item_boots_of_rejunivation_4:GetManaCost(abilitylevel)
	return self.BaseClass.GetManaCost(self, abilitylevel)
end

function item_boots_of_rejunivation_4:GetCooldown(abilitylevel)
	return self.BaseClass.GetCooldown(self, abilitylevel)
end


item_boots_of_rejunivation_5 = class({})

function item_boots_of_rejunivation_5:GetIntrinsicModifierName()
	return "item_boots_of_rejunivation_modifier"
end

function item_boots_of_rejunivation_5:OnSpellStart()

	--- Get Caster, Victim, Player, Point ---
	local caster		= self:GetCaster()
	local caster_loc	= caster:GetAbsOrigin()
	local playerID		= caster:GetPlayerOwnerID()
	local player		= PlayerResource:GetPlayer(playerID)
	local team			= caster:GetTeamNumber()
	
	--- Get Special Values ---
	local bonus_movement 			= self:GetSpecialValueFor("bonus_movement")
	local hp_replenish_percentage 	= self:GetSpecialValueFor("hp_replenish_percentage")
	local mana_replenish_percentage = self:GetSpecialValueFor("mana_replenish_percentage")
	local replenish_duration 		= self:GetSpecialValueFor("replenish_duration")
	local main_attribute 			= self:GetSpecialValueFor("main_attribute")
	local secondary_attributes 		= self:GetSpecialValueFor("secondary_attributes")
	local attributes_max 			= self:GetSpecialValueFor("attributes_max")

	local interval = 0.1
	local instances = replenish_duration / interval

	local hp_per_interval = ( caster:GetMaxHealth() * (hp_replenish_percentage / 100) ) / instances
	local mana_per_interval = ( caster:GetMaxMana() * (mana_replenish_percentage / 100) ) / instances

	-- Particle --
	local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_huskar/huskar_inner_vitality.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster)
	ParticleManager:SetParticleControl( particle, 0, caster_loc)

	-- Sound --
	StartSoundEventReliable("DOTA_Item.ClarityPotion.Activate", caster)
	StartSoundEventReliable("DOTA_Item.HealingSalve.Activate", caster)
	
	local timer1 = Timers:CreateTimer(function()

		if caster ~= nil then
		if not caster:IsNull() then
		if caster:IsAlive() then

			caster:Heal(hp_per_interval, self)
			caster:GiveMana(mana_per_interval)

		end
		end
		end

		return interval
	end)

	Timers:CreateTimer(replenish_duration - (interval/2), function()

		ParticleManager:DestroyParticle( particle, false )
		ParticleManager:ReleaseParticleIndex( particle )
		particle = nil

		Timers:RemoveTimer(timer1)
		timer1 = nil

	end)

end

function item_boots_of_rejunivation_5:GetManaCost(abilitylevel)
	return self.BaseClass.GetManaCost(self, abilitylevel)
end

function item_boots_of_rejunivation_5:GetCooldown(abilitylevel)
	return self.BaseClass.GetCooldown(self, abilitylevel)
end

