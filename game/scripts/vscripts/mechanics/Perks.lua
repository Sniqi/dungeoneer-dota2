-- CONSTANTS

local DEBUG_MSG_Perks = false

local PerkModifiers = {}

-- ### Dynamic Perk Modifier Table Start ### --
	table.insert(PerkModifiers, "glyph_blazing_gold")
	table.insert(PerkModifiers, "glyph_blazing_knowledge")
	table.insert(PerkModifiers, "glyph_blazing_mind")
	table.insert(PerkModifiers, "glyph_blazing_power")
	table.insert(PerkModifiers, "glyph_mystic_book")
	table.insert(PerkModifiers, "glyph_mystic_flask")
	table.insert(PerkModifiers, "glyph_mystic_rune")
	table.insert(PerkModifiers, "glyph_mystic_stream")
	table.insert(PerkModifiers, "glyph_petrified_cloak")
	table.insert(PerkModifiers, "glyph_petrified_jewel")
	table.insert(PerkModifiers, "glyph_petrified_particles")
	table.insert(PerkModifiers, "glyph_petrified_soil")
	table.insert(PerkModifiers, "glyph_sacred_bracing")
	table.insert(PerkModifiers, "glyph_sacred_glory")
	table.insert(PerkModifiers, "glyph_sacred_vigor")
	table.insert(PerkModifiers, "glyph_sacred_vitality")
	table.insert(PerkModifiers, "glyph_sparking_agility")
	table.insert(PerkModifiers, "glyph_sparking_alacrity")
	table.insert(PerkModifiers, "glyph_sparking_swiftness")
	table.insert(PerkModifiers, "glyph_sparking_thunder")
	table.insert(PerkModifiers, "glyph_umbral_energy")
	table.insert(PerkModifiers, "glyph_umbral_force")
	table.insert(PerkModifiers, "glyph_umbral_fragments")
	table.insert(PerkModifiers, "glyph_umbral_potency")
	table.insert(PerkModifiers, "artifact_bound_souls")
	table.insert(PerkModifiers, "artifact_celestial_barrage")
	table.insert(PerkModifiers, "artifact_crackling_lightning")
	table.insert(PerkModifiers, "artifact_crunching_ground")
	table.insert(PerkModifiers, "artifact_fiery_eruption")
	table.insert(PerkModifiers, "artifact_holy_gush")
	table.insert(PerkModifiers, "artifact_purifiying_mana_burst")
	table.insert(PerkModifiers, "artifact_time_anomaly")
-- ### Dynamic Perk Modifier Table End ### --

local PerkModifiers_Descr = {}

