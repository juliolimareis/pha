extends Node

func getItemName(id: int) -> String:
	return items[str(id)]

func getItem(id: int):
	return load("res://Scenes/items/"+getItemName(id)+".tscn").instance()

func getImg(id: int):
	return Utils.getImgItem(getItemName(id))

var items = {
	"1": "pokeball",
	"2": "potion",
	"3": "revive"
}
