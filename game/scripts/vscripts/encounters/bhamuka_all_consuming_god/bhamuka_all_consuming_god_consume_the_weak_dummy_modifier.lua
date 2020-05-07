bhamuka_all_consuming_god_consume_the_weak_dummy_modifier = class({})

function bhamuka_all_consuming_god_consume_the_weak_dummy_modifier:OnCreated( kv )
	if not IsServer() then return end
	local model = {"models/heroes/undying/undying_minion_torso.vmdl", "models/heroes/undying/undying_minion.vmdl"}
end

function bhamuka_all_consuming_god_consume_the_weak_dummy_modifier:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_ABSOLUTE
	}

	return funcs
end

function bhamuka_all_consuming_god_consume_the_weak_dummy_modifier:GetModifierMoveSpeed_Absolute()
	return 60
end

function bhamuka_all_consuming_god_consume_the_weak_dummy_modifier:GetModifierModelChange()
	return "models/heroes/undying/undying_minion_torso.vmdl"--model[RandomInt(1, #model)]
end

function bhamuka_all_consuming_god_consume_the_weak_dummy_modifier:GetModifierModelScale()
	return 1.0
end

function bhamuka_all_consuming_god_consume_the_weak_dummy_modifier:GetAttributes()
	return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE
end

function bhamuka_all_consuming_god_consume_the_weak_dummy_modifier:IsHidden()
    return true
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
	return false
end