-- ### Dynamic Perk Modifier Description Table Start ### --
	PerkModifiers_Descr["glyph_blazing_gold"] = {}
	PerkModifiers_Descr["glyph_blazing_gold"]["title"] = "Blazing Gold"
	PerkModifiers_Descr["glyph_blazing_gold"]["descr"] = "Defeated encounters grant $1% more gold."
	PerkModifiers_Descr["glyph_blazing_gold"]["type1"] = "Economic"
	PerkModifiers_Descr["glyph_blazing_gold"]["type2"] = "Fire"
	PerkModifiers_Descr["glyph_blazing_gold"]["stats"] = {}
	PerkModifiers_Descr["glyph_blazing_gold"]["stats"][1] = 10
	PerkModifiers_Descr["glyph_blazing_gold"]["effectiveness_holy"] = 4
	PerkModifiers_Descr["glyph_blazing_gold"]["effectiveness_offensive"] = -5.0
	PerkModifiers_Descr["glyph_blazing_knowledge"] = {}
	PerkModifiers_Descr["glyph_blazing_knowledge"]["title"] = "Blazing Knowledge"
	PerkModifiers_Descr["glyph_blazing_knowledge"]["descr"] = "Increases effectiveness of $(earth)Earth, $(shadow)Shadow and $(lightning)Lightning by $1%."
	PerkModifiers_Descr["glyph_blazing_knowledge"]["type1"] = "Supportive"
	PerkModifiers_Descr["glyph_blazing_knowledge"]["type2"] = "Fire"
	PerkModifiers_Descr["glyph_blazing_knowledge"]["stats"] = {}
	PerkModifiers_Descr["glyph_blazing_knowledge"]["stats"][1] = 15
	PerkModifiers_Descr["glyph_blazing_knowledge"]["effectiveness_earth"] = 15
	PerkModifiers_Descr["glyph_blazing_knowledge"]["effectiveness_shadow"] = 15
	PerkModifiers_Descr["glyph_blazing_knowledge"]["effectiveness_lightning"] = 15
	PerkModifiers_Descr["glyph_blazing_mind"] = {}
	PerkModifiers_Descr["glyph_blazing_mind"]["title"] = "Blazing Mind"
	PerkModifiers_Descr["glyph_blazing_mind"]["descr"] = "Increases all attributes by $1%."
	PerkModifiers_Descr["glyph_blazing_mind"]["type1"] = "Supportive"
	PerkModifiers_Descr["glyph_blazing_mind"]["type2"] = "Fire"
	PerkModifiers_Descr["glyph_blazing_mind"]["stats"] = {}
	PerkModifiers_Descr["glyph_blazing_mind"]["stats"][1] = 4
	PerkModifiers_Descr["glyph_blazing_mind"]["effectiveness_defensive"] = 8
	PerkModifiers_Descr["glyph_blazing_mind"]["effectiveness_offensive"] = -3
	PerkModifiers_Descr["glyph_blazing_power"] = {}
	PerkModifiers_Descr["glyph_blazing_power"]["title"] = "Blazing Power"
	PerkModifiers_Descr["glyph_blazing_power"]["descr"] = "Increases attack damage by $1%"
	PerkModifiers_Descr["glyph_blazing_power"]["type1"] = "Offensive"
	PerkModifiers_Descr["glyph_blazing_power"]["type2"] = "Fire"
	PerkModifiers_Descr["glyph_blazing_power"]["stats"] = {}
	PerkModifiers_Descr["glyph_blazing_power"]["stats"][1] = 10
	PerkModifiers_Descr["glyph_blazing_power"]["effectiveness_shadow"] = -3.0
	PerkModifiers_Descr["glyph_blazing_power"]["effectiveness_defensive"] = -2.0
	PerkModifiers_Descr["glyph_mystic_book"] = {}
	PerkModifiers_Descr["glyph_mystic_book"]["title"] = "Mystic Book"
	PerkModifiers_Descr["glyph_mystic_book"]["descr"] = "Reduces cooldowns of spells and items by $1%."
	PerkModifiers_Descr["glyph_mystic_book"]["type1"] = "Supportive"
	PerkModifiers_Descr["glyph_mystic_book"]["type2"] = "Arcane"
	PerkModifiers_Descr["glyph_mystic_book"]["stats"] = {}
	PerkModifiers_Descr["glyph_mystic_book"]["stats"][1] = 10
	PerkModifiers_Descr["glyph_mystic_book"]["effectiveness_holy"] = 5
	PerkModifiers_Descr["glyph_mystic_book"]["effectiveness_economic"] = -3.0
	PerkModifiers_Descr["glyph_mystic_flask"] = {}
	PerkModifiers_Descr["glyph_mystic_flask"]["title"] = "Mystic Flask"
	PerkModifiers_Descr["glyph_mystic_flask"]["descr"] = "Whenever spending mana, regenerate $1% of mana spent over $2 seconds."
	PerkModifiers_Descr["glyph_mystic_flask"]["type1"] = "Supportive"
	PerkModifiers_Descr["glyph_mystic_flask"]["type2"] = "Arcane"
	PerkModifiers_Descr["glyph_mystic_flask"]["stats"] = {}
	PerkModifiers_Descr["glyph_mystic_flask"]["stats"][1] = 10
	PerkModifiers_Descr["glyph_mystic_flask"]["stats"][2] = 8
	PerkModifiers_Descr["glyph_mystic_flask"]["effectiveness_offensive"] = 6
	PerkModifiers_Descr["glyph_mystic_rune"] = {}
	PerkModifiers_Descr["glyph_mystic_rune"]["title"] = "Mystic Rune"
	PerkModifiers_Descr["glyph_mystic_rune"]["descr"] = "Increases Arcane Knowledge by $1% (increases spell damage). Arcane Knowledge bonuses stack multiplicative."
	PerkModifiers_Descr["glyph_mystic_rune"]["type1"] = "Offensive"
	PerkModifiers_Descr["glyph_mystic_rune"]["type2"] = "Arcane"
	PerkModifiers_Descr["glyph_mystic_rune"]["stats"] = {}
	PerkModifiers_Descr["glyph_mystic_rune"]["stats"][1] = 10
	PerkModifiers_Descr["glyph_mystic_rune"]["effectiveness_holy"] = 3.0
	PerkModifiers_Descr["glyph_mystic_rune"]["effectiveness_shadow"] = 3.0
	PerkModifiers_Descr["glyph_mystic_rune"]["effectiveness_fire"] = -2.0
	PerkModifiers_Descr["glyph_mystic_rune"]["effectiveness_earth"] = -2.0
	PerkModifiers_Descr["glyph_mystic_rune"]["effectiveness_lightning"] = -2.0
	PerkModifiers_Descr["glyph_mystic_stream"] = {}
	PerkModifiers_Descr["glyph_mystic_stream"]["title"] = "Mystic Stream"
	PerkModifiers_Descr["glyph_mystic_stream"]["descr"] = "Amplifies any incoming mana regeneration by $1%"
	PerkModifiers_Descr["glyph_mystic_stream"]["type1"] = "Supportive"
	PerkModifiers_Descr["glyph_mystic_stream"]["type2"] = "Arcane"
	PerkModifiers_Descr["glyph_mystic_stream"]["stats"] = {}
	PerkModifiers_Descr["glyph_mystic_stream"]["stats"][1] = 15
	PerkModifiers_Descr["glyph_mystic_stream"]["effectiveness_offensive"] = 6
	PerkModifiers_Descr["glyph_petrified_cloak"] = {}
	PerkModifiers_Descr["glyph_petrified_cloak"]["title"] = "Petrified Cloak"
	PerkModifiers_Descr["glyph_petrified_cloak"]["descr"] = "$1% of damage taken is staggered and will be dealt to you over $2 seconds instead."
	PerkModifiers_Descr["glyph_petrified_cloak"]["type1"] = "Defensive"
	PerkModifiers_Descr["glyph_petrified_cloak"]["type2"] = "Earth"
	PerkModifiers_Descr["glyph_petrified_cloak"]["stats"] = {}
	PerkModifiers_Descr["glyph_petrified_cloak"]["stats"][1] = 20
	PerkModifiers_Descr["glyph_petrified_cloak"]["stats"][2] = 2
	PerkModifiers_Descr["glyph_petrified_cloak"]["effectiveness_offensive"] = 8
	PerkModifiers_Descr["glyph_petrified_cloak"]["effectiveness_shadow"] = -2.0
	PerkModifiers_Descr["glyph_petrified_jewel"] = {}
	PerkModifiers_Descr["glyph_petrified_jewel"]["title"] = "Petrified Jewel"
	PerkModifiers_Descr["glyph_petrified_jewel"]["descr"] = "Increases Resilience by $1% (reduces any damage taken). Resilience bonuses stack multiplicative."
	PerkModifiers_Descr["glyph_petrified_jewel"]["type1"] = "Defensive"
	PerkModifiers_Descr["glyph_petrified_jewel"]["type2"] = "Earth"
	PerkModifiers_Descr["glyph_petrified_jewel"]["stats"] = {}
	PerkModifiers_Descr["glyph_petrified_jewel"]["stats"][1] = 5
	PerkModifiers_Descr["glyph_petrified_jewel"]["effectiveness_supportive"] = 3
	PerkModifiers_Descr["glyph_petrified_jewel"]["effectiveness_shadow"] = -3.0
	PerkModifiers_Descr["glyph_petrified_particles"] = {}
	PerkModifiers_Descr["glyph_petrified_particles"]["title"] = "Petrified Particles"
	PerkModifiers_Descr["glyph_petrified_particles"]["descr"] = "Defeated Encounters grant $1% more Glyph Particles."
	PerkModifiers_Descr["glyph_petrified_particles"]["type1"] = "Economic"
	PerkModifiers_Descr["glyph_petrified_particles"]["type2"] = "Earth"
	PerkModifiers_Descr["glyph_petrified_particles"]["stats"] = {}
	PerkModifiers_Descr["glyph_petrified_particles"]["stats"][1] = 10
	PerkModifiers_Descr["glyph_petrified_particles"]["effectiveness_fire"] = 4
	PerkModifiers_Descr["glyph_petrified_particles"]["effectiveness_offensive"] = -5.0
	PerkModifiers_Descr["glyph_petrified_soil"] = {}
	PerkModifiers_Descr["glyph_petrified_soil"]["title"] = "Petrified Soil"
	PerkModifiers_Descr["glyph_petrified_soil"]["descr"] = "Amplifies any incoming health regeneration (including passive regeneration, healing and lifesteal) by $1%"
	PerkModifiers_Descr["glyph_petrified_soil"]["type1"] = "Defensive"
	PerkModifiers_Descr["glyph_petrified_soil"]["type2"] = "Earth"
	PerkModifiers_Descr["glyph_petrified_soil"]["stats"] = {}
	PerkModifiers_Descr["glyph_petrified_soil"]["stats"][1] = 8
	PerkModifiers_Descr["glyph_petrified_soil"]["effectiveness_lightning"] = 5
	PerkModifiers_Descr["glyph_petrified_soil"]["effectiveness_offensive"] = -5.0
	PerkModifiers_Descr["glyph_sacred_bracing"] = {}
	PerkModifiers_Descr["glyph_sacred_bracing"]["title"] = "Sacred Bracing"
	PerkModifiers_Descr["glyph_sacred_bracing"]["descr"] = "Every $1 seconds gain an shield which absorbs incoming damage in the amount of $2% of max health."
	PerkModifiers_Descr["glyph_sacred_bracing"]["type1"] = "Defensive"
	PerkModifiers_Descr["glyph_sacred_bracing"]["type2"] = "Holy"
	PerkModifiers_Descr["glyph_sacred_bracing"]["stats"] = {}
	PerkModifiers_Descr["glyph_sacred_bracing"]["stats"][1] = 8
	PerkModifiers_Descr["glyph_sacred_bracing"]["stats"][2] = 5
	PerkModifiers_Descr["glyph_sacred_bracing"]["effectiveness_offensive"] = 2
	PerkModifiers_Descr["glyph_sacred_bracing"]["effectiveness_shadow"] = -2.0
	PerkModifiers_Descr["glyph_sacred_glory"] = {}
	PerkModifiers_Descr["glyph_sacred_glory"]["title"] = "Sacred Glory"
	PerkModifiers_Descr["glyph_sacred_glory"]["descr"] = "Increases effectiveness of $(fire)Fire and $(arcane)Arcane by $1%."
	PerkModifiers_Descr["glyph_sacred_glory"]["type1"] = "Supportive"
	PerkModifiers_Descr["glyph_sacred_glory"]["type2"] = "Holy"
	PerkModifiers_Descr["glyph_sacred_glory"]["stats"] = {}
	PerkModifiers_Descr["glyph_sacred_glory"]["stats"][1] = 20
	PerkModifiers_Descr["glyph_sacred_glory"]["effectiveness_fire"] = 20
	PerkModifiers_Descr["glyph_sacred_glory"]["effectiveness_arcane"] = 20
	PerkModifiers_Descr["glyph_sacred_glory"]["effectiveness_supportive"] = -4.0
	PerkModifiers_Descr["glyph_sacred_vigor"] = {}
	PerkModifiers_Descr["glyph_sacred_vigor"]["title"] = "Sacred Vigor"
	PerkModifiers_Descr["glyph_sacred_vigor"]["descr"] = "Increases primary attribute by $1%."
	PerkModifiers_Descr["glyph_sacred_vigor"]["type1"] = "Supportive"
	PerkModifiers_Descr["glyph_sacred_vigor"]["type2"] = "Holy"
	PerkModifiers_Descr["glyph_sacred_vigor"]["stats"] = {}
	PerkModifiers_Descr["glyph_sacred_vigor"]["stats"][1] = 12
	PerkModifiers_Descr["glyph_sacred_vigor"]["effectiveness_defensive"] = 8
	PerkModifiers_Descr["glyph_sacred_vitality"] = {}
	PerkModifiers_Descr["glyph_sacred_vitality"]["title"] = "Sacred Vitality"
	PerkModifiers_Descr["glyph_sacred_vitality"]["descr"] = "Whenever taking damage, heal for $1% of damage taken over $2 seconds."
	PerkModifiers_Descr["glyph_sacred_vitality"]["type1"] = "Defensive"
	PerkModifiers_Descr["glyph_sacred_vitality"]["type2"] = "Holy"
	PerkModifiers_Descr["glyph_sacred_vitality"]["stats"] = {}
	PerkModifiers_Descr["glyph_sacred_vitality"]["stats"][1] = 10
	PerkModifiers_Descr["glyph_sacred_vitality"]["stats"][2] = 8
	PerkModifiers_Descr["glyph_sacred_vitality"]["effectiveness_offensive"] = 8
	PerkModifiers_Descr["glyph_sacred_vitality"]["effectiveness_fire"] = -4.0
	PerkModifiers_Descr["glyph_sacred_vitality"]["effectiveness_lightning"] = -4.0
	PerkModifiers_Descr["glyph_sparking_agility"] = {}
	PerkModifiers_Descr["glyph_sparking_agility"]["title"] = "Sparking Agility"
	PerkModifiers_Descr["glyph_sparking_agility"]["descr"] = "Increases attack speed by $1."
	PerkModifiers_Descr["glyph_sparking_agility"]["type1"] = "Offensive"
	PerkModifiers_Descr["glyph_sparking_agility"]["type2"] = "Lightning"
	PerkModifiers_Descr["glyph_sparking_agility"]["stats"] = {}
	PerkModifiers_Descr["glyph_sparking_agility"]["stats"][1] = 25
	PerkModifiers_Descr["glyph_sparking_agility"]["effectiveness_shadow"] = 3.0
	PerkModifiers_Descr["glyph_sparking_agility"]["effectiveness_holy"] = -4.0
	PerkModifiers_Descr["glyph_sparking_alacrity"] = {}
	PerkModifiers_Descr["glyph_sparking_alacrity"]["title"] = "Sparking Alacrity"
	PerkModifiers_Descr["glyph_sparking_alacrity"]["descr"] = "Decreases cast times of spells and items by $1%."
	PerkModifiers_Descr["glyph_sparking_alacrity"]["type1"] = "Supportive"
	PerkModifiers_Descr["glyph_sparking_alacrity"]["type2"] = "Lightning"
	PerkModifiers_Descr["glyph_sparking_alacrity"]["stats"] = {}
	PerkModifiers_Descr["glyph_sparking_alacrity"]["stats"][1] = 20
	PerkModifiers_Descr["glyph_sparking_alacrity"]["effectiveness_arcane"] = 2
	PerkModifiers_Descr["glyph_sparking_alacrity"]["effectiveness_earth"] = -2.0
	PerkModifiers_Descr["glyph_sparking_swiftness"] = {}
	PerkModifiers_Descr["glyph_sparking_swiftness"]["title"] = "Sparking Swiftness"
	PerkModifiers_Descr["glyph_sparking_swiftness"]["descr"] = "Increases move speed by $1%."
	PerkModifiers_Descr["glyph_sparking_swiftness"]["type1"] = "Supportive"
	PerkModifiers_Descr["glyph_sparking_swiftness"]["type2"] = "Lightning"
	PerkModifiers_Descr["glyph_sparking_swiftness"]["stats"] = {}
	PerkModifiers_Descr["glyph_sparking_swiftness"]["stats"][1] = 5
	PerkModifiers_Descr["glyph_sparking_swiftness"]["effectiveness_earth"] = -3.0
	PerkModifiers_Descr["glyph_sparking_thunder"] = {}
	PerkModifiers_Descr["glyph_sparking_thunder"]["title"] = "Sparking Thunder"
	PerkModifiers_Descr["glyph_sparking_thunder"]["descr"] = "Increases effectiveness of $(arcane)Arcane and $(fire)Fire $1%."
	PerkModifiers_Descr["glyph_sparking_thunder"]["type1"] = "Supportive"
	PerkModifiers_Descr["glyph_sparking_thunder"]["type2"] = "Lightning"
	PerkModifiers_Descr["glyph_sparking_thunder"]["stats"] = {}
	PerkModifiers_Descr["glyph_sparking_thunder"]["stats"][1] = 20
	PerkModifiers_Descr["glyph_sparking_thunder"]["effectiveness_arcane"] = 20
	PerkModifiers_Descr["glyph_sparking_thunder"]["effectiveness_shadow"] = 20
	PerkModifiers_Descr["glyph_sparking_thunder"]["effectiveness_offensive"] = -4.0
	PerkModifiers_Descr["glyph_umbral_energy"] = {}
	PerkModifiers_Descr["glyph_umbral_energy"]["title"] = "Umbral Energy"
	PerkModifiers_Descr["glyph_umbral_energy"]["descr"] = "Lifesteal: $1% of any damage done (physical, magical and pure) is returned back to you as health."
	PerkModifiers_Descr["glyph_umbral_energy"]["type1"] = "Offensive"
	PerkModifiers_Descr["glyph_umbral_energy"]["type2"] = "Shadow"
	PerkModifiers_Descr["glyph_umbral_energy"]["stats"] = {}
	PerkModifiers_Descr["glyph_umbral_energy"]["stats"][1] = 1.5
	PerkModifiers_Descr["glyph_umbral_energy"]["effectiveness_defensive"] = 3
	PerkModifiers_Descr["glyph_umbral_energy"]["effectiveness_supportive"] = 3
	PerkModifiers_Descr["glyph_umbral_energy"]["effectiveness_earth"] = -5.0
	PerkModifiers_Descr["glyph_umbral_energy"]["effectiveness_holy"] = -5.0
	PerkModifiers_Descr["glyph_umbral_force"] = {}
	PerkModifiers_Descr["glyph_umbral_force"]["title"] = "Umbral Force"
	PerkModifiers_Descr["glyph_umbral_force"]["descr"] = "Increases spell damage by $1%."
	PerkModifiers_Descr["glyph_umbral_force"]["type1"] = "Offensive"
	PerkModifiers_Descr["glyph_umbral_force"]["type2"] = "Shadow"
	PerkModifiers_Descr["glyph_umbral_force"]["stats"] = {}
	PerkModifiers_Descr["glyph_umbral_force"]["stats"][1] = 10
	PerkModifiers_Descr["glyph_umbral_force"]["effectiveness_arcane"] = 4
	PerkModifiers_Descr["glyph_umbral_force"]["effectiveness_fire"] = -3.0
	PerkModifiers_Descr["glyph_umbral_force"]["effectiveness_defensive"] = -2.0
	PerkModifiers_Descr["glyph_umbral_fragments"] = {}
	PerkModifiers_Descr["glyph_umbral_fragments"]["title"] = "Umbral Fragments"
	PerkModifiers_Descr["glyph_umbral_fragments"]["descr"] = "Defeated encounters grant $1% more Artifact Fragments."
	PerkModifiers_Descr["glyph_umbral_fragments"]["type1"] = "Economic"
	PerkModifiers_Descr["glyph_umbral_fragments"]["type2"] = "Shadow"
	PerkModifiers_Descr["glyph_umbral_fragments"]["stats"] = {}
	PerkModifiers_Descr["glyph_umbral_fragments"]["stats"][1] = 10
	PerkModifiers_Descr["glyph_umbral_fragments"]["effectiveness_lightning"] = 4
	PerkModifiers_Descr["glyph_umbral_fragments"]["effectiveness_offensive"] = -5.0
	PerkModifiers_Descr["glyph_umbral_potency"] = {}
	PerkModifiers_Descr["glyph_umbral_potency"]["title"] = "Umbral Potency"
	PerkModifiers_Descr["glyph_umbral_potency"]["descr"] = "Every $1 seconds reduce the cooldown of a random spell by 10%."
	PerkModifiers_Descr["glyph_umbral_potency"]["type1"] = "Supportive"
	PerkModifiers_Descr["glyph_umbral_potency"]["type2"] = "Shadow"
	PerkModifiers_Descr["glyph_umbral_potency"]["stats"] = {}
	PerkModifiers_Descr["glyph_umbral_potency"]["stats"][1] = 3
	PerkModifiers_Descr["glyph_umbral_potency"]["stats"][2] = 10
	PerkModifiers_Descr["glyph_umbral_potency"]["effectiveness_defensive"] = -5.0
	PerkModifiers_Descr["glyph_umbral_potency"]["effectiveness_lightning"] = 5.0
	PerkModifiers_Descr["artifact_bound_souls"] = {}
	PerkModifiers_Descr["artifact_bound_souls"]["title"] = "Bound Souls"
	PerkModifiers_Descr["artifact_bound_souls"]["descr"] = "Creates a tether between your hero and the last auto attacked enemy. Slowing the enemy by 20% and dealing $2 magical damage (50% of all attributes) every $3 seconds, increasing by 30% every $3 second resulting in $5 total damage within 6 ticks over the full duration. Lasts $7 seconds or breaks if the tethered unit is more than $8 units away.<br><br>20.0s Cooldown."
	PerkModifiers_Descr["artifact_bound_souls"]["type1"] = "Offensive"
	PerkModifiers_Descr["artifact_bound_souls"]["type2"] = "Shadow"
	PerkModifiers_Descr["artifact_bound_souls"]["stats"] = {}
	PerkModifiers_Descr["artifact_bound_souls"]["stats"][1] = 20
	PerkModifiers_Descr["artifact_bound_souls"]["stats"][2] = 50
	PerkModifiers_Descr["artifact_bound_souls"]["stats"][3] = 1.0
	PerkModifiers_Descr["artifact_bound_souls"]["stats"][4] = 30
	PerkModifiers_Descr["artifact_bound_souls"]["stats"][5] = 525
	PerkModifiers_Descr["artifact_bound_souls"]["stats"][6] = 6
	PerkModifiers_Descr["artifact_bound_souls"]["stats"][7] = 5.0
	PerkModifiers_Descr["artifact_bound_souls"]["stats"][8] = 400
	PerkModifiers_Descr["artifact_bound_souls"]["stats"][9] = 20.0
	PerkModifiers_Descr["artifact_celestial_barrage"] = {}
	PerkModifiers_Descr["artifact_celestial_barrage"]["title"] = "Celestial Barrage"
	PerkModifiers_Descr["artifact_celestial_barrage"]["descr"] = "Fires 80 holy orbs either to a random enemy or to a friendly hero. If a friendly hero drops below 75% health, the friendly hero is chosen as target and is healed by $3 (9% of all attributes). Otherwise a random enemy in range is chosen, dealing $4 (9% of all attributes) magical damage resulting in $5 total damage if all orbs hit enemies. Lasts 20.0 seconds and operates in a range of $7.<br><br>50.0s Cooldown."
	PerkModifiers_Descr["artifact_celestial_barrage"]["type1"] = "Defensive"
	PerkModifiers_Descr["artifact_celestial_barrage"]["type2"] = "Holy"
	PerkModifiers_Descr["artifact_celestial_barrage"]["stats"] = {}
	PerkModifiers_Descr["artifact_celestial_barrage"]["stats"][1] = 80
	PerkModifiers_Descr["artifact_celestial_barrage"]["stats"][2] = 75
	PerkModifiers_Descr["artifact_celestial_barrage"]["stats"][3] = 9
	PerkModifiers_Descr["artifact_celestial_barrage"]["stats"][4] = 9
	PerkModifiers_Descr["artifact_celestial_barrage"]["stats"][5] = 720
	PerkModifiers_Descr["artifact_celestial_barrage"]["stats"][6] = 20.0
	PerkModifiers_Descr["artifact_celestial_barrage"]["stats"][7] = 700
	PerkModifiers_Descr["artifact_celestial_barrage"]["stats"][8] = 50.0
	PerkModifiers_Descr["artifact_crackling_lightning"] = {}
	PerkModifiers_Descr["artifact_crackling_lightning"]["title"] = "Crackling Lightning"
	PerkModifiers_Descr["artifact_crackling_lightning"]["descr"] = "Zaps the last auto attacked enemy with lightning, dealing $1 (340% of all attributes) magical damage. The lightning jumps to an enemy within a range of 800, dealing $3% less damage than the previous one. Maximum of 4 jumps. If only one target is hit, damage is increased by 40%.<br><br>20.0s Cooldown."
	PerkModifiers_Descr["artifact_crackling_lightning"]["type1"] = "Offensive"
	PerkModifiers_Descr["artifact_crackling_lightning"]["type2"] = "Lightning"
	PerkModifiers_Descr["artifact_crackling_lightning"]["stats"] = {}
	PerkModifiers_Descr["artifact_crackling_lightning"]["stats"][1] = 340
	PerkModifiers_Descr["artifact_crackling_lightning"]["stats"][2] = 800
	PerkModifiers_Descr["artifact_crackling_lightning"]["stats"][3] = 50
	PerkModifiers_Descr["artifact_crackling_lightning"]["stats"][4] = 4
	PerkModifiers_Descr["artifact_crackling_lightning"]["stats"][5] = 40
	PerkModifiers_Descr["artifact_crackling_lightning"]["stats"][6] = 20.0
	PerkModifiers_Descr["artifact_crunching_ground"] = {}
	PerkModifiers_Descr["artifact_crunching_ground"]["title"] = "Crunching Ground"
	PerkModifiers_Descr["artifact_crunching_ground"]["descr"] = "Shatters the earth within a $1 AoE around your hero, stunning all enemies for $2 seconds and dealing $3 physical damage (675% of all attributes), evenly split among all units hit. Every unit hit increases the damage by $4%.<br><br>30.0s Cooldown."
	PerkModifiers_Descr["artifact_crunching_ground"]["type1"] = "Offensive"
	PerkModifiers_Descr["artifact_crunching_ground"]["type2"] = "Earth"
	PerkModifiers_Descr["artifact_crunching_ground"]["stats"] = {}
	PerkModifiers_Descr["artifact_crunching_ground"]["stats"][1] = 400
	PerkModifiers_Descr["artifact_crunching_ground"]["stats"][2] = 1.0
	PerkModifiers_Descr["artifact_crunching_ground"]["stats"][3] = 675
	PerkModifiers_Descr["artifact_crunching_ground"]["stats"][4] = 20
	PerkModifiers_Descr["artifact_crunching_ground"]["stats"][5] = 30.0
	PerkModifiers_Descr["artifact_fiery_eruption"] = {}
	PerkModifiers_Descr["artifact_fiery_eruption"]["title"] = "Fiery Eruption"
	PerkModifiers_Descr["artifact_fiery_eruption"]["descr"] = "Hurls 24 Fireballs over 0.8 seconds to random enemies within $3 range. Each Fireball deals $4 magical damage (12.50% of all attributes) for a total of $5 damage.<br><br>12.0s Cooldown."
	PerkModifiers_Descr["artifact_fiery_eruption"]["type1"] = "Offensive"
	PerkModifiers_Descr["artifact_fiery_eruption"]["type2"] = "Fire"
	PerkModifiers_Descr["artifact_fiery_eruption"]["stats"] = {}
	PerkModifiers_Descr["artifact_fiery_eruption"]["stats"][1] = 24
	PerkModifiers_Descr["artifact_fiery_eruption"]["stats"][2] = 0.8
	PerkModifiers_Descr["artifact_fiery_eruption"]["stats"][3] = 700
	PerkModifiers_Descr["artifact_fiery_eruption"]["stats"][4] = 12.50
	PerkModifiers_Descr["artifact_fiery_eruption"]["stats"][5] = 300
	PerkModifiers_Descr["artifact_fiery_eruption"]["stats"][6] = 12.0
	PerkModifiers_Descr["artifact_holy_gush"] = {}
	PerkModifiers_Descr["artifact_holy_gush"]["title"] = "Holy Gush"
	PerkModifiers_Descr["artifact_holy_gush"]["descr"] = "Heals your hero equal to $1% of your health ($2 HP). Then emit a wave which heals all friendly heroes hit by $3% of the amount of overhealing ($4 heal with 100% overheal) and damages all enemies hit by $5% ($6 damage with 100% overheal) of the amount of overhealing. $7 Range.<br><br>20.0s Cooldown."
	PerkModifiers_Descr["artifact_holy_gush"]["type1"] = "Defensive"
	PerkModifiers_Descr["artifact_holy_gush"]["type2"] = "Holy"
	PerkModifiers_Descr["artifact_holy_gush"]["stats"] = {}
	PerkModifiers_Descr["artifact_holy_gush"]["stats"][1] = 30
	PerkModifiers_Descr["artifact_holy_gush"]["stats"][2] = 30
	PerkModifiers_Descr["artifact_holy_gush"]["stats"][3] = 30
	PerkModifiers_Descr["artifact_holy_gush"]["stats"][4] = 30
	PerkModifiers_Descr["artifact_holy_gush"]["stats"][5] = 60
	PerkModifiers_Descr["artifact_holy_gush"]["stats"][6] = 60
	PerkModifiers_Descr["artifact_holy_gush"]["stats"][7] = 1200.0
	PerkModifiers_Descr["artifact_holy_gush"]["stats"][8] = 20.0
	PerkModifiers_Descr["artifact_purifiying_mana_burst"] = {}
	PerkModifiers_Descr["artifact_purifiying_mana_burst"]["title"] = "Purifiying Mana Burst"
	PerkModifiers_Descr["artifact_purifiying_mana_burst"]["descr"] = "25% of your mana is taken ($2 mana) and amplified by $3% to heal all friendly heroes ($4 total heal). The most injured hero receives 35% of healing done. The rest is evenly split among all other heroes. Any overhealing done is inflicted to your last auto attacked target as magical damage. Unlimited range.<br><br>20.0s Cooldown."
	PerkModifiers_Descr["artifact_purifiying_mana_burst"]["type1"] = "Defensive"
	PerkModifiers_Descr["artifact_purifiying_mana_burst"]["type2"] = "Arcane"
	PerkModifiers_Descr["artifact_purifiying_mana_burst"]["stats"] = {}
	PerkModifiers_Descr["artifact_purifiying_mana_burst"]["stats"][1] = 25
	PerkModifiers_Descr["artifact_purifiying_mana_burst"]["stats"][2] = 25
	PerkModifiers_Descr["artifact_purifiying_mana_burst"]["stats"][3] = 400
	PerkModifiers_Descr["artifact_purifiying_mana_burst"]["stats"][4] = 400
	PerkModifiers_Descr["artifact_purifiying_mana_burst"]["stats"][5] = 35
	PerkModifiers_Descr["artifact_purifiying_mana_burst"]["stats"][6] = 20.0
	PerkModifiers_Descr["artifact_time_anomaly"] = {}
	PerkModifiers_Descr["artifact_time_anomaly"]["title"] = "Time Anomaly"
	PerkModifiers_Descr["artifact_time_anomaly"]["descr"] = "Resets all Cooldowns and lowers any Cooldowns by 30%, Mana costs by $2% and Cast times by $3% and increases Spell damage by $4% for $5 seconds.<br><br>45.0s Cooldown."
	PerkModifiers_Descr["artifact_time_anomaly"]["type1"] = "Supportive"
	PerkModifiers_Descr["artifact_time_anomaly"]["type2"] = "Arcane"
	PerkModifiers_Descr["artifact_time_anomaly"]["stats"] = {}
	PerkModifiers_Descr["artifact_time_anomaly"]["stats"][1] = 30
	PerkModifiers_Descr["artifact_time_anomaly"]["stats"][2] = 40
	PerkModifiers_Descr["artifact_time_anomaly"]["stats"][3] = 20
	PerkModifiers_Descr["artifact_time_anomaly"]["stats"][4] = 30
	PerkModifiers_Descr["artifact_time_anomaly"]["stats"][5] = 4
	PerkModifiers_Descr["artifact_time_anomaly"]["stats"][6] = 45.0
