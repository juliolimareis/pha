extends TextureRect

class_name DepotItem

onready var info: Node2D = get_parent().get_node("Info")

#json de ddados do pokémon
var pokeData setget setPokeData, getPokeData
#se esse slot está na bag ou no depot
var isBag = false
#posição do array onde este elemento está
var index = 0

func _ready():
	setInfos()
	info.visible = false
	get_parent().connect("mouse_left_click", self, "_on_mouse_left")
	# get_parent().connect("mouse_right_click", self, "_on_mouse_right")
	addMiniaturePoke()

func _on_mouse_left():
	DepotController.setIdPokesUpdate(isBag, index, pokeData)

func addMiniaturePoke():
	var pokeName = PokeList.getName(pokeData.code)
	texture = Utils.getPokeMiniature(pokeName)

func setPokeData(data):
	pokeData = data

func setIndex(i: int):
	index = i

func getPokeData():
	return pokeData

func _on_PokeDepot_mouse_entered():
	info.visible = true

func _on_PokeDepot_mouse_exited():
	info.visible = false

func setInfos():
	info.get_node("Label").text = pokeData.nickname +", Lv "+str(pokeData.level)
