extends Node

#json deve conter no minimo type e text
var dataNotifi = {}

var id
var icon
var isClick = false
var isSelect = false
var isActiveClick = false
var type

func _ready():
	setId()
	configNotifi()
	$Icon.set_texture(icon)
	$RichTextLabel.bbcode_text = dataNotifi.text

func setId():
	id = (hash(str(self.get_instance_id())+Utils.getTime()))
	dataNotifi['id'] = id

func configNotifi():
	if isClick:
		setActiveClick(true)
	setIcon("poke")

func setIcon(iconName):
	icon = Utils.getIcon(iconName)

func setActiveClick(active) -> void:
	if(active):
		$Control.connect("mouse_left_click", self, "_on_click")
#		isActiveClick = active
		$Control.set_mouse_filter(0)

func _on_click():
	if(type == "addAtk"):
		if(GlobalPlayer.isBattle):
			Game.addAlertTemp(Msg.getMsg(Msg.NOT_ALLOWED_IN_BATTLE))
		else:
			Game.setChangeMove(dataNotifi)
			Game.addAlert(Msg.getMsg(Msg.CHANGE_ATK))

#func temp():
#	if isTemp:
#		var timer = Timer.new()
#		add_child(timer)
#		timer.set_wait_time(6)
#		timer.one_shot = true
#		timer.start()
#		timer.connect("timeout", self, "_on_timeout")

#func _on_timeout():
#	queue_free() 
