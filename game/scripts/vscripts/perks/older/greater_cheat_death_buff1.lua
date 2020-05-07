greater_cheat_death_buff1 = class({})

function greater_cheat_death_buff1:OnCreated( data )
end

function greater_cheat_death_buff1:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MIN_HEALTH
	}

	return funcs
end

function greater_cheat_death_buff1:GetMinHealth( params )
	if self.deactivated then
		return 0
	else
		return 1
	end
end

function greater_cheat_death_buff1:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE + MODIFIER_ATTRIBUTE_MULTIPLE
end

function greater_cheat_death_buff1:IsHidden()
    return true
end

function greater_cheat_death_buff1:IsPurgable()
	return false
end

function greater_cheat_death_buff1:IsPurgeException()
	return false
end

function greater_cheat_death_buff1:IsStunDebuff()
	return false
end

function greater_cheat_death_buff1:IsDebuff()
	return false
end











