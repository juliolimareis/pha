extends Node

var startGame = false
# id do jogador, mesmo do banco
var idPlayer: int 
# poke que o jogador esta usando no momento
var pokeDefault = null
# pokes na bag do jogador
var pokesBagInstance = {}
#dados dos pokes da bag(exatamente como vem do banco)
var dataPokesBag: Array = []
#items do jogadotr
var items: Array = []
# nome do player
var nickname: String
# nome do mapa onde o jogador se encontra(será salvo no banco)
var locationName: String = "world"
# nome da localização do jodador no momento (não será salvo no banco)
var locationNameTemp: String = "world"
# X e Y de posição do jogador no momento
var playerPosition: Vector2
# diretório onde a cena no jogador está
var personName: String = ""
# token para conexão
# var token: String = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZFBsYXllciI6MSwidXNlclR5cGUiOjAsImlhdCI6MTYzMDkwMTY1NX0.hsPMlgn0vSxXyQFlcjGCv9wtoDkEu6z2YPJatd5nSSc"
var token: String #= "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZFBsYXllciI6MSwidXNlclR5cGUiOjAsImlhdCI6MTYzMDkwMTY1NX0.hsPMlgn0vSxXyQFlcjGCv9wtoDkEu6z2YPJatd5nSSc"
# id do pokemon selecionado como principal
var idMainPoke: int
# array de node de perfil de pokemon que aparece na tela
var pokeProfiles = []
# posição do pokémon selecionado na batalha
var pokePositionSelect: int = 0
# id do pokémon selecionado na batalha
var idPokeSelect: int = 0 
# se jogador está em batalha
var isBattle = false
var isPvp = false
var isRaid = false
var inWorld = true 
# se o jogador está com chat aberto
var isChat = false

var isPlayerInvokedInBattle = false
# array de notificação do jogador
var notifications: Array = []

var isInitialPoke = false

#Sinais que jogador emite
signal refresh_poke_profiles()
#emite a posição que foi pressionada na troca
signal change_poke(dataPoke)
# emite quando o jogador está na área de batalha
signal area_battle(enable)
# emite quando o jogador muda o poke principal
signal change_main_poke()
# emite sinal quando um item no slot muda adicionado
signal change_action_slot()

#verifica se o jogador está em batalha e se está sem poke invocado 
func isPlayerMoveInBattle():
	return isBattle && Game.getQuantEnemies() == 0

func setPersonName(pName: String) -> void:
	personName = "res://Scenes/players/"+pName+"/"+pName+".tscn"

# array de pokemons que já foram add_child(instanciados)
func setPokeInstance(poke) -> void:
	pokesBagInstance[str(poke.id)] = poke

func getPokeInstance(id: int) -> Node2D:
	return pokesBagInstance[str(id)] 

func getMainPoke() -> Node2D:
	return GlobalPoke.getPokeBag(dataPokesBag[0])

func getPokeBag(position: int) -> Node2D:
	return GlobalPoke.getPokeBag(dataPokesBag[position])

func getDataPokeBagByPokeSelect():# -> jsonDataPokeBag
	if(isBattle):
		return getDataPokeBag(pokePositionSelect)
	return getDataPokeBag(0)

func getDataPokeBag(position: int):# -> jsonDataPokeBag
	return dataPokesBag[position]

func removePokePokeSelect():
	dataPokesBag.remove_at(0)
	emitRefreshPokeProfiles()
	
func getDataPokeBagLast():# -> jsonDataPokeBag
	return dataPokesBag[dataPokesBag.size()-1]

func getDataPokeBagById(id: int):# -> jsonDataPokeBag
	for data in dataPokesBag:
		if(data.idPokemon == id):
			return data
	return null

func getDataPokeBagByCode(code: int):# -> jsonDataPokeBag
	for data in dataPokesBag:
		if(data.code == code):
			return data
	return null

func getPosDataPokeBagById(id: int):# -> jsonDataPokeBag || null
	for i in dataPokesBag.size():
		if(dataPokesBag[i].idPokemon == id):
			return i
	return null

func setDataPokeBagById(id: int, newDataPokeBag) -> void:
	for data in dataPokesBag:
		if(data.idPokemon == id):
			data = newDataPokeBag

func verifyPokePokeBagRepeat(code: int) -> bool:
	for data in dataPokesBag:
		if(data.code == code):
			return true
	return false

func isPokeCodeExistInArray(dataPokes, code: int) -> bool:
	for data in dataPokes:
		if(data.code == code):
			return true
	return false

# tenta add o pokemon na bag, caso contrário add no depot
func addDataPokesBag(newDataPokeBag) -> void:
	# if dataPokesBag.size() < 6 && !GlobalPlayer.verifyPokePokeBagRepeat(newDataPokeBag.code):
	dataPokesBag.push_back(newDataPokeBag)
	# else:
	# 	GlobalPlayer.addDataPokesDepot(newDataPokeBag)

