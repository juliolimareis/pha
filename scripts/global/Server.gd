extends Node

var err
var isConn = false
var isReady = false
var ws = WebSocketClient.new()

# chamado após validação de usuário no servidor
signal start_game()
# emite sinal de jogadores na mesma região
signal channel_statePlayer(infoPlayer)
# emite sinal de jogadores na mesma região disconecta
signal channel_statePlayer_disconnect(infoPlayer)
# emite outros sinais
signal channel_other(receiver)
# emite quando conecta no servidor
signal _connected()

func _process(delta):
	delta = delta
	if(isConn):
		ws.poll()

func initConn() -> void:
	connectServer()

func start():
	emit("auth", {"token": GlobalPlayer.token})
	
func processAuth(dataPlayer):
	GlobalPlayer.setDataPlayer(dataPlayer)
	isReady = true

func connectServer() -> void:
	ws.connect('connection_error', self, '_connection_error')
	ws.connect('connection_closed', self, '_closed')
	ws.connect('data_received', self, '_on_receiver')
	ws.connect('server_close_request', self, '_server_close_request')
	ws.connect('connection_established', self, '_connected')
	
	err = ws.connect_to_url(GlobalUrl.worldSocket)

	if err == OK:
		isConn = true
	else:
		isConn = false
		print('connection refused')

func _on_receiver() -> void:
	var receiver = JSON.parse(ws.get_peer(1).get_packet().get_string_from_utf8()).result

	if(receiver.type == "auth"):
		processAuth(receiver.dataPlayer)
		emit_signal("start_game")
	else:
		if(receiver.type == "statePlayer" && isReady):
			# if(GlobalPlayer.locationName == receiver.infoPlayer.locationName):
			emit_signal("channel_statePlayer", receiver.infoPlayer)
		elif(receiver.type == "removePlayer" && isReady):
			# if(GlobalPlayer.locationName == receiver.infoPlayer.locationName):
			emit_signal("channel_statePlayer_disconnect", receiver.infoPlayer)
		else:
			emit_signal("channel_other", receiver)

func _connected(arg) -> void:
	print("connected!", arg)
	print(ws.get_connection_status())
	emit_signal("_connected")

func _server_close_request(arg1, arg2):
	print("_server_close_request", arg1)
	print("_server_close_request", arg2)

func connection_closed(arg):
	print("connection_closed", arg)
	
func _connection_error():
	print("_connection_error")
	print(ws.get_connection_status())
	
func _closed(arg) -> void:
	print(ws.get_connection_status())
	print("_closed ", arg)
	isReady = false
	isConn = false
	GlobalScene.toLogin()

func _close_request() -> void:
	print("_close_request")

func emit(type: String, json) -> void:
	if(ws.get_connection_status() == 2):
		json["type"] = type
		ws.get_peer(1).put_packet(JSON.print(json).to_utf8())

func emitChannel(type: String, json, forAll: bool) -> void:
	if(ws.get_connection_status() == 2):
		var send = { "type": type, "forAll": forAll, "dataPlayer": json, "idPlayer": GlobalPlayer.idPlayer }
		ws.get_peer(1).put_packet(JSON.print(send).to_utf8())

func Get(endpoint, channel, body):
	request(endpoint, channel, 'get', body)

func Put(endpoint, channel, body):
	request(endpoint, channel, 'put', body)

func Post(endpoint, channel, body):
	request(endpoint, channel, 'post', body)

func request(endpoint, channel, method, body):
	var request = {
		"endpoint": endpoint,
		"token": GlobalPlayer.token,
		"channel": channel,
		"method": method,
		"body": body
	}
	emit('api', request)
