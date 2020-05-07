the_dungeoneer_death_and_decay_modifier = class({})

function the_dungeoneer_death_and_decay_modifier:OnCreated( kv )
	self.move_speed_absolute          = self:GetAbility():GetSpecialValueFor("move_speed_absolute")
end

function the_dungeoneer_death_and_decay_modifier:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_ABSOLUTE,
	}

	return funcs
end


function the_dungeoneer_death_and_decay_modifier:GetModifierMoveSpeed_Absolute( params )
	return self.move_speed_absolute
end


function the_dungeoneer_death_and_decay_modifier:GetAttributes()
	return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE
end

function the_dungeoneer_death_and_decay_modifier:IsHidden()
    return false
end

function the_dungeoneer_death_and_decay_modifier:IsPurgable()
	return false
end

function the_dungeoneer_death_and_decay_modifier:IsPurgeException()
	return false
end

function the_dungeoneer_death_and_decay_modifier:IsStunDebuff()
	return false
end

function the_dungeoneer_death_and_decay_modifier:IsDebuff()
	return true
end