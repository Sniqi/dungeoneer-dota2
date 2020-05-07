item_artifact_of_greater_knowledge_modifier = class({})

function item_artifact_of_greater_knowledge_modifier:OnCreated( kv )
end

function item_artifact_of_greater_knowledge_modifier:DeclareFunctions()
	local funcs = {
	}

	return funcs
end

function item_artifact_of_greater_knowledge_modifier:RemoveOnDeath()
	return false
end

function item_artifact_of_greater_knowledge_modifier:IsHidden()
	return true
end

function item_artifact_of_greater_knowledge_modifier:GetAttributes()
	return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE + MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_MULTIPLE
end

function item_artifact_of_greater_knowledge_modifier:IsPurgable()
	return false
end

function item_artifact_of_greater_knowledge_modifier:IsPurgeException()
	return false
end

function item_artifact_of_greater_knowledge_modifier:IsStunDebuff()
	return false
end

function item_artifact_of_greater_knowledge_modifier:IsDebuff()
	return false
end