-- ### Dynamic Perk Modifier Description Table End ### --

PERKTYPES = {}
PERKTYPES[1] = "artifact"
PERKTYPES[2] = "glyph"

PerkTypes_Readable = {}

PerkTypes_Readable["artifact"] = "Artifact"
PerkTypes_Readable["glyph"] = "Glyph"

PerkTypes_Readable["offensive"] = "Offensive"
PerkTypes_Readable["defensive"] = "Defensive"
PerkTypes_Readable["supportive"] = "Supportive"
PerkTypes_Readable["economic"] = "Economic"

PerkTypes_Readable["arcane"] = "Arcane"
PerkTypes_Readable["shadow"] = "Shadow"
PerkTypes_Readable["holy"] = "Holy"
PerkTypes_Readable["lightning"] = "Lightning"
PerkTypes_Readable["earth"] = "Earth"
PerkTypes_Readable["fire"] = "Fire"

--PerkTypes_Readable["passive"] = "Passive"
--PerkTypes_Readable["triggered"] = "Triggered"
--PerkTypes_Readable["dealingdamage"] = "Dealing Damage"

PERK_MAX_LEVEL = 10000

LOOT_COUNT = {}
LOOT_COUNT["artifact"] = 8
LOOT_COUNT["glyph"] = 8

