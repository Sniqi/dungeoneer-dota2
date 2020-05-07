sinastra_ice_shard_barrage_modifier = class({})

function sinastra_ice_shard_barrage_modifier:OnCreated( kv )
	self.damage                       = self:GetAbility():GetSpecialValueFor("damage")
end

function sinastra_ice_shard_barrage_modifier:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_TOOLTIP,
	}

	return funcs
end


function sinastra_ice_shard_barrage_modifier:OnTooltip( params )
	return self.damage
end


function sinastra_ice_shard_barrage_modifier:GetAttributes()
	return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE
end

function sinastra_ice_shard_barrage_modifier:IsHidden()
    return false
end

function sinastra_ice_shard_barrage_modifier:IsPurgable()
	return false
end

function sinastra_ice_shard_barrage_modifier:IsPurgeException()
	return false
end

function sinastra_ice_shard_barrage_modifier:IsStunDebuff()
	return false
end

function sinastra_ice_shard_barrage_modifier:IsDebuff()
	return true
end