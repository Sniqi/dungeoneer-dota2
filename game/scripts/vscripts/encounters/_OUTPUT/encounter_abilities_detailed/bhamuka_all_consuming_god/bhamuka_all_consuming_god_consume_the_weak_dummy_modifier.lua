bhamuka_all_consuming_god_consume_the_weak_dummy_modifier = class({})

function bhamuka_all_consuming_god_consume_the_weak_dummy_modifier:OnCreated( kv )
	self.heal_percentage              = self:GetAbility():GetSpecialValueFor("heal_percentage")
end

function bhamuka_all_consuming_god_consume_the_weak_dummy_modifier:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_TOOLTIP,
	}

	return funcs
end


function bhamuka_all_consuming_god_consume_the_weak_dummy_modifier:OnTooltip( params )
	return self.heal_percentage
end


function bhamuka_all_consuming_god_consume_the_weak_dummy_modifier:GetAttributes()
	return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE
end

function bhamuka_all_consuming_god_consume_the_weak_dummy_modifier:IsHidden()
    return false
end

function bhamuka_all_consuming_god_consume_the_weak_dummy_modifier:IsPurgable()
	return false
end

function bhamuka_all_consuming_god_consume_the_weak_dummy_modifier:IsPurgeException()
	return false
end

function bhamuka_all_consuming_god_consume_the_weak_dummy_modifier:IsStunDebuff()
	return false
end

function bhamuka_all_consuming_god_consume_the_weak_dummy_modifier:IsDebuff()
	return true
end