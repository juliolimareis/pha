extends CharacterBody2D
class_name PokemonNode 

@export var code: int = 0
var pokemon: PokemonAbstract = null

#@export var ACCELERATION = 400
#@export var MAX_SPEED = 65
#@export var FRICTION = 400

enum State {
	ATTACK_1,
	ATTACK_2,
	ATTACK_3,
	ATTACK_4,
	MOVE,
	DEAD,
	SLEEP,
}

var state = State.MOVE

@export var isPlayer = true

@export var codeMove1: int = 0
@export var codeMove2: int = 0
@export var codeMove3: int = 0
@export var codeMove4: int = 0

@onready var animationTree: AnimationTree = $AnimationTree
@onready var animationPlayer = $AnimationPlayer
@onready var animationState = animationTree.get("parameters/playback")

var input_vector = Vector2(0, 0)

var momentAttack: int = 1
var moveAttack: MoveNode
var isAttack: bool = false
var directionPoke = Vector2(-1,0)
var isMove: bool = true
var isNetwork: bool = false
var max_speed_default: int = 0

func mount() -> void:
	pokemon = PokemonFactory.build(code)
	max_speed_default = pokemon.max_speed

	if codeMove1:
		pokemon.addMove(codeMove1)
	if codeMove2:
		pokemon.addMove(codeMove2)
	if codeMove3:
		pokemon.addMove(codeMove3)
	if codeMove4:
		pokemon.addMove(codeMove4)

func _ready():
	mount()
	mountSprite()
	animationPlayer.active = true
	animationTree.active = true

	if(isPlayer):
		var camera = Camera2D.new()
		add_child(camera)

func _process(delta):
	match state:
		State.ATTACK_1:
			attack_state(0)
		State.ATTACK_2:
			attack_state(1)
		State.ATTACK_3:
			attack_state(2)
		State.ATTACK_4:
			attack_state(3)
		State.MOVE:
			move_state(delta)
		State.SLEEP:
			animationTree.set("parameters/sleep/blend_position", input_vector)
			animationState.travel("sleep")
		State.DEAD:
			animationTree.set("parameters/dead/blend_position", input_vector)
			animationState.travel("dead")

func move_state(delta: float) -> void:
	if !isMove:
		animationState.travel("Idle")
		return
	
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
		velocity = velocity.move_toward(input_vector * pokemon.max_speed, pokemon.acceleration * delta)
	else:
		animationState.travel("Idle")
		velocity = velocity.move_toward(Vector2.ZERO, pokemon.friction * delta)
		
	if(isPlayer):
		move_and_slide()
	
	input_vector = Vector2.ZERO
	
	#if(isPlayer && !isAttack):
	if Input.is_action_just_pressed("attack_1"):
		prepareMove(State.ATTACK_1)
	elif Input.is_action_just_pressed("attack_2"):
		prepareMove(State.ATTACK_2)
	elif Input.is_action_just_pressed("attack_3"):
		prepareMove(State.ATTACK_3)
	elif Input.is_action_just_pressed("attack_4"):
		prepareMove(State.ATTACK_4)

func mountSprite() -> void:
	var sprite_path := VariablesGlobal.getPokemonSprite(pokemon.name)
	var image := Image.new()
	var error := image.load(sprite_path)
	var texture := ImageTexture.new()
	
	if (error != OK):
		push_error("Error loading pokemon sprite" + pokemon.name)
  
	texture.set_image(image)
	get_node("Sprite").texture = texture

func prepareMove(moveState: State):
	if(pokemon.hasMoveIndex(moveState)):
		momentAttack = moveState
		isAttack = true
		state = moveState

func attack_state(index: int):
	if(isAttack and pokemon.hasMoveIndex(index)):
		instanceAndAnimateAttack(index)
	else:
		state = State.MOVE
	
func instanceAndAnimateAttack(index: int):
	var moveNode = VariablesGlobal.getMoveInstance(pokemon.getMove(index).name)

	if moveNode:
		isMove = false
		animationStateAttack(moveNode)
	
# animação chama este evento
func attack_animation_finished():
	#attack()
	isAttack = false
	isMove = true
	state = State.MOVE

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
		#get_node("/root/Server").add_child(moveAttack)

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

func animationStateAttack(moveNode: MoveNode):
	if(moveNode.move.category == MoveAbstract.Category.PHYSICAL):
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

func _on_animation_tree_animation_finished_tree(anim_name: StringName) -> void:
	if anim_name.contains("attack"):
		attack_animation_finished()
