class_name PokemonAbstract
extends PokemonBaseAbstract

var level: int = 1
var experience: int = 0
var status_effects: Array[PokemonStatusEffect] = []
var status_effects_unaffected: Array[PokemonStatusEffect] = []
var isUnaffected = false

var attacks: Array[PokemonAttackAbstract] = []

func _init():
	if get_class() == "PokemonAbstract":
		push_error("PokemonAbstract is abstract class")