PERK_ACTIVE_MAX = {}
PERK_ACTIVE_MAX["artifact"] = 1
PERK_ACTIVE_MAX["glyph"] = 6

PERK_LOOT_TIME = 180

PERK_LEVEL_EFFECTIVENESS = 0.20

local PERK_REROLL_AMOUNT = {}
PERK_REROLL_AMOUNT["Classic"] = 1
if ClassicSubMode_Endless then
	PERK_REROLL_AMOUNT["Classic"] = 3
end
PERK_REROLL_AMOUNT["Challenger"] = 0
PERK_REROLL_AMOUNT["Free"] = 999999

local PERK_REROLL_STATUS = {}

local PERK_REPLACE_PERK_NAME = {}
local PERK_REPLACE_PERK_POS = {}

local LOOT_PERKS_TIMER1 = {}
local LOOT_PERKS_TIMER2 = {}

PERK_ABILITY_COOLDOWN1 = {}
PERK_ABILITY_COOLDOWN2 = {}

local PERKS_LOOTED = {}

local PerksPerPlayer = {}

PerksPerPlayer_Missed = {}

local PerksVote_Old_Vote = {}

local PerkModifiers_Glyph = {}
local PerkModifiers_Artifact = {}

PerkEffectivenessStats = {}

local PerkReplace_StartRound = 6

local AddPerkMode = {}

local AddPerkQueue = {}

-- FUNCTIONS

--SplitPerks()
local count = 0
for _,perk in pairs(PerkModifiers) do
	if perk:find("^glyph_") ~= nil then
		table.insert(PerkModifiers_Glyph, perk)
	else
		table.insert(PerkModifiers_Artifact, perk)
	end
end

if DEBUG then
	LOOT_COUNT["glyph"] = #PerkModifiers - 8
end

function PerkRerollInit()
	for i=0,GetPlayerCount()-1 do
		PERK_REROLL_STATUS[i] = PERK_REROLL_AMOUNT[ GameMode_Active ]
	end
end

function PerkReplaceInit()
	for i=0,GetPlayerCount()-1 do
		PERK_REPLACE_PERK_NAME[i] = ""
		PERK_REPLACE_PERK_POS[i] = 1
		
		PerkEffectivenessStats[i] = {}

		AddPerkQueue[i] = {}
	end
end

function GetPerkPickCount(hero, perkType) --return int
	local mods = hero:FindAllModifiers()

	local count = 0
	for i,mod in pairs(mods) do
		if string.match(mod:GetName(), perkType) then
			count = count + 1
		end
	end
	return count
end

function GetPerksPicked(hero, perkType) --return table(buff)
	local mods = hero:FindAllModifiers()

	local perks = {}
	for i,mod in pairs(mods) do
		if string.match(mod:GetName(), perkType) then
			table.insert(perks, tonumber(mod.perkID), mod)
		end
	end
	return perks
end

function FixPerkIDs(hero, perkType, perkID_removed) --return nothing
	local perksPicked = GetPerksPicked(hero, perkType)

	local perksModified = {}

	for _,mod in pairs( perksPicked ) do
		for key,value in pairs(mod) do
			if string.match(mod:GetName(), perkType) and mod.perkID > perkID_removed then
				mod.perkID = mod.perkID - 1
				break--table.insert(perksModified, mod:GetName())
			end
		end
	end
end

function GetPerkCost(perkType, level) --return int
	if perkType == "artifact" then
		return -200 * ( level * 0.25 )
	elseif perkType == "glyph" then
		return -400 * ( level * 0.25 )
	end
end

