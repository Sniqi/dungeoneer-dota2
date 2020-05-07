artifact_fiery_eruption = class({})

function artifact_fiery_eruption:OnCreated( data )
	-- ### VALUES START ### --
	self.fireball_count                = 24
	self.duration                      = 0.8
	self.radius                        = 700
	self.all_attributes                = 12.50
	self.all_attributes_total          = 300
	self.cooldown                      = 12.0
	-- ### VALUES END ### --
	
	if not IsServer() then return end
	self.perkname = data.perkName
	self.perkID = data.perkID
	self.level = data.level
	self.perkEffectiveness = data.perkEffectiveness

	Change_PerkEffectivenessStats(self, true)

	self.count = 10

	self:StartIntervalThink(0.1)
end

function artifact_fiery_eruption:OnRemoved()
	if not IsServer() then return end
	Change_PerkEffectivenessStats(self, false)
end

function artifact_fiery_eruption:DeclareFunctions()
	local funcs = {
	}

	return funcs
end

function artifact_fiery_eruption:OnIntervalThink()
	if not IsServer() then return end

	self:SetStackCount( 10000 * self.perkEffectiveness )

	-- Dynamic value update
	local caster = self:GetParent()

	--Cast Range UI
	local castRangeUI = self.radius * ( self:GetStackCount() / 10000 )
	caster:SetModifierStackCount("castrange_modifier_ability", caster, castRangeUI)
	--Cooldown UI
	local cooldownUI = self.cooldown * ( self:GetStackCount() / 10000 )
	caster:SetModifierStackCount("cooldown_modifier_ability", caster, cooldownUI)

	if self.count == 10 then
		self.count = 0

		self.damage = ( caster:GetStrength() + caster:GetAgility() + caster:GetIntellect() ) * ( self.all_attributes / 100 )
		self.damage = self.damage * ( self:GetStackCount() / 10000 )
	end

	self.count = self.count + 1
	-- Dynamic value update

	if not self.activated then return end
	self.activated = false

	local caster = self:GetParent()
	local caster_loc = caster:GetAbsOrigin()
	local team = caster:GetTeamNumber()

	local fireball_count = self.fireball_count
	local health_trigger = self.health_trigger
	local duration = self.duration

	local radius = self.radius
	radius = radius * ( self:GetStackCount() / 10000 )

	local interval = duration / fireball_count

	local timer = Timers:CreateTimer(function()

		if not caster:IsAlive() then return end

		local units_enemy = FindUnitsInRadius(team, caster:GetAbsOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
		
		if #units_enemy > 0 then

			victim = units_enemy[RandomInt(1, #units_enemy)]

			-- Sound --
			victim:EmitSound("Hero_Phoenix.ProjectileImpact")

			-- Damage --
			local damageTable = {
				victim = victim,
				attacker = caster,
				damage = self.damage,
				damage_type = DAMAGE_TYPE_MAGICAL,
				damage_flags = DOTA_DAMAGE_FLAG_NONE,
				ability = self,
			}
			ApplyDamage(damageTable)

			local info = 
			{
				Target = victim,
				Source = caster,
				Ability = self,
				EffectName = "particles/units/heroes/hero_phoenix/phoenix_base_attack.vpcf",
				iMoveSpeed = 2500,
				vSourceLoc = caster:GetAbsOrigin() + (caster:GetForwardVector() + Vector(50,30,50) ),
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

		return interval
	end)

	Timers:CreateTimer(duration+(interval/2), function()
		Timers:RemoveTimer(timer)
		timer = nil
	end)

end

function artifact_fiery_eruption:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE + MODIFIER_ATTRIBUTE_MULTIPLE
end

function artifact_fiery_eruption:IsHidden()
    return true
end

function artifact_fiery_eruption:IsPurgable()
	return false
end

function artifact_fiery_eruption:IsPurgeException()
	return false
end

function artifact_fiery_eruption:IsStunDebuff()
	return false
end

function artifact_fiery_eruption:IsDebuff()
	return false
end





















































































































































