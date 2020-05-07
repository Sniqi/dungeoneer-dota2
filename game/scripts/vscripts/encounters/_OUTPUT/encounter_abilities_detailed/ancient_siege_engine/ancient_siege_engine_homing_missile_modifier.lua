ancient_siege_engine_homing_missile_modifier = class({})

function ancient_siege_engine_homing_missile_modifier:OnCreated( kv )
	self.missile_speed_start          = self:GetAbility():GetSpecialValueFor("missile_speed_start")
	self.missile_speed_end            = self:GetAbility():GetSpecialValueFor("missile_speed_end")
end

function ancient_siege_engine_homing_missile_modifier:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_TOOLTIP,
		MODIFIER_PROPERTY_TOOLTIP,
	}

	return funcs
end


function ancient_siege_engine_homing_missile_modifier:OnTooltip( params )
	return self.missile_speed_start
end

function ancient_siege_engine_homing_missile_modifier:OnTooltip( params )
	return self.missile_speed_end
end


function ancient_siege_engine_homing_missile_modifier:GetAttributes()
	return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE
end

function ancient_siege_engine_homing_missile_modifier:IsHidden()
    return false
end

function ancient_siege_engine_homing_missile_modifier:IsPurgable()
	return false
end

function ancient_siege_engine_homing_missile_modifier:IsPurgeException()
	return false
end

function ancient_siege_engine_homing_missile_modifier:IsStunDebuff()
	return false
end

function ancient_siege_engine_homing_missile_modifier:IsDebuff()
	return true
end