class_name VariablesGlobal

static var _MOVE_PATH := "res://game/moves/{MOVE_NAME}/{MOVE_NAME}.tscn"
static var _POKEMON_SPRITE_PATH := "res://img/pokemons/{POKEMON_NAME}.png"

static func getMoveInstance(name: String) -> MoveNode:
	var path := _MOVE_PATH.format({"MOVE_NAME": name})
	var scene := load(path) as PackedScene
	
	if scene == null:
		push_error("Move scene not found: %s" % path)
		return null

	return scene.instantiate() as MoveNode

static func getPokemonSprite(name: String) -> String:
	return _POKEMON_SPRITE_PATH.format({"POKEMON_NAME": name})
  
