%AbilityClass% = class({})%LinkLuaModifier%

function %AbilityClass%:OnSpellStart()

	--- Get Caster, Victim, Player, Point ---
	local caster		= self:GetCaster()
	local caster_loc	= caster:GetAbsOrigin()
	local playerID		= caster:GetPlayerOwnerID()
	local player		= PlayerResource:GetPlayer(playerID)
	local team			= caster:GetTeamNumber()%Target%%Point%
	
	--- Get Special Values ---%SpecialValues%

	-- Sound --
	caster:EmitSound("")%EndAnimation%
	
	-------------
	-- Victims --
	-------------
	
	%GetVictims%%Foreach%%Modifier%
	%VictimSound%%Particles%%ApplyDamage%%ApplyHeal%%ForeachEnd%
	
end

function %AbilityClass%:OnAbilityPhaseStart()
	local caster			= self:GetCaster()
	local playerID			= caster:GetPlayerOwnerID()
	local player			= PlayerResource:GetPlayer(playerID)%CheckDistanceToTarget%

	return true
end

function %AbilityClass%:GetManaCost(abilitylevel)
	return self.BaseClass.GetManaCost(self, abilitylevel)
end

function %AbilityClass%:GetCooldown(abilitylevel)
	return self.BaseClass.GetCooldown(self, abilitylevel)
end%GetAOERadius%