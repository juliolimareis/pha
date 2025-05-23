extends Node

var version: String = "v0.2.1"
#verifica se está na versão certa
var isVersion: bool = true
var isValidVersion: bool = true

# pegar membros do grupo
# var my_group_members = get_tree().get_nodes_in_group("my_group")

# You can also call an specific method for all members:

# get_tree().call_group("my_group","my_function",args...)

# If you need to do something with your group:

# for member in get_tree().get_nodes_in_group("my_group"):
#     member.my_function(args...)


# {
# 	"id": 1238818145,
# 	"type": "addMove",
# 	"idPokemon": 1,
# 	"moveName": "growl",
# 	"text": "[color=#1493ce]Bulbasaur[/color] pode aprender o ataque [color=#1493ce] Growl. [/color][u]Clique aqui para aprender.[/u]"
# }
var timeAlert = 4
# instancia do pokemon na batalha
var _poke: Pokemon
var _player: Player
# variável que contem o ataque que foi selecionado no painem de moves(movePainel)
var changeMove
# se deve sortear a posição que deve nascer
var isRandInitialPosition = false
# guarda a posição atual onde deve invocar o poke atualmente
var _initialPositions = [] #Array<Vector2>
# guarda a referência do node onde esta sendo instanciado os poke do jogador no momento
var _nodeInstancePlayer: Node2D
var _nodeInstancePokemon: Node2D
# notificações de ataque
var notifications = []
var notificationsMove = []
# node da camera
var screen = null
# verifica se jogador pode trocar de poke
# true = pode trocar
var isSwitch = true
# guarda o parâmetro de pokemons a serem invocados no mapa de baralha 
var pokesMobBattle: Array = []
# guarda o parâmetro dos items a serem invocados no mapa de baralha 
var itensBattle: Array = []
# quantidade de inimigos no mapa da batalha
var quantEnemies = 0
# verifica se pode capturar poke nessa área
var isAreaCatch = false
# pokemon deve seguir o jogador
var _isPokeFollow = false
# pokemon deve se um player
var _isPokePlayer = true
# verifica se o pokemon está invocano no mundo, como follow
var isPokeInWorld = false

var idPlayerBossTarget: int = 0

# guarda o codigo dos pokemons salvos na bag
# para evitar que o jogador receba pokemons repetidos
# antes da resposta do servidor
var tempCodePokesBag = []

# verificar se está em batalha
var isBattle = false
# permissão de poder controlar o person
var enablePersonControl = true
# permissão de poder controlar o poke
var enablePokeControl = false
# isPersonControll(caso seja falso está controlando o poke)
var isPersonControl = true

# TODO game signals
signal add_alert(alert) # pode ser string ou bool
signal add_alert_temp(alert, time) # pode ser string ou bool
signal notify_clicked(dataNotifi)
signal move_notify_clicked(dataNotifi)
signal move_countdown(keyPos, time)
signal exit_battle(isExit)
#emite quando algum poke tem o hp drenado
signal hp_drain(idsPokeAttack)

# func _ready():
# 	GlobalPlayer.connect('change_poke', self, '_on_change_poke')

func isTatget():
	if GlobalPlayer.idPlayer == idPlayerBossTarget:
		return true
	return false

# quando a notificação no painel for clicada
func emitMoveCountdown(keyPos, time):
	emit_signal("move_countdown", keyPos, time)

# quando o jogador sai da batalha
func emitExitBattle(isExit: bool):
	if isExit:
		GlobalPlayer.pokePositionSelect = 0
	emit_signal("exit_battle", isExit)

# quando a notificação no painel for clicada
func notifiClicked(dataNotifi):
	emit_signal("notify_clicked", dataNotifi)

# quando a notificação no painel de movimentos for clicada
func moveNotifiClicked(dataNotifi):
	emit_signal("move_notify_clicked", dataNotifi)

# signal changeMove(dataMove) #json contendo os dados básicos do atk 
# {
# 	"type": "addMove",
# 	"idPokemon": 1,
# 	"moveName": "growl",
# 	"text": ""
# }

func reduceQuantEnemies():
	quantEnemies += -1
	if(quantEnemies < 0):
		quantEnemies = 0

func setQuantEnemies(quant: int):
	quantEnemies = quant

