class_name PokemonAttackAbstract

enum Type {
  PHYSICAL,
  SPECIAL
}

var id: String = ""
var name: String = ""
var pwr: int = 0
var countdown: int = 1
var type: int = PokemonType.NORMAL
var atkType: int = PokemonType.NORMAL

func _init():
	if get_class() == "PokemonAttackAbstract":
		push_error("PokemonAttackAbstract is abstract class")
		pass

func fetchEffects() -> Array[PokemonStatusEffect]:
	push_error("Method 'fetchEffects' has be implemented in PokemonAttackAbstract class")
	return []

func fetchSelfEffects() -> Array[PokemonStatusEffect]:
	push_error("Method 'fetchEffects' has be implemented in PokemonAttackAbstract class")
	return []
