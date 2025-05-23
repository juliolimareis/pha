class_name PokemonXp

#/** getLimitLevel
#* Esta função recebe o lv e Leveling e retorna quando de xp deve superar para
#* avançar de nível
#* de acordom o leveling rate
#*
#* @link https:#bulbapedia.bulbagarden.net/wiki/Experience
#*
#* @param Int lv [level do qual quer calcular o limite]
#* @param Int lr [Leveling rate]
#*
#* @return Int poke [dados do pokemon pós processo]
#*
#* @Exemplo getLimitLevel(5,'ms')
#*/
##getLimitLevel
#/* Descrição Leveling rate
#Leveling rate(lr) :
# 0 - (e)Erratic
# 1 - (f)Fest
# 2 - (mf)MediumFest
# 3 - (ms)MediumSlow
# 4 - (s)Slow
# 5 - (fl)Fluctuating
#*/
func _init():
	# 1261
	getLimitLevel(12, 'ms')

func getLimitLevel(lv: int, lr: String):
	var n
	var n2
	var m
	#se for Erratic
	if(lr == 'e'):
	#inicio do calculo
		n = pow(lv,3)
		#se lv for menor que 50
		if(lv < 50):
			n2 = (100-lv)
			n = (n*n2)
			n = (n/50)
			n = (n)
		#e lv for maior que 50 e menor que 68
		elif(lv >= 50 && lv < 68):
			n2 = (150-lv)
			n  = (n*n2)
			n  = (n/100)
			n = (n)
		# se lv for maior que 68 e menor que 98
		elif(lv >= 68 && lv < 98):
			m  = (10*lv)
			n2 = (1911-(m))
			n2 = ((n2)/3)
			n  = (n*n2)
			n  = (n/500)
			n = (n)
		# se lv for maior ou igual a 98 e menor que 100
		elif(lv >= 98 && lv <= 100):
			n2 = (160-(lv))
			n  = (n*n2)
			n  = (n/100)
			n = (n)
	#se for fast
	elif(lr == 'f'):
		n = (4*(pow(lv,3))/(5))
	
	#se for medium fast
	elif(lr == 'mf'):
		n = pow(lv,3)
	
	#se for medium slow
	elif(lr == 'ms'):
		n = ( (1.2)*(pow(lv,3)) - (15*(pow(lv,2)) ) + (100*lv) - 140 )
	
	#se for slow
	elif(lr == 's'):
		n = (5*(pow(lv,3))/(4))
	
	#se for Fluctuating
	elif(lr == 'fl'):
	  #iniciando cálculo
		n = pow(lv,3)
	  #se for level menor que 15
		if(lv < 15):
			n2 = lv+1/3
			n2 = n2+24
			n2 = n2/50
			n = n*n2
		#se for level maior que 14 e menor que 36
		elif(lv >= 15 && lv < 36):
			n2 = lv+14/50
			n = n*n2
		#se for level maior que 35
		elif(lv > 35):
			n2 =  int((lv/2)+32/50)
			n = n*n2
	return int(n)

# //getXp
# Descrição $v
# a = {
# 	1 se o Pokémon desmaiado é selvagem
# 	1.5 se o Pokémon desmaiado é de propriedade de um treinador
# }

# b = {
# 	recompensa de XP de acordo com o pokemon derrotado
# }

# e = {
# 	1.5 se o Pokémon vencedor estiver segurando um Lucky Egg
# 	1 caso contrário
# }

# f = {
# 	1.2 se o Pokémon tiver um afeto de dois corações ou mais
# 	1 caso contrário
# }

# l = {
# 	level do pokemon derrotado
# }

# t = {
# 	1 se o atual proprietário do Pokémon vencedor for seu treinador original
# 	1.5 se o Pokémon foi ganho em um comércio interno
# 	Geração IV + somente : 1.7 se o Pokémon foi ganho em um comércio internacional
# }

#var v = {
#	"a": 1,
#	"b": 1,
#	"t": 1,
#	"e": 1,
#	"l": 1,
#	"f": 1,
#	"s": 1
#}
func getXp(v):
	var ext = (v['a']*v['t']*v['b']*v['e']*v['l']*v['f']);
	return int(ext/(7*v['s']));
