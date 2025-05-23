extends Node 

################################################
# classe responsável por processar as ações do #
#	menu depot                                   #
################################################

# responsável por guardar os pokes que serão atualizados
# usado para salvar os pokes que foram para o depot
# os pokemon da bag sempre serão atualizados caso haja alteração na bag
# portanto os dataPokes na bag não são adicionados em => pokesUpdateDepot
var pokesUpdateDepot = []
# array com todos os dataPoke do depot
var pokesDepot = [] #json do da tabela pokemon
# pokes do menu depot que estão na bag, para serem atualizados no menu depot
var pokesDepotBag = [] # json do pokemon completo
# emite quando o depot sofre mudanças
signal updateDepot()
# tela de depot
var isOpenDepot: bool = false setget setIsOpenDepot, getIsOpenDepot
# verifica se deve fazer request no depot quando o menu tela abrir
var isRequestDepot: bool = true
# deprecated
func _ready(): 
	ServerResponse.connectChannel("addPokeDepot", self, "_on_add_poke_depot")

# deprecated
# recebe o poke que foi capturado e enviado para o depot
func _on_add_poke_depot(newPokeDepot): # array de dataPoke
	pokesDepot.push_front(newPokeDepot)
	GlobalPoke.saveNotifyNewPokeCatch(newPokeDepot.nickname)

# recebe dataPoke e verifica se existe no array, se sim, remove o dataPoke, caso não tenha add
# isBag => verifica de onde esse pokeData está, true na bag, false no depot
func setIdPokesUpdate(isBag, index, pokeData):
		# processo de pokes que vão para o depot
		if isBag:
			# verifica se tem pelo menos um poke na bag
			if pokesDepotBag.size() > 1:
				# adiciona no array de depot
				pokesDepot.push_back(pokeData)
				# remove do array de bag
				pokesDepotBag.remove(index)
				# verifica se existe no array de update
				if pokesUpdateDepot.find(pokeData) == -1:
					pokesUpdateDepot.push_back(pokeData)
		# processo de pokes que vão para a bag
		else:
			# verifica se tem espaço na bag
			if pokesDepotBag.size() < 6 && !GlobalPlayer.isPokeCodeExistInArray(pokesDepotBag, pokeData.code):
				# adiciona no array da bag
				pokesDepotBag.push_back(pokeData)
				# remove do array de depot
				pokesDepot.remove(index)
				# verifica se esse dataPoke existe no array de update
				# caso exista remover, pois os pokes da bag são atualizados separadamente
				var indexPokeBag = pokesUpdateDepot.find(pokeData)
				if indexPokeBag != -1:
					pokesUpdateDepot.remove(indexPokeBag)
	
		emit_signal("updateDepot")

func updatePokesDepot() -> void:
	isOpenDepot = false
	
	# configura os pokes da bag para salvar
	# for i in range(1, pokesDepotBag.size()):
	# 	pokesDepotBag[i].isBag = 0
	# 	pokesDepotBag[i].idPosition = i
	
	# salva os pokes da bag
	for i in pokesDepotBag.size():
		var pos = int(i+1)
		pokesDepotBag[i].isBag = 0
		pokesDepotBag[i].idPosition = pos
		# print({
		# 	"idPosition": pos,
		# 	"isBag": 0
		# })
		Request.updatePoke(pokesDepotBag[i].idPokemon, {
			"idPosition": pokesDepotBag[i].idPosition,
			"isBag": pokesDepotBag[i].isBag
		})
	
	# salva os pokes que foram para o depot
	# print("Salva os pokes depot")
	for i in pokesUpdateDepot.size():
		# print({
		# 	"idPosition": 0,
		# 	"isBag": 1
		# })
		Request.updatePoke(pokesUpdateDepot[i].idPokemon, {
			"idPosition": 0,
			"isBag": 1
		})
	
	# limpa os arrays
	pokesUpdateDepot.clear()
	# remover poke invocado
	# Game.
	# remover as instancias dos pokes
	GlobalPlayer.pokesBagInstance = {}
	Game.removePokeInstance()

	GlobalPlayer.dataPokesBag = pokesDepotBag.duplicate()
	GlobalPlayer.emitRefreshPokeProfiles()

func setIsOpenDepot(value: bool):
	if value:
		Game.removePokeInWorld()

	if (value && isRequestDepot):
		isRequestDepot = false
		Request.getPokeDepot("getPokesDepot")
	pokesDepotBag = GlobalPlayer.dataPokesBag.duplicate()
	isOpenDepot = value

func getIsOpenDepot() -> bool:
	return isOpenDepot