################# inicio
func setDataPlayer(dataPlayer) -> void:
	idPlayer = dataPlayer.idPlayer
	nickname = dataPlayer.nickname
	dataPokesBag = dataPlayer.pokesBag
	setPersonName(dataPlayer.personName)
	locationName = dataPlayer.locationName
	
	if hasPokeBag():
		idMainPoke = dataPokesBag[0].idPokemon
		idPokeSelect = dataPokesBag[0].idPokemon
	else:
		isInitialPoke = true
	
	if(dataPlayer.internal.empty()):
		setPosition(Vector2(dataPlayer.positionX, dataPlayer.positionY))
	else:
		setPosition(Vector2(dataPlayer.internal[0].positionX, dataPlayer.internal[0].positionY))
	
	configNodeProfilePoke()
#	items = dataPlayer.items

func hasPokeBag() -> bool:
	if(dataPokesBag.size() > 0):
		return true
	return false

func addItem(itemObj) -> void:
	var isRepeat = false
	for item in items:
		if item.idItem == itemObj.id:
			sumItem(item.idItem, 1)
			isRepeat = true
	if(!isRepeat):
		items.push_back({
			"idPosition": "",
			"idItem": itemObj.id,
			"quantity": 1
		})
	Request.saveItems()

func sumItem(idItem: int, value: int): #decrescenta ou aumenta a quantidade, salva e retorna o item com o novo valor
	for item in items:
		if item.idItem == idItem:
			item.quantity += value
			if item.quantity < 0:
				item.quantity = 0
			Request.saveItems()
			return item

func getItemById(idItem: int):
	for item in items:
		if item.idItem == idItem:
			return item

func getItems():
	return items

func changeMainPoke(idPoke):
	if(idPoke != idMainPoke):
		var posNewMainPoke = getPosDataPokeBagById(idPoke)
		var mainPoke = getDataPokeBag(posNewMainPoke)
		var oldMainPoke = getDataPokeBag(0)
		idMainPoke = idPoke
		idPokeSelect = idPoke
		dataPokesBag[0] = mainPoke
		# dataPokesBag[posNewMainPoke] = oldMainPoke
		Request.setValuePoke(mainPoke.idPokemon, "idPosition", 1)
		Request.setValuePoke(oldMainPoke.idPokemon, "idPosition", (posNewMainPoke+1))
		# Request.getMoveNotify()
		emitChangeManPoke()
		emitRefreshPokeProfiles()

# cria o node de profile dos pokemon na bolsa
func configNodeProfilePoke():
	pokeProfiles = []
	for dpb in dataPokesBag:
		pokeProfiles.push_back(createProfilePoke(dpb))

# @description emite troca de pokemon principal
func emitChangeManPoke():
	emit_signal("change_main_poke")

func emitChangeActionSlot():
	emit_signal("change_action_slot")

func emitRefreshPokeProfiles():
	emit_signal("refresh_poke_profiles")

# FIXME emitChangePoke
# @description qual posição do pokemon selecionado
func emitChangePoke(idPosition: int):
		if(isExistDataPokesBag(idPosition)):
			if(pokePositionSelect != idPosition):
				if isBattle:
					if Game.isSwitch:
						idPokeSelect = dataPokesBag[idPosition].idPokemon
						pokePositionSelect = idPosition
						if(!isPokeDeadById(idPokeSelect)):
							# Time.start('battle', 'switch')
							Game.isSwitch = false
						# Request.getMoveNotify()
						emit_signal("change_poke", dataPokesBag[idPosition])
				else: 
					changeMainPoke(getDataPokeBag(idPosition).idPokemon)
			else:
				if isPlayerMoveInBattle():
					if isPlayerInvokedInBattle:
						Game.getPlayer().enableCamera(false)
						Game.activePokeFollow(false)
						Game.getPlayer().isPlayer = false
						Game.getPlayer().input_vector = Vector2.ZERO
						isPlayerInvokedInBattle = false
					else:
						Game.activePokeFollow(true)
						Game.getPlayer().enableCamera(true)
						Game.getPlayer().isPlayer = true
						isPlayerInvokedInBattle = true

func isPokeDead(idPosition: int) -> bool:
	if(dataPokesBag[idPosition].acHp > 0):
		return false
	return true

func isPokeDeadById(id: int) -> bool:
	if(getDataPokeBagById(id).acHp > 0):
		return false
	return true

func isPokeSelectDead() -> bool:
	if(getDataPokeBagById(idPokeSelect).acHp > 0):
		return false
	return true

# amite quando está na area de combate
func emitAreaBattle(enable: bool):
	emit_signal("area_battle", enable)

