extends Node

var pokes: Dictionary = {}
var players: Dictionary = {}
var pokesMobs: Dictionary = {}
var nodePokes: Node2D
var nodePlayers: Node2D
var nodeMobs: Node2D
var groupLocationName: String
var typeMap: String = ""

var isEmitPlayer = false
var isEmitPoke = false

var targetRaid = false

var offline = false

func start():
	GlobalServer.connect("server_response", self, "_on_server_response")

	if (is_instance_valid(Game.getPlayer())):
		players[str(GlobalPlayer.idPlayer)] = Game.getPlayer()

# RESPOSTAS DO SERVIDOR
func _on_server_response(response: Dictionary) -> void:
	callv(response.action, [response.dataPlayer])

# para o cliente enviar comando para movePoke do servidor
func setIsBattle(dataPlayer: Dictionary):
	Game.isBattle = dataPlayer.isBattle

# Mudança de grupo: remover todos os outros players e instanciar os novos
func changeGroup(dataPlayer: Dictionary) -> void:
	var idsPlayers = players.keys()
	
	for idPlayer in idsPlayers:
		removePlayer({"idPlayer": idPlayer})
	
	for info in dataPlayer["infosPlayers"]:
		playerMove(info)

func invokePoke(infoPlayer):
	Game._nodeInstancePokemon = get_node("Pokes")
	Game.setInitialDataBattle([GlobalPlayer.getPosition()], nodePokes)

	Game.startPokeBattle(true, true)
	Game.getPoke().position = GlobalPlayer.getPosition()

func removePlayer(infoPlayer: Dictionary) -> void:
	# verifica se não é o próprio id
	if str(infoPlayer.idPlayer) != str(GlobalPlayer.idPlayer):
		removePokeByIdPlayer(infoPlayer.idPlayer)
		searchRemovePlayer(infoPlayer.idPlayer)

func removePokeByIdPlayer(idPlayer: int):
	var key = str(idPlayer)
	if pokes.has(key):
		if is_instance_valid(pokes[key]):
			pokes[key].queue_free()
		pokes.erase(key)

func countPokes() -> int:
	var amount = 0
	for id in pokes:
		amount += 1
	return amount

func pokeMove(infoPoke: Dictionary):
	var strIdPlayer = str(infoPoke.idPlayer)
	
	if pokes.has(strIdPlayer):
		if is_instance_valid(pokes[strIdPlayer]):
			if pokes[strIdPlayer].id == infoPoke.idPokemon:
				setStatePoke(pokes[strIdPlayer], infoPoke)
			else:
				removePoke(infoPoke)
				addPoke(infoPoke)
	elif infoPoke.idPlayer:
		addPoke(infoPoke)
	else: # poke mob/boss(IA)
		var idInstance = str(infoPoke.idInstance)
		
		if pokesMobs.has(idInstance):
			if is_instance_valid(pokesMobs[idInstance]):
				setStatePoke(pokesMobs[idInstance], infoPoke)
			else:
				pokesMobs.erase(idInstance)
		else:
			addPokeMob(infoPoke)
		
func setInfoControl(infoServer: Dictionary) -> void:
	Game.getPlayer().isPlayer = infoServer.isPersonControl
	
	Game.isBattle = infoServer.isBattle
	Game.isPersonControl = infoServer.isPersonControl
	Game.enablePersonControl = infoServer.enablePersonControl
	Game.enablePokeControl = infoServer.enablePokeControl
	
	Game.configCamera()

# adiciona e movimenta o jogador
func playerMove(infoPlayer: Dictionary) -> void:
	if infoPlayer && !infoPlayer.empty() && infoPlayer.has("id"):
		if(existPlayer(infoPlayer.id)):
			var player = players[str(infoPlayer.id)]
			setStatePlayer(player, infoPlayer)
		else:
			if !isSelf(infoPlayer.id):
				addPlayer(infoPlayer)

func existPlayer(idPlayer: int) -> bool:
	if players.has(str(idPlayer)):
		if is_instance_valid(players[str(idPlayer)]):
			return true
	return false

