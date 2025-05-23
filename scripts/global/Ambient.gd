extends Node

#Essa classe cuida ambientação dos mapas

# periodDay 0 = manhã, 1 = Dia, 2 = Tarde, 3 = Noite
var periodDay = 0
var colorDay = "ffffff"
var isLight = false

signal ambient()

func _ready():
	Server.connect("channel_other", self, "_on_channel_server")
	Server.emit("ambient", {})

func _on_channel_server(receiver):
	if(receiver.type == "ambient"):
			periodDay = receiver.periodDay
			setLight()
			setColor()
			emit_signal("ambient")
			# print("ambient: ", receiver.periodDay)

func setLight() -> void:
	if periodDay == 3:
		isLight = true
	else:
		isLight = false

func setColor() -> void:
	if periodDay == 0:
		colorDay = "dadada" #d6d5e4
	elif periodDay == 1:
		colorDay = "ffffff"
	elif periodDay == 2:
		colorDay = "fff7d2" #ffe2b4
	else:
		colorDay = "a49ee7"
