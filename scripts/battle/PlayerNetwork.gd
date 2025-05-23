extends Node2D

export (bool) var isTest = false

export (bool) var addPlayer = false
export (bool) var addPoke = false

export (bool) var offline = false

export (String) var groupLocationName = ""
export(String , "", "inside", "world") var typeMap


export (bool) var exitWithActionPress = false
# export (bool) var enableCameraPlayer = false

export (bool) var isRaid = false
export (bool) var isPvp = false
export (bool) var isBattle = false

# export (bool) var isPvp = false

export (Vector2) var playerPosition = Vector2(0,0)
export (Vector2) var positionPoke =  Vector2(0,0)


# export (bool) var isTeam = false

# localização do banco(usado no world)
export (bool) var isNativeLocalization = false

export (bool) var isPlayerPositonRandom = false
export (float) var playerMinX
export (float) var playerMaxX
export (float) var playerMinY
export (float) var playerMaxY

export (bool) var isPokePositonRandom = false
export (float) var pokeMinX
export (float) var pokeMaxX
export (float) var pokeMinY
export (float) var pokeMaxY

onready var nodePokes = get_node('Pokes')
onready var nodePlayers = get_node('Pokes')
onready var nodeMobs = get_node('Mobs')

var player
var isRun = false

var controller = PlayerNetworkController

func _ready() -> void:
	if !isTest:
		
#		GlobalPlayer.isBattle = isBattle
#
#		if isPvp:
#			GlobalPlayer.isPvp = isPvp
#
#		if isRaid:
#			GlobalPlayer.isRaid = isRaid
#			GlobalPlayer.isBattle = isRaid
#
#		GlobalPlayer.setInWorld(!GlobalPlayer.isBattle)

		# GlobalPlayer.isPvp = isPvp
		
		#player
#		Game._nodeInstancePlayer = get_node("Players")
		Game.instancePlayer(nodePlayers, GlobalPlayer.getPosition(), true, true)
		player = Game.getPlayer()
		
		if GlobalPlayer.isBattle:
			enableCamera(false)
			player.isPlayer = false
		else:
			enableCamera(true)
			player.isPlayer = true

		#poke
		
#			Game.getPoke().position = getPosPlayer()
#		else:
#			addPokemon()

		# para evitar que jogador recolha o pokemon
#		Game.setQuantEnemies(1)
		
		controller.offline = offline
		
		controller.isEmitPlayer = addPlayer
		controller.isEmitPoke = addPoke
		
		controller.nodePlayers = nodePlayers
		controller.nodeMobs = nodeMobs
		controller.nodePokes = nodePokes
		controller.groupLocationName = groupLocationName
		controller.typeMap = typeMap
		
		controller.start()
#		if isRaid:
#			controller.boss = get_node("Boss").get_children()[0]
		
func enableCamera(value: bool) -> void:
	Game.enableCamera(player, value)

func getPosPlayer() -> Vector2:
	if isNativeLocalization:
		return GlobalPlayer.playerPosition
	else:
		if isPlayerPositonRandom:
			# if Utils.randInt(0, 1) == 0:
				#rande 1 da arena
				# return Vector2(Utils.randInt(-155, -172), Utils.randInt(-23, 23))
				return Vector2(Utils.randInt(playerMinX, playerMaxX), Utils.randInt(playerMinY, playerMaxY))
			# else:
			# 	#rande 2 da arena
			# 	# return Vector2(Utils.randInt(155, 172), Utils.randInt(-23, 23))
			# 	return Vector2(Utils.randInt(155, 172), Utils.randInt(-23, 23))
		else:
			return playerPosition

func getPosPoke() -> Vector2:
	if isPokePositonRandom:
		return Vector2(Utils.randInt(pokeMinX, pokeMaxX), Utils.randInt(pokeMinY, pokeMaxY))
	else:
		return positionPoke

################## EVENTOS DO JOGADOR ####################

#func _input(event: InputEvent) -> void:
#	if exitWithActionPress:
#		if(event.is_action_pressed("action") && !GlobalPlayer.isChat):
##			controller.emitRemovePoke()
#			Game.emitExitBattle(true)
#			GlobalScene.toWorld()

