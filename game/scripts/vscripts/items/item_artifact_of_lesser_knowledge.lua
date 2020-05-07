item_artifact_of_lesser_knowledge = class({})

LinkLuaModifier( 'item_artifact_of_lesser_knowledge_modifier', 'items/item_artifact_of_lesser_knowledge_modifier', LUA_MODIFIER_MOTION_NONE )

function item_artifact_of_lesser_knowledge:OnSpellStart( params )

	--- Get Caster, Victim, Player, Point ---
	local caster		= self:GetCaster()
	local caster_loc	= caster:GetAbsOrigin()
	local playerID		= caster:GetPlayerOwnerID()
	local player		= PlayerResource:GetPlayer(playerID)
	local team			= caster:GetTeamNumber()
	
	--- Get Special Values ---
	local limit_per_hero 		= self:GetSpecialValueFor("limit_per_hero")

	local count = #caster:FindAllModifiersByName("item_artifact_of_lesser_knowledge_modifier")

	if count < limit_per_hero then
		caster:AddNewModifier(caster, self, "item_artifact_of_lesser_knowledge_modifier", {})
		caster:EmitSound("Item.MoonShard.Consume")
		LootPerks( caster:GetPlayerOwnerID(), true, "lesser" )
	else
		caster:ModifyGold(self:GetCost(), true, DOTA_ModifyGold_Unspecified)
		Notifications:Bottom(caster:GetPlayerOwnerID(), {text="You cannot exceed the hero limit of "..limit_per_hero, duration=2.0, style={color="rgb(200, 48, 48)", ["font-size"]="20", ["text-shadow"]="1px 1px 4px 5.0 #333333b0"}, continue=false})
	end

	self:Destroy()
end

function item_artifact_of_lesser_knowledge:GetManaCost(abilitylevel)
	return self.BaseClass.GetManaCost(self, abilitylevel)
end

function item_artifact_of_lesser_knowledge:GetCooldown(abilitylevel)
	return self.BaseClass.GetCooldown(self, abilitylevel)
end
