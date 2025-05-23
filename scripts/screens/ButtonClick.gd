extends Control

var isSelect = false

signal mouse_left_click()
signal mouse_right_click()

signal mouse_hover(isHover)

func _ready():
	connect("mouse_entered", self, "_on_mouse_entred")
	connect("mouse_exited", self, "_on_mouse_exited")

func _process(delta):
	delta = delta
	if(Input.is_action_just_pressed("click_left")):
		if isSelect:
			emit_signal("mouse_left_click")
	elif Input.is_action_just_pressed("click_right"):
		if isSelect:
			emit_signal("mouse_right_click")

func _on_mouse_entred():
	isSelect = true
	emit_signal("mouse_hover", isSelect)
	
func _on_mouse_exited():
	isSelect = false
	emit_signal("mouse_hover", isSelect)

