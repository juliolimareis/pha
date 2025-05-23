class_name Effective

#verifica a efetividade e devolve o valor a ser multiplicado, se for 0 é imune
func typeEffective(typeAtk, typeDef):
	match typeAtk:
		1:
				return type_normal(typeDef)
		2:
				return type_fire(typeDef)
		3:
				return type_fighting(typeDef)
		4:
				return type_water(typeDef)
		5:
				return type_flying(typeDef)
		6:
				return type_grass(typeDef)
		7:
				return type_poison(typeDef)
		8:
				return type_electric(typeDef)
		9:
				return type_ground(typeDef)
		10:
				return type_psychic(typeDef)
		11:
				return type_rock(typeDef)
		12:
				return type_ice(typeDef)
		13:
				return type_bug(typeDef)
		14:
				return type_dragon(typeDef)
		15:
				return type_ghost(typeDef)
		16:
				return type_dark(typeDef)
		17:
				return type_steel(typeDef)
		18:
				return type_fairy(typeDef)	

func type_fairy(type):
	if(type == 16 || type == 14 || type == 3):
		return 2
	elif(type == 2 || type == 7 || type == 17):
		return 0.5
	else:
		return 1

func type_steel(type):
	if(type == 18 || type == 12 || type == 11):
		return 2
	elif(type == 8 || type == 2 || type == 17 || type == 4):
		return 0.5
	else:
		return 1

func type_dark(type):
	if(type == 15 || type == 10):
		return 2
	elif(type == 16 || type == 18 || type == 3):
		return 0.5
	else:
		return 1

func type_ghost(type):
	if(type == 15 || type == 10):
		return 2
	elif(type == 16):
		return 0.5
	elif(type == 1 || type == 3):
		return 0
	else:
		return 1

func type_dragon(type):
	if(type == 14):
		return 2
	elif(type == 17):
		return 0.5
	elif(type == 18):
		return 0
	else:
		return 1

func type_bug(type):
	if(type == 16 || type == 6 || type == 10):
		return 2
	elif(type == 18 || type == 3 || type == 2 || type == 5
	|| type == 15 || type == 7 || type == 17):
		return 0.5
	else:
		return 1

func type_ice(type):
	if(type == 14 || type == 5 || type == 6 || type == 9): 
		return 2
	elif(type == 2 || type == 12 || type == 17 || type == 4):
		return 0.5
	else:
		return 1

func type_rock(type):
	if(type == 13 || type == 2 || type == 5 || type == 12): 
		return 2
	elif(type == 3 || type == 9 || type == 17):
		return 0.5
	else:
		return 1

func type_psychic(type):
	if(type == 3 || type == 7): 
		return 2
	elif(type == 10 || type == 17):
		return 0.5
	elif(type == 16):
		return 0
	else:
		return 1

func type_ground(type):
	if(type == 2 || type == 7 || type == 8 || type == 11
	|| type == 17): 
		return 2
	elif(type == 6 || type == 13):
		return 0.5
	elif(type == 5):
		return 0
	else:
		return 1

func type_electric(type):
	if(type == 5 || type == 4): 
		return 2
	elif(type == 6 || type == 8 || type == 14):
		return 0.5
	elif(type == 9):
		return 0
	else:
		return 1

func type_poison(type):
	if(type == 18 || type == 6): 
		return 2
	elif(type == 7 || type == 9 || type == 11 || type == 15):
		return 0.5
	elif(type == 17):
		return 0
	else:
		return 1

func type_grass(type):
	if(type == 9 || type == 11 || type == 4): 
		return 2
	elif(type == 13 || type == 14 || type == 2 || type == 5
	|| type == 6 || type == 7 || type == 17):
		return 0.5
	else:
		return 1

func type_flying(type):
	if(type == 13 || type == 3 || type == 6): 
		return 2
	elif(type == 8 || type == 11 || type == 17):
		return 0.5
	else:
		return 1

func type_water(type):
	if(type == 2 || type == 9 || type == 11): 
		return 2
	elif(type == 14 || type == 6 || type == 4):
		return 0.5
	else:
		return 1
	
func type_normal(type):
	if(type == 15): 
		return 0
	elif(type == 17 || type == 11):
		return 0.5
	else:
		return 1

func type_fire(type):
	if(type == 13 || type == 6 || type == 12 || type == 17):
		return 2
	elif(type == 14 || type == 2 || type == 11 || type == 4):
		return 0.5
	else:
		return 1

func type_fighting(type):
	if(type == 16 || type == 12 || type == 1 || type == 11
	|| type == 17): 
		return 2
	elif(type == 13 || type == 18 || type == 5 || type == 7
	|| type == 10):
		return 0.5
	elif(type == 15):
		return 0
	else:
		return 1