func existPoke(infoPoke: Dictionary) -> bool:
	var strIdPlayer = str(infoPoke.idPlayer)
	
	if pokes.has(strIdPlayer):
		if is_instance_valid(pokes[strIdPlayer]):
			if pokes[strIdPlayer].id == infoPoke.idPokemon:
				return true
	return false

func isSelf(idPlayer: int) -> bool:
	if GlobalPlayer.idPlayer == idPlayer:
		return true
	return false

func getInfoPlayer(input_vector: Vector2, direction: Vector2, isRun: bool) -> Dictionary:
	return {
		"input_vector": input_vector,
		"direction": direction,
		"isRun": isRun
	}

func getInfoPokePlayer(input_vector: Vector2, direction: Vector2, momentAttack: int) -> Dictionary:
	return {
		"input_vector": input_vector,
		"directionPoke": direction,
		"momentAttack": momentAttack
	}

#FIXME state player
func setStatePlayer(player: Player, infoPlayer: Dictionary) -> void:
#	player.setInputVector(infoPlayer.input_vector)
#	player.direction = infoPlayer.direction
#	player.move(infoPlayer.velocity)
	
	player.isRun = infoPlayer.isRun

	player.normalizedInput()
	
	player.direction = infoPlayer.direction
	player.setInputVector(infoPlayer.input_vector)

	player.serverMove()
	player.global_position = infoPlayer.position

# FIXME state poke
func setStatePoke(poke, infoPoke) -> void:
	if !isSelf(infoPoke.idPlayer):
		poke.labelLv.text = str(infoPoke.playerName, "\nLv ", poke.pokeStatus.status.level)
#	if (poke.isLive() && poke.state == poke.DEAD):
#		# poke.state = poke.MOVE
#		#testar
#		poke.pokeController.revive(infoPoke.status.hp)
	
	poke.global_position = infoPoke.position
	poke.pokeController.setStatus(infoPoke.status)
	poke.pokeController.getHealthBar().updated(infoPoke.status.hp)

	if(infoPoke.status.hp > 0):
		
#		if !isSelf(infoPoke.idPlayer):
		processConditions(poke, infoPoke)
		
		if(infoPoke.isNetworkDamage):
			poke.flashAnimation()
		
		if(!infoPoke.isSleep):
			poke.normalizedInput()
			
#			if !isSelf(infoPoke.idPlayer):
			poke.input_vector = infoPoke.input_vector
			poke.directionPoke = infoPoke.directionPoke

			#verifica se não está no mundo
#			if !GlobalPlayer.inWorld:
			poke.move(infoPoke.velocity)

		if(infoPoke.isAttack):
			poke.isAttack = true
			if infoPoke.momentAttack == 1:
				poke.state = poke.ATTACK_1
			elif infoPoke.momentAttack == 2:
				poke.state = poke.ATTACK_2
			elif infoPoke.momentAttack == 3:
				poke.state = poke.ATTACK_3
			elif infoPoke.momentAttack == 4:
				poke.state = poke.ATTACK_4
#	else:
#		poke.input_vector = Vector2.ZERO

func processConditions(poke: Pokemon, infoPoke) -> void:
	poke.isBurn = infoPoke.isBurn
	poke.isSeed = infoPoke.isSeed
	poke.isSleep = infoPoke.isSleep
	poke.isFreeze = infoPoke.isFreeze
	poke.isPoison = infoPoke.isPoison
	poke.isParalysis = infoPoke.isParalysis
	poke.isConfusion = infoPoke.isConfusion

	if(poke.isSleep):
		if(poke.state != poke.SLEEP):
			poke.startSleep()
	else:
		if(poke.state == poke.SLEEP):
			poke.state = poke.MOVE

func searchRemovePoke(infoPoke: Dictionary) -> void:
	if existPoke(infoPoke):
		pokes[str(infoPoke.idPlayer)].queue_free()

