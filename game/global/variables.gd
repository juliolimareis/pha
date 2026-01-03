class_name VariablesGlobal

static var _MOVE_PATH = "res://game/moves/{MOVE_NAME}/{MOVE_NAME}.tscn"
static var _POKEMON_SPRITE_PATH = "res://img/pokemons/{POKEMON_NAME}.png"

static func getMoveInstance(name: String) -> MoveNode:
  return load(_MOVE_PATH.format({"MOVE_NAME": name})).instance()

static func getPokemonSprite(name: String) -> String:
  return _POKEMON_SPRITE_PATH.format({"POKEMON_NAME": name})
  
