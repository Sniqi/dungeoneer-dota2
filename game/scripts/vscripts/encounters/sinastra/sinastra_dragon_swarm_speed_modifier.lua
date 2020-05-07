sinastra_dragon_swarm_speed_modifier = class({})

function sinastra_dragon_swarm_speed_modifier:OnCreated( kv )
end

function sinastra_dragon_swarm_speed_modifier:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_ABSOLUTE,
	}

	return funcs
end

function sinastra_dragon_swarm_speed_modifier:GetModifierMoveSpeed_Absolute( params )
	return 1000
end

function sinastra_dragon_swarm_speed_modifier:GetAttributes()
	return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE
end

function sinastra_dragon_swarm_speed_modifier:IsHidden()
    return false
end

function sinastra_dragon_swarm_speed_modifier:IsPurgable()
	return false
end

function sinastra_dragon_swarm_speed_modifier:IsPurgeException()
	return false
end

function sinastra_dragon_swarm_speed_modifier:IsStunDebuff()
	return false
end

function sinastra_dragon_swarm_speed_modifier:IsDebuff()
	return false
end