function GetRandomPerks(playerID, perkType, count) --return table(string)

	if DEBUG and DEBUG_MSG_Perks then
		print("DEBUG - GetRandomPerks(playerID, perkType, count) ===", playerID, perkType, count)
		CustomGameEventManager:Send_ServerToAllClients("debug_msg", { msg="DEBUG - GetRandomPerks(playerID, perkType, count) === "..tostring(playerID, perkType, count) } )
	end

	local choosenPerks = {}

	for i=1,count do

		if perkType == "glyph" then
			local rnd = RandomInt(1,#PerkModifiers_Glyph)
			newPerk = PerkModifiers_Glyph[ rnd ]
			table.remove(PerksPerPlayer[playerID]["glyph"], rnd)
		else
			local rnd = RandomInt(1,#PerkModifiers_Artifact)
			newPerk = PerkModifiers_Artifact[ rnd ]
			table.remove(PerksPerPlayer[playerID]["artifact"], rnd)
		end
		table.insert(choosenPerks, newPerk)
		
	end

	return choosenPerks
end

function GeneratePerksAllPlayers()
	for i=0,GetPlayerCount()-1 do
		PerksPerPlayer[i] = {}
		PerksPerPlayer[i]["glyph"] = PerkModifiers_Glyph
		PerksPerPlayer[i]["artifact"] = PerkModifiers_Artifact
	end
end

function GeneratePerksPlayer(playerID)
	SplitPerks()
	PerksPerPlayer[playerID] = {}
	PerksPerPlayer[playerID]["glyph"] = PerkModifiers_Glyph
	PerksPerPlayer[playerID]["artifact"] = PerkModifiers_Artifact
end

function SplitPerks()
	PerkModifiers_Glyph = {}
	PerkModifiers_Artifact = {}

	local count = 0
	for _,perk in pairs(PerkModifiers) do
		if perk:find("^glyph_") ~= nil then
			table.insert(PerkModifiers_Glyph, perk)
		else
			table.insert(PerkModifiers_Artifact, perk)
		end
	end

	return count
end

function RefreshPerkModifiers() --returns nothing

	if DEBUG and DEBUG_MSG_Perks then
		print("DEBUG - RefreshPerkModifiers() ===", nil)
		CustomGameEventManager:Send_ServerToAllClients("debug_msg", { msg="DEBUG - RefreshPerkModifiers() === "..tostring(nil) } )
	end

	for _,Hero in pairs(GetHeroesAliveEntities()) do
		for i,Modifier in pairs(PerkModifiers) do

			local modifier = Hero:FindModifierByName(Modifier)

			if modifier ~= nil then
				modifier:ForceRefresh()
			end
		end
	end

end

function LootPerks(playerID, addPerk, perkType) --returns nothing

	if DEBUG and DEBUG_MSG_Perks then
		print("DEBUG - LootPerks(playerID, addPerk, perkType) ===", playerID, addPerk, perkType)
		CustomGameEventManager:Send_ServerToAllClients("debug_msg", { msg="DEBUG - LootPerks(playerID, addPerk, perkType) === "..tostring(playerID, addPerk, perkType) } )
	end

	local round = GetRound() - 1
	if round < 1 then round = 1 end

	LootPerksStart(playerID, round, addPerk, perkType)

--[[
	local missed = false

	if PlayerResource:GetConnectionState(playerID) == 2 then --connected
		
		if AddPerkQueue[playerID][1] == nil or PerksPerPlayer_Missed[playerID] then

			if PerksPerPlayer_Missed[playerID] then
				missed = true
			end

			PerksPerPlayer_Missed[playerID] = false

			LootPerksStart(playerID, GetRound() - 1, addPerk, perkType)

		end

	else
		PerksPerPlayer_Missed[playerID] = true
	end

	local temp_table = {}
	temp_table["playerID"] = playerID
	temp_table["round"] = GetRound() - 1
	temp_table["addPerk"] = addPerk
	temp_table["perkType"] = perkType

	if PlayerResource:GetConnectionState(playerID) ~= 2 then --disconnected
		if temp_table["perkType"] == nil then
			if temp_table["round"] == 1 or temp_table["round"] == 4 or temp_table["round"] % 7 == 0 or temp_table["round"] % 10 == 0 then
				temp_table["perkType"] = "artifact"
			else
				temp_table["perkType"] = "glyph"
			end
		end
	end

	if DEBUG and DEBUG_MSG_Perks then
		CustomGameEventManager:Send_ServerToAllClients("debug_msg", { msg="DEBUG - LootPerks"..tostring(temp_table["playerID"]).." - "..tostring(temp_table["round"]).." - "..tostring(temp_table["addPerk"]).." - "..tostring(temp_table["perkType"]) } )
	end

	if missed then
		table.insert( AddPerkQueue[playerID], 1, temp_table )
	else
		table.insert( AddPerkQueue[playerID], temp_table )
	end
]]
end

function LootPerksStart(playerID, round, addPerk, perkType) --returns nothing

	if DEBUG and DEBUG_MSG_Perks then
		print("DEBUG - LootPerksStart(playerID, round, addPerk, perkType) ===", playerID, round, addPerk, perkType)
		CustomGameEventManager:Send_ServerToAllClients("debug_msg", { msg="DEBUG - LootPerksStart(playerID, round, addPerk, perkType) === "..tostring(playerID, round, addPerk, perkType) } )
	end

	local player = PlayerResource:GetPlayer(playerID)
	local time = 40

	CustomGameEventManager:Send_ServerToPlayer(player, "on_change_game_phase_perkspicker", { phase="pick" } )

	GeneratePerksPlayer(playerID)

	local perks = GenerateLootPerks(playerID, round, perkType)

	local time = PERK_LOOT_TIME

	LOOT_PERKS_TIMER1[playerID] = Timers:CreateTimer(function()

		CustomGameEventManager:Send_ServerToAllClients("on_update_perks_timer", { time=time } )

		time = time - 1

		if time == -1 then return end
		return 1.0
	end)

	LOOT_PERKS_TIMER2[playerID] = Timers:CreateTimer(time+1, function()

		LootPerks_Locked(playerID, nil)

	end)

end

function GenerateLootPerks(playerID, round, perkType) --returns table(string)

	if DEBUG and DEBUG_MSG_Perks then
		print("DEBUG - GenerateLootPerks(playerID, round, perkType) ===", playerID, round, perkType)
		CustomGameEventManager:Send_ServerToAllClients("debug_msg", { msg="DEBUG - GenerateLootPerks(playerID, round, perkType) === "..tostring(playerID, round, perkType) } )
	end

	local player = PlayerResource:GetPlayer(playerID)
	local hero = player:GetAssignedHero()
	local count = LOOT_COUNT[perkType]
	local typeColor = "#ffffff"

	if perkType == "artifact" then
		typeColor = "#fff194"
	elseif perkType == "glyph" then
		typeColor = "#ffa6c2"
	end

	local perks = GetRandomPerks(playerID, perkType, count)

	local reroll_status = PERK_REROLL_STATUS[playerID]

	local headline = "Manage your <font color='"..typeColor.."'>"..string.gsub(perkType, "(%a)([%w_']*)", titleCase).."s".."</font>!"

	CustomGameEventManager:Send_ServerToPlayer(player, "on_perks_init", { headline=headline, reroll=reroll_status, perkType=perkType } )

	for i=1,count do

		local enabled = true

		local costs = 0
		local level = 1

		local title = PerkModifiers_Descr[perks[i]]["title"]
		local descr = GenerateDynamicPerkDescription(player, perks[i], nil, level, true, false, false)
		local type1 = PerkModifiers_Descr[perks[i]]["type1"]
		local type2 = PerkModifiers_Descr[perks[i]]["type2"]

		local color1 = GetPerkTypeColor(type2)[1]
		local color2 = GetPerkTypeColor(type2)[2]

		costs = GetPerkCost(perkType, level)

		if costs*-1 > PlayerCurrencies[playerID][perkType] then
			enabled = false
		end	

		--Check if Max Perk Count reached
		if perkType == "artifact" then
			if GetPerkPickCount(hero, perkType) == PERK_ACTIVE_MAX["artifact"] then
				enabled = false
			end
		elseif perkType == "glyph" then
			if GetPerkPickCount(hero, perkType) == PERK_ACTIVE_MAX["glyph"] then
				enabled = false
			end
		end

		CustomGameEventManager:Send_ServerToPlayer(player, "on_new_perkspicker_line_perks", {
													type="buy",
													name=perks[i],
													title=title,
													descr=descr,
													type1=type1,type2=type2,
													level=tostring(level),
													costs=tostring(costs),
													pos=tostring(i-1), votes="0",
													color1=color1, color2=color2, gradient="100",
													enabled=enabled
													} )

		PERKS_LOOTED[playerID] = {}
	end

	-- Owned Perks for upgrade
	GenerateUpgradePerks(playerID, perkType)

	return perks
end

function GenerateDynamicPerkDescription(player, perk, perkID, level, choose, upgrade, calc) --returns string

	if DEBUG and DEBUG_MSG_Perks then
		print("DEBUG - GenerateDynamicPerkDescription(perk, perkID, player, choose, level, upgrade) ===", perk, perkID, player, choose, level, upgrade)
		CustomGameEventManager:Send_ServerToAllClients("debug_msg", { msg="DEBUG - GenerateDynamicPerkDescription(perk, perkID, player, choose, level, upgrade) === "..tostring(perk, perkID, player, choose, level, upgrade) } )
	end

	local caster = player:GetAssignedHero()

	local title = PerkModifiers_Descr[perk]["title"]
	local perk_descr = PerkModifiers_Descr[perk]["descr"]
	local type1 = PerkModifiers_Descr[perk]["type1"]
	local type2 = PerkModifiers_Descr[perk]["type2"]

	local stats = PerkModifiers_Descr[perk]["stats"]

	local spell_amp_info = false
	local spell_amp_apply = {}

	local stat = {}

	local effectiveness = CalculatePerkEffectiveness(player, perk, perkID, level, choose)
	local effectivenessLvlOnly = CalculatePerkEffectivenessLvlOnly(player, perk, perkID, level, choose, level)

	if perk == "artifact_bound_souls" then
		--stat[1] = stats[1] * effectiveness
		stat[2] = ( caster:GetStrength() + caster:GetAgility() + caster:GetIntellect() ) * ( stats[2] / 100 ) * effectiveness
		stat[3] = stats[3] / effectiveness
		--stat[4] = stats[4] * effectiveness
		stat[5] = ( caster:GetStrength() + caster:GetAgility() + caster:GetIntellect() ) * ( stats[5] / 100 ) * effectiveness
		--stat[6] = stats[6] * effectiveness
		stat[7] = stats[7] * effectiveness
		stat[8] = stats[8] * effectiveness
		stat[9] = stats[9] * effectiveness

		spell_amp_info = true
		spell_amp_apply[2] = true
		spell_amp_apply[5] = true
	end

	if perk == "artifact_purifiying_mana_burst" then
		--stat[1] = stats[1] / effectiveness
		stat[2] = caster:GetMaxMana() * ( stats[2] / 100 )
		stat[3] = stats[3] * effectiveness
		stat[4] = stat[2] * ( stats[4] / 100 )
		--stat[5] = stats[5] * effectiveness
		--stat[6] = stats[6] * effectiveness
	end

	if perk == "artifact_time_anomaly" then
		--stat[1] = stats[1] * effectiveness
		stat[2] = stats[2] * effectiveness
		stat[3] = stats[3] * effectiveness
		stat[4] = stats[4] * effectiveness
		stat[5] = stats[5] * effectiveness
		--stat[6] = stats[6] * effectiveness
	end

	if perk == "artifact_fiery_eruption" then
		--stat[1] = stats[1] * effectiveness
		--stat[2] = stats[2] * effectiveness
		stat[3] = stats[3] * effectiveness
		stat[4] = ( caster:GetStrength() + caster:GetAgility() + caster:GetIntellect() ) * ( stats[4] / 100 ) * effectiveness
		stat[5] = stat[4] * stats[1]
		--stat[6] = stats[6] * effectiveness

		spell_amp_info = true
		spell_amp_apply[4] = true
		spell_amp_apply[5] = true
	end

	if perk == "artifact_crunching_ground" then
		stat[1] = stats[1] * effectiveness
		stat[2] = stats[2] * effectiveness
		stat[3] = ( caster:GetStrength() + caster:GetAgility() + caster:GetIntellect() ) * ( stats[3] / 100 ) * effectiveness
		stat[4] = stats[4] * effectiveness
		--stat[5] = stats[5] * effectiveness

		spell_amp_info = true
		spell_amp_apply[3] = true
	end

	if perk == "artifact_celestial_barrage" then
		--stat[1] = stats[1] * effectiveness
		--stat[2] = stats[2] * effectiveness
		stat[3] = ( caster:GetStrength() + caster:GetAgility() + caster:GetIntellect() ) * ( stats[3] / 100 ) * effectiveness
		stat[4] = ( caster:GetStrength() + caster:GetAgility() + caster:GetIntellect() ) * ( stats[4] / 100 ) * effectiveness
		stat[5] = stat[4] * stats[1]
		--stat[6] = stats[6] * effectiveness
		stat[7] = stats[7] * effectiveness
		--stat[8] = stats[8] * effectiveness

		spell_amp_info = true
		spell_amp_apply[3] = true
		spell_amp_apply[4] = true
		spell_amp_apply[5] = true
	end

	if perk == "artifact_crackling_lightning" then
		stat[1] = ( caster:GetStrength() + caster:GetAgility() + caster:GetIntellect() ) * ( stats[1] / 100 ) * effectiveness
		--stat[2] = stats[2] * effectiveness
		stat[3] = stats[3] / effectiveness
		--stat[4] = stats[4] * effectiveness
		--stat[5] = stats[5] * effectiveness
		--stat[6] = stats[6] * effectiveness

		spell_amp_info = true
		spell_amp_apply[1] = true
	end

	if perk == "artifact_holy_gush" then
		stat[1] = stats[1] * effectiveness
		stat[2] = caster:GetMaxHealth() * ( stats[2] / 100 ) * effectiveness
		stat[3] = stats[3] * effectiveness
		stat[4] = stat[2] * ( stats[3] / 100 ) * effectiveness
		stat[5] = stats[5] * effectiveness
		stat[6] = stat[2] * ( stats[5] / 100 ) * effectiveness
		stat[7] = stats[7] * effectiveness
		--stat[8] = stats[8] * effectiveness

		spell_amp_info = true
		spell_amp_apply[6] = true
	end

	-- GLYPHS

	if perk == "glyph_blazing_gold" then
		stat[1] = stats[1] * effectiveness
	end
	if perk == "glyph_blazing_knowledge" then
		stat[1] = stats[1] * effectiveness
	end
	if perk == "glyph_blazing_mind" then
		stat[1] = stats[1] * effectiveness
	end
	if perk == "glyph_blazing_power" then
		stat[1] = stats[1] * effectiveness
	end
	if perk == "glyph_mystic_book" then
		stat[1] = stats[1] * effectiveness
	end
	if perk == "glyph_mystic_flask" then
		stat[1] = stats[1] * effectiveness
		stat[2] = stats[2] / effectiveness
	end
	if perk == "glyph_mystic_rune" then
		stat[1] = stats[1] * effectiveness
	end
	if perk == "glyph_mystic_stream" then
		stat[1] = stats[1] * effectiveness
	end
	if perk == "glyph_petrified_cloak" then
		stat[1] = stats[1] * effectiveness
		if stat[1] > 100.0 then stat[1] = 100.0 end
		stat[2] = stats[2] * effectiveness
	end
	if perk == "glyph_petrified_jewel" then
		stat[1] = stats[1] * effectiveness
	end
	if perk == "glyph_petrified_particles" then
		stat[1] = stats[1] * effectiveness
	end
	if perk == "glyph_petrified_soil" then
		stat[1] = stats[1] * effectiveness
	end
	if perk == "glyph_sacred_bracing" then
		stat[1] = stats[1] / effectiveness
		stat[2] = stats[2] * effectiveness
	end
	if perk == "glyph_sacred_glory" then
		stat[1] = stats[1] * effectiveness
	end
	if perk == "glyph_sacred_vigor" then
		stat[1] = stats[1] * effectiveness
	end
	if perk == "glyph_sacred_vitality" then
		stat[1] = stats[1] * effectiveness
		stat[2] = stats[2] / effectiveness
	end
	if perk == "glyph_sparking_agility" then
		stat[1] = stats[1] * effectiveness
	end
	if perk == "glyph_sparking_alacrity" then
		stat[1] = stats[1] * effectiveness
	end
	if perk == "glyph_sparking_swiftness" then
		stat[1] = stats[1] * effectiveness
	end
	if perk == "glyph_sparking_thunder" then
		stat[1] = stats[1] * effectiveness
	end
	if perk == "glyph_umbral_energy" then
		stat[1] = stats[1] * effectiveness
	end
	if perk == "glyph_umbral_force" then
		stat[1] = stats[1] * effectiveness
	end
	if perk == "glyph_umbral_fragments" then
		stat[1] = stats[1] * effectiveness
	end
	if perk == "glyph_umbral_potency" then
		stat[1] = stats[1] / effectiveness
		stat[2] = stats[2] * effectiveness
	end

	for i,st in pairs(stat) do
		if st ~= nil then

			local base_number = st
			local spell_amp_bonus = 0
			local final_number = 0

			if type(st) == "number" then

				if spell_amp_apply[i] then
					spell_amp_bonus = base_number * ( caster:GetSpellAmplification( false ) )
				end

				base_number = math.floor(base_number * 100) / 100
				spell_amp_bonus = math.floor(spell_amp_bonus * 100) / 100

				final_number = base_number + spell_amp_bonus
				final_number = math.floor(final_number * 100) / 100
			end
			local replacement_txt = "<font color='#f4dc42'>"..tostring(base_number).."</font>"

			if spell_amp_apply[i] then
					replacement_txt = replacement_txt .. "<font color='#47e81b'>$(plus)"..tostring(spell_amp_bonus).."</font>"
					replacement_txt = replacement_txt .. " (<font color='#ff8066'>"..tostring(final_number).."</font>)"
			end

			perk_descr = perk_descr:gsub("$"..i, replacement_txt)
		end
	end

	local descr = ""

	local effec_color = "#ffffff"
	if effectiveness > 1.0 then
		effec_color = "#68f442"
	elseif effectiveness < 1.0 then
		effec_color = "#ff7070"
	end

	--descr = descr .. "<br><br>"
	descr = descr .. "<b>Description:</b><br>"
	descr = descr .. perk_descr

	descr = descr .. "<br><br>"
	descr = descr .. "<b>Effectiveness: <font color='"..effec_color.."'>"..tostring(math.floor(effectiveness*100)).."%</font></b>"

	if upgrade then
		descr = descr .. " <font color='#42f5d1'><i>($(plus)"..(PERK_LEVEL_EFFECTIVENESS*100).."%)</i></font>"
	end

	local i = 0
	local effectivenessDescr = {}
	effectivenessDescr["positive"] = ""
	effectivenessDescr["negative"] = ""
	for eff_type,value in pairs( PerkModifiers_Descr[perk] ) do
		if string.match(eff_type, "effectiveness_") then

			local effectivenessType = "positive"

			value = value * effectivenessLvlOnly
			value = math.floor(value * 100) / 100

			local effec_color = "#68f442"
			local sign = "$(plus)"
			if value < 0 then
				effec_color = "#ff7070"
				sign = "$(minus)"

				effectivenessType = "negative"
			end

			if i == 0 then
				effectivenessDescr["positive"] = effectivenessDescr["positive"] .. "<br><br>Changes effectiveness of following types:"
			end

			local ptype1 = stringSplit(eff_type, "_")[2]
			local ptype2 = stringSplit(eff_type, "_")[3]

			--effectivenessDescr[effectivenessType] = effectivenessDescr[effectivenessType] .. "<br>Increases effectiveness of Perks with the type $(" .. ptype .. ")" .. PerkTypes_Readable[ ptype ] .. " by " .. value .. "%."
			effectivenessDescr[effectivenessType] = effectivenessDescr[effectivenessType] .. "<br><font color='".. effec_color .. "'>".. sign .."<b>" .. value .. "%</b></font> $(" .. ptype1 .. ")" .. PerkTypes_Readable[ ptype1 ]

			if ptype2 ~= nil then
				effectivenessDescr[effectivenessType] = effectivenessDescr[effectivenessType] .. " $(" .. ptype2 .. ")" .. PerkTypes_Readable[ ptype2 ]
			end

			i = i + 1
		end
	end

	descr = descr .. effectivenessDescr["positive"]
	descr = descr .. effectivenessDescr["negative"]

	descr = descr .. "<br><br><b>Additional Info:</b>"

	if spell_amp_info then
		descr = descr .. "<br>$(info)This Perk's damage benefits from Spell Amplification and it's bonus is shown in green.<br>"
	end

	descr = descr .. "<br>$(info)This Perk Stacks but shares the Effectiveness with Perks with the exact same name. (<i>" .. title .. "</i>)"

	--[[
	if type1 == "Dealing Damage" and type2 == "Offensive" then
		descr = descr .. "<br><br>"
		descr = descr .. "$(info)This Perk reduces the Effectiveness of Perks with the same type by 25%. ($(dealingdamage)" .. PerkModifiers_Descr[perk]["type1"] .. " / $(offensive)" .. PerkModifiers_Descr[perk]["type2"] .. ")"
	end
	]]
	return descr
end

function CalculatePerkEffectiveness(player, perk, perkID, level, choose) --returns string

	if DEBUG and DEBUG_MSG_Perks then
		print("DEBUG - CalculatePerkEffectiveness(perk, perkID, player, choose, level) ===", perk, perkID, player, choose, level)
		CustomGameEventManager:Send_ServerToAllClients("debug_msg", { msg="DEBUG - CalculatePerkEffectiveness(perk, perkID, player, choose, level) === "..tostring(perk, perkID, player, choose, level) } )
	end

	local caster = player:GetAssignedHero()
	local playerID = caster:GetPlayerOwnerID()

	local type1 = PerkModifiers_Descr[perk]["type1"]
	local type2 = PerkModifiers_Descr[perk]["type2"]

	local effectiveness = 1.0

	--SAME TYPE MALUS
	--[[
	if not choose then
		local mod_same_type = caster:FindAllModifiersByName(perk)

		if mod_same_type[1] ~= nil then
			for key,value in pairs(mod_same_type) do
				if type(key) == "string" then
					if string.match(key, "effectiveness_") and value < 0 then

						local ptype1 = PerkTypes_Readable[ stringSplit(key, "_")[2] ]
						local ptype2 = PerkTypes_Readable[ stringSplit(key, "_")[3] ]

						local ptype = ptype1
						if ptype2 ~= nil then
							ptype = ptype1 .. "_" .. ptype2
						end
						effectiveness = effectiveness + (value * -1 / 100)
					end
				end
			end
		end
	end
]]
	--

	local perkTypeAddedEffectiveness = 1.0

	for _,perkType in pairs( PERKTYPES ) do
		for i,mod in pairs( GetPerksPicked(caster, perkType) ) do
			for key,value in pairs(mod) do
				if type(key) == "string" then
					if string.match(key, "^effectiveness_.+") then

						local ptype1 = PerkTypes_Readable[ stringSplit(key, "_")[2] ]
						local ptype2 = PerkTypes_Readable[ stringSplit(key, "_")[3] ]

						local ptype = ptype1
						if ptype2 ~= nil then
							ptype = ptype1 .. "_" .. ptype2
						end

						if ptype == type1 or ptype == type2 then
							local levelAddedEffectiveness = ( tonumber(value) / 100 ) * ( ( tonumber(mod.level) - 1 ) * PERK_LEVEL_EFFECTIVENESS )
							levelAddedEffectiveness = levelAddedEffectiveness + ( tonumber(value) / 100 )
							perkTypeAddedEffectiveness = perkTypeAddedEffectiveness + levelAddedEffectiveness
						end

					end
				end
			end
		end
	end

	effectiveness = effectiveness * perkTypeAddedEffectiveness

	--[[

	for perktype,eff in pairs( PerkEffectivenessStats[playerID] ) do

		local ptype1 = stringSplit(perktype, "_")[1]
		local ptype2 = stringSplit(perktype, "_")[2]

		if ptype2 == nil then
			if type1 == ptype1 or type2 == ptype1 then
				effectiveness = effectiveness + tonumber(eff)
			end
		else
			if type1 == ptype1 and type2 == ptype2 then
				effectiveness = effectiveness + tonumber(eff)
			end
		end

	end
	]]

	--LEVEL
	if level == PERK_MAX_LEVEL-1 and choose then level = level - 1 end

	effectiveness = effectiveness + ( (level-1) * PERK_LEVEL_EFFECTIVENESS )
	--SAME NAME MALUS
	local count_same_perk = #caster:FindAllModifiersByName(perk)

	if count_same_perk == 0 then
		count_same_perk = 1
	elseif choose then
		count_same_perk = count_same_perk + 1
	end

	effectiveness = effectiveness / count_same_perk

	--

	if effectiveness < 0.0 then effectiveness = 0.0 end

	return effectiveness
end

function CalculatePerkEffectivenessLvlOnly(player, perk, perkID, level, choose, level) --returns string

	if DEBUG and DEBUG_MSG_Perks then
		print("DEBUG - CalculatePerkEffectivenessLvlOnly(perk, perkID, player, choose, level) ===", perk, perkID, player, choose, level)
		CustomGameEventManager:Send_ServerToAllClients("debug_msg", { msg="DEBUG - CalculatePerkEffectivenessLvlOnly(perk, perkID, player, choose, level) === "..tostring(perk, perkID, player, choose, level) } )
	end

	local caster = player:GetAssignedHero()
	local playerID = caster:GetPlayerOwnerID()

	local effectiveness = 1.0

	--LEVEL
	if level == PERK_MAX_LEVEL-1 and choose then level = level - 1 end

	effectiveness = effectiveness + ( (level-1) * PERK_LEVEL_EFFECTIVENESS )

	--

	if effectiveness < 0.0 then effectiveness = 0.0 end

	return effectiveness
end

function LootPerks_Locked(playerID, perkType) --returns nothing

	if DEBUG and DEBUG_MSG_Perks then
		print("DEBUG - LootPerks_Locked(playerID, perkType) ===", playerID, perkType)
		CustomGameEventManager:Send_ServerToAllClients("debug_msg", { msg="DEBUG - LootPerks_Locked(playerID, perkType) === "..tostring(playerID, perkType) } )
	end

	local player = PlayerResource:GetPlayer(playerID)
	--[[
	local hero = player:GetAssignedHero()
	local perkMod = nil
	local addPerk = AddPerkMode[playerID]

	local round = GetRound() - 1
	]]

	Timers:RemoveTimer(LOOT_PERKS_TIMER1[playerID])
	Timers:RemoveTimer(LOOT_PERKS_TIMER2[playerID])

	CustomGameEventManager:Send_ServerToPlayer(player, "on_change_game_phase_perkspicker", { phase="no-pick" } )
	CustomGameEventManager:Send_ServerToPlayer(player, "perks_removeall", {} )

	if perkType == "artifact" then
		LootPerks( playerID, nil, "glyph" )
		ChecklistUpdateItems(playerID, {"artifact"}, "done")
		ChecklistUpdateItems(playerID, {"glyph"}, "in_progress")
	end
	if perkType == "glyph" then
		ChecklistUpdateItems(playerID, {"glyph"}, "done")
		ChecklistUpdateItems(playerID, {"level"}, "in_progress")
		ChecklistUpdateItems(playerID, {"gold"}, "in_progress")
	end

end

function GameMode:Perks_Lock(params)
	local playerID = params.PlayerID
	--local perkName = params.name
	local perkType = params.perkType
	LootPerks_Locked(playerID, perkType)
end

function GameMode:Perks_Upvote(params)

	if DEBUG and DEBUG_MSG_Perks then
		print("DEBUG - GameMode:Perks_Upvote(params) ===", DeepPrintTable(params))
		CustomGameEventManager:Send_ServerToAllClients("debug_msg", { msg="DEBUG - GameMode:Perks_Upvote(params) === "..tostring(params) } )
	end

	if params.enabled == 0 then return end

	local playerID = params.playerID
	local player = PlayerResource:GetPlayer(playerID)
	local perkName = params.name
	local perkPos = tonumber(params.pos)
	local perkID = nil
	local perkType = nil
	local hero = player:GetAssignedHero()
	local perkMod = nil
	local addPerk = AddPerkMode[playerID]
	local level = tonumber(params.level)
	local round = GetRound() - 1

	if string.match(perkName, "artifact") then
		perkType = "artifact"
	elseif string.match(perkName, "glyph") then
		perkType = "glyph"
	end

	-- BUY PERK
	if level == 1 then

		--Check if Max Perk Count reached
		if perkType == "artifact" then
			if GetPerkPickCount(hero, perkType) == PERK_ACTIVE_MAX["artifact"] then return end
		elseif perkType == "glyph" then
			if GetPerkPickCount(hero, perkType) == PERK_ACTIVE_MAX["glyph"] then return end
		end

		perkID = GetPerkPickCount(hero, perkType)

		GenerateDynamicPerkDescription(player, perkName, perkID, level, false, false, true)

		local perkEffectiveness = CalculatePerkEffectiveness(player, perkName, perkID, level, false)
		perkMod = hero:AddNewModifier(hero, nil, perkName, { perkName=perkName, perkID=perkID, level=level, perkEffectiveness=perkEffectiveness })

		if perkType == "artifact" then
			--player.ability_usable_timer = Perks_UseAbility_Usable(playerID, perkName, perkMod.perkID)

			local ability = hero:FindAbilityByName("artifact_ability")
			ability:SetActivated(true)
			ability.perkName = perkName
			ability.perkID = perkID
		end

		AddPerkMode[playerID] = false

		if PERKS_LOOTED[playerID] == nil then PERKS_LOOTED[playerID] = {} end
		table.insert(PERKS_LOOTED[playerID], {perkName=perkName, perkID=perkID, perkPos=perkPos})
	end

	--UPGRADE PERK
	if level > 1 then

		local modifiers = hero:FindAllModifiersByName( perkName )

		for i,mod in ipairs( modifiers ) do

			if tonumber(mod.perkID) == perkPos then

				perkID = tonumber(mod.perkID)
				perkMod = mod
--[[
				if mod.additional_modifier ~= nil then
					for _,additional_mod in pairs( mod.additional_modifier ) do
						if additional_mod ~= nil then
							if not additional_mod:IsNull() then
								
								additional_mod:Destroy()
							end
						end
					end
				end

				mod:Destroy()
]]
				break
			end
		end

		--GenerateDynamicPerkDescription(player, perkName, perkMod.perkID, level, false, false, true)

		--local perkEffectiveness = CalculatePerkEffectiveness(player, perkName, perkID, level, false)
		--local perkMod = hero:AddNewModifier(hero, nil, perkName, { perkName=perkName, perkID=perkID, level=level, perkEffectiveness=perkEffectiveness })
		
		local perkEffectiveness = CalculatePerkEffectiveness(player, perkMod:GetName(), perkMod.perkID, level, false)
		perkMod.perkEffectiveness = perkEffectiveness
		perkMod.level = level

	end

	--PAY
	Currency_Modify(playerID, GetPerkCost(perkType, level), perkType)

	--Add to Upgrade Tab
	GenerateUpgradePerks(playerID, perkType)
	GenerateActivePerks(playerID)

--[[
	Timers:CreateTimer(0.1, function()
		--Disable bought perk
		if level == 1 then
			CustomGameEventManager:Send_ServerToPlayer(player, "on_buy_perk", { type="buy", name=perkName, pos=perkID } )
		end
	end)
]]
	local perkCountReached = false
	--Check if Max Perk Count reached
	if perkType == "artifact" then
		if GetPerkPickCount(hero, perkType) == PERK_ACTIVE_MAX["artifact"] then
			perkCountReached = true
			CustomGameEventManager:Send_ServerToPlayer(player, "disable_all_perks", {} )
		end
	elseif perkType == "glyph" then
		if GetPerkPickCount(hero, perkType) == PERK_ACTIVE_MAX["glyph"] then
			perkCountReached = true
			CustomGameEventManager:Send_ServerToPlayer(player, "disable_all_perks", {} )
		end
	end

	if not perkCountReached then
		CustomGameEventManager:Send_ServerToPlayer(player, "disable_perks_too_expensive", { currency=PlayerCurrencies[playerID][perkType] } )
	end

	--Disable already bought perks
	local array = ""
	for i,perk in pairs( PERKS_LOOTED[playerID] ) do
		array = array.."buy"..perk["perkName"]..perk["perkPos"]..";"
	end
	array = array:sub(1, -2)
	CustomGameEventManager:Send_ServerToPlayer(player, "disable_bought_perks", { array=array } )

--[[
	if GetPerkCost(perkType, 1)*-1 > PlayerCurrencies[playerID][perkType] then
		CustomGameEventManager:Send_ServerToPlayer(player, "disable_all_perks", {} )
	end

	-- Queue

	table.remove(AddPerkQueue[playerID], 1)

	if AddPerkQueue[playerID][1] ~= nil then

		local playerID = AddPerkQueue[playerID][1]["playerID"]
		local round = AddPerkQueue[playerID][1]["round"]
		local addPerk = AddPerkQueue[playerID][1]["addPerk"]
		local perkType = AddPerkQueue[playerID][1]["perkType"]

		LootPerksStart(playerID, round, addPerk, perkType)
	end
	]]
end

function GameMode:Perks_Sell(params)

	if DEBUG and DEBUG_MSG_Perks then
		print("DEBUG - GameMode:Perks_Sell(params) ===", DeepPrintTable(params))
		CustomGameEventManager:Send_ServerToAllClients("debug_msg", { msg="DEBUG - GameMode:Perks_Sell(params) === "..tostring(params) } )
	end

	local playerID = params.playerID
	local player = PlayerResource:GetPlayer(playerID)
	local perkName = params.name
	local perkPOS = tonumber(params.pos)
	local perkID = nil
	local perkType = nil
	local hero = player:GetAssignedHero()
	local perkMod = nil
	local addPerk = AddPerkMode[playerID]
	local level = tonumber(params.level)
	local round = GetRound() - 1

	if string.match(perkName, "artifact") then
		perkType = "artifact"
	elseif string.match(perkName, "glyph") then
		perkType = "glyph"
	end

	--DELETE PERK
	if perkType == "artifact" then
		hero:FindAbilityByName("artifact_ability"):SetActivated(false)
	end

	local modifiers = hero:FindAllModifiersByName( perkName )

	local perkID_removed = nil

	for i,mod in ipairs( modifiers ) do

		if tonumber(mod.perkID) == perkPOS then

			perkID = tonumber(mod.perkID)
			perkID_removed = perkID

			if mod.additional_modifier ~= nil then
				for _,additional_mod in pairs( mod.additional_modifier ) do
					if additional_mod ~= nil then
						if not additional_mod:IsNull() then
							additional_mod:Destroy()
						end
					end
				end
			end

			mod:Destroy()

			break

		end
	end

	--Cast Range UI and Cooldown UI reset
	hero:SetModifierStackCount("castrange_modifier_ability", hero, 0)
	hero:SetModifierStackCount("cooldown_modifier_ability", hero, 0)

	local modifiers = hero:FindAllModifiersByName( perkName )
--[[
	for i,mod in ipairs( modifiers ) do
		mod.perkID = i
	end

	local modifiers = hero:FindAllModifiers()

	local perksPicked = GetPerksPicked(hero, perkType)

	for i,mod in ipairs( modifiers ) do
		for key,value in pairs(mod) do
			if type(key) == "string" then
				if string.match(key, "^glyph") then
					mod.perkID = i
				end
			end
		end
	end
]]

	--

	FixPerkIDs(hero, perkType, perkID_removed)
	GenerateUpgradePerks(playerID, perkType)
	GenerateActivePerks(playerID)

	--

	--GET CURRENCY
	Currency_Modify(playerID, GetPerkCost(perkType, level-1)*-1, perkType)

	--Check if Max Perk Count not reached anymore
	if perkType == "artifact" then
		if GetPerkPickCount(hero, perkType) < PERK_ACTIVE_MAX["artifact"] then
			CustomGameEventManager:Send_ServerToPlayer(player, "enable_all_perks", {} )
		end
	elseif perkType == "glyph" then
		if GetPerkPickCount(hero, perkType) < PERK_ACTIVE_MAX["glyph"] then
			CustomGameEventManager:Send_ServerToPlayer(player, "enable_all_perks", {} )
		end
	end

	--Disable already bought perks
	for i,perk in pairs( PERKS_LOOTED[playerID] ) do
		if perk["perkName"] == perkName then
			PERKS_LOOTED[playerID][i] = nil
		end
	end

	local array = ""
	for i,perk in pairs( PERKS_LOOTED[playerID] ) do
		if perk ~= nil then
			array = array.."buy"..perk["perkName"]..perk["perkPos"]..";"
		end
	end
	array = array:sub(1, -2)
	CustomGameEventManager:Send_ServerToPlayer(player, "disable_bought_perks", { array=array } )

end

function GameMode:Perks_Reroll(params)

	if DEBUG and DEBUG_MSG_Perks then
		print("DEBUG - GameMode:Perks_Reroll(params) ===", DeepPrintTable(params))
		CustomGameEventManager:Send_ServerToAllClients("debug_msg", { msg="DEBUG - GameMode:Perks_Reroll(params) === "..tostring(params) } )
	end

	local playerID = params.PlayerID
	local player = PlayerResource:GetPlayer(playerID)
	local perkType = params.perkType

	PERK_REROLL_STATUS[playerID] = PERK_REROLL_STATUS[playerID] - 1

	PerksVote_Old_Vote[playerID+1] = nil

	CustomGameEventManager:Send_ServerToPlayer(player, "perks_removeall", {} )

	Timers:CreateTimer(0.1, function()
		GenerateLootPerks(playerID, nil, perkType)
	end)
end

function GameMode:Perks_Skip(params)
	local playerID = params.PlayerID
	local player = PlayerResource:GetPlayer(playerID)
	LootPerks_Locked(playerID, nil)
end

function GameMode:Perks_Replace(params)
	local round = GetRound() - 1

	if round >= PerkReplace_StartRound and ClassicSubMode_Endless then

		local playerID = params.PlayerID
		local player = PlayerResource:GetPlayer(playerID)

		local perkName = params.name
		local perkPos = tonumber(params.pos)

		PERK_REPLACE_PERK_NAME[playerID] = perkName
		PERK_REPLACE_PERK_POS[playerID] = perkPos

		CustomGameEventManager:Send_ServerToPlayer(player, "perks_replacetxt", { name=perkName } )

	end
end

function GenerateUpgradePerks(playerID, perkType)

	if DEBUG and DEBUG_MSG_Perks then
		print("DEBUG - GenerateUpgradePerks(playerID, perkType) ===", playerID, perkType)
		CustomGameEventManager:Send_ServerToAllClients("debug_msg", { msg="DEBUG - GenerateUpgradePerks(playerID, perkType) === "..tostring(playerID, perkType) } )
	end

	local player = PlayerResource:GetPlayer(playerID)
	local hero = player:GetAssignedHero()

	CustomGameEventManager:Send_ServerToPlayer(player, "perks_removeall_upgrade", {} )

	local perksPicked = GetPerksPicked(hero, perkType)

	Timers:CreateTimer(function()
		if GetPerkPickCount(hero, perkType) > 0 then
			for i,mod in pairs(perksPicked) do

				local enabled = true

				local costs = 0
				local level = 0
				local level_current = mod.level
				local level_upgraded = level_current + 1

				if level_current == PERK_MAX_LEVEL then
					level = level_current
					costs = -1
					enabled = false
				else
					level = level_upgraded
					costs = GetPerkCost(perkType, level)
					enabled = true
				end

				if costs*-1 > PlayerCurrencies[playerID][perkType] then
					enabled = false
				end

				local title = PerkModifiers_Descr[mod:GetName()]["title"]
				local descr = GenerateDynamicPerkDescription(player, mod:GetName(), i, level, false, true, false)
				local type1 = PerkModifiers_Descr[mod:GetName()]["type1"]
				local type2 = PerkModifiers_Descr[mod:GetName()]["type2"]

				local color1 = GetPerkTypeColor(type2)[1]
				local color2 = GetPerkTypeColor(type2)[2]

				CustomGameEventManager:Send_ServerToPlayer(player, "on_new_perkspicker_line_perks", {
															type="upgrade",
															name=mod:GetName(),
															title=title,
															descr=descr,
															type1=type1,type2=type2,
															level=tostring(level),
															costs=tostring(costs),
															pos=tostring(i), votes="0",
															color1=color1, color2=color2, gradient="100",
															enabled=enabled
															} )
			end
		end
	end)
end

function GenerateActivePerks(playerID)

	if DEBUG and DEBUG_MSG_Perks then
		print("DEBUG - GenerateActivePerks(playerID) ===", playerID)
		CustomGameEventManager:Send_ServerToAllClients("debug_msg", { msg="DEBUG - GenerateActivePerks(playerID) === "..tostring(playerID) } )
	end

	local player = PlayerResource:GetPlayer(playerID)
	local hero = player:GetAssignedHero()

	CustomGameEventManager:Send_ServerToPlayer(player, "activeperks_removeall", {} )

	Timers:CreateTimer(function()

		for _,perkType in pairs( PERKTYPES ) do

			local perksPicked = GetPerksPicked(hero, perkType)
			if GetPerkPickCount(hero, perkType) > 0 then
				for i,mod in pairs(perksPicked) do

					local title = PerkModifiers_Descr[mod:GetName()]["title"]
					local descr = GenerateDynamicPerkDescription(player, mod:GetName(), mod.perkID, mod.level, false, false, false)
					local type1 = PerkModifiers_Descr[mod:GetName()]["type1"]
					local type2 = PerkModifiers_Descr[mod:GetName()]["type2"]
					local costs = 0
					local level = mod.level

					local color1 = GetPerkTypeColor(type2)[1]
					local color2 = GetPerkTypeColor(type2)[2]

					if string.match(mod:GetName(), "glyph") then
						costs = GetPerkCost("glyph", level)
					else
						costs = GetPerkCost("artifact", level)
					end

					local enabled = true
					CustomGameEventManager:Send_ServerToPlayer(player, "on_new_activeperkspicker_line_activeperks", {
																name=mod:GetName(),
																title=title,
																descr=descr,
																type1=type1,type2=type2,
																level=tostring(level),
																costs=tostring(costs),
																pos=tostring(mod.perkID), votes="0",
																color1=color1, color2=color2, gradient="100",
																bordercolor=bordercolor, enabled=enabled
																} )

					local perkEffectiveness = CalculatePerkEffectiveness(player, mod:GetName(), mod.perkID, level, false)
					mod.perkEffectiveness = perkEffectiveness
				end
			end
		end
	end)
end

function PerkAppearance_Active(playerID, perk, id, bordercolor, time)
	local player = PlayerResource:GetPlayer(playerID)

	CustomGameEventManager:Send_ServerToPlayer(player, "on_active_perk_change_appearance", {
												name=perk, id=id, bordercolor=bordercolor, time=time } )
end

function PerkAppearance_Inactive(playerID, perk, id, time)
	local player = PlayerResource:GetPlayer(playerID)

	CustomGameEventManager:Send_ServerToPlayer(player, "on_inactive_perk_change_appearance", {
												name=perk, id=id, time=time } )
end

function Change_PerkEffectivenessStats(buff, add)
--[[
	local playerID = buff:GetParent():GetPlayerOwnerID()

	if DEBUG and DEBUG_MSG_Perks then
		print("DEBUG - Change_PerkEffectivenessStats(buff, add) ===", buff, add, playerID)
		CustomGameEventManager:Send_ServerToAllClients("debug_msg", { msg="DEBUG - Change_PerkEffectivenessStats(buff, add) === "..tostring(buff, add, playerID) } )
	end

	local perkType = ""
	if string.match(buff:GetName(), "artifact") then perkType = "artifact"
	elseif string.match(buff:GetName(), "glyph") then perkType = "glyph" end

	local saved_effectiveness = {}

	for key,value in pairs(buff) do
		if type(key) == "string" then
			if string.match(key, "^effectiveness_.+") then

				local ptype1 = PerkTypes_Readable[ stringSplit(key, "_")[2] ]
				local ptype2 = PerkTypes_Readable[ stringSplit(key, "_")[3] ]

				local ptype = ptype1
				if ptype2 ~= nil then
					ptype = ptype1 .. "_" .. ptype2
				end

				if PerkEffectivenessStats[ playerID ][ ptype ] == nil then
					PerkEffectivenessStats[ playerID ][ ptype ] = 0
				end
print(" - DEBUG - Change_PerkEffectivenessStats", buff:GetName(), buff.perkID)
print(" - DEBUG - Change_PerkEffectivenessStats", ptype)
				if add then
					print(" - DEBUG - Change_PerkEffectivenessStats ADD", value, buff.perkEffectiveness)
					value = value * buff.perkEffectiveness
					print(" - DEBUG - Change_PerkEffectivenessStats ADD", value)
					table.insert(saved_effectiveness, { name=ptype.."_saved_effectiveness", value=value } )
					print(" - DEBUG - Change_PerkEffectivenessStats ADD", buff[ptype.."_saved_effectiveness"])
					PerkEffectivenessStats[ playerID ][ ptype ] = PerkEffectivenessStats[ playerID ][ ptype ] + (value / 100)
				else
					value = buff[ptype.."_saved_effectiveness"]
					print(" - DEBUG - Change_PerkEffectivenessStats REMOVE", value)
					PerkEffectivenessStats[ playerID ][ ptype ] = PerkEffectivenessStats[ playerID ][ ptype ] - (value / 100)
				end
			end
		end
	end

	for _,values in pairs(saved_effectiveness) do
		buff[ values["name"] ] = values["value"]
	end
]]
end

function GetPerkTypeColor(type2) --return table
	local colors = {}

	if type2 == "Arcane" then
		table.insert(colors, "#fc88fc")
		table.insert(colors, "#ffccff")
	elseif type2 == "Shadow" then
		table.insert(colors, "#9013fe")
		table.insert(colors, "#c17aff")
	elseif type2 == "Holy" then
		table.insert(colors, "#f8e71c")
		table.insert(colors, "#faf4a7")
	elseif type2 == "Lightning" then
		table.insert(colors, "#0038ff")
		table.insert(colors, "#7896ff")
	elseif type2 == "Earth" then
		table.insert(colors, "#b57204")
		table.insert(colors, "#ffc86e")
	elseif type2 == "Fire" then
		table.insert(colors, "#d0021b")
		table.insert(colors, "#de5b6b")
	end

	return colors
end
--[[
function GameMode:Perks_UseAbility(params)
	local playerID = params.PlayerID
	local player = PlayerResource:GetPlayer(playerID)
	local hero = player:GetAssignedHero()
	local perkName = params.name
	local perkID = tonumber(params.pos)

	if hero:IsStunned() or hero:IsSilenced() or not hero:IsAlive() then return end

	local modifiers = hero:FindAllModifiersByName( perkName )

	for i,mod in ipairs( modifiers ) do

		if tonumber(mod.perkID) == perkID then

			if PERK_ABILITY_COOLDOWN1[playerID] == nil then
				mod.activated = true

				local time = mod.cooldown

				if DEBUG and DEBUG_MSG_Perks then
					time = 5
				end

				PERK_ABILITY_COOLDOWN1[playerID] = Timers:CreateTimer(function()
					CustomGameEventManager:Send_ServerToPlayer(player, "on_update_activeperks_ability_cooldown", { name=perkName, id=perkID, time=time } )

					time = time - 1

					if time == 0 then return end
					return 1.0
				end)

				PERK_ABILITY_COOLDOWN2[playerID] = Timers:CreateTimer(time+1, function()
					Timers:RemoveTimer( PERK_ABILITY_COOLDOWN1[playerID] )
					PERK_ABILITY_COOLDOWN1[playerID] = nil
				end)

			end

			break

		end
	end

end
]]
--[[
function Perks_UseAbility_Usable(playerID, perkName, perkID) --returns timer
	local player = PlayerResource:GetPlayer(playerID)
	local hero = player:GetAssignedHero()
	local type2 = PerkModifiers_Descr[perkName]["type2"]

	local usable_count = 0
	local not_usable_count = 0

	local timer = Timers:CreateTimer(1.0, function()

		if ( hero:IsStunned() or hero:IsSilenced() or not hero:IsAlive() ) then
			usable_count = 0
			not_usable_count = not_usable_count + 1
		else
			not_usable_count = 0
			usable_count = usable_count + 1
		end

		if usable_count == 1 then
			local color1 = GetPerkTypeColor(type2)[1]
			local color2 = GetPerkTypeColor(type2)[2]
			local gradient = 100

			CustomGameEventManager:Send_ServerToPlayer(player, "ability_usable", { name=perkName, id=perkID, usable=true, color1=color1, color2=color2, gradient=gradient } )
		end
		if not_usable_count == 1 then
			local color1 = "#9c9c9c"
			local color2 = "#4f4f4f"
			local gradient = 100
			CustomGameEventManager:Send_ServerToPlayer(player, "ability_usable", { name=perkName, id=perkID, usable=false, color1=color1, color2=color2, gradient=gradient } )
		end

		return 0.1
	end)

	return timer
end
]]




































