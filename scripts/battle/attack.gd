extends Area2D

class_name MoveAttack

@export var attackName = "scratch"
@export var animationFinished = false
@export var move = true
@export var velocity = 250
@export var time = 0
@export var inverse = false
@export var prepare = true
@export var hold = false

@export_enum("Status", "Normal", "Fire", "Fighting", "Water", "Flying", "Grass", "Poison", "Electric", "Ground", "Psychic", "Rock", "Ice", "Bug", "Dragon", "Ghost", "Dark", "Steel", "Fairy") var type: int

@onready var id = self.get_instance_id()
@onready var timer: Timer = Timer.new()
@onready var status: moveStatus = $status

var direction = Vector2(0, 0)

var isAttack: bool = false
# caso seja instancia de informação (Info)
var isInfo: bool = false

func _ready() -> void:
	if !isInfo:
		$animation.play("attack")
		startTimer()

func _process(delta) -> void:
	translate(direction * velocity * delta)

func startTimer() -> void:
	if(time > 0):
		timer.one_shot = true
		timer.set_wait_time(time)
		timer.connect("timeout", _on_Timer_timeout_remove_attack)
		add_child(timer)
		timer.start()

func _on_Timer_timeout_remove_attack() -> void:
	queue_free()

func finished() -> void:
	if(animationFinished && attackName):
		var finished = load("res://Scenes/attacks/"+attackName+"/"+attackName+"_finished.tscn").instance()
		var world = get_tree().current_scene
		world.add_child(finished)
		finished.global_position = global_position
	queue_free()

func set_dir(val) -> void:
	direction = val

func set_rotat(val) -> void:
	rotation = val

func _on_Fire_1_body_entered(body: Node2D) -> void:
#	if body.is_in_group("player_self") || body.is_in_group("player_friend"):
#		return
	if !isInfo:
		if(verifySelfDamage(body)):
			return
		if(animationFinished):
			finished()

func _on_notifier_screen_exited() -> void:
	if !isInfo:
		queue_free()

func verifySelfDamage(body: Node2D):
	return $status.receiverIsAttack(body)