func addPokeMob(infoPoke) -> void:
	var poke = PokeList.getPokeById(infoPoke.code)
	
	poke.id = infoPoke.idPokemon
	poke.idPlayer = infoPoke.idPlayer
	pokesMobs[str(infoPoke.idInstance)] = poke
	poke.isPlayer = false
	poke.isNetwork = true
	nodeMobs.add_child(poke)
	
	poke.hideSight()
	poke.pokeController.startLabelLv()
	setStatePoke(poke, infoPoke)
	
	poke.add_to_group("poke_mob")
	poke.add_to_group("poke_enemy")

func addPoke(infoPoke) -> void:
	removePokeByIdPlayer(infoPoke.idPlayer)
	
	var poke = PokeList.getPokeById(infoPoke.code)
	
	poke.id = infoPoke.idPokemon
	poke.idPlayer = infoPoke.idPlayer
	pokes[str(infoPoke.idPlayer)] = poke
	poke.isPlayer = false
	poke.isNetwork = true
	nodePokes.add_child(poke)
	
	poke.pokeController.setStatus(infoPoke.status)
	poke.pokeController.refreshStatusDefault(infoPoke.status.maxHp)
	poke.hideSight()
	poke.pokeController.startLabelLv()
	GlobalPoke.setAttacksInPoke(poke, infoPoke)
	setStatePoke(poke, infoPoke)
	
	if isSelf(infoPoke.idPlayer):
		poke.add_to_group("poke_self")
		Game.setPoke(poke)

func getPersonObject(personName: String):
	return load("res://Scenes/players/"+personName+"/"+personName+".tscn").instance()

# Adiciona outros jogadores
func addPlayer(infoPlayer) -> void:
	if is_instance_valid(nodePlayers):
		var player = getPersonObject(infoPlayer.personName)
		nodePlayers.add_child(player)
		
		player.id = infoPlayer.id
		players[str(infoPlayer.id)] = player
		player.isPlayer = false
		player.setNickname(infoPlayer.nickname, false)

		setStatePlayer(player, infoPlayer)

func removePoke(infoPlayer: Dictionary) -> void:
	var idPlayer = str(infoPlayer.idPlayer)
	
	if pokes.has(idPlayer):
		if is_instance_valid(pokes[idPlayer]):
			pokes[idPlayer].queue_free()
			pokes.erase(idPlayer)

func searchRemovePlayer(idPlayer: int) -> void:
	if existPlayer(idPlayer):
		players[str(idPlayer)].queue_free()
		pokes.erase(str(idPlayer))


func getInfoPoke(): # -> infoPoke
#	var poke = Game.getPoke()
#
#	if(is_instance_valid(poke)):
#		return {
#			"poke":{
#				"id": poke.id,
#				"idPlayer": GlobalPlayer.idPlayer,
#				"name": GlobalPlayer.getDataPokeBagByPokeSelect().nickname,
#				"playerName": GlobalPlayer.nickname,
#				"code": poke.pokeStatus.code,
#				"status": poke.pokeStatus.status,
#
#				"isAttack": poke.isAttack,
#				"momentAttack": poke.momentAttack,
#				"isNetworkDamage": poke.isNetworkDamage,
#
#				"isBurn": poke.isBurn,
#				"isSeed": poke.isSeed,
#				"isSleep": poke.isSleep,
#				"isPoison": poke.isPoison,
#				"isFreeze": poke.isFreeze,
#				"isParalysis": poke.isParalysis,
#				"isConfusion": poke.isConfusion,
#				"groupLocationName": groupLocationName,
#
#				"move1": GlobalPlayer.getDataPokeBagByPokeSelect().move1,
#				"move2": GlobalPlayer.getDataPokeBagByPokeSelect().move2,
#				"move3": GlobalPlayer.getDataPokeBagByPokeSelect().move3,
#				"move4": GlobalPlayer.getDataPokeBagByPokeSelect().move4,
#
#				"velocity": {
#					"x": poke.velocity.x,
#					"y": poke.velocity.y
#				},
#				"directionPoke":{
#					"x": poke.directionPoke.x,
#					"y": poke.directionPoke.y
#				},
#				"input_vector": {
#					"x": poke.input_vector.x,
#					"y": poke.input_vector.y
#				},
#				"position": {
#					"x": poke.position.x,
#					"y": poke.position.y
#				},
#			}
#		}
#	else:
	return {"poke": null}
