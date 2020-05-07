heroname_abilityname = class({})

LinkLuaModifier( 'heroname_abilityname_modifier', 'heroes/heroname/heroname_abilityname_modifier', LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( 'heroname_abilityname_modifier', 'heroes/heroname/talents/heroname_abilityname_modifier', LUA_MODIFIER_MOTION_NONE )

function heroname_abilityname:OnSpellStart()

	--- Get Caster, Victim, Player, Point ---
	local caster		= self:GetCaster()
	local caster_loc	= caster:GetAbsOrigin()
	local playerID		= caster:GetPlayerOwnerID()
	local player		= PlayerResource:GetPlayer(playerID)
	local team			= caster:GetTeamNumber()
	local point			= Vector(0,0,0)
	
	--- Get Special Values ---
	local duration			= self:GetSpecialValueFor("duration")
	local channel_time		= self:GetSpecialValueFor("channel_time")
	local damage			= self:GetSpecialValueFor("damage")
	local damage_instances	= self:GetSpecialValueFor("damage_instances")
	local damage_interval	= self:GetSpecialValueFor("damage_interval")
	local range				= self:GetSpecialValueFor("range")
	local aggro_multiplier	= self:GetSpecialValueFor("aggro_multiplier")
	local aoe				= self:GetSpecialValueFor("aoe")
	local special			= self:GetSpecialValueFor("special")
	local special			= self:GetSpecialValueFor("special")
	local special			= self:GetSpecialValueFor("special")
	
	local delay				= nil
	local interval			= damage_interval

	------------
	-- Caster --
	------------
	
	-- Animation --
	caster:StartGestureWithPlaybackRate(ACT_DOTA_CAST_ABILITY_1, 1.00)
	
	-- Modifier --
	caster:AddNewModifier(caster, self, "heroname_abilityname_modifier", {duration = 1.0})
	
	-- Sound --
	caster:EmitSound("")
	
	-- Particle --
	particle = ParticleManager:CreateParticle("", PATTACH_ABSORIGIN, caster)
	ParticleManager:SetParticleControl( particle, 0, caster_loc )
	ParticleManager:ReleaseParticleIndex( particle )

	-------------
	-- Victims --
	-------------
	
	-- DOTA_UNIT_TARGET_TEAM_FRIENDLY; DOTA_UNIT_TARGET_TEAM_ENEMY; DOTA_UNIT_TARGET_TEAM_BOTH
	local units	= FindUnitsInRadius(team, point, nil, aoe, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
	local particle = {}
	for _,victim in pairs(units) do
		-- Modifier --
		victim:AddNewModifier(caster, self, "heroname_abilityname_modifier", {duration = 1.0})
		
		-- Sound --
		victim:EmitSound("")
		
		-- Particle --
		particle[_] = ParticleManager:CreateParticle("", PATTACH_ABSORIGIN, victim)
		ParticleManager:SetParticleControl( particle[_], 0, victim:GetAbsOirign() )
		ParticleManager:ReleaseParticleIndex( particle[_] )
	end
	
	------------
	-- Damage --
	------------
	
	--- Apply Multiplier ---
	damage = damage * GameRules.PLAYER_HEROES_DMG_MULTIPLIER[playerID+1]
	--damage = damage * GameRules.PLAYER_HEROES_HEAL_MULTIPLIER[playerID+1]

	--- Apply Critical Hit ---
	damage = ApplyCriticalHit(self, damage, caster, playerID)

	--- Apply Damage Or Heal ---
	-- type: "damage" "heal"
	-- victim: Entity or Table
	-- damagetype: DAMAGE_TYPE_PHYSICAL DAMAGE_TYPE_MAGICAL DAMAGE_TYPE_PURE
	ApplyDamageOrHeal("damage", victim, caster, self, damage, DAMAGE_TYPE_MAGICAL, delay, interval, duration)
	
	--- Apply Aggro ---
	ApplyAggro(damage, aggro_multiplier, playerID, player)
end

function heroname_abilityname:OnAbilityPhaseStart()
	return true
end

function heroname_abilityname:heroname_abilityname(caster, playerID, interval)
	local talent = GameRules.PLAYER_HEROES_TALENT_UNIT[playerID+1]:FindAbilityByName("heroname_abilityname")
	local level = talent:GetLevel()

	local talent_interval = talent:GetSpecialValueFor("interval")

	if level > 0 then
		interval = interval * ( 1 + ( talent_interval / 100 ) )
	end

	return interval
end

function heroname_abilityname:GetCooldown(abilitylevel)
	local caster	= self:GetCaster()
	local player	= caster:GetPlayerOwnerID()
	--local cdr 		= 0
	--local stacks 	= caster:GetModifierStackCount("TALENT_modifier", caster)

	--if (stacks > 0) then
	--	cdr = 0.0 + (stacks * 0.25)
	--end

	return self.BaseClass.GetCooldown(self, abilitylevel)-- - cdr
end
