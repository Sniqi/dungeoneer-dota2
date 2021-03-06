bhamuka_all_consuming_god_tentacle_sweep_modifier = class({})

function bhamuka_all_consuming_god_tentacle_sweep_modifier:OnCreated( kv )
	self.damage                       = self:GetAbility():GetSpecialValueFor("damage")
end

function bhamuka_all_consuming_god_tentacle_sweep_modifier:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_TOOLTIP,
	}

	return funcs
end


function bhamuka_all_consuming_god_tentacle_sweep_modifier:OnTooltip( params )
	return self.damage
end


function bhamuka_all_consuming_god_tentacle_sweep_modifier:GetAttributes()
	return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE
end

function bhamuka_all_consuming_god_tentacle_sweep_modifier:IsHidden()
    return false
end

function bhamuka_all_consuming_god_tentacle_sweep_modifier:IsPurgable()
	return false
end

function bhamuka_all_consuming_god_tentacle_sweep_modifier:IsPurgeException()
	return false
end

function bhamuka_all_consuming_god_tentacle_sweep_modifier:IsStunDebuff()
	return false
end

function bhamuka_all_consuming_god_tentacle_sweep_modifier:IsDebuff()
	return true
end