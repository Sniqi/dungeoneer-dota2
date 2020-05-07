item_book_of_intelligence = class({})

LinkLuaModifier( 'item_book_of_intelligence_modifier', 'items/item_book_of_intelligence_modifier', LUA_MODIFIER_MOTION_NONE )

function item_book_of_intelligence:OnSpellStart()

	--- Get Caster, Victim, Player, Point ---
	local caster		= self:GetCaster()
	local caster_loc	= caster:GetAbsOrigin()
	local playerID		= caster:GetPlayerOwnerID()
	local player		= PlayerResource:GetPlayer(playerID)
	local team			= caster:GetTeamNumber()
	
	--- Get Special Values ---
	local bonus_intelligence 	= self:GetSpecialValueFor("bonus_intelligence")
	local limit_per_hero 		= self:GetSpecialValueFor("limit_per_hero")

	local count = #caster:FindAllModifiersByName("item_book_of_intelligence_modifier")

	if count < limit_per_hero then
		caster:AddNewModifier(caster, self, "item_book_of_intelligence_modifier", {bonus_intelligence=bonus_intelligence})
		caster:EmitSound("Item.TomeOfKnowledge")
	else
		caster:ModifyGold(self:GetCost(), true, DOTA_ModifyGold_Unspecified)
		Notifications:Bottom(caster:GetPlayerOwnerID(), {text="You cannot exceed the hero limit of "..limit_per_hero, duration=2.0, style={color="rgb(200, 48, 48)", ["font-size"]="20", ["text-shadow"]="1px 1px 4px 5.0 #333333b0"}, continue=false})
	end
	
	self:Destroy()
end

function item_book_of_intelligence:GetManaCost(abilitylevel)
	return self.BaseClass.GetManaCost(self, abilitylevel)
end

function item_book_of_intelligence:GetCooldown(abilitylevel)
	return self.BaseClass.GetCooldown(self, abilitylevel)
end
