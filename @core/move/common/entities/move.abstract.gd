class_name MoveAbstract

enum Category {
  PHYSICAL,
  SPECIAL,
  STATUS
}

enum FormatType {
  RANGE,
  CLOSE,
  SIGHT
}

var id := ""
var code := 0
var name := ""
var pwr := 0
var countdown := 1
var type := PokemonBaseAbstract.Type.NORMAL
var category := Category.SPECIAL

var velocity := 250
var time := 0
var prepare := true
var hold := false
var formatType := FormatType.RANGE

var effectAccuracy := 100
var effectTime := 2.0

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
