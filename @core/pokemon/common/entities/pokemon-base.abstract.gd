class_name PokemonBaseAbstract

var id: String = ""
var code: int = 0
var name: String = ""
var levelingRate: int = PokemonLevel.LevelingRate.MEDIUM

var atk: int = 0
var def: int = 0
var hp: int = 0
var sp_atk: int = 0
var sp_def: int = 0
var speed: int = 0

var genderBase: int = 0 # para saber a probabilidade de ser macho 
var type: Array[int] = []

var catchRate: int = 90

var atk_ev: int = 0
var atkSp_ev: int = 0
var def_ev: int = 0
var defSp_ev: int = 0
var exp_ev: int = 157
var hp_ev: int = 0
var speed_ev: int = 0

var acceleration = 400
var max_speed = 65
var friction = 400

func _init():
	if get_class() == "PokemonBaseAbstract":
		push_error("PokemonBaseAbstract is abstract class")
