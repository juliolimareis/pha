class_name MoveAbstract

enum Type {
  PHYSICAL,
  SPECIAL
}

var id: String = ""
var code: int = 0
var name: String = ""
var pwr: int = 0
var countdown: int = 1
var type: int = PokemonType.NORMAL
var atkType: int = PokemonType.NORMAL

var velocity = 250
var time = 0
var prepare = true
var hold = false

func _init():
	if get_class() == "PokemonMoveAbstract":
		push_error("PokemonMoveAbstract is abstract class")
		pass

func fetchEffects() -> Array[PokemonStatusEffect]:
	push_error("Method 'fetchEffects' has be implemented in PokemonMoveAbstract class")
	return []

func fetchSelfEffects() -> Array[PokemonStatusEffect]:
	push_error("Method 'fetchEffects' has be implemented in PokemonMoveAbstract class")
	return []
