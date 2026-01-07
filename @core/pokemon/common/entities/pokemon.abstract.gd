class_name PokemonAbstract
extends PokemonBaseAbstract

var experience: int = 0
var status_effects: Array[PokemonStatusEffect] = []
var status_effects_unaffected: Array[PokemonStatusEffect] = []
var isUnaffected = false
var _moves: Array[MoveAbstract] = []
var acceleration = 400
var max_speed = 65
var friction = 400

var _currentData: PokemonBaseAbstract

func _init():
	if get_class() == "PokemonAbstract":
		push_error("PokemonAbstract is abstract class")
	
	resetCurrentData()

func getMove(index: int) -> MoveAbstract:
	if hasMoveIndex(index):
		return _moves[index]
	else:
		push_error("Invalid move index: " + str(index))
		return null

func hasMoveIndex(index: int) -> bool:
	return index >= 0 and index < _moves.size()

func replaceMove(moveCode: int, index: int):
	if index >= 0 && index < _moves.size():
		var new_move := MoveFactory.build(moveCode)

		if !new_move:
			push_error("Invalid move code: " + str(moveCode))
			return

		_moves.set(index, new_move)
	else:
		push_error("Invalid move index: " + str(index))

func addMove(moveCode: int):
	if _moves.size() < 4:
		var new_move := MoveFactory.build(moveCode)

		if !new_move:
			push_error("Invalid move code: " + str(moveCode))
			return
	  
		_moves.append(new_move)
	else:
		push_error("Cannot add more than 4 moves to a Pokemon.")

func resetCurrentData():
	var _self = self as PokemonBaseAbstract
	_currentData = _self.copy()

func _to_string() -> String:
	return PokemonDecorator.toString(self)
