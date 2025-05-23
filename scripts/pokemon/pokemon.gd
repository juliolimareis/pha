extends CharacterBody2D

class_name Pokemon 

@export var ACCELERATION = 400
@export var MAX_SPEED = 65
@export var FRICTION = 400

enum {
	DEAD,
	MOVE,
	SLEEP,
	ATTACK_1, ATTACK_2, ATTACK_3, ATTACK_4,
}

var state = MOVE

@export var isPlayer = true

@export var move1: String = ""
@export var move2: String = ""
@export var move3: String = ""
@export var move4: String = ""

@onready var animationTree: AnimationTree = $AnimationTree
@onready var animationPlayer = $AnimationPlayer
@onready var animationState = animationTree.get("parameters/playback")

var input_vector = Vector2(0, 0)

var pathMove1 = ""
var pathMove2 = ""
var pathMove3 = ""
var pathMove4 = ""

var momentAttack: int = 1
var moveAttack: MoveAttack
var isAttack: bool = false
var directionPoke = Vector2(-1,0)
var isMove: bool = true
var isNetwork: bool = false
var max_speed_default: int = MAX_SPEED

var delta

@export var code: int = 1
var pokemonAbstract: PokemonAbstract = PokemonFactory.build(code);

func _ready():
	mountAttacks()
	animationPlayer.active = true
	animationTree.active = true

	#if(isPlayer):
		#var camera = Camera2D.new()
		#camera.make_current()
		#add_child(camera)

func _process(delta):
	match state:
		MOVE:
			move_state(delta)
			isAttack = false
		SLEEP:
			animationTree.set("parameters/sleep/blend_position", input_vector)
			animationState.travel("sleep")
		DEAD:
			animationTree.set("parameters/dead/blend_position", input_vector)
			animationState.travel("dead")
		ATTACK_1:
			attack_1_state()
		ATTACK_2:
			attack_2_state()
		ATTACK_3:
			attack_3_state()
		ATTACK_4:
			attack_4_state()

func normalizedInput():
	input_vector = input_vector.normalized()

func move(velocity_: Vector2) -> void:
	move_and_slide()

func move_state(_delta: float) -> void:
	delta = _delta
	
	#if(isConfusion):
		#input_vector = Vector2(randInt(-1,1), randInt(-1,1))
#	if isPlayer && !GlobalPlayer.isChat:
	if isPlayer:
		input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
		input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
		configDirection()
	
	if input_vector != Vector2.ZERO:
		animationTree.set("parameters/Idle/blend_position", input_vector)
		animationTree.set("parameters/Run/blend_position", input_vector)
		animationTree.set("parameters/Attack/blend_position", input_vector)
		animationTree.set("parameters/AttackSp/blend_position", input_vector)
		animationState.travel("Run")
		velocity = velocity.move_toward(input_vector * MAX_SPEED, ACCELERATION * delta)
	else:
		animationState.travel("Idle")
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
		
	if(isPlayer):
		move_and_slide()
	
	input_vector = Vector2.ZERO
	
	#if(isPlayer && !isAttack && !isFreeze && !GlobalPlayer.isChat):
	if Input.is_action_just_pressed("attack_1"):
		atk1()
	elif Input.is_action_just_pressed("attack_2"):
		atk2()
	elif Input.is_action_just_pressed("attack_3"):
		atk3()
	elif Input.is_action_just_pressed("attack_4"):
		atk4()

func mountAttacks():
	if(move1):
		move1 = "res://Scenes/attacks/"+str(move1)+"/"+str(move1)+".tscn"
	if(move2):
		move2 = "res://Scenes/attacks/"+str(move2)+"/"+str(move2)+".tscn"
	if(move3):
		move3 = "res://Scenes/attacks/"+str(move3)+"/"+str(move3)+".tscn"
	if(move4):
		move4 = "res://Scenes/attacks/"+str(move4)+"/"+str(move4)+".tscn"

func atk1():
	if(pathMove1):
		momentAttack = 1
		isAttack = true
		state = ATTACK_1
func atk2():
	if(pathMove2):
		momentAttack = 2
		isAttack = true
		state = ATTACK_2
