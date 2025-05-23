class_name MoveBaseAbstract

enum AttackType {
  PTHYSICAL,
  SPECIAL
}

var power = 0
var countdown: float = 1
var type: int = PokemonType.NORMAL
var attackType: int = AttackType.PTHYSICAL

func _init() -> void:
	if get_class() == "MovieBaseAbstract":
		push_error("MovieAbstract is abstract class")

func accuracy() -> bool:
	return false
