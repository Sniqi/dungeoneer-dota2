drono_red_dragonkin_commander_red_dragon_army_modifier = class({})

function drono_red_dragonkin_commander_red_dragon_army_modifier:OnDestroy( kv )
	if not IsServer() then return end
	self.killed_dragonkin_damage_to_drono_percentage = self:GetAbility():GetSpecialValueFor("killed_dragonkin_damage_to_drono_percentage")

	local unit = self:GetParent()
	local caster = self:GetCaster()

	--local damage = self.killed_dragonkin_damage_to_drono_percentage / GetPlayerCount()

	-- Apply Damage --
	--EncounterApplyDamage(caster, unit, self:GetAbility(), damage, DAMAGE_TYPE_PURE, DOTA_DAMAGE_FLAG_NONE)

	local new_health = caster:GetHealthPercent() - self.killed_dragonkin_damage_to_drono_percentage
	new_health = caster:GetMaxHealth() * ( new_health / 100 )

	if new_health <= 0 then
		caster:Kill(self:GetAbility(), caster)
	else
		caster:SetHealth( new_health )
	end
	
end

function drono_red_dragonkin_commander_red_dragon_army_modifier:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_TOOLTIP,
	}

	return funcs
end

function drono_red_dragonkin_commander_red_dragon_army_modifier:OnTooltip( params )
	return self.killed_dragonkin_damage_to_drono_percentage
end

function drono_red_dragonkin_commander_red_dragon_army_modifier:GetAttributes()
	return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE
end

function drono_red_dragonkin_commander_red_dragon_army_modifier:IsHidden()
    return false
end

function drono_red_dragonkin_commander_red_dragon_army_modifier:IsPurgable()
	return false
end

function drono_red_dragonkin_commander_red_dragon_army_modifier:IsPurgeException()
	return false
end

function drono_red_dragonkin_commander_red_dragon_army_modifier:IsStunDebuff()
	return false
end

function drono_red_dragonkin_commander_red_dragon_army_modifier:IsDebuff()
	return true
end