extends CanvasModulate

func _ready():
#	Ambient.connect("ambient", self, "_on_ambient")
	_on_ambient()

func _on_ambient():
	pass
#	set_color(Ambient.colorDay)
