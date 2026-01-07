class_name PokemonBaseAbstract

var id := ""
var code := 0
var name := ""
var level := 1
var levelingRate := PokemonLevel.LevelingRate.MEDIUM
var gender := 0 # 1 = macho, 0 = fêmea

var hp := 0
var atk := 0
var def := 0
var sp_atk := 0
var sp_def := 0
var speed := 0

var genderBase := 50 # para saber a probabilidade de ser macho 
var type: Array[PokemonBaseAbstract.Type] = []

var catchRate := 90

var atk_ev := 4
var atkSp_ev := 4
var def_ev := 4
var defSp_ev := 4
var exp_ev := 157
var hp_ev := 4
var speed_ev := 4

var atk_iv := 0
var atkSp_iv := 0
var def_iv := 0
var defSp_iv := 0
var hp_iv := 0
var speed_iv := 0

func _init():
	if get_class() == "PokemonBaseAbstract":
		push_error("PokemonBaseAbstract is abstract class")

enum Type {
	NORMAL,
	FIRE,
	WATER,
	GRASS,
	ELECTRIC,
	ICE,
	FIGHTING,
	POISON,
	GROUND,
	FLYING,
	PSYCHIC,
	BUG,
	ROCK,
	GHOST,
	DRAGON,
	DARK,
	STEEL,
	FAIRY,
	STELLAR
}
