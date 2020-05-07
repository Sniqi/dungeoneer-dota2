lesser_damage_increases_with_stacks = class({})

function lesser_damage_increases_with_stacks:OnCreated( data )
	-- ### VALUES START ### --
	self.all_attributes                = 10
	self.bonus                         = 20
	self.stacks_max                    = 5
	self.stack_trigger_cd              = 0.5
	self.effectiveness_dealingdamage_offensive= -25.0
	-- ### VALUES END ### --
	
	if not IsServer() then return end
	self.perkname = data.perkName
	self.perkID = data.perkID
	self.level = data.level
	self.perkEffectiveness = data.perkEffectiveness

	Change_PerkEffectivenessStats(self, true)

	self.stacks = 0

	self.on_cd = false
	self.on_trigger_cd = false

	self.id = DoUniqueString("lesser_damage_increases_with_stacks")
end

function lesser_damage_increases_with_stacks:OnRemoved()
	if not IsServer() then return end
	Change_PerkEffectivenessStats(self, false)
end

function lesser_damage_increases_with_stacks:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_TAKEDAMAGE
	}

	return funcs
end

function lesser_damage_increases_with_stacks:OnTakeDamage( params )
	if not IsServer() then return end
	if self.on_cd then return end
	if self.on_trigger_cd then return end
	if self:GetParent() ~= params.attacker then return end
	if self:GetParent() == params.unit then return end
	if params.damage <= 0 then return end
	if params.damage_flags == DOTA_DAMAGE_FLAG_NO_DIRECTOR_EVENT then return end

	--Trigger CD
	self.on_trigger_cd = true
	Timers:CreateTimer(self.stack_trigger_cd, function()
		self.on_trigger_cd = false
	end)

	local caster = self:GetParent()
	local victim = params.unit

	PerkAppearance_Inactive(self:GetParent():GetPlayerOwnerID(), self.perkname, self.perkID, self.stacks)
	--PerkAppearance_Active(self:GetParent():GetPlayerOwnerID(), self.perkname, self.perkID, "#d14500", self:GetStackCount())

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

	damage = damage * ( 1 + ( self.stacks * ( self.bonus / 100 ) ) )
	damage = damage * ( self:GetStackCount() / 10000 )

	local damageTable = {
		victim = victim,
		attacker = caster,
		damage = damage,
		damage_type = DAMAGE_TYPE_PHYSICAL,
		damage_flags = DOTA_DAMAGE_FLAG_NO_DIRECTOR_EVENT,
	}

	-- Create Particle --
	local particle = ParticleManager:CreateParticle("particles/perks/lesser_damage_increases_with_stacks.vpcf", PATTACH_POINT_FOLLOW, caster)
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

	if self.stacks == self.stacks_max then
		self.stacks = 0
	end

	self.stacks = self.stacks + 1

	self:SetStackCount( self.stacks * 10000 * self.perkEffectiveness )

	--CD
	--[[
	self.on_cd = true
	Timers:CreateTimer(self.cooldown, function()
		self.on_cd = false
	end)
	]]

end

function lesser_damage_increases_with_stacks:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE + MODIFIER_ATTRIBUTE_MULTIPLE
end

function lesser_damage_increases_with_stacks:IsHidden()
    return true
end

function lesser_damage_increases_with_stacks:IsPurgable()
	return false
end

function lesser_damage_increases_with_stacks:IsPurgeException()
	return false
end

function lesser_damage_increases_with_stacks:IsStunDebuff()
	return false
end

function lesser_damage_increases_with_stacks:IsDebuff()
	return false
end











































































