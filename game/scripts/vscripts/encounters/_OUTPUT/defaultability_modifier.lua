%ModifierClass% = class({})

function %ModifierClass%:OnCreated( kv )%GetSpecialValueFor%
end

function %ModifierClass%:DeclareFunctions()
	local funcs = {%DeclareFunctions%
	}

	return funcs
end

%GetModifier%

function %ModifierClass%:GetAttributes()
	return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE
end

function %ModifierClass%:IsHidden()
    return false
end

function %ModifierClass%:IsPurgable()
	return false
end

function %ModifierClass%:IsPurgeException()
	return false
end

function %ModifierClass%:IsStunDebuff()
	return false
end

function %ModifierClass%:IsDebuff()
	return true
end