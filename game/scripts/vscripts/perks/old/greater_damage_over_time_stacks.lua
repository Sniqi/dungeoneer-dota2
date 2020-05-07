greater_damage_over_time_stacks = class({})

function greater_damage_over_time_stacks:OnCreated( data )
	-- ### VALUES START ### --
	self.stacks_max                    = 4
	self.all_attributes                = 16
	self.duration                      = 6
	self.stack_trigger_cd              = 0.2
	self.effectiveness_dealingdamage_offensive= -25.0
	-- ### VALUES END ### --
	
	if not IsServer() then return end
	self.perkname = data.perkName
	self.perkID = data.perkID
	self.level = data.level
	self.perkEffectiveness = data.perkEffectiveness

	Change_PerkEffectivenessStats(self, true)

	self.on_cd = false
	self.on_trigger_cd = false

	self.id = DoUniqueString("greater_damage_over_time_stacks")

	self:StartIntervalThink(1.00)
end

function greater_damage_over_time_stacks:OnRemoved()
	if not IsServer() then return end
	Change_PerkEffectivenessStats(self, false)
end


function greater_damage_over_time_stacks:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_TAKEDAMAGE
	}

	return funcs
end

function greater_damage_over_time_stacks:OnIntervalThink()
	if not IsServer() then return end

	self:SetStackCount( 10000 * self.perkEffectiveness )
end

function greater_damage_over_time_stacks:OnTakeDamage( params )
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

	if victim.greater_damage_over_time_stacks == nil then
		victim.greater_damage_over_time_stacks = {}
	end

	if victim.greater_damage_over_time_stacks[self.id] == nil then
		victim.greater_damage_over_time_stacks[self.id] = {}
		victim.greater_damage_over_time_stacks[self.id]["stacks"] = 0
	end

	if victim.greater_damage_over_time_stacks[self.id]["stacks"] < self.stacks_max then
		victim.greater_damage_over_time_stacks[self.id]["stacks"] = victim.greater_damage_over_time_stacks[self.id]["stacks"] + 1
	end

	if victim.greater_damage_over_time_stacks[self.id]["dot"] ~= nil then
		Timers:RemoveTimer( victim.greater_damage_over_time_stacks[self.id]["dot"] )
	end

	local dot = Timers:CreateTimer(1.0, function()
		if not IsValidEntity(victim) then return end
		if victim == nil then return end
		if victim:IsNull() then return end
		if not victim:IsAlive() then return end

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

		damage = damage * victim.greater_damage_over_time_stacks[self.id]["stacks"]
		damage = damage * ( self:GetStackCount() / 10000 )

		local damageTable = {
			victim = victim,
			attacker = caster,
			damage = damage,
			damage_type = DAMAGE_TYPE_PHYSICAL,
			damage_flags = DOTA_DAMAGE_FLAG_NO_DIRECTOR_EVENT,--DOTA_DAMAGE_FLAG_NONE,
		}

		ApplyDamage(damageTable)

		return 1.0
	end)

	victim.greater_damage_over_time_stacks[self.id]["dot"] = dot


	if victim.greater_damage_over_time_stacks[self.id]["duration"] ~= nil then
		Timers:RemoveTimer( victim.greater_damage_over_time_stacks[self.id]["duration"] )
	end

	local duration = Timers:CreateTimer(self.duration+0.1, function()
		if not IsValidEntity(victim) then return end
		if victim == nil then return end
		if victim:IsNull() then return end
		if not victim:IsAlive() then return end

		Timers:RemoveTimer( victim.greater_damage_over_time_stacks[self.id]["dot"] )
		victim.greater_damage_over_time_stacks[self.id]["stacks"] = 0
	end)

	victim.greater_damage_over_time_stacks[self.id]["duration"] = duration

	local info =
	{
		Target = victim,
		Source = caster,
		Ability = nil,
		EffectName = "particles/units/heroes/hero_venomancer/venomancer_plague_ward_projectile.vpcf",
		iMoveSpeed = 1500,
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

end

function greater_damage_over_time_stacks:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE + MODIFIER_ATTRIBUTE_MULTIPLE
end

function greater_damage_over_time_stacks:IsHidden()
    return true
end

function greater_damage_over_time_stacks:IsPurgable()
	return false
end

function greater_damage_over_time_stacks:IsPurgeException()
	return false
end

function greater_damage_over_time_stacks:IsStunDebuff()
	return false
end

function greater_damage_over_time_stacks:IsDebuff()
	return false
end










































































