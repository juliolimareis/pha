class_name GeneratePokemon

#iv máximo = 31 - Individual Value
#ev máximo = 65535 - Effort values (Valores de esforço)

var rand = RandomNumberGenerator.new()
var _ivs = {}

# gera um pokemon com iv 
func generate(pokeMold, lv: int):
	var newPoke = {}

	newPoke["iv"] = getRandIv()
	newPoke["ev"] = getInitialEv()

	for key in newPoke["iv"]:
		newPoke[key] = generateStatus(key, pokeMold[key], lv, newPoke["iv"][key], newPoke["ev"][key])

	newPoke["gender"] = getGender(pokeMold['gender'])

	return newPoke

func create(statusBase, lv: int, iv, ev): # -> statusPokeJson
	var newPoke = {}
	# var pokeMold = PokeList.getPokeById(idPoke).pokeStatus.statusBase

	for key in statusBase:
		if(key != "gender"):
			newPoke[key] = generateStatus(key, statusBase[key], lv, iv[key], ev[key])
	
	newPoke["gender"] = getGender(statusBase['gender'])
	
	newPoke["iv"] = iv
	newPoke["ev"] = ev
	newPoke["level"] = lv

	return newPoke

func getRandIv(): 
	return {
		"hp": getRandomInt(1,31),
		"atk": getRandomInt(1,31),
		"def": getRandomInt(1,31),
		"atkSp": getRandomInt(1,31),
		"defSp": getRandomInt(1,31),
		"speed": getRandomInt(1,31)
	}

func getInitialEv():
	return {
		"hp": 4,
		"atk": 4,
		"def": 4,
		"atkSp": 4,
		"defSp": 4,
		"speed": 4
	}

func generateStatus(stName: String, base: int, lv: int, iv: int, ev: int) -> int:
	var b := (2*base+iv)
	var b2 := (ev/4)
	b = (b+b2)
	b = (b*lv)/100

	if(stName == 'hp'):
		return int(b+lv+10)

	return int(b+5)

func getGender(g) -> int: 
	var r = getRandomInt(1,100);
	if(r <= g):
		return 0
	return 1

func getRandomInt(init: int, end: int) -> int:
	rand.randomize()
	return rand.randi_range(init, end)

