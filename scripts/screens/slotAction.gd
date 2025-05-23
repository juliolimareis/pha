extends Sprite

export (String) var keyName = ""
export (String) var keyPos = ""

onready var key = $Key
onready var time = $Time
onready var quant = $Quant

var _item #json do item
var itemObj: Item
var isCountdown = false
var keyTime = 'actions'
var seconds

func _ready():
	key.text = keyName
#	$Control.connect("mouse_hover", self, "_on_hover")
	$Control.connect("mouse_left_click", self, "_on_click")
	GlobalPlayer.connect("change_action_slot", self, "refreshQunt")
	Game.connect("exit_battle", self, "_on_verify_reset_time")
	Time.getTimer(keyTime, keyPos).connect("timeout", self, "_on_verify_countdown")

func _on_verify_countdown():
	if(seconds == 1):
		seconds = itemObj.countdown
		Time.stop(keyTime, keyPos)
		countTime()
		enableCountdown(false)
	else:
		seconds -= 1
		countTime()

func _on_click():
	print("slot", keyName)

func _on_action(is_countdown: bool):
	enableCountdown(is_countdown)
	refreshQunt()

func setAction(item): # josn das informações do item
	_item = item 
	refreshQunt()
	modulate = "#ffffff"
	self_modulate = "#ffffff"
	itemObj = ItemsList.getItem(_item.idItem)
	itemObj.keyPos = keyPos
	seconds = itemObj.countdown
	countTime()
	$icon.texture = ItemsList.getImg(_item.idItem)
	itemObj.connect("action", self, "_on_action")
	setGroup()

#FIXME Gatilho de ativação das actions
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("action"+str(keyPos)) && !GlobalPlayer.isChat:
		if (_item):
			if(_item.quantity > 0 && !isCountdown):
				itemObj.action()

func enableCountdown(value: bool):
	if(value):
		modulate = "#9affffff"
		self_modulate = "#444343"
		$icon.modulate = "#858585"
		$icon.self_modulate = "#858585"
	else:
		resetModulates()
	$Time.visible = value
	isCountdown = value

func resetModulates():
	modulate = "#ffffff"
	self_modulate = "#ffffff"
	$icon.modulate = "#ffffff"
	$icon.self_modulate = "#ffffff"

func countTime():
	$Time.text = str(seconds)

func refreshQunt():
	if _item:
		quant.text = str(GlobalPlayer.getItemById(_item.idItem).quantity)

func setGroup():
	if(itemObj.type == itemObj.typeItem.potion
	 || itemObj.type == itemObj.typeItem.revive):
		add_to_group("reset_exit_battle")

func _on_verify_reset_time(isExit:bool):
	if(isExit):
		if(is_in_group("reset_exit_battle")):
			seconds = 1

#enum typeItem { pokeball, potion, tm, revive }
