extends Node

var SERVER = GlobalUrl.SERVER
var SERVER_PORT = GlobalUrl.SERVER_PORT

var isConnect = false
var serverMessage = ""

var peer
var username = ""
var passwd = ""

signal server_response(response)

############### CONEXÃO ################

func startConnect(_username: String, _passwd: String) -> void:
	peer = ENetMultiplayerPeer.new()
	username = _username
	passwd = _passwd
	
	peer.create_client(SERVER, SERVER_PORT)
	get_tree().network_peer = peer

	peer.connect("connection_succeeded", self, "_player_on_connect")
	
	# erros
	peer.connect("connection_failed", self, "_player_on_failed")
	peer.connect("server_disconnected", self, "_player_on_disconnect")
	peer.set_target_peer(1)
	
	isConnect = true
	
	setServerMessage("")

func _startGame(dataPlayer):
	GlobalPlayer.setDataPlayer(dataPlayer)
	GlobalPlayer.startGame = true
	get_tree().change_scene(GlobalScene.startGame)

func _player_on_connect():
	print("Player connect.")
	isConnect = true
	rpc_id(1, "startConnection", username, passwd)

func _player_on_failed(args):
	print(args)
	serverMessage = "Failed to connect server."

func _player_on_disconnect():
	peer = null
	isConnect = false
	if has_node("/root/Login"):
		setServerMessage("Invalid Cridentials.")
	else:
		GlobalScene.toLogin()
	
func _setServerMessage(msg: String):
	setServerMessage(msg)
	
func setServerMessage(msg: String):
	serverMessage = msg
	print(serverMessage)
	
func getServerMessage():
	return serverMessage
	
############### SENDS E RESPONSES ################

# envia dados para o servidor
func rpcId(actionName, data):
	rpc_id(1, "dataSend", {
		"action": actionName,
		"dataPlayer": data
	})

# recebe dados dos servidor
func serverResponse(response):
	emit_signal("server_response", response)

# função fantasma apenas para ter no cliente (essa função existe apenas no lado do servidor)
func sendPokeMove(dataPlayer, poke):
	pass
	
func sendPlayerMove(dataPlayer):
	pass
