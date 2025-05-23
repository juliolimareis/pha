extends Node2D

var poke: Pokemon
var pokeXp = PokemonXp.new()
var personPosition = Vector2(295.587, 116.221)
var initialPositionPokePlayer =  Vector2(225,115)

onready var nodePokePlayers = $players
onready var nodeMobs = $mobs

func _ready() -> void:
	Game.setInitialDataBattle([initialPositionPokePlayer], nodePokePlayers)
	Game.startPokeBattle(false, true)
	
	Game.instancePlayer(self, personPosition, false, false)
	
	Game.generatePokesMob(nodeMobs)
	setPositionsMob()

func setPositionsMob():
	for pk in Game.pokesMobBattle:
		pk.position = getRandPos()

#x > 14 && x < 345
#y > 29 && < 225
func getRandPos() -> Vector2:
	return Vector2(Utils.randInt(14, 245), Utils.randInt(29, 225))
