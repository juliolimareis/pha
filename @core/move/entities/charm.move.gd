extends MoveAbstract
class_name CharmMove

func _init() -> void:
	id = "charm-move"
	code = 1
	name = "Charm"
	pwr = 0
	countdown = 1
	type = PokemonBaseAbstract.Type.FAIRY
	category = MoveAbstract.Category.STATUS

	velocity = 250
	time = 0
	formatType = FormatType.RANGE

	effectAccuracy = 100
	effectTime = 2.0
