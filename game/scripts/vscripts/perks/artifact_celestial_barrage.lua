artifact_celestial_barrage = class({})

function artifact_celestial_barrage:OnCreated( data )
	-- ### VALUES START ### --
	self.orb_count                     = 80
	self.health_trigger                = 75
	self.all_attributes_heal           = 9
	self.all_attributes_damage         = 9
	self.all_attributes_damage_total   = 720
	self.duration                      = 20.0
	self.radius                        = 700
	self.cooldown                      = 50.0
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

function artifact_celestial_barrage:OnRemoved()
	if not IsServer() then return end
	Change_PerkEffectivenessStats(self, false)
end

function artifact_celestial_barrage:DeclareFunctions()
	local funcs = {
	}

	return funcs
end

function artifact_celestial_barrage:OnIntervalThink()
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

		self.heal = ( caster:GetStrength() + caster:GetAgility() + caster:GetIntellect() ) * ( self.all_attributes_heal / 100 )
		self.heal = self.heal * ( self:GetStackCount() / 10000 )

		self.damage = ( caster:GetStrength() + caster:GetAgility() + caster:GetIntellect() ) * ( self.all_attributes_damage / 100 )
		self.damage = self.damage * ( self:GetStackCount() / 10000 )
	end

	self.count = self.count + 1
	-- Dynamic value update

	if not self.activated then return end
	self.activated = false

	local caster = self:GetParent()
	local caster_loc = caster:GetAbsOrigin()
	local team = caster:GetTeamNumber()
	local victim = caster

	local orb_count = self.orb_count
	local health_trigger = self.health_trigger

	local duration = self.duration

	local radius = self.radius * ( self:GetStackCount() / 10000 )

	local interval = duration / orb_count

	local timer = Timers:CreateTimer(function()

		if not caster:IsAlive() then return end

		-- DOTA_UNIT_TARGET_TEAM_FRIENDLY; DOTA_UNIT_TARGET_TEAM_ENEMY; DOTA_UNIT_TARGET_TEAM_BOTH
		local units_friend_potential = FindUnitsInRadius(team, caster:GetAbsOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
		local units_friend = {}
		if units_friend_potential ~= nil then
			for _,friend in pairs(units_friend_potential) do
				if friend:GetHealthPercent() <= health_trigger then
					table.insert(units_friend, friend)
				end
			end
		end

		local unit_friend = nil
		if #units_friend >= 1 then
			unit_friend = units_friend[RandomInt(1, #units_friend)]
		end

		local units_enemy = nil
		if unit_friend == nil then
			units_enemy = FindUnitsInRadius(team, caster:GetAbsOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
			victim = units_enemy[RandomInt(1, #units_enemy)]
		else
			victim = unit_friend
		end
		
		if victim == nil then victim = caster end

		-- Sound --
		victim:EmitSound("Hero_Oracle.ProjectileImpact")

		if victim:GetTeamNumber() == team then
			-- Heal --
			victim:Heal(self.heal, self)
		else
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
		end

		local info = 
		{
			Target = victim,
			Source = caster,
			Ability = self,
			EffectName = "particles/units/heroes/hero_oracle/oracle_base_attack.vpcf",
			iMoveSpeed = 1400,
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

		-- Sound --
		caster:EmitSound("Hero_SkywrathMage.PreAttack")

		return interval
	end)

	Timers:CreateTimer(duration+(interval/2), function()
		Timers:RemoveTimer(timer)
		timer = nil
	end)

end

--[[
function artifact_celestial_barrage:OnProjectileHit( hTarget, vLocation )
	--- Get Caster, Victim, Player, Point ---
	local caster		= self:GetCaster()
	local playerID		= caster:GetPlayerOwnerID()
	local player		= PlayerResource:GetPlayer(playerID)
	local team			= caster:GetTeamNumber()
	local victim		= hTarget
	
	-- Sound --
	victim:EmitSound("Hero_Oracle.ProjectileImpact")

	if victim:GetTeamNumber() == team then
		-- Heal --
		victim:Heal(self.heal, self)
	else
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
	end

	return true
end
]]

function artifact_celestial_barrage:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE + MODIFIER_ATTRIBUTE_MULTIPLE
end

function artifact_celestial_barrage:IsHidden()
    return true
end

function artifact_celestial_barrage:IsPurgable()
	return false
end

function artifact_celestial_barrage:IsPurgeException()
	return false
end

function artifact_celestial_barrage:IsStunDebuff()
	return false
end

function artifact_celestial_barrage:IsDebuff()
	return false
end





















































































































































