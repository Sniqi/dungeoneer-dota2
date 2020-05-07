greater_damage_at_max_stacks = class({})

function greater_damage_at_max_stacks:OnCreated( data )
	-- ### VALUES START ### --
	self.stack_trigger                 = 4
	self.all_attributes                = 150
	self.stack_trigger_cd              = 0.4
	self.effectiveness_dealingdamage_offensive= -25
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
end

function greater_damage_at_max_stacks:OnRemoved()
	if not IsServer() then return end
	Change_PerkEffectivenessStats(self, false)
end

function greater_damage_at_max_stacks:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_TAKEDAMAGE
	}

	return funcs
end

function greater_damage_at_max_stacks:OnTakeDamage( params )
	if not IsServer() then return end
	if self.on_cd then return end
	if self.on_trigger_cd then return end
	if self:GetParent() ~= params.attacker then return end
	if self:GetParent() == params.unit then return end
	if params.damage <= 0 then return end
	if params.damage_flags == DOTA_DAMAGE_FLAG_NO_DIRECTOR_EVENT then return end

	local caster = self:GetParent()
	local victim = params.unit

	self.stacks = self.stacks + 1

	PerkAppearance_Inactive(self:GetParent():GetPlayerOwnerID(), self.perkname, self.perkID, self.stacks)

	if self.stacks < self.stack_trigger then

		--Trigger CD
		self.on_trigger_cd = true
		Timers:CreateTimer(self.stack_trigger_cd, function()
			self.on_trigger_cd = false
		end)

	else --Active

		self:SetStackCount( 10000 * self.perkEffectiveness )

		self.stacks = 0

		PerkAppearance_Active(self:GetParent():GetPlayerOwnerID(), self.perkname, self.perkID, "#d14500", "!")

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

		Timers:CreateTimer(0.25, function()
			if not IsValidEntity(victim) then return end
			if victim == nil then return end
			if victim:IsNull() then return end
			if not victim:IsAlive() then return end

			ApplyDamage(damageTable)
		end)

		local info =
		{
			Target = victim,
			Source = caster,
			Ability = nil,
			EffectName = "particles/units/heroes/hero_phoenix/phoenix_base_attack.vpcf",
			iMoveSpeed = 2000,
			vSourceLoc = caster:GetAbsOrigin() + Vector(0,0,50),
			bDrawsOnMinimap = false,                          -- Optional
			bDodgeable = false,                               -- Optional
			bIsAttack = false,                                 -- Optional
			bVisibleToEnemies = true,                         -- Optional
			bReplaceExisting = false,                         -- Optional
			flExpireTime = GameRules:GetGameTime() + 10,      -- Optional but recommended
			bProvidesVision = false,                          -- Optional
			--iVisionRadius = 0,                                -- Optional
			--iVisionTeamNumber = caster:GetTeamNumber()        -- Optional
		}

		ProjectileManager:CreateTrackingProjectile(info)

		--CD
		--[[
		self.on_cd = true
		Timers:CreateTimer(self.cooldown, function()
			self.on_cd = false
		end)
		]]

	end
end

function greater_damage_at_max_stacks:OnProjectileHit( hTarget, vLocation )

end

function greater_damage_at_max_stacks:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE + MODIFIER_ATTRIBUTE_MULTIPLE
end

function greater_damage_at_max_stacks:IsHidden()
    return true
end

function greater_damage_at_max_stacks:IsPurgable()
	return false
end

function greater_damage_at_max_stacks:IsPurgeException()
	return false
end

function greater_damage_at_max_stacks:IsStunDebuff()
	return false
end

function greater_damage_at_max_stacks:IsDebuff()
	return false
end


















