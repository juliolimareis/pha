extends Node
# Tratativa de resposta da API.

var callConnections = []

func _ready():
	Server.connect("channel_other", self, "_on_channel_other")

# adiciona uma conexão de call back. 
# Quando o channel tiver resposta, 
# a função functionName será chamada dentro do elemento target
func connectChannel(channel: String, target, functionName):
	var callConn = {
		"target": target,
		"channel": channel,
		"functionName": functionName,
	}
	var indexCall = callConnections.find(channel)

	if indexCall == -1:
		callConnections.push_back(callConn)
	else:
		callConnections[indexCall] = callConn
	
func _on_channel_other(receiver):
	for callConn in callConnections:
		if(receiver.type == callConn.channel):
			callConn.target.callv(callConn.functionName, [receiver.dataPlayer])
