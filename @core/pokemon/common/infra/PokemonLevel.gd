class_name PokemonLevel

enum LevelingRate {
  ERRATIC,
  FAST,
  MEDIUM,
  SLOW,
  MEDIUM_FAST,
  MEDIUM_SLOW,
  FLUCTUATING
}

static func calcLimitLevel(levelingRate: LevelingRate, level: int) -> int:
	var n: float = 0
	var n2: float = 0
	var m: int = 0
	#se for Erratic
	if(levelingRate == LevelingRate.ERRATIC):
	#inicio do calculo
		n = pow(level,3)
		#se level for menor que 50
		if(level < 50):
			n2 = (100-level)
			n = (n*n2)
			n = (n/50)
			n = (n)
		#e level for maior que 50 e menor que 68
		elif(level >= 50 && level < 68):
			n2 = (150-level)
			n  = (n*n2)
			n  = (n/100)
			n = (n)
		# se level for maior que 68 e menor que 98
		elif(level >= 68 && level < 98):
			m  = (10*level)
			n2 = (1911-(m))
			n2 = ((n2)/3)
			n  = (n*n2)
			n  = (n/500)
			n = (n)
		# se level for maior ou igual a 98 e menor que 100
		elif(level >= 98 && level <= 100):
			n2 = (160-(level))
			n  = (n*n2)
			n  = (n/100)
			n = (n)
	#se for fast
	elif(levelingRate == LevelingRate.FAST):
		n = (4*(pow(level,3))/(5))
	
	#se for medium fast
	elif(levelingRate == LevelingRate.MEDIUM_FAST):
		n = pow(level,3)
	
	#se for medium slow
	elif(levelingRate == LevelingRate.MEDIUM_SLOW):
		n = ( (1.2)*(pow(level,3)) - (15*(pow(level,2)) ) + (100*level) - 140 )
	
	#se for slow
	elif(levelingRate == LevelingRate.SLOW):
		n = (5*(pow(level,3))/(4))
	
	#se for Fluctuating
	elif(levelingRate == LevelingRate.FLUCTUATING):
	  #iniciando cálculo
		n = pow(level,3)
	  #se for level menor que 15
		if(level < 15):
			n2 = level + 1/3
			n2 = n2 + 24
			n2 = n2 / 50
			n = n * n2
		#se for level maior que 14 e menor que 36
		elif(level >= 15 && level < 36):
			n2 = level + 14/50
			n = n*n2
		#se for level maior que 35
		elif(level > 35):
			n2 =  int((level/2) + 32/50)
			n = n*n2
	return int(n)