func getQuantEnemies():
	return quantEnemies

func activePokeFollow(value: bool):
	if is_instance_valid(_poke):
		_poke.isFollow = value
		_poke.isPlayer = !value

		_poke.enableSight(!value)
		_poke.isFollow = value
		_poke.isPlayer = !value

		_isPokeFollow = value
		_isPokePlayer = !value

		Game.getPoke().enableCamera(!value)

# Remove o poke invocado no world
func removePokeInWorld():
	isPokeInWorld = false
	removePokeInstance()

func removePersonsInstance():
	if is_instance_valid(_player) && is_instance_valid(_nodeInstancePlayer):
		_nodeInstancePlayer.remove_child(_player)
	
	if is_instance_valid(_poke) && is_instance_valid(_nodeInstancePokemon):
		for poke in _nodeInstancePokemon.get_children():
			if poke == _poke: 
				_nodeInstancePokemon.remove_child(_poke)

func removePokeInstance():
	if is_instance_valid(_poke) && is_instance_valid(_nodeInstancePokemon):
		# if _poke.isNetwork: #emitir para a rede remover esse poke
		# 	Server.emitChannel("removePokeOnly", { "idPlayer": GlobalPlayer.idPlayer }, true)
		if(_nodeInstancePokemon.get_children().find(_poke) != -1):
			_nodeInstancePokemon.remove_child(_poke)

func setChangeMove(dataMove):
	if Utils.isFileExist("res://Scenes/attacks/"+dataMove.moveName+"/"+dataMove.moveName+".tscn"):
		# Input.set_default_cursor_shape(Input.CURSOR_CROSS)
		changeMove = dataMove
	else:
		print("Ataque não encontrado: ", dataMove.moveName)

# notifica para o painel que tem uma nova instancia
# func activeNotification(dataNotifi): # recebe uma json de notificação e converte para objeto
# 	emit_signal("add_notification", getNotifi(dataNotifi))

# notifica para o painel que tem uma nova instancia
# func setMovePainel(dataNotifi): # recebe uma json de notificação e converte para objeto
# 	emit_signal("add_move_painel", getNotifi(dataNotifi))

# notifica para o painel de alerta que tem uma nova mensagem
func addAlert(alert): # pode ser string ou bool
	emit_signal("add_alert", alert)

# notifica para o painel de alerta que tem uma nova mensagem com tempo de encerramento
func addAlertTemp(alert): # pode ser string ou bool, tempo que o alerta ficará ativo
	emit_signal("add_alert_temp", alert, timeAlert)

# recebe um json e retorna o node de notificação
func getNotifi(dataNotifi): # json{ type: "addTak", text: "" }
	var notifi = load("res://Scenes/screens/Notification.tscn").instance()
	notifi.dataNotifi = dataNotifi
	return notifi

# quando selecione um movimento
# remove o alerta em caso de click com o botão esquerdo
func _unhandled_input(event):
	if event.is_action("click_right"):
		if changeMove:
			Input.set_default_cursor_shape(Input.CURSOR_ARROW)
			addAlert(false)

# pega o proximo pokemon disponivel para a batalha
func getPokeBattleConfig(): #jsonDataPoke	
	var dataPoke = GlobalPlayer.getDataPokeBag(0)
	var index = 0
	
	for dPoke in GlobalPlayer.dataPokesBag:
		if(dPoke.acHp > 0):
			dataPoke = dPoke
			GlobalPlayer.pokePositionSelect = index
			break
		index += 1

	GlobalPlayer.idPokeSelect = dataPoke.idPokemon
	GlobalPlayer.emitRefreshPokeProfiles()
	return dataPoke

#FIXME instance Poke
func instancePoke(dataPoke, initialPosition: Vector2, nodeInstancePokemon: Node2D) -> void:
	if is_instance_valid(_poke) && is_instance_valid(nodeInstancePokemon):
		for poke in nodeInstancePokemon.get_children():
			if poke == _poke: 
				nodeInstancePokemon.remove_child(_poke)
	
	_poke = GlobalPoke.getPokeBag(dataPoke)
	_poke.add_to_group("player_self")
	nodeInstancePokemon.add_child(_poke)
	GlobalPlayer.setPokeInstance(_poke)
	GlobalPoke.setStatusPokeBag(_poke, dataPoke)
	GlobalPoke.setAttacksInPoke(_poke, dataPoke)
	_poke.position = initialPosition
	_poke.id = dataPoke.idPokemon
	_poke.isPlayer = _isPokePlayer
	_poke.isFollow = _isPokeFollow
	_poke.idPlayer = GlobalPlayer.idPlayer
	_poke.pokeController.startLabelLv()
	_poke.enableSight(!_isPokeFollow)
