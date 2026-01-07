class_name PokemonDecorator

static func toString(pokemon: PokemonAbstract) -> String:
	var str_representation = ""
	var type_names: Array[String] = []

	str_representation += "Code: %s\n" % pokemon.code
	str_representation += "Name: %s\n" % pokemon.name
	str_representation += "Level: %d\n" % pokemon.level

	for type in pokemon.type:
		type_names.append(PokemonBaseAbstract.Type.keys()[type])
	
	str_representation += "Type: %s\n" % ", ".join(type_names)

	str_representation += "HP: %d\n" % pokemon.hp
	str_representation += "Attack: %d\n" % pokemon.atk
	str_representation += "Defense: %d\n" % pokemon.def
	str_representation += "Special Attack: %d\n" % pokemon.sp_atk
	str_representation += "Special Defense: %d\n" % pokemon.sp_def
	str_representation += "Speed: %d\n" % pokemon.speed

	str_representation += "Experience: %d\n" % pokemon.experience
	str_representation += "Gender: %s\n" % ("Male" if pokemon.gender == 1 else "Female")
	str_representation += "Special Attack: %s\n" % str(pokemon.sp_atk)
	str_representation += "HP IV: %d\n" % pokemon.hp_iv
	str_representation += "Attack IV: %d\n" % pokemon.atk_iv
	str_representation += "Defense IV: %d\n" % pokemon.def_iv
	str_representation += "Special Attack IV: %d\n" % pokemon.atkSp_iv
	str_representation += "Special Defense IV: %d\n" % pokemon.defSp_iv
	str_representation += "Speed IV: %d\n" % pokemon.speed_iv
	str_representation += "HP EV: %d\n" % pokemon.hp_ev
	str_representation += "Attack EV: %d\n" % pokemon.atk_ev
	str_representation += "Defense EV: %d\n" % pokemon.def_ev
	str_representation += "Special Attack EV: %d\n" % pokemon.atkSp_ev
	str_representation += "Special Defense EV: %d\n" % pokemon.defSp_ev
	str_representation += "Speed EV: %d\n" % pokemon.speed_ev
	str_representation += "Catch Rate: %d\n" % pokemon.catchRate
	str_representation += "Leveling Rate: %s\n" % PokemonLevel.LevelingRate.keys()[pokemon.levelingRate]
	str_representation += "Status Effects: %s\n" % str(pokemon.status_effects)
	str_representation += "Status Effects Unaffected: %s\n" % str(pokemon.status_effects_unaffected)
	str_representation += "Is Unaffected: %s\n" % str(pokemon.isUnaffected)
	str_representation += "Acceleration: %d\n" % pokemon.acceleration
	str_representation += "Max Speed: %d\n" % pokemon.max_speed
	str_representation += "Friction: %d\n" % pokemon.friction
	
	str_representation += "Moves:\n"
	
	for i in range(pokemon._moves.size()):
		str_representation += "  - %s\n" % pokemon._moves[i].name
	
	return str_representation
	
