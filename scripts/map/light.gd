extends Light2D

@export var isWindow = false
@export var isRand = false

func _ready():
	pass
#	Ambient.connect("ambient", self, "_on_ambient")
#	_on_ambient()

#func _on_ambient():
#	set_enabled(Ambient.isLight)
#	if isWindow:
#		if isRand:
#			if Utils.prob(40):
#				get_parent().visible = Ambient.isLight
#		else:
#			get_parent().visible = Ambient.isLight
