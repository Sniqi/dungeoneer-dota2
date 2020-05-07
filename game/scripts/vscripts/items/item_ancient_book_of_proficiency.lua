item_ancient_book_of_proficiency = class({})

LinkLuaModifier( 'item_ancient_book_of_proficiency_modifier', 'items/item_ancient_book_of_proficiency_modifier', LUA_MODIFIER_MOTION_NONE )

function item_ancient_book_of_proficiency:OnSpellStart( params )

	--- Get Caster, Victim, Player, Point ---
	local caster		= self:GetCaster()
	local caster_loc	= caster:GetAbsOrigin()
	local playerID		= caster:GetPlayerOwnerID()
	local player		= PlayerResource:GetPlayer(playerID)
	local team			= caster:GetTeamNumber()
	
	--- Get Special Values ---
	local bonus_all_stats 		= self:GetSpecialValueFor("bonus_all_stats")
	
	caster:AddNewModifier(caster, self, "item_ancient_book_of_proficiency_modifier", {bonus_all_stats=bonus_all_stats} )

	self:Destroy()
end

function item_ancient_book_of_proficiency:GetManaCost(abilitylevel)
	return self.BaseClass.GetManaCost(self, abilitylevel)
end

function item_ancient_book_of_proficiency:GetCooldown(abilitylevel)
	return self.BaseClass.GetCooldown(self, abilitylevel)
end
