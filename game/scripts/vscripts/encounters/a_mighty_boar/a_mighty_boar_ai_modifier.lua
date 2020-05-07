a_mighty_boar_ai_modifier = class({})

function a_mighty_boar_ai_modifier:OnCreated( kv )
	if not IsServer() then return end
	self:StartIntervalThink(4.0)
end

function a_mighty_boar_ai_modifier:OnIntervalThink()
	if not IsServer() then return end

	local caster = self:GetParent()

	local victim		= GetRandomHeroEntities(1)
	if not victim then return end
	victim				= victim[1]
	local victim_loc	= victim:GetAbsOrigin()
	local loc

	if RandomInt(0, 1) == 0 then
		loc = victim_loc + RandomVector(150.0)
	else
		loc = victim_loc - RandomVector(150.0)
	end

	caster:MoveToPosition(loc)
end

function a_mighty_boar_ai_modifier:GetAttributes()
	return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE
end

function a_mighty_boar_ai_modifier:IsHidden()
    return true
end

function a_mighty_boar_ai_modifier:IsPurgable()
	return false
end

function a_mighty_boar_ai_modifier:IsPurgeException()
	return false
end

function a_mighty_boar_ai_modifier:IsStunDebuff()
	return false
end

function a_mighty_boar_ai_modifier:IsDebuff()
	return false
end