func atk3():
	if(pathMove3):
		momentAttack = 3
		isAttack = true
		state = ATTACK_3
func atk4():
	if(pathMove4):
		momentAttack = 4
		isAttack = true
		state = ATTACK_4

func attack_1_state():
	if(isAttack):
		instanceAndAnimateAttack(pathMove1)
func attack_2_state():
	if(isAttack):
		instanceAndAnimateAttack(pathMove2)
func attack_3_state():
	if(isAttack):
		instanceAndAnimateAttack(pathMove3)
func attack_4_state():
	if(isAttack):
		instanceAndAnimateAttack(pathMove4)
	
func instanceAndAnimateAttack(pathMove):
	isAttack = false

	if pathMove:
		moveAttack = load(pathMove).instance()
		animationStateAttack(moveAttack)
	
#animação chama este evento
func attack_animation_fnished():
	attack()
	isAttack = false
	isMove = true
	state = MOVE

func attack():
	if(moveAttack != null):
		atkRange()
	elif(moveAttack.get_node("status").getTarget() == "sight"):
		#atkSight()
		pass
	else:
		atkClose()

#func atkSight():
	#moveAttack = setAttackStatus(moveAttack)
	
	if(moveAttack.hold):
		$Attack/sight.add_child(moveAttack)
	else:
		moveAttack.global_position = $Attack/sight.global_position
		get_parent().add_child(moveAttack)
	
func atkClose():
	#moveAttack = setAttackStatus(moveAttack)
	moveAttack.direction = Vector2.ZERO
	
	if(moveAttack.hold):
		$closeAttack.add_child(moveAttack)
	else:
		moveAttack.global_position = $closeAttack.global_position
		get_parent().add_child(moveAttack)

func atkRange():
	#moveAttack = setAttackStatus(moveAttack)
	
	if(!moveAttack.inverse):
		moveAttack.rotation = getRotationAttack()
		
	if(moveAttack.move):
		moveAttack.direction = getDirectionAttack()
	
	if(moveAttack.hold):
		$Attack/range.add_child(moveAttack)
	else:
		moveAttack.global_position = $Attack/range.global_position
#		get_parent().add_child(moveAttack)
		get_node("/root/Server").add_child(moveAttack)

#func atkSight():
	#moveAttack = setAttackStatus(moveAttack)
	#
	#if(moveAttack.hold):
		#$Attack/sight.add_child(moveAttack)
	#else:
		#moveAttack.global_position = $Attack/sight.global_position
		#get_parent().add_child(moveAttack)
	
#func atkClose():
	#moveAttack = setAttackStatus(moveAttack)
	#moveAttack.direction = Vector2.ZERO
	#
	#if(moveAttack.hold):
		#$closeAttack.add_child(moveAttack)
	#else:
		#moveAttack.global_position = $closeAttack.global_position
		#get_parent().add_child(moveAttack)

func animationStateAttack(moveAttack: MoveAttack):
	if(moveAttack.status.atkType == "Physical"):
		animationState.travel("Attack")
	else:
		animationState.travel("AttackSp")

func configDirection() -> void:
	if Input.is_action_just_pressed("ui_up"):
		directionPoke = Vector2(0,-1)
	elif Input.is_action_just_pressed("ui_down"):
		directionPoke = Vector2(0,1)
	elif Input.is_action_just_pressed("ui_left"):
		directionPoke = Vector2(-1,0)
	elif Input.is_action_just_pressed("ui_right"):
		directionPoke = Vector2(1,0)

func getDirectionAttack() -> Vector2:
	if(input_vector == Vector2.ZERO):
		return directionPoke
	return input_vector.normalized()

func getRotationAttack() -> float:
	if(input_vector == Vector2.ZERO):
		return directionPoke.normalized().angle()
	return input_vector.normalized().angle()

func hideSight() -> void:
	$Attack.visible = false

func enableSight(value: bool) -> void:
	$Attack.visible = value

func flashAnimationCatch(isCatch: bool) -> void:
	if isCatch:
		$Sprite.modulate = "#ff4a4a"
	else: 
		$Sprite.modulate = "#ffffff"

func randInt(init: int, end: int) -> int:
	return AttackProcess.new().getRandomInt(init, end)
	
