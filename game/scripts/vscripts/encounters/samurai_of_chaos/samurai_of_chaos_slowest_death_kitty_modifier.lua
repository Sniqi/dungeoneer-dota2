samurai_of_chaos_slowest_death_kitty_modifier = class({})

function samurai_of_chaos_slowest_death_kitty_modifier:OnCreated( kv )
	self.move_speed_absolute          = self:GetAbility():GetSpecialValueFor("move_speed_absolute")
end

function samurai_of_chaos_slowest_death_kitty_modifier:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_ABSOLUTE,
	}

	return funcs
end


function samurai_of_chaos_slowest_death_kitty_modifier:GetModifierMoveSpeed_Absolute( params )
	return self.move_speed_absolute
end


function samurai_of_chaos_slowest_death_kitty_modifier:GetAttributes()
	return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE
end

function samurai_of_chaos_slowest_death_kitty_modifier:IsHidden()
    return false
end

function samurai_of_chaos_slowest_death_kitty_modifier:IsPurgable()
	return false
end

function samurai_of_chaos_slowest_death_kitty_modifier:IsPurgeException()
	return false
end

function samurai_of_chaos_slowest_death_kitty_modifier:IsStunDebuff()
	return false
end

function samurai_of_chaos_slowest_death_kitty_modifier:IsDebuff()
	return true
end