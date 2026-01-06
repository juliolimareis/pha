extends MoveAbstract
class_name BiteMove

func _init() -> void:
	id = "bite-move"
	code = 1
	name = "Bite"
	pwr = 60
	countdown = 2
	type = PokemonType.DARK
	category = MoveAbstract.Category.PHYSICAL

	velocity = 250
	time = 0
	formatType = FormatType.RANGE

	effectAccuracy = 100
	effectTime = 3.0
