bhamuka_all_consuming_god_consume_souls_modifier = class({})

function bhamuka_all_consuming_god_consume_souls_modifier:OnCreated( kv )
	self.damage                       = self:GetAbility():GetSpecialValueFor("damage")
end

function bhamuka_all_consuming_god_consume_souls_modifier:OnRefresh( params )
	if not IsServer() then return end

	local caster = self:GetParent()

	if self:GetStackCount() >= 100 then
		caster:Kill(self:GetAbility(), self:GetCaster())
	end
end

function bhamuka_all_consuming_god_consume_souls_modifier:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_TOOLTIP,
	}

	return funcs
end

function bhamuka_all_consuming_god_consume_souls_modifier:OnTooltip( params )
	return self.damage
end

function bhamuka_all_consuming_god_consume_souls_modifier:GetAttributes()
	return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE
end

function bhamuka_all_consuming_god_consume_souls_modifier:IsHidden()
    return false
end

function bhamuka_all_consuming_god_consume_souls_modifier:IsPurgable()
	return false
end

function bhamuka_all_consuming_god_consume_souls_modifier:IsPurgeException()
	return false
end

function bhamuka_all_consuming_god_consume_souls_modifier:IsStunDebuff()
	return false
end

function bhamuka_all_consuming_god_consume_souls_modifier:IsDebuff()
	return true
end