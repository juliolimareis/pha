extends Node2D

#FIXME Inicio do game
func _ready():
	startGame()
#	if Server.isReady:
#		_on_start()
#	else:
#		Server.start()
#		Server.connect("start_game", self, "_on_start")
#
#func _on_start():
#	if Game.isValidVersion:
#		Server.connect("channel_other", self, "_on_channel_server")
#		Request.getServerData("gameVersion")
#	else:
#		startGame()
#
#func _on_channel_server(receiver):
#	# verifica a vessão do jogo
#	if(receiver.type == "gameVersion"):
#		if(receiver.dataPlayer.gameVersion == Game.version.replace("HMG-", "").replace("DEV-", "")):
#			startGame()
#		else:
#			Game.isVersion = false
#			GlobalScene.toLogin()
			
func startGame():
	GlobalScene.toWorld()