#	_poke.gameReady()

func startPokeBattle(isNetwork: bool, isPokePlayer: bool) -> void:
	var initialPos = _initialPositions[0]
	_isPokeFollow = !isPokePlayer
	_isPokePlayer = isPokePlayer
	
	if(isRandInitialPosition):
		initialPos = Utils.randInt(0, _initialPositions.size())

	var dataPoke = getPokeBattleConfig()
	instancePoke(dataPoke, initialPos, _nodeInstancePokemon)
	_poke.isNetwork = isNetwork

func isExistOtherPokeAlive(id: int) -> bool:
	for poke in GlobalPlayer.dataPokesBag:
		if poke.idPokemon != id && poke.acHp > 0:
			return true
	return false

func isExistPokeAlive() -> bool:
	if !GlobalPlayer.hasPokeBag():
		return false
	
	var index = 0
	var resp = false
	var next = true

	while(next && index < 6):
		if(GlobalPlayer.isExistDataPokesBag(index)):
			if(GlobalPlayer.isPokeDead(index)):
				index += 1
			else:
				resp = true
				next = false
		else:
			next = false
	return resp

func setInitialDataBattle(initialPositions: Array, nodeInstancePokemon: Node2D):
	_initialPositions = initialPositions
	_nodeInstancePokemon = nodeInstancePokemon

func _on_change_poke(dataPoke):
	if(is_instance_valid(_poke)):
		var posOldPoke = _poke.position
		_poke.enableCamera(false)
		_poke.queue_free()
		instancePoke(dataPoke, posOldPoke, _nodeInstancePokemon)	

func setPoke(poke):
	_poke = poke

func getPoke():
	return _poke

func setPlayer(player):
	_player = player

func getPlayer():
	return _player

#FIXME instancePlayer
func instancePlayer(node: Node2D, position: Vector2, isPlayer: bool, isNetwork: bool):
	if (!is_instance_valid(_player)):
		var player = load(GlobalPlayer.personName).instance()
		player.id = GlobalPlayer.idPlayer
		player.add_to_group("player_self")
		player.setNickname(GlobalPlayer.nickname, true)
		setPlayer(player)
	
	_player.isNetwork = isNetwork
	_player.isPlayer = isPlayer
	_player.global_position = position
	node.add_child(_player)

func changeScene():
	if(is_instance_valid(_poke)):
		_poke.enableCamera(false)
	if(is_instance_valid(_player)):
		_player.enableCamera(false)
	
	removePersonsInstance()
	GlobalPlayer.emitRefreshPokeProfiles()

# apenas adiciona a notificação no array.
# Não salva
func addNotify(notify):
	Game.notifications.push_front(notify)

# apenas adiciona a notificação no array. Não salva no banco	
func addMoveNotifyInPoke(dataPoke, notify):
	var n = notify.duplicate()
	n.text = Msg.addMove(notify.moveName)
	#BUG addMoveNotify caso não funcione
	dataPoke.moveNotify.push_front(n)

func notify(icon: String, text: String) -> void:
	addNotify({"icon": icon, "text": text})
	# Request.saveNotification()

# ativa camera principal no de acordo com a variável isPersonControll(caso seja falso está controlando o poke)
func configCamera():
	if isPersonControl:
		enableCamera(_player, true)
		enableCamera(_poke, false)
	else:
		enableCamera(_poke, true)
		enableCamera(_player, false)

# ativa camera principal no objeto(player ou poke)
func enableCamera(object: Node2D, value: bool):
	if is_instance_valid(object):
		if(value):
			if(!object.has_node("Screen")):
				object.add_child(getScreen())
		else:
			if(object.has_node("Screen")):
				object.remove_child(Game.screen)

