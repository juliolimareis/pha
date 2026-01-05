class_name MoveAbstract

enum Category {
  PHYSICAL,
  SPECIAL,
  STATUS
}

var id := ""
var code := 0
var name := ""
var pwr := 0
var countdown := 1
var type := PokemonType.NORMAL
var category := Category.SPECIAL

var velocity := 250
var time := 0
var prepare := true
var hold := false

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
