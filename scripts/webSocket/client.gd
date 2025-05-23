extends Node2D

var ws = WebSocketClient.new()
var err
var players: Array = []
var isRefresh: bool = false
var isReady: bool = false
var enemies: Array = []
var controller: ClientController = ClientController.new()
var isConn = false
var timeForLive: int = 0

var pokeDefault = null
var pokeList: Array = [
	"Raticate",
	"Ivysaur",
	"Bulbasaur",
	"Charmander",
	"Charmeleon",
	"Squirtle",
	"Wartortle",
	"Butterfree",
	"Fearow",
	"Beedrill",
	"Zapdos",
	"Raikou",
	"Charizard",
	"Blastoise",
	"Venusaur",
	"Clefable",
	"Scyther",
	"Machamp",
	"Salamence",
	"Metagross",
	"Flareon",
	"Umbreon",
	"Swampert",
	"Gengar",
	"Lapras"
]
 
var rand = RandomNumberGenerator.new()

func _ready() -> void:
	connectServer()

func _process(delta) -> void:
	ws.poll()
	#connectServer()
	verifyResetPoke()
	playerMonitor()

func verifyResetPoke() -> void:
	if(isReady):
		if(controller.pokePlayer != null):
			if(!controller.pokePlayer.isLive()):
				if(timeForLive == 250):
					addNewPoke()
				else:
					timeForLive += 1

func addNewPoke() -> void:
	removePoke(controller.getInfoPokePlayer().player)
	var pokeNumber = randInt(0, pokeList.size() -1)
	
	if(pokeDefault != null):
		pokeNumber = pokeDefault
	
	var newPoke = instancePerson(pokeList[pokeNumber])
	setPokeRandomPositionToStart(newPoke)
	
	newPoke.isNetwork = true
	newPoke.id = controller.selfId
	controller.setSelfPoke(newPoke)
	
	timeForLive = 0
	add_child(newPoke)
	emitReplacePoke()

func playerMonitor() -> void:
	#if(controller.isRefreshPlayer()):
	emitStatePlayer()

func emitReplacePoke() -> void:
	if isReady:
		emit("replacePoke", controller.getInfoPokePlayer())

func emitStatePlayer() -> void:
	if isReady:
		emit("statePlayer", controller.getInfoPokePlayer())

func randInt(init: int, end: int) -> int:
	return AttackProcess.new().getRandomInt(init, end)

#cria um pokemon
func instancePerson(name: String):
	return load("res://Scenes/characters/"+name+"/"+name+".tscn").instance()
	# return poke.instance()
	
# recebe um array de jogadores/verifica se já adicionou, se não adiconar
func addOthersPlayers(infoPlayers) -> void:
	var addPokes = []
	for pokeInfo in infoPlayers:
		if(controller.selfId != pokeInfo.id):
			if(!verifyExistPokeInPokes(pokeInfo.id)):
				addPokes.push_back(pokeInfo)
	#adiconar os não encontrados
	for pokeInfo in addPokes:
		addPlayer(pokeInfo)

func verifyExistPokeInPokes(id) -> bool:
	for poke in controller.pokes:
		if(poke.id == id):
			return true
	return false
	
func getPokeAndPosInPokes(id):
	var pos: int = 0
	for poke in controller.pokes:
		if(poke.id == id):
			return {"pos": pos, "poke": poke }
		pos += 1
	return null

func removePoke(infoPoke) -> void:
	var dataPoke = getPokeAndPosInPokes(infoPoke.id)
	if(dataPoke != null):
		controller.pokes.remove(dataPoke.pos)
		dataPoke.poke.queue_free()

func replacePoke(infoPoke) -> void:
	if(infoPoke.id != controller.selfId):
		var infoReplacePoke = getPokeAndPosInPokes(infoPoke.id)
		removePoke(infoReplacePoke.poke)
		addPlayer(infoPoke)

func addPlayer(infoPlayer) -> void:
	var player = instancePerson(infoPlayer.status.name)
	player.isPlayer = false
	player.hideSight()
	add_child(player)
	controller.setPosition(player, infoPlayer)
	controller.addPoke(player, infoPlayer)

func addSelfPlayer() -> void:
	var pokeNumber = randInt(0, pokeList.size() -1)
	
	if(pokeDefault != null):
		pokeNumber = pokeDefault
		
	var playerNode = instancePerson(pokeList[pokeNumber])
	playerNode.isNetwork = true
	add_child(playerNode)
	controller.setSelfPoke(playerNode)
	controller.setVisiblePokePlayer(false)
	setPokeRandomPositionToStart(playerNode)
	emit("addPlayer", controller.getInfo(playerNode))
	isReady = true

func instancieSelfPlayer(receiverPlayer) -> void:
	controller.setId(receiverPlayer.id)
	controller.refreshPokeJson()
	controller.setVisiblePokePlayer(true)

func setPokeRandomPositionToStart(poke: Pokemon) -> void:
	var locaPosition: int = randInt(0,4)
	if(locaPosition == 0): #superior esquerdo
		poke.position = Vector2(16, 19)
	elif(locaPosition == 1): #superior direito
		poke.position = Vector2(295, 19)
	elif(locaPosition == 2): #inferior esquerdo
		poke.position = Vector2(16, 156)
	elif(locaPosition == 3): #inferior direito
		poke.position = Vector2(295, 156)
	else: #centro
		poke.position = Vector2(156, 84)

func refreshPlayer(player) -> void:
	for poke in controller.pokes:
		if(poke.id == player.id):
			controller.setStatePlayer(poke, player)

############### SERVER FUNCTIONS #################
func _connected(proto = "") -> void:
	print("Connected")
	emit("auth", {"token": "5f4ds8t4ads4fg6d54g"})

#recebe dados do servidor!
func _on_data() -> void:
	var receiver = JSON.parse(ws.get_peer(1).get_packet().get_string_from_utf8()).result
	
	#recebe 1 jogador para atualizar o status
	if(receiver.type == "statePlayer"):
		refreshPlayer(receiver.player)
	#recebe um ok da atualização dos status deste jogador
	elif(receiver.type == "stateSelf"):
		controller.refreshPokeJson()
	#recebe o jogador com id do servidor
	elif(receiver.type == "addSelfPlayer"):
		instancieSelfPlayer(receiver.player)
	#recebe um array de jogadores para verificar e instanciar 
	elif(receiver.type == "addPlayers"):
		#instanciar novo jogador other
		addOthersPlayers(receiver.players)
	elif(receiver.type == "removePoke"):
		removePoke(receiver.poke)
	elif(receiver.type == "replacePoke"):
		replacePoke(receiver.poke)
	elif(receiver.type == "auth"):
		addSelfPlayer()
		
func _closed() -> void:
	isConn = false
	print("connection closed")

func _on_Button_pressed() -> void:
	#ws.disconnect_from_host(1000, str(data["id"]))
	get_tree().quit()

func emit(type: String, json) -> void:
	json["type"] = type
	ws.get_peer(1).put_packet(JSON.print(json).to_utf8())
	
func connectServer() -> void:
	if(!isConn):
		#print($enemies.get_children()[0].get_instance_id())
		ws.connect('connection_closed', self, '_closed')
		ws.connect('connection_error', self, '_closed')
		ws.connect('connection_established', self, '_connected')
		ws.connect('data_received', self, '_on_data')
		
		err = ws.connect_to_url(GlobalUrl.battleSocket)
		
		if err == OK:
			isConn = true
		else:
			isConn = false
			print('connection refused')
