greater_damage_at_specific_damage_amount = class({})

function greater_damage_at_specific_damage_amount:OnCreated( data )
	-- ### VALUES START ### --
	self.boss_hp                       = 4
	self.all_attributes                = 200
	self.effectiveness_dealingdamage_offensive= -25.0
	-- ### VALUES END ### --
	
	if not IsServer() then return end
	self.perkname = data.perkName
	self.perkID = data.perkID
	self.level = data.level
	self.perkEffectiveness = data.perkEffectiveness

	Change_PerkEffectivenessStats(self, true)

	self.damage_done = 0

	self:StartIntervalThink(0.06)
end

function greater_damage_at_specific_damage_amount:OnRemoved()
	if not IsServer() then return end
	Change_PerkEffectivenessStats(self, false)
end

function greater_damage_at_specific_damage_amount:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_TAKEDAMAGE
	}

	return funcs
end

function greater_damage_at_specific_damage_amount:OnTakeDamage( params )
	if not IsServer() then return end
	if self.on_cd then return end
	if self.on_trigger_cd then return end
	if self:GetParent() ~= params.attacker then return end
	if self:GetParent() == params.unit then return end
	if params.damage <= 0 then return end
	if params.damage_flags == DOTA_DAMAGE_FLAG_NO_DIRECTOR_EVENT then return end

	local boss = GetCurrentEncounterEntity()

	if not IsValidEntity(boss) then return end
	if boss == nil then return end
	if boss:IsNull() then return end
	if not boss:IsAlive() then return end

	local caster = self:GetParent()
	local victim = params.unit

	local damage_trigger = math.floor( boss:GetMaxHealth() * ( self.boss_hp / 100 ) )

	self.damage_done = self.damage_done + params.damage

	local txt = math.floor( ( self.damage_done / damage_trigger ) * 100 )
	PerkAppearance_Inactive(self:GetParent():GetPlayerOwnerID(), self.perkname, self.perkID, txt.."%")

	while self.damage_done >= damage_trigger do

		self:SetStackCount( 10000 * self.perkEffectiveness )

		self.damage_done = self.damage_done - damage_trigger

		local txt = math.floor( ( self.damage_done / damage_trigger ) * 100 )
		PerkAppearance_Inactive(self:GetParent():GetPlayerOwnerID(), self.perkname, self.perkID, txt.."%")

		local damage = 0
		--[[
		if caster:GetPrimaryAttribute() == 0 then
			damage = caster:GetStrength() * ( self.main_attribute / 100 )
		elseif caster:GetPrimaryAttribute() == 1 then
			damage = caster:GetAgility() * ( self.main_attribute / 100 )
		elseif caster:GetPrimaryAttribute() == 2 then
			damage = caster:GetIntellect() * ( self.main_attribute / 100 )
		end
		]]
		damage = ( caster:GetStrength() + caster:GetAgility() + caster:GetIntellect() ) * ( self.all_attributes / 100 )
		damage = damage * ( self:GetStackCount() / 10000 )

		local damageTable = {
			victim = victim,
			attacker = caster,
			damage = damage,
			damage_type = DAMAGE_TYPE_MAGICAL,
			damage_flags = DOTA_DAMAGE_FLAG_NO_DIRECTOR_EVENT,--DOTA_DAMAGE_FLAG_NONE,
		}

		-- Create Particle --
		local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_zuus/zuus_arc_lightning.vpcf", PATTACH_POINT_FOLLOW, caster)
		ParticleManager:SetParticleControlEnt( particle, 0, caster, PATTACH_POINT_FOLLOW, "attach_hitloc", caster:GetAttachmentOrigin(caster:ScriptLookupAttachment("attach_attack1")), true)
		ParticleManager:SetParticleControlEnt( particle, 1, victim, PATTACH_POINT_FOLLOW, "attach_hitloc", victim:GetAttachmentOrigin(victim:ScriptLookupAttachment("attach_hitloc")), true)

		Timers:CreateTimer(0.25, function()

			if particle ~= nil then
				ParticleManager:DestroyParticle( particle, false )
				ParticleManager:ReleaseParticleIndex( particle )
				particle = nil
			end
			
			if not IsValidEntity(victim) then return end
			if victim == nil then return end
			if victim:IsNull() then return end
			if not victim:IsAlive() then return end

			ApplyDamage(damageTable)
		end)

		--CD
		self.on_cd = true
		Timers:CreateTimer(0.50, function()
			self.on_cd = false
		end)

	end

end


function greater_damage_at_specific_damage_amount:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE + MODIFIER_ATTRIBUTE_MULTIPLE
end

function greater_damage_at_specific_damage_amount:IsHidden()
    return true
end

function greater_damage_at_specific_damage_amount:IsPurgable()
	return false
end

function greater_damage_at_specific_damage_amount:IsPurgeException()
	return false
end

function greater_damage_at_specific_damage_amount:IsStunDebuff()
	return false
end

function greater_damage_at_specific_damage_amount:IsDebuff()
	return false
end










































































