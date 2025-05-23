extends Node

# @param dataPlayer = { idPlayer, nickname, text }
signal network_chat(dataPlayer)

func _ready():
	Server.connect("channel_other", self, "_on_channel_server")

func sendChat(channel: String, text: String):
	Server.emitChannel("chat", { "channel": channel, "text": text, "idPlayer": GlobalPlayer.idPlayer, "nickname": GlobalPlayer.nickname }, true)
	# Server.emit("chat", {"channel": channel, "text": text})

func _on_channel_server(receiver):
		if(receiver.type == "chat"):
			if(receiver.dataPlayer.channel == "global"):
				emit_signal("network_chat", receiver.dataPlayer)
