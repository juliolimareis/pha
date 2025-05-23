class_name AttackProcess

var effective = Effective.new()
var rand = RandomNumberGenerator.new()
#calcula o dano do ataque
func calcDamage(move, poke) -> int:
	#variáveis do delta
	var e = getEffectiveValue(move, poke)
	var r = float(getRandomInt(85,100))/100.0
	var c = 1
	var out = 1
	var stab = getStab(move, poke)

	var delt = (stab*e*c*out*r)

	var pwr = move.pwr
	var atk = getAtk(move)
	var def = getDef(move, poke)
	var lv = poke.level

	#calculo final
	var d = (2*lv+10)
	d  = (float(d)/250.0)
	var d2 = 0
	d2 = (float(atk)/float(def))
	var d3 = (pwr+2)
	d  = (d*d2)
	d  = (d*d3)
	d  = (d*delt)

	return int(d)

func getAtk(move):
	if(move.atkType == "Physical"):
		return move.pokemonAttack
	return move.pokemonAttackSp

func getDef(move, poke):
	if(move.atkType == "Physical"):
		return poke.def
	return poke.defSp

func getStab(move, poke):
	if(move.type == poke.pokemonType1 || move.type == poke.pokemonType2):
		return 1.5
	return 1

func getEffectiveValue(move, poke):
	var e = effective.typeEffective(move.type, poke.pokemonType1)
	if(e == 0):
		return 0
	
	if(poke.pokemonType2 != 0):
		var e2 = effective.typeEffective(move.type, poke.pokemonType2)
		
		if(e2 == 0):
			return 0
		
		var value = e + e2
		
		if( (value == 2.5) || (value == 2) ):
			e = 1
		#dano x2
		elif(value == 3):
			e = 2
		#dano x4
		elif(value == 4):
			e = 4
		#dano 1/2
		elif(value == 1.5):
			e = 0.5
		#dano 1/4
		elif(value == 1):
			e = 0.25
	return e

func getRandomInt(init: int, end: int) -> int:
	rand.randomize()
	return rand.randi_range(init, end)
