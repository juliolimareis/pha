class_name PokemonGenerate

#iv máximo = 31 - Individual Value
#ev máximo = 65535 - Effort values (Valores de esforço)

func build(code: int, level: int) -> PokemonAbstract:
	var poke := PokemonFactory.build(code)

	poke = getRandIv(poke)

	poke.hp = generateStatus("hp", poke.hp, level, poke.hp_iv, poke.hp_ev)
	poke.atk = generateStatus("atk", poke.atk, level, poke.atk_iv, poke.atk_ev)
	poke.def = generateStatus("def", poke.def, level, poke.def_iv, poke.def_ev)
	poke.sp_atk = generateStatus("atkSp", poke.sp_atk, level, poke.atkSp_iv, poke.atkSp_ev)
	poke.sp_def = generateStatus("defSp", poke.sp_def, level, poke.defSp_iv, poke.defSp_ev)
	poke.speed = generateStatus("speed", poke.speed, level, poke.speed_iv, poke.speed_ev)

	poke.gender= getGender(poke)

	return poke

# func create(statusBase, lv: int, iv, ev): # -> statusPokeJson
# 	var newPoke = {}
# 	# var pokeMold = PokeList.getPokeById(idPoke).pokeStatus.statusBase

# 	for key in statusBase:
# 		if(key != "gender"):
# 			newPoke[key] = generateStatus(key, statusBase[key], lv, iv[key], ev[key])
	
# 	newPoke["gender"] = getGender(statusBase['gender'])
	
# 	newPoke["iv"] = iv
# 	newPoke["ev"] = ev
# 	newPoke["level"] = lv

# 	return newPoke

func getRandIv(poke: PokemonAbstract) -> PokemonAbstract: 
	poke.hp_iv = getRandomInt(1,31)
	poke.atk_iv = getRandomInt(1,31)
	poke.def_iv = getRandomInt(1,31)
	poke.atkSp_iv = getRandomInt(1,31)
	poke.defSp_iv = getRandomInt(1,31)
	poke.speed_iv = getRandomInt(1,31)
	
	return poke
	
func generateStatus(statusName: String, base: int, level: int, iv: int, ev: int) -> int:
	var b = (2 * base + iv)
	var b2 = (ev / 4)

	b = (b + b2)
	b = (b * level) / 100

	if(statusName == 'hp'):
		return int(b + level + 10)
	return int(b + 5)

func getGender(poke: PokemonBaseAbstract) -> int: 
	var randInt = getRandomInt(1,100);
	if(randInt <= poke.genderBase):
		return 0
	return 1

func getRandomInt(init: int, end: int) -> int:
	var rand = RandomNumberGenerator.new()
	rand.randomize()
	return rand.randi_range(init, end)