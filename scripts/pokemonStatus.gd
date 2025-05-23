extends Node2D

class_name pokemonStatus

var attackProcess = AttackProcess.new()

@export var Name = ""
@export var code = 0
@export var isShiny = 0

@export_enum("none", "Normal", "Fire", "Fighting", "Water", "Flying", "Grass", "Poison", "Electric", "Ground", "Psychic", "Rock", "Ice", "Bug", "Dragon", "Ghost", "Dark", "Steel", "Fairy") var pokemonType1: int
@export_enum("none", "Normal", "Fire", "Fighting", "Water", "Flying", "Grass", "Poison", "Electric", "Ground", "Psychic", "Rock", "Ice", "Bug", "Dragon", "Ghost", "Dark", "Steel", "Fairy") var pokemonType2: int

#export (int) var level = 3
# se for ultima forma, deixar 0
@export var levelEvolution = 0
# se for ultima forma, deixar 0
@export var codeEvolution = 0
@export var isEvolutionNatual = true

# 0 - (e)Erratic
# 1 - (f)Fest
# 2 - (mf)MediumFest
# 3 - (ms)MediumSlow
# 4 - (s)Slow
# 5 - (fl)Fluctuating
@export_enum("e", "f", "mf", "ms", "s", "fl") var levelingRate: String = "e"

@export var statusBase = {
	"hp": 0,
	"atk": 0,
	"def": 0,
	"atkSp": 0,
	"defSp": 0,
	"gender": 50,
}

@export var move1: String = ""
@export var move2: String = ""
@export var move3: String = ""
@export var move4: String = ""

#export var learnset = {}
# https://bulbapedia.bulbagarden.net/wiki/List_of_Pok%C3%A9mon_by_catch_rate
@export var catchRate = 0
@export var EV = {
	"exp": 0,
	"hp": 0,
	"atk": 0,
	"def": 0,
	"atkSp": 0,
	"defSp": 0,
	"speed": 0,
}

var generatePokemon = GeneratePokemon.new()
var status = {"hp": 0}

var statusDefault = status

var thisPoke = get_parent()

func getStatusDefault():
	return statusDefault

func getStatus():
	return status

func setStatus(newStatus) -> void:
	status = newStatus

func recoverStatusValue(statusName: String) -> void:
	if statusName == "accuracy":
		status[statusName] = 100
	else:
		status[statusName] = statusDefault[statusName]
	# print("Status: "+statusName+" restaurado!")

func pokeDead():
	var xp = {
		"a": 1,
		"b": EV['exp'],
		"t": 1,
		"e": 1,
		"l": status["level"],
		"f": 1,
		"s": 1,
		"ev": EV
	}
#	GlobalPoke.emitPokeDead(get_parent().getPoke(), xp)

func setDamage(damage: int) -> void:
	status.hp -= damage

	if(status.hp <= 0):
		status.hp = 0
		pokeDead()

	if (!get_parent().isNetwork):
		get_parent().pokeController.getHealthBar().updated(status.hp) 
	# print("Vida"+"("+Name+")"+": "+String(status.hp))
	
	# !* Salva o acHp
#	if(get_parent().isPlayer && get_parent().id):
#		GlobalPoke.saveAcHp(get_parent().id, status.hp)

func processDamage(move) -> int:
	if thisPoke.checkUnaffectedValue("all") || thisPoke.checkUnaffectedValue("damage"):
		return 0

	var damage = attackProcess.calcDamage(move, status)
	
	if(get_parent().isNetwork && damage > 0):
		get_parent().isNetworkDamage = true
		get_parent().flashAnimation()
	
	if(damage > 0):
		setDamage(damage)

	return damage

	# print("Damage em "+"("+Name+"): "+ String(damage))

func refreshStatusDefault(defaultHp: int) -> void:
	statusDefault = status.duplicate()
	statusDefault.hp = defaultHp

func getLevel() -> int:
	return get_parent().level
	
func isPlayer() -> bool:
	if(get_parent().isMob):
		return false
	return get_parent().isPlayer

func _ready() -> void:
	if(!isPlayer()):
		status = generatePokemon.generate(statusBase, getLevel())
		if get_parent().isBoss:
			status.atk = status.atk * 2
			status.atkSp = status.atkSp * 2
			status.hp = status.hp * 3
			status.def = status.def * 3
			status.defSp = status.defSp * 3
			status.speed = status.speed * 3
		refreshStatusDefault(status.hp)
	
	status['name'] = Name
	status["speed"] = 100
	status["level"] = getLevel()
	status["accuracy"] = 100
	status["pokemonType1"] = pokemonType1
	status["pokemonType2"] = pokemonType2
	
	# print(status)
