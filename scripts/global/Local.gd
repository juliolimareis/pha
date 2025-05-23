extends Node

enum {
	trainingArena
}

func getLocalName(local) -> String:
	match local:
		trainingArena:
			return "res://Scenes/AreaTest.tscn"
	return GlobalScene.world
