extends Control

onready var buttonNotifi = $ButtonNotifi
onready var painelNotifi = $PainelNotifi
onready var animNotifi = $ButtonNotifi/AnimatedSprite
onready var vBoxContainer = $PainelNotifi/TextureRect/ScrollContainer/VBoxContainer

func _ready() -> void:
	buttonNotifi.connect("mouse_left_click", self, "_on_enable_painel")
	Server.connect("channel_other", self, "_on_server_response")
	Request.getNotifi()

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
	if(receiver.type == "response_notifi"):
		if(receiver.dataPlayer.size() > 0):
			#verifica se é notificação nova, ou se está carregando das notificações antigas
			if(Game.notifications.size() != 0):
				setAnim(true)
			
			Game.notifications = receiver.dataPlayer
			removeAllNotifiInPainal()
			setNotifi()

func clearPainel():
	Game.notifications = []
	Request.saveNotification()

func setNotifi():
	for i in Game.notifications.size():
		var n = Game.getNotifi(Game.notifications[i])
		vBoxContainer.add_child(n)

func removeAllNotifiInPainal():
	for notifi in vBoxContainer.get_children():
		notifi.queue_free()