func getScreen():
	if !is_instance_valid(screen):
		screen = load("res://Scenes/screens/Screen.tscn").instance()
	return screen

func getNewScreen():
	return load("res://Scenes/screens/Screen.tscn").instance()
  
func generatePokesMob(node: Node2D):
	if(pokesMobBattle):
		setQuantEnemies(pokesMobBattle.size()) 
		for pk in pokesMobBattle:
			node.add_child(pk)
			# pk.pokeController.startLabelLv()

#FIXME savePoke
func savePoke(poke: Pokemon, isCatch: bool):
	var dataNewPoke = {
		"nickname": poke.pokeStatus.Name,
		"hp": poke.pokeStatus.statusDefault.hp,
		"atk": poke.pokeController.getValueStatus('atk'),
		"atkSp": poke.pokeController.getValueStatus('atkSp'),
		"def": poke.pokeController.getValueStatus('def'),
		"defSp": poke.pokeController.getValueStatus('defSp'),
		"gender": poke.pokeController.getValueStatus('gender'),
		"level": poke.pokeController.getValueStatus('level'),
		"isShiny": poke.pokeStatus.isShiny,
		"xp": PokemonXp.new().getLimitLevel(poke.pokeController.getValueStatus('level'), poke.pokeStatus.levelingRate),
		"code": poke.pokeStatus.code,
		"speed": 100,
		"isCanEvo": 0,
		"lr": poke.pokeStatus.levelingRate,
		"iv": poke.pokeController.getValueStatus('iv'),
		"move1": null,
		"move2": null,
		"move3": null,
		"move4": null
	}

	if poke.isBoss:
		dataNewPoke.level = 10
		dataNewPoke.xp = PokemonXp.new().getLimitLevel(10, poke.pokeStatus.levelingRate)

		dataNewPoke.atk = dataNewPoke.atk / 2
		dataNewPoke.atkSp = dataNewPoke.atkSp / 2
		dataNewPoke.hp = dataNewPoke.hp / 3
		dataNewPoke.def = dataNewPoke.def / 3
		dataNewPoke.defSp = dataNewPoke.defSp / 3
		dataNewPoke.speed = dataNewPoke.speed / 3

	if(poke.pokeStatus.move1):
		dataNewPoke['move1'] = poke.pokeStatus.move1
	if(poke.pokeStatus.move2):
		dataNewPoke['move2'] = poke.pokeStatus.move2
	if(poke.pokeStatus.move3):
		dataNewPoke['move3'] = poke.pokeStatus.move3
	if(poke.pokeStatus.move4):
		dataNewPoke['move4'] = poke.pokeStatus.move4
	
	var quantiPokeBag = GlobalPlayer.dataPokesBag.size()
	if quantiPokeBag < 6 && !verifyPokeCodeRepeatInTemp(dataNewPoke.code) && !GlobalPlayer.verifyPokePokeBagRepeat(dataNewPoke.code):
		dataNewPoke['idPosition'] = quantiPokeBag+1
		dataNewPoke['isBag'] = 0
		tempCodePokesBag.push_back(dataNewPoke.code)
	else: # poke vai para depot, isBag = 1
		dataNewPoke['idPosition'] = 0
		dataNewPoke['isBag'] = 1

	var channelSend = "addPokeDepot"

	# pokemon capturado
	if(dataNewPoke['isBag'] == 0 && isCatch):
		channelSend = "newPokeCatch"
	# pokemon adquirido sem ser capturado
	elif(dataNewPoke['isBag'] == 0 && !isCatch):
		channelSend = "newPoke"

	# Request.saveNewPoke(dataNewPoke, channelSend)

func verifyPokeCodeRepeatInTemp(code: int) -> bool:
	for codePoke in tempCodePokesBag:
		if(codePoke == code):
			return true
	return false

func addInitialPoke(code: int):
	GlobalPlayer.isInitialPoke = false
	var pokeInit = PokeList.getPokeById(code)
	pokeInit.isPlayer = false
	add_child(pokeInit)
	savePoke(pokeInit, false)
	remove_child(pokeInit)

func setIsSwitch(switch: bool):
	isSwitch = switch

func getIsSwitch() -> bool:
	return isSwitch
