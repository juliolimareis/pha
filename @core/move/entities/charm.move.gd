extends MoveAbstract
class_name CharmMove

func _init() -> void:
	id = "charm-move"
	code = 1
	name = "Charm"
	pwr = 20
	countdown = 1
	type = PokemonType.FAIRY
	category = MoveAbstract.Category.STATUS

	velocity = 250
	time = 0
	formatType = FormatType.RANGE

	effectAccuracy = 100
	effectTime = 2.0
