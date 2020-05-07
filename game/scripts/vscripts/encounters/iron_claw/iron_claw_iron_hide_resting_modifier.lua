iron_claw_iron_hide_resting_modifier = class({})

function iron_claw_iron_hide_resting_modifier:OnCreated( kv )
	if not IsServer() then return end

	local caster = self:GetParent()

	caster:StartGesture(ACT_DOTA_DISABLED)
	
	-- Modifier --
	caster:AddNewModifier(caster, self:GetAbility(), "casting_no_turning_modifier", {})
end

function iron_claw_iron_hide_resting_modifier:OnDestroy( kv )
	if not IsServer() then return end

	local caster = self:GetParent()

	caster:RemoveGesture(ACT_DOTA_DISABLED)

	-- Modifier --
	caster:RemoveModifierByName("casting_no_turning_modifier")
	caster:AddNewModifier(caster, self:GetAbility(), "iron_claw_iron_hide_modifier", {})
end

function iron_claw_iron_hide_resting_modifier:DeclareFunctions()
	local funcs = {
	}

	return funcs
end

function iron_claw_iron_hide_resting_modifier:GetEffectName()
	return "particles/generic_gameplay/generic_sleep.vpcf"
end

function iron_claw_iron_hide_resting_modifier:GetEffectAttachType()
	return PATTACH_OVERHEAD_FOLLOW
end

function iron_claw_iron_hide_resting_modifier:GetAttributes()
	return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE
end

function iron_claw_iron_hide_resting_modifier:IsHidden()
    return false
end

function iron_claw_iron_hide_resting_modifier:IsPurgable()
	return false
end

function iron_claw_iron_hide_resting_modifier:IsPurgeException()
	return false
end

function iron_claw_iron_hide_resting_modifier:IsStunDebuff()
	return false
end

function iron_claw_iron_hide_resting_modifier:IsDebuff()
	return false
end