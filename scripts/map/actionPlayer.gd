extends Node2D

enum action {
	DEPOT,
	CURE_ALL,
	SMASH,
	CUT,
	NOME
}

export (action) var isAction = action.NOME

var isArea = false

func _ready():
	connect("body_entered", self, "_on_body_entered")
	connect("body_exited", self, "_on_body_exited")

func _input(event: InputEvent) -> void:
	if(isArea):
		if(event.is_action_pressed("action") && !GlobalPlayer.isChat):
			match isAction:
				action.DEPOT:
					DepotController.setIsOpenDepot(true)
				action.CURE_ALL:
					GlobalPlayer.cureAll()
#				action.SMASH:
#					GlobalPlayer.smash()
#				action.CUT:
#					GlobalPlayer.cut()
				action.NOME:
					print("No action selected")
				
func _on_body_entered(body):
	if body.is_in_group("player_self"):
		# if GlobalPlayer.hasPokeBag():
		activeArea()

func activeArea():
	isArea = true
	GlobalPlayer.emitAreaBattle(true)

func _on_body_exited(body):
	if body.is_in_group("player_self"):
		isArea = false
		GlobalPlayer.emitAreaBattle(false)

