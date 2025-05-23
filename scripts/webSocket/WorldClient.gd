extends Node

var controller: WorldController = WorldController.new()

var err
var isConn = false
var isReady = false
var isOtherPlayers = false
var nodeInstancePlayer

#Essa classe nunca é reiniciada
#instancia o jogador e inicia evento de atualização de jogador
func start() -> void:
	if !isReady:
		Server.connect("channel_statePlayer", self, "_on_statePlayer")
		Server.connect("channel_statePlayer_disconnect", self, "_on_statePlayer_disconnect")
	
	addSelfPlayer()
	isReady = true

func _process(delta):
	delta = delta
	playerMonitor()

func setNodePlayers(path: String):
	nodeInstancePlayer = get_node(path)

func setOtherPlayers(value: bool):
	isOtherPlayers = value

func _on_statePlayer_disconnect(infoPlayer):
	removePlayer(infoPlayer.id)

func _on_statePlayer(infoPlayer):
	if isReady:
		refreshPlayer(infoPlayer)

func playerMonitor() -> void:
	if isReady:
		emitStatePlayer()

func emitStatePlayer() -> void:
	var idSelf = GlobalPlayer.idPlayer
	if (isReady && is_instance_valid(controller.players[str(idSelf)])):
		Server.emit("statePlayer", controller.getInfoPlayer())

#cria personagem
func instancePerson(dir: String) -> Node2D:
	return load(dir).instance()

#function addSelfPlayer
func addSelfPlayer() -> void:

	Game.instancePlayer(
		nodeInstancePlayer,
		GlobalPlayer.playerPosition, 
		true,
		true
	)
	
	controller.setSelfPlayer(Game.getPlayer())
	
	if !isReady:
		Server.emit("addPlayer", controller.getInfoPlayer())

# Adiciona outros jogadores
func addPlayer(infoPlayer) -> void:
	if is_instance_valid(nodeInstancePlayer):
		var player = instancePerson(infoPlayer.personName)
		player.add_to_group("player_other")
		nodeInstancePlayer.add_child(player)
		controller.addPlayer(player, infoPlayer)
		controller.setPosition(player, infoPlayer)
	
# func instancieSelfPlayer() -> void:
# 	# controller.refreshPokeJson()
# 	controller.setVisiblePlayer(true)

# Atualiza os jogadores
func refreshPlayer(infoPlayer) -> void:
	if(GlobalPlayer.locationName == "world" && existPlayer(infoPlayer.id)):
		if(infoPlayer.locationName == GlobalPlayer.locationName):
			var player = controller.players[str(infoPlayer.id)]
			if (is_instance_valid(player)):
				controller.setStatePlayer(player, infoPlayer)
		else:
			removePlayer(infoPlayer.id)
	else:
		if infoPlayer.id != GlobalPlayer.idPlayer:
			if(infoPlayer.locationName == GlobalPlayer.locationName):
				addPlayer(infoPlayer)

func removePlayer(id) -> void:
	for key in controller.players:
		if(key == str(id)):
			if(is_instance_valid(controller.players[str(id)])):
				controller.players[str(id)].queue_free() 

func existPlayer(idPlayer):
	for id in controller.players:
		if id == str(idPlayer):
			return true
	return false

