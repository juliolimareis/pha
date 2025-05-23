extends Control

onready var buttonNotifi = $ButtonNotifi
onready var painelNotifi = $PainelNotifi
onready var animNotifi = $ButtonNotifi/AnimatedSprite
onready var vBoxContainer = $PainelNotifi/TextureRect/ScrollContainer/VBoxContainer

func _ready() -> void:
	buttonNotifi.connect("mouse_left_click", self, "_on_enable_painel")
	GlobalPlayer.connect("change_main_poke", self, "refreshPainel")
	GlobalPlayer.connect("change_poke", self, "_on_change_poke")
	Server.connect("channel_other", self, "_on_server_response")
	
	if(Server.isReady):
		if(GlobalPlayer.hasPokeBag()):
			# Request.getMoveNotifi()
			_on_change_poke(GlobalPlayer.getDataPokeBagByPokeSelect())

func _on_enable_painel() -> void:
	enablePainel(!painelNotifi.visible)
	setAnim(false)

func enablePainel(enable: bool) -> void:
	painelNotifi.visible = enable

func setAnim(enable: bool) -> void:
	if enable:
		animNotifi.play("Notifi")
	else:
		animNotifi.play("Idle")

func _on_server_response(receiver):
	if(receiver.type == "response_moves_notifi_poke"):
		if receiver.dataPlayer.size() > 0:
			if receiver.dataPlayer[0].idPokemon == GlobalPlayer.getDataPokeBagByPokeSelect().idPokemon:
				refreshPainel()
				removeAllNotifiInPainal()
				Game.notificationsMove = receiver.dataPlayer
				setNotifi()

#FIXME refreshNotifiPainel: quando o jogador muda de pokemon
func _on_change_poke(dataPoke) -> void:
	Game.notificationsMove = dataPoke.moveNotify
	refreshPainel()
	
func refreshPainel() -> void:
	Game.notificationsMove = GlobalPlayer.getDataPokeBagByPokeSelect().moveNotify
	removeAllNotifiInPainal()
	setNotifi()

func setNotifi():
	for i in Game.notificationsMove.size():
		var n = Game.getNotifi(Game.notificationsMove[i])
		n.isClick = true
		n.type = "addAtk"
		vBoxContainer.add_child(n)

func removeAllNotifiInPainal():
	for notifi in vBoxContainer.get_children():
		notifi.queue_free()
