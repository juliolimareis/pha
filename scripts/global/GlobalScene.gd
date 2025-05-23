extends Node
# Classe responsável por guardar os links de rotas das telas

#var world: String = "res://Scenes/WorldTest.tscn"
var world: String = "res://Scenes/maps/Client.tscn"
var login: String = "res://Scenes/screens/login.tscn"
var register: String = "res://Scenes/screens/register.tscn"
var startGame: String = "res://Scenes/screens/StartGame.tscn"
var battleGrass: String = "res://Scenes/maps/battle/Battle.tscn"

func toWorld():
	Game.isAreaCatch = false
	GlobalPlayer.isBattle = false
	GlobalPlayer.locationName = "world"
	GlobalPlayer.setInWorld(true)
	changeScene(world)

func toLogin():
	get_tree().change_scene(login)

func toRegister():
	get_tree().change_scene(register)

func toMap(local: String):
	GlobalScene.changeScene("res://Scenes/maps/"+local+".tscn")

func changeScene(scene: String):
	Game.changeScene()
	if GlobalPlayer.isRaid:
		Server.emit("exitRaid", {})
	GlobalPlayer.isRaid = false
	GlobalPlayer.isPvp = false

	get_tree().change_scene(scene)
