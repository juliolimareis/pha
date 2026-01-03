class_name PokemonAbstract
extends PokemonBaseAbstract

var level: int = 1
var experience: int = 0
var status_effects: Array[PokemonStatusEffect] = []
var status_effects_unaffected: Array[PokemonStatusEffect] = []
var isUnaffected = false

var moves: Array[PokemonMoveAbstract] = []

func _init():
	if get_class() == "PokemonAbstract":
		push_error("PokemonAbstract is abstract class")

func getAttack(attack_id: int) -> PokemonMoveAbstract:
	if moves.has(attack_id - 1):
		return moves[attack_id - 1]
	else:
		return null