# Cria o profile de tela do poke de acordo com os dados
func createProfilePoke(dpb):
	var profile = load("res://Scenes/layouts/ProfilePoke.tscn").instance()
	
	profile.idPoke = dpb.idPokemon

	if(dpb.nickname):
		profile.pokeName = dpb.nickname
	else:
		profile.pokeName = PokeList.getName(dpb.code)
	
	profile.level = dpb.level

	profile.isCanEvo = dpb.isCanEvo
	
	profile.pokeCode = dpb.code

	profile.hpMax = dpb.hp
	profile.hpValue = dpb.acHp
	
	# calculo da barra de XP
#	profile.xpMax = (PokemonXp.new().getLimitLevel(dpb.level, dpb.lr) - PokemonXp.new().getLimitLevel(dpb.level-1, dpb.lr))
#	profile.xpValue = calcValueXp(profile.xpMax, dpb.xp, dpb.level, dpb.lr)
	
	var pokemonXp = PokemonXp.new()
	var limitNextLv = pokemonXp.getLimitLevel(dpb.level+1, dpb.lr)
	var limitActualLv = pokemonXp.getLimitLevel(dpb.level, dpb.lr)
	
	profile.xpMax = limitNextLv - limitActualLv
	profile.xpValue = calcValueXp(profile.xpMax, dpb.xp, dpb.level, dpb.lr)
	
	return profile

func calcValueXp(xpMax: int, xpValue: int, lv: int, lr) -> int:
	var nextLv = PokemonXp.new().getLimitLevel(lv+1, lr)
	var totalToNext = nextLv - xpValue
	var valueLevel = int(xpMax - totalToNext)
#	return int((valueLevel * 100) / (xpMax))
	
	return valueLevel

# deprecated
#func _process(delta) -> void:
#	delta = delta
#	if(Input.is_action_just_pressed("poke_1") && !GlobalPlayer.isChat):
#		# função para invocar poke follow no mundo
#		# verifica se esta no mundo e se o poke selecionado está vivo
#		if inWorld && dataPokesBag[0].acHp > 0 && !GlobalPlayer.isBattle:
#			# verifica se já tem poke invocado
#			if Game.isPokeInWorld:
#				# verifica se o poke invocado é o mesmo do poke selecionado, remover
#				if is_instance_valid(Game.getPoke()) && Game.getPoke().id == dataPokesBag[0].idPokemon:
#					Game.removePokeInWorld()
#				else: # poke invocado não é igual ao selecionado, emitir trocar
#					emit_signal("change_poke", dataPokesBag[0])
#					Game.activePokeFollow(true)
#			else: # não tem poke invocado, invocar
#				Game.isPokeInWorld = true
#				Game.startPokeBattle(true, false)
#				Game.getPoke().position = GlobalPlayer.playerPosition
#		else: # não está no mundo
#			emitChangePoke(0)
#	elif(Input.is_action_just_pressed("poke_2") && !GlobalPlayer.isChat):
#		emitChangePoke(1)
#	elif(Input.is_action_just_pressed("poke_3") && !GlobalPlayer.isChat):
#		emitChangePoke(2)
#	elif(Input.is_action_just_pressed("poke_4") && !GlobalPlayer.isChat):
#		emitChangePoke(3)
#	elif(Input.is_action_just_pressed("poke_5") && !GlobalPlayer.isChat):
#		emitChangePoke(4)
#	elif(Input.is_action_just_pressed("poke_6") && !GlobalPlayer.isChat):
#		emitChangePoke(5)
#	else:
#		GlobalPlayer.pokePositionSelect = 0
			
func isExistDataPokesBag(idPosition: int) -> bool:
	if(idPosition == 0):
		return true
	if(dataPokesBag.size() >= (idPosition+1) ):
		return true
	return false

func isSelf(_idPlayer):
	return idPlayer == _idPlayer

func isSelfPoke(idPoke):
	return idPokeSelect == idPoke

####################### SET GET ##############################
func setPosition(position: Vector2) -> void:
	playerPosition = position

func getPosition() -> Vector2:
	return playerPosition
	
func setInWorld(value: bool):
	inWorld = value
	
func getInWorld():
	return inWorld

func setIdPokeSelect(value: int):
	print("[setIdPokeSelect]: ", value)
	idPokeSelect = value
	
func getIdPokeSelect():
	return idPokeSelect

func setPokePositionSelect(value: int):
	# print("[setPokePositionSelect]: ", value)
	pokePositionSelect = value
	
func getPokePositionSelect():
	return pokePositionSelect

# cura todos os pokemons da bag
func cureAll():
	Game.removePokeInWorld()
	var isRefresh = false
	for poke in dataPokesBag:
		if poke.acHp != poke.hp:
			poke.acHp = poke.hp
			isRefresh = true
			Request.saveAcHp(poke.idPokemon, poke.acHp)
	if isRefresh:
		emitRefreshPokeProfiles()
