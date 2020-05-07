sinastra_dragon_swarm_modifier = class({})

function sinastra_dragon_swarm_modifier:OnCreated( kv )
	self.move_speed_percentage        = self:GetAbility():GetSpecialValueFor("move_speed_percentage")
end

function sinastra_dragon_swarm_modifier:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
	}

	return funcs
end


function sinastra_dragon_swarm_modifier:GetModifierMoveSpeedBonus_Percentage( params )
	return self.move_speed_percentage
end


function sinastra_dragon_swarm_modifier:GetAttributes()
	return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE
end

function sinastra_dragon_swarm_modifier:IsHidden()
    return false
end

function sinastra_dragon_swarm_modifier:IsPurgable()
	return false
end

function sinastra_dragon_swarm_modifier:IsPurgeException()
	return false
end

function sinastra_dragon_swarm_modifier:IsStunDebuff()
	return false
end

function sinastra_dragon_swarm_modifier:IsDebuff()
	return true
end