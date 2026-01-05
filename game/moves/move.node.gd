extends Area2D
class_name MoveNode

@export var code := 1
@export var inverse := false
@export var hasAnimationFinished := false

@onready var id: int = self.get_instance_id()
@onready var timer := Timer.new()
#@onready var status: moveStatus = $status

var move: MoveAbstract
var direction := Vector2(0, 0)
var isAttack := false
# caso seja instancia de informação (Info)
var isInfo := false

func _init():
	move = MoveFactory.build(code)

func _ready() -> void:
	if !isInfo:
		$animation.play("attack")
		startTimer()

func _process(delta) -> void:
	translate(direction * move.velocity * delta)

func startTimer() -> void:
	if(move.time > 0):
		timer.one_shot = true
		timer.set_wait_time(move.time)
		timer.connect("timeout", _on_timer_timeout_remove_attack)
		add_child(timer)
		timer.start()

func _on_timer_timeout_remove_attack() -> void:
	queue_free()

func finished() -> void:
	if(hasAnimationFinished && move.name):
		var animation_node = load("res://Scenes/attacks/"+move.name+"/"+move.name+"_finished.tscn").instance()
		var world = get_tree().current_scene
		world.add_child(animation_node)
		animation_node.global_position = global_position
	queue_free()

func set_dir(val) -> void:
	direction = val

# func set_rotation(val) -> void:
# 	rotation = val

func _on_Fire_1_body_entered(body: Node2D) -> void:
#	if body.is_in_group("player_self") || body.is_in_group("player_friend"):
#		return
	#if !isInfo:
		#if(verifySelfDamage(body)):
			#return
	if(hasAnimationFinished):
		finished()

func _on_notifier_screen_exited() -> void:
	if !isInfo:
		queue_free()

#func verifySelfDamage(body: Node2D):
	#return $status.receiverIsAttack(body)
