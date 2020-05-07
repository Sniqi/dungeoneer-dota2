the_dungeoneer_reshaped_ground_poison_modifier = class({})

function the_dungeoneer_reshaped_ground_poison_modifier:OnCreated( kv )
	self.poison_damage                = self:GetAbility():GetSpecialValueFor("poison_damage")
end

function the_dungeoneer_reshaped_ground_poison_modifier:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_TOOLTIP,
	}

	return funcs
end


function the_dungeoneer_reshaped_ground_poison_modifier:OnTooltip( params )
	return self.poison_damage
end


function the_dungeoneer_reshaped_ground_poison_modifier:GetAttributes()
	return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE
end

function the_dungeoneer_reshaped_ground_poison_modifier:IsHidden()
    return false
end

function the_dungeoneer_reshaped_ground_poison_modifier:IsPurgable()
	return false
end

function the_dungeoneer_reshaped_ground_poison_modifier:IsPurgeException()
	return false
end

function the_dungeoneer_reshaped_ground_poison_modifier:IsStunDebuff()
	return false
end

function the_dungeoneer_reshaped_ground_poison_modifier:IsDebuff()
	return true
end