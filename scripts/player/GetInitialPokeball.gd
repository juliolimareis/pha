extends Node2D

export (String) var imagePath

func _ready():
	if(imagePath):
		$PokeballGreen.texture = load(imagePath)

func _on_Area2D_body_entered(body):
	pass
#	if body.is_in_group("player_self") && !GlobalPlayer.hasPokeBag() && GlobalPlayer.isInitialPoke:
#		Game.addInitialPoke(int(name))
#		queue_free()
