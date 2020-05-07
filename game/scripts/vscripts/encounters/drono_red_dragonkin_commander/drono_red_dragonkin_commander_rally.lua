drono_red_dragonkin_commander_rally = class({})

LinkLuaModifier( 'drono_red_dragonkin_commander_rally_modifier', 'encounters/drono_red_dragonkin_commander/drono_red_dragonkin_commander_rally_modifier', LUA_MODIFIER_MOTION_NONE )

function drono_red_dragonkin_commander_rally:OnSpellStart()

	--- Get Caster, Victim, Player, Point ---
	local caster		= self:GetCaster()
	local caster_loc	= caster:GetAbsOrigin()
	local playerID		= caster:GetPlayerOwnerID()
	local player		= PlayerResource:GetPlayer(playerID)
	local team			= caster:GetTeamNumber()
	local victim		= caster
	local victim_loc	= victim:GetAbsOrigin()
	
	--- Get Special Values ---
	local duration                    = self:GetSpecialValueFor("duration")
	local delay                       = self:GetSpecialValueFor("delay")

	if caster.red_dragon_army_units == nil then return end
	if caster.red_dragon_army_units[1] == nil then return end

	-- Sound --
	local sound = {"troll_warlord_troll_regen_01"}
	EmitAnnouncerSound( sound[RandomInt(1, #sound)] )

	local timer = Timers:CreateTimer(delay, function()

		for _,victim in pairs(caster.red_dragon_army_units) do

			if victim ~= nil then
			if not victim:IsNull() then
			if victim:IsAlive() then

				-- Sound --
				victim:EmitSound("DOTA_Item.FaerieSpark.Activate")

				-- Particle --
				local particle = ParticleManager:CreateParticle("particles/econ/events/fall_major_2016/blink_dagger_end_fm06_sparkles_outer.vpcf", PATTACH_ABSORIGIN_FOLLOW, victim)
				ParticleManager:SetParticleControl( particle, 0, victim:GetAbsOrigin() )
				ParticleManager:ReleaseParticleIndex( particle )
				particle = nil

				-- Modifier --
				victim:AddNewModifier(caster, self, "drono_red_dragonkin_commander_rally_modifier", {duration = duration})

				victim:Heal( victim:GetMaxHealth(), self )

			end
			end
			end

		end

	end)
	PersistentTimer_Add(timer)

end

function drono_red_dragonkin_commander_rally:OnAbilityPhaseStart()
	local caster			= self:GetCaster()
	local playerID			= caster:GetPlayerOwnerID()
	local player			= PlayerResource:GetPlayer(playerID)

	return true
end

function drono_red_dragonkin_commander_rally:GetManaCost(abilitylevel)
	return self.BaseClass.GetManaCost(self, abilitylevel)
end

function drono_red_dragonkin_commander_rally:GetCooldown(abilitylevel)
	return self.BaseClass.GetCooldown(self, abilitylevel)
end