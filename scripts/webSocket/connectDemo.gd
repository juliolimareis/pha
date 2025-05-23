class_name Connect 

# Classe de demo de conexão

var ws = WebSocketClient.new()
#var URL = "ws://26.113.17.234:9001/" #radmin
var URL = "ws://localhost:9002/" 
#var URL = "ws://25.103.65.14:9001/" #ramachi

var err
var isConn = false

func _ready():
	connectServer()



############### Server Fuctions ###############
func connectServer():
		ws.connect('connection_closed', self, '_closed')
		ws.connect('connection_error', self, '_closed')
		ws.connect('connection_established', self, '_connected')
		ws.connect('data_received', self, '_on_data')
		
		err = ws.connect_to_url(URL)
		if err == OK:
			return ws
		else:
			isConn = false
			print('connection refused')

func _on_data():
	var receiver = JSON.parse(ws.get_peer(1).get_packet().get_string_from_utf8()).result
	
	if(receiver.type == "statePlayer"):
		pass	
	elif(receiver.type == "auth"):
		pass			

func _closed():
	isConn = false
	print("connection closed")

func _connected(proto = ""):
	emit("auth", {"token": GlobalUrl.token})

func emit(type: String, json):
	json["type"] = type
	ws.get_peer(1).put_packet(JSON.print(json).to_utf8())
