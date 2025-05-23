extends Node2D

class_name PokeFollow

var thisPoke: Node2D
var target: Node2D 

var countStateZero: int = 0
var delta: float

func _process(_delta: float) -> void:
	delta = _delta
	thisPoke = get_parent()

	if thisPoke.isFollow && is_instance_valid(thisPoke):
		if(is_instance_valid(target)):
			thisPoke.isPlayer = false
			if(thisPoke.isLive() && calcDistance() >= 35):
				action()
#			else:
#				thisPoke.input_vector = Vector2.ZERO

func action() -> void:
	if calcDistance() >= 70:
		thisPoke.global_position = target.global_position
	
	var targetPosition = target.global_position
	var direction = (targetPosition - thisPoke.global_position).normalized()
	
	thisPoke.input_vector = direction
	move(direction)

func move(direction) -> void:
	thisPoke.move_and_slide(direction * 40)
	thisPoke.isEmitServer = true

func calcDistance() -> float:
	return thisPoke.global_position.distance_to(target.global_position)
