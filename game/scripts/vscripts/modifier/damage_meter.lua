damage_meter = class({})

function damage_meter:OnCreated( kv )

end

function damage_meter:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_TAKEDAMAGE
	}

	return funcs
end

function damage_meter:OnTakeDamage( params )
    if not IsServer() then return end

    if params.unit ~= self:GetParent() then return end

    local attacker = params.attacker

    if attacker == nil then return end

    if not attacker:IsRealHero() then
        if attacker:GetPlayerOwner() ~= nil then
            attacker = attacker:GetPlayerOwner():GetAssignedHero()
        end
    end

    local hero = attacker:GetUnitName()

    if GameRules.DAMAGE_METER[hero] == nil then
        GameRules.DAMAGE_METER[hero] = {}
    end

    -- The ability/item used to damage, or nil if not damaged by an item/ability
    local damagingAbility = params.inflictor

    if damagingAbility == nil then
        if GameRules.DAMAGE_METER[hero]["autoattack"] == nil then
            GameRules.DAMAGE_METER[hero]["autoattack"] = 0
            --GameRules.DAMAGE_METER[hero]["autoattack_orig"] = 0
        end

        GameRules.DAMAGE_METER[hero]["autoattack"] = GameRules.DAMAGE_METER[hero]["autoattack"] + params.damage or params.damage
        --GameRules.DAMAGE_METER[hero]["autoattack_orig"] = GameRules.DAMAGE_METER[hero]["autoattack_orig"] + params.original_damage or params.original_damage
    elseif damagingAbility:GetDebugName() ~= params.unit:GetDebugName() then
        damagingAbility = damagingAbility:GetAbilityName()

        if GameRules.DAMAGE_METER[hero][damagingAbility] == nil then
            GameRules.DAMAGE_METER[hero][damagingAbility] = 0
            --GameRules.DAMAGE_METER[hero][damagingAbility .. "_orig"] = 0
        end

        GameRules.DAMAGE_METER[hero][damagingAbility] = GameRules.DAMAGE_METER[hero][damagingAbility] + params.damage or params.damage
        --GameRules.DAMAGE_METER[hero][damagingAbility .. "_orig"] = GameRules.DAMAGE_METER[hero][damagingAbility .. "_orig"] + params.original_damage or params.original_damage
    end

    -- params.damage_type
    -- params.attacker
    -- params.original_damage
    -- params.damage

end

function damage_meter:IsHidden()
    return true
end

function damage_meter:IsPurgable()
    return false
end

function damage_meter:IsPurgeException()
    return false
end

function damage_meter:IsStunDebuff()
    return false
end

function damage_meter:IsDebuff()
    return false
end