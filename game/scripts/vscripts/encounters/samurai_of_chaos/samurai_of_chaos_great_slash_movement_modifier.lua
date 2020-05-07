samurai_of_chaos_great_slash_movement_modifier = class({})

function samurai_of_chaos_great_slash_movement_modifier:OnCreated( kv )
	self.move_speed_absolute          = self:GetAbility():GetSpecialValueFor("move_speed_absolute")
end

function samurai_of_chaos_great_slash_movement_modifier:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_ABSOLUTE,
	}

	return funcs
end


function samurai_of_chaos_great_slash_movement_modifier:GetModifierMoveSpeed_Absolute( params )
	return self.move_speed_absolute
end


function samurai_of_chaos_great_slash_movement_modifier:GetAttributes()
	return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE
end

function samurai_of_chaos_great_slash_movement_modifier:OnDestroy()
	
end

function samurai_of_chaos_great_slash_movement_modifier:IsHidden()
    return false
end

function samurai_of_chaos_great_slash_movement_modifier:IsPurgable()
	return false
end

function samurai_of_chaos_great_slash_movement_modifier:IsPurgeException()
	return false
end

function samurai_of_chaos_great_slash_movement_modifier:IsStunDebuff()
	return false
end

function samurai_of_chaos_great_slash_movement_modifier:IsDebuff()
	return true
end