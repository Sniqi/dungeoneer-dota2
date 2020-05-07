modifier_encounter_damage = class({})

function modifier_encounter_damage:OnCreated( kv )
	if not IsServer() then return end
end

function modifier_encounter_damage:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE
	}

	return funcs
end

function modifier_encounter_damage:GetModifierTotalDamageOutgoing_Percentage( params )
	if not IsServer() then return end

	local dmg_multiplier = 0

	--difficulty
	dmg_multiplier = ( ( EncounterDamageMultiplierByMode[GameMode_Active] * 100 ) - 100 ) / 2

	--endless
	if GetRound() >= 7 and ClassicSubMode_Endless then
		dmg_multiplier = dmg_multiplier + ( ( ( GetRound() - 6 ) * EncounterDamageMultiplierEndless ) * EncounterDamageMultiplierByMode[GameMode_Active] )
	end

	return dmg_multiplier
end

function modifier_encounter_damage:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE
end

function modifier_encounter_damage:IsHidden()
    return true
end

function modifier_encounter_damage:IsPurgable()
	return false
end

function modifier_encounter_damage:IsPurgeException()
	return false
end

function modifier_encounter_damage:IsStunDebuff()
	return false
end

function modifier_encounter_damage:IsDebuff()
	return false
end




































