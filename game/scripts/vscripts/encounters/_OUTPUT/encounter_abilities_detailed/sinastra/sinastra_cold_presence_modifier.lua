sinastra_cold_presence_modifier = class({})

function sinastra_cold_presence_modifier:OnCreated( kv )
	self.move_speed_percentage        = self:GetAbility():GetSpecialValueFor("move_speed_percentage")
	self.no_movement_duration         = self:GetAbility():GetSpecialValueFor("no_movement_duration")
end

function sinastra_cold_presence_modifier:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_PROPERTY_TOOLTIP,
	}

	return funcs
end


function sinastra_cold_presence_modifier:GetModifierMoveSpeedBonus_Percentage( params )
	return self.move_speed_percentage
end

function sinastra_cold_presence_modifier:OnTooltip( params )
	return self.no_movement_duration
end


function sinastra_cold_presence_modifier:GetAttributes()
	return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE
end

function sinastra_cold_presence_modifier:IsHidden()
    return false
end

function sinastra_cold_presence_modifier:IsPurgable()
	return false
end

function sinastra_cold_presence_modifier:IsPurgeException()
	return false
end

function sinastra_cold_presence_modifier:IsStunDebuff()
	return false
end

function sinastra_cold_presence_modifier:IsDebuff()
	return true
end