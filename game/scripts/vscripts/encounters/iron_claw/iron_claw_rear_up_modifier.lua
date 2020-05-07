iron_claw_rear_up_modifier = class({})

function iron_claw_rear_up_modifier:OnCreated( kv )
	self.duration = self:GetAbility():GetSpecialValueFor("duration")

	if not IsServer() then return end

	local caster = self:GetParent()

	caster:StartGesture(ACT_DOTA_DISABLED)
	
	-- Modifier --
	caster:AddNewModifier(caster, self:GetAbility(), "casting_no_turning_modifier", {})
end

function iron_claw_rear_up_modifier:OnDestroy( kv )
	if not IsServer() then return end

	local caster = self:GetParent()

	caster:RemoveGesture(ACT_DOTA_DISABLED)

	-- Modifier --
	caster:RemoveModifierByName("casting_no_turning_modifier")
end

function iron_claw_rear_up_modifier:GetEffectName()
	return "particles/units/heroes/hero_lone_druid/lone_druid_savage_roar_debuff.vpcf"
end

function iron_claw_rear_up_modifier:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

function iron_claw_rear_up_modifier:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_TOOLTIP,
	}

	return funcs
end


function iron_claw_rear_up_modifier:OnTooltip( params )
	return self.duration
end


function iron_claw_rear_up_modifier:GetAttributes()
	return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE
end

function iron_claw_rear_up_modifier:IsHidden()
    return false
end

function iron_claw_rear_up_modifier:IsPurgable()
	return false
end

function iron_claw_rear_up_modifier:IsPurgeException()
	return false
end

function iron_claw_rear_up_modifier:IsStunDebuff()
	return false
end

function iron_claw_rear_up_modifier:IsDebuff()
	return true
end