# ************ KEYBOARD COMMANDS PLAYER **************
func _process(delta):
	delta = delta
	if !player || !is_instance_valid(player):
		return
	
	if Input.is_action_just_pressed("action") && player.entranceData:
		GlobalServer.rpcId("changeLocale", {})
	
	var input_vector = getInputVector()
	var direction = getDirection()
	var momentAttack = getMomentAttack()
	
#	if(player.isPlayer && player.isMove):
	if Game.isPersonControl:
#		player.input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
#		player.input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
#		player.input_vector = player.input_vector.normalized()
#		configDirection()
		if(input_vector != Vector2.ZERO):
			isRun = false
			if Input.is_action_pressed("run"):
				isRun = true
			GlobalServer.rpcId("playerMove", controller.getInfoPlayer(input_vector, direction, isRun))
#			if is_instance_valid(Game.getPoke()):
#				refreshPokeFollow()
	else: # MOVE POKE
		if (is_instance_valid(Game.getPoke()) && (input_vector != Vector2.ZERO || momentAttack != 0)):
			GlobalServer.rpcId("pokeMove", controller.getInfoPokePlayer(input_vector, direction, momentAttack))
	
	if Input.is_action_just_pressed("switchController"):
		if Game.enablePersonControl && Game.enablePokeControl:
			GlobalServer.rpcId("changeControllerPlayer", {})
	
	for i in range(4):
		if Input.is_action_just_pressed("attack_"+str(i+1)):
			GlobalServer.rpcId("atkPoke", {"atkPosition": i+1})
#	ação de invocar poke
	for i in range(6):
		if Input.is_action_just_pressed(str("poke_", (i+1))):
			GlobalServer.rpcId("invokePoke", {"pokePosition": i})

func refreshPokeFollow():
	if Game._isPokeFollow:
		GlobalServer.rpcId("pokeMoveFollow", {})

func getMomentAttack() -> int:
	for i in range(4):
		if Input.is_action_just_pressed("attack_"+str(i+1)):
			return (i+1)
	return 0

func getDirection() -> Vector2:
	if Input.is_action_just_pressed("ui_up"):
		return Vector2.UP
	elif Input.is_action_just_pressed("ui_down"):
		return Vector2.DOWN
	elif Input.is_action_just_pressed("ui_left"):
		return Vector2.LEFT
	elif Input.is_action_just_pressed("ui_right"):
		return Vector2.RIGHT
	else:
		return Vector2.ZERO

func getInputVector() -> Vector2:
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	input_vector = input_vector.normalized()
	return input_vector
# TODO:
#	if(Input.is_action_just_pressed("poke_1") && !GlobalPlayer.isChat):
#		# função para invocar poke follow no mundo
#		# verifica se esta no mundo e se o poke selecionado está vivo
#		if GlobalPlayer.inWorld && GlobalPlayer.dataPokesBag[0].acHp > 0 && !GlobalPlayer.isBattle:
#			# verifica se já tem poke invocado
#			if Game.isPokeInWorld:
#				# verifica se o poke invocado é o mesmo do poke selecionado, remover
#				if is_instance_valid(Game.getPoke()) && Game.getPoke().id == GlobalPlayer.dataPokesBag[0].idPokemon:
#					Game.removePokeInWorld()
#				else: # poke invocado não é igual ao selecionado, emitir trocar
#					GlobalPlayer.emit_signal("change_poke", GlobalPlayer.dataPokesBag[0])
#					Game.activePokeFollow(true)
#			else: # não tem poke invocado, invocar
#				Game.isPokeInWorld = true
#				Game.startPokeBattle(true, false)
#				Game.getPoke().position = GlobalPlayer.playerPosition
#		else: # não está no mundo
#			GlobalPlayer.emitChangePoke(0)
#	elif(Input.is_action_just_pressed("poke_2") && !GlobalPlayer.isChat):
#		GlobalPlayer.emitChangePoke(1)
#	elif(Input.is_action_just_pressed("poke_3") && !GlobalPlayer.isChat):
#		GlobalPlayer.emitChangePoke(2)
#	elif(Input.is_action_just_pressed("poke_4") && !GlobalPlayer.isChat):
#		GlobalPlayer.emitChangePoke(3)
#	elif(Input.is_action_just_pressed("poke_5") && !GlobalPlayer.isChat):
#		GlobalPlayer.emitChangePoke(4)
#	elif(Input.is_action_just_pressed("poke_6") && !GlobalPlayer.isChat):
#		GlobalPlayer.emitChangePoke(5)
