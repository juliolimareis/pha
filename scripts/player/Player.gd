extends CharacterBody2D

# XXX: Player
class_name Player

@export var FRICTION = 400
@export var MAX_SPEED = 60
@export var RUN_SPEED = 80
@export var ACCELERATION = 200

enum {
	MOVE,
	ATTACK_1
}

var id
var state = MOVE

@export var isPlayer: bool = false
@export var isSlave: bool = false

@onready var animationTree = $AnimationTree
@onready var animationPlayer = $AnimationPlayer
@onready var chatLabel = $ChatLabel
@onready var animationState = animationTree.get("parameters/playback")
@onready var screen
#var playerController = PlayerController.new(self)

@onready var input_vector = Vector2(0,0)
@onready var timerChat = $TimerChat

var moveAttack
var pathMove: String = "res://Scenes/items/pokeball_action.tscn"
var isMove: bool = true
var momentAttack: int = 1
var isAttack: bool = false
var isNetwork: bool = false
var max_speed_default: int = MAX_SPEED
var isRun = false

var timeLimitChat = 5
var countTimeChat = 0

var direction = Vector2(-1,0)

var delta

# dados do local de entrada ou saída que o jogador está no momento
#{
#	"locationName": locationName,
#	"postitionY": position.y,
#	"positionX": position.x,
#	"isExit": isExit
#}
var entranceData: Dictionary = {}
# dados do jogador que invocou esse poke
var dataPlayer: Dictionary = {
	# dados para ter uma comunicação via RPC
	"partyName": "", # *
	"locationName": "", # *
	"subLocationName": ""
}
var isServer = false
var isEmitServer = false

func _ready():
	# timerChat.connect("timeout", self, "removeChat")

	if(isPlayer && !isNetwork):
		var camera = Camera2D.new()
		camera.current = true
		add_child(camera)
#	Chat.connect("network_chat", self, "_on_chat_receiver")

#	if(isPlayer):
#		gameReady()

#func gameReady():
#	if(Server.isReady && is_in_group("player_self")):
#		add_child(Game.getScreen())
#		Game.setPlayer(self)
#	elif(!Server.isReady):
#		var camera = Camera2D.new()
#		camera.current = true
#		add_child(camera)

#func _input(event: InputEvent) -> void:
#	if(event.is_action_pressed("action") && GlobalPlayer.locationName == "LabInside" && !GlobalPlayer.isChat):
#		DepotController.isOpenDepot = true

# [ ]: player emitRpc
func emitRpc():
	if(isEmitServer && dataPlayer): # é poke do jogador
		GlobalServer.sendPlayerMove(dataPlayer)
#		print("Player emitRpc")
	isEmitServer = false

func _process(delta) -> void:
	emitRpc()
#	if GlobalPlayer.isBattle:
#		$Battle.visible = true
#	else:
#		$Battle.visible = false
#
#	if is_in_group("player_self") && GlobalPlayer.locationName == "world":
#		GlobalPlayer.setPosition(position)

	if isRun:
		MAX_SPEED = RUN_SPEED
	else:
		MAX_SPEED = max_speed_default

	match state:
		MOVE:
			move_state(delta)
		ATTACK_1:
			attack_1_state()
			
func _on_chat_receiver(dataPlayer):
	if dataPlayer.idPlayer == id:
		chatLabel.text = dataPlayer.text
		timerChat.start()
		countTimeChat = 0

#func _input(event):
#	if event is InputEventKey and !GlobalPlayer.isChat:
#		if event.pressed and event.scancode == KEY_DELETE:
#			Request.setValuePoke(GlobalPlayer.idMainPoke, 'isBag', -1)
#			GlobalPlayer.removePokePokeSelect()
#		if event.pressed and event.scancode == KEY_HOME:
#			Request.setValuePoke(GlobalPlayer.idMainPoke, 'isBag', 1)
#			GlobalPlayer.removePokePokeSelect()

func removeChat():
	if countTimeChat == timeLimitChat:
		countTimeChat = 0
		timerChat.stop()
		chatLabel.text = ""
	else:
		countTimeChat += 1

func getNickname() -> String:
	return $"Name".text

func setNickname(nickname: String, isSelf: bool) -> void:
	$"Name".text = nickname
	if(isSelf): 
		$Name.set("custom_colors/font_color", "#446efc")

func move(veloc: Vector2) -> void:
	move_and_slide()
	
func normalizedInput():
	input_vector = input_vector.normalized()

func setInputVector(input: Vector2) -> void:
	input_vector = input
	
func serverMove() -> void:
	velocity = velocity.move_toward(input_vector * MAX_SPEED, ACCELERATION * delta)
	move(velocity)
	isEmitServer = true

func move_state(_delta) -> void:
	delta = _delta
	isRun = false
#	if(isPlayer && isMove && !GlobalPlayer.isChat):
	if(isPlayer && !isNetwork):
		input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
		input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
		if Input.is_action_pressed("run"):
			isRun = true

		input_vector = input_vector.normalized()
		serverMove()
	
	if input_vector != Vector2.ZERO:
		animationTree.set("parameters/Run/blend_position", input_vector)
		animationTree.set("parameters/Idle/blend_position", input_vector)
		animationTree.set("parameters/Attack/blend_position", input_vector)
		animationTree.set("parameters/AttackSp/blend_position", input_vector)
		animationState.travel("Run")
		velocity = velocity.move_toward(input_vector * MAX_SPEED, ACCELERATION * delta)
		
		# desativar menu depot
#		if is_in_group("player_self") && DepotController.isOpenDepot:
#			DepotController.isOpenDepot = false
	else:
		animationState.travel("Idle")
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)

	input_vector = Vector2.ZERO

func attack_1_state() -> void:
	animationState.travel("Attack")
	
#animação chama este evento
func attack_animation_fnished() -> void:
	dispatchAttack()
	isAttack = false
	isMove = true
	state = MOVE

func dispatchAttack():
	moveAttack = load(pathMove).instance()
	moveAttack.direction = direction
	moveAttack.global_position = global_position
	get_node("/root/Server").add_child(moveAttack)

func attack() -> void:
	if(pathMove):
		state = ATTACK_1

func getPathMove() -> String:
	return moveAttack
func setPathMove(path: String):
	pathMove = path

#func configDirection() -> void:
#	if Input.is_action_just_pressed("ui_up"):
#		direction = Vector2(0,-1)
#	elif Input.is_action_just_pressed("ui_down"):
#		direction = Vector2(0,1)
#	elif Input.is_action_just_pressed("ui_left"):
#		direction = Vector2(-1,0)
#	elif Input.is_action_just_pressed("ui_right"):
#		direction = Vector2(1,0)

func randInt(init: int, end: int) -> int:
	return AttackProcess.new().getRandomInt(init, end)
