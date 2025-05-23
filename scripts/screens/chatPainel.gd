extends Control

onready var textLabel = $TextureRect/VBoxContainer/RichTextLabel 
onready var input = $TextureRect/LineEdit

func _ready():
	Chat.connect("network_chat", self, "_on_chat")
	input.connect("text_entered", self, "_on_input")

func _on_chat(dataPlayer) -> void:
	addMessage(dataPlayer.nickname, dataPlayer.text)

func _on_input(text) -> void:
	if text && text.replace(" ", ""):
		Chat.sendChat("global", text)
		input.release_focus()
		GlobalPlayer.isChat = false
		input.set_text("")
	
func addMessage(name, text) -> void:
	if text && text.replace(" ", ""):
		textLabel.text += "\n"+ getPlayerName(name) + text

func getPlayerName(name: String) -> String:
	return "["+name+"] "

func _input(event):
	if event is InputEventKey:
		if event.pressed and event.scancode == KEY_ENTER:
			GlobalPlayer.isChat = true
			input.grab_focus()
		if event.pressed and event.scancode == KEY_ESCAPE:
			GlobalPlayer.isChat = false
			input.release_focus()
		# trocar o canal no futuro
		# if event.pressed and event.scancode == KEY_TAB:
		# 	input.release_focus()
