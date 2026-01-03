class_name EffectiveFactory
# verifica a efetividade e devolve o valor a ser multiplicado, se for 0 é imune
static func typeEffective(typeAtk: int, typeDef: int):
	match typeAtk:
		1: return _type_normal(typeDef)
		2: return _type_fire(typeDef)
		3: return _type_fighting(typeDef)
		4: return _type_water(typeDef)
		5: return _type_flying(typeDef)
		6: return _type_grass(typeDef)
		7: return _type_poison(typeDef)
		8: return _type_electric(typeDef)
		9: return _type_ground(typeDef)
		10: return _type_psychic(typeDef)
		11: return _type_rock(typeDef)
		12: return _type_ice(typeDef)
		13: return _type_bug(typeDef)
		14: return _type_dragon(typeDef)
		15: return _type_ghost(typeDef)
		16: return _type_dark(typeDef)
		17: return _type_steel(typeDef)
		18: return _type_fairy(typeDef)	

static func _type_fairy(type: int):
	if(type == 16 || type == 14 || type == 3):
		return 2
	elif(type == 2 || type == 7 || type == 17):
		return 0.5
	else:
		return 1

static func _type_steel(type: int):
	if(type == 18 || type == 12 || type == 11):
		return 2
	elif(type == 8 || type == 2 || type == 17 || type == 4):
		return 0.5
	else:
		return 1

static func _type_dark(type: int):
	if(type == 15 || type == 10):
		return 2
	elif(type == 16 || type == 18 || type == 3):
		return 0.5
	else:
		return 1

static func _type_ghost(type: int):
	if(type == 15 || type == 10):
		return 2
	elif(type == 16):
		return 0.5
	elif(type == 1 || type == 3):
		return 0
	else:
		return 1

static func _type_dragon(type: int):
	if(type == 14):
		return 2
	elif(type == 17):
		return 0.5
	elif(type == 18):
		return 0
	else:
		return 1

static func _type_bug(type: int):
	if(type == 16 || type == 6 || type == 10):
		return 2
	elif(type == 18 || type == 3 || type == 2 || type == 5 || type == 15 || type == 7 || type == 17):
		return 0.5
	else:
		return 1

static func _type_ice(type: int):
	if(type == 14 || type == 5 || type == 6 || type == 9): 
		return 2
	elif(type == 2 || type == 12 || type == 17 || type == 4):
		return 0.5
	else:
		return 1

static func _type_rock(type: int):
	if(type == 13 || type == 2 || type == 5 || type == 12): 
		return 2
	elif(type == 3 || type == 9 || type == 17):
		return 0.5
	else:
		return 1

static func _type_psychic(type: int):
	if(type == 3 || type == 7): 
		return 2
	elif(type == 10 || type == 17):
		return 0.5
	elif(type == 16):
		return 0
	else:
		return 1

static func _type_ground(type: int):
	if(type == 2 || type == 7 || type == 8 || type == 11 || type == 17): 
		return 2
	elif(type == 6 || type == 13):
		return 0.5
	elif(type == 5):
		return 0
	else:
		return 1

static func _type_electric(type: int):
	if(type == 5 || type == 4): 
		return 2
	elif(type == 6 || type == 8 || type == 14):
		return 0.5
	elif(type == 9):
		return 0
	else:
		return 1

static func _type_poison(type: int):
	if(type == 18 || type == 6): 
		return 2
	elif(type == 7 || type == 9 || type == 11 || type == 15):
		return 0.5
	elif(type == 17):
		return 0
	else:
		return 1

static func _type_grass(type: int):
	if(type == 9 || type == 11 || type == 4): 
		return 2
	elif(type == 13 || type == 14 || type == 2 || type == 5 || type == 6 || type == 7 || type == 17):
		return 0.5
	else:
		return 1

static func _type_flying(type: int):
	if(type == 13 || type == 3 || type == 6): 
		return 2
	elif(type == 8 || type == 11 || type == 17):
		return 0.5
	else:
		return 1

static func _type_water(type: int):
	if(type == 2 || type == 9 || type == 11): 
		return 2
	elif(type == 14 || type == 6 || type == 4):
		return 0.5
	else:
		return 1
	
static func _type_normal(type: int):
	if(type == 15): 
		return 0
	elif(type == 17 || type == 11):
		return 0.5
	else:
		return 1

static func _type_fire(type: int):
	if(type == 13 || type == 6 || type == 12 || type == 17):
		return 2
	elif(type == 14 || type == 2 || type == 11 || type == 4):
		return 0.5
	else:
		return 1

static func _type_fighting(type: int):
	if(type == 16 || type == 12 || type == 1 || type == 11 || type == 17): 
		return 2
	elif(type == 13 || type == 18 || type == 5 || type == 7 || type == 10):
		return 0.5
	elif(type == 15):
		return 0
	else:
